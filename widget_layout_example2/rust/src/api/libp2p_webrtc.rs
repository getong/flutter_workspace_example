use std::{sync::OnceLock, time::Duration};

use anyhow::{Result, anyhow};
use futures::StreamExt;
use libp2p::{
    Multiaddr, StreamProtocol, Transport,
    core::muxing::StreamMuxerBox,
    multiaddr::Protocol,
    request_response::{self, ProtocolSupport},
    swarm::{NetworkBehaviour, SwarmEvent},
};
use libp2p_webrtc as webrtc;
use rand::thread_rng;
use serde::{Deserialize, Serialize};
use tokio::{runtime::Runtime, time::timeout};

static RUNTIME: OnceLock<Runtime> = OnceLock::new();

#[derive(Debug, Clone)]
pub struct Libp2pWebRtcDialRequest {
    pub server_multiaddr: String,
    pub timeout_seconds: u32,
    pub message: String,
}

#[derive(Debug, Clone)]
pub struct Libp2pWebRtcDialResult {
    pub local_peer_id: String,
    pub remote_peer_id: String,
    pub dialed_multiaddr: String,
    pub sent_message: String,
    pub echoed_message: String,
    pub server_timestamp: String,
    pub status_message: String,
    pub explanation: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
struct ChatRequest {
    message: String,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
struct ChatResponse {
    original_message: String,
    echoed_message: String,
    server_timestamp: String,
}

#[derive(NetworkBehaviour)]
struct Behaviour {
    request_response: request_response::cbor::Behaviour<ChatRequest, ChatResponse>,
}

pub async fn dial_libp2p_webrtc_server(
    request: Libp2pWebRtcDialRequest,
) -> Result<Libp2pWebRtcDialResult, String> {
    let task = move || dial_libp2p_webrtc_server_blocking(request);
    tokio::task::spawn_blocking(task)
        .await
        .map_err(|error| error.to_string())?
        .map_err(|error| error.to_string())
}

fn dial_libp2p_webrtc_server_blocking(
    request: Libp2pWebRtcDialRequest,
) -> Result<Libp2pWebRtcDialResult> {
    let runtime = RUNTIME
        .get_or_init(|| Runtime::new().expect("tokio runtime should initialize for libp2p webrtc"));

    runtime.block_on(async move { dial_impl(request).await })
}

async fn dial_impl(request: Libp2pWebRtcDialRequest) -> Result<Libp2pWebRtcDialResult> {
    let server_multiaddr = request
        .server_multiaddr
        .trim()
        .parse::<Multiaddr>()
        .map_err(|error| anyhow!("Invalid multiaddr: {error}"))?;

    let timeout_seconds = request.timeout_seconds.max(5);
    let sent_message = request.message.trim().to_owned();
    if sent_message.is_empty() {
        return Err(anyhow!("Message must not be empty"));
    }

    let mut swarm = libp2p::SwarmBuilder::with_new_identity()
        .with_tokio()
        .with_other_transport(|id_keys| {
            Ok(webrtc::tokio::Transport::new(
                id_keys.clone(),
                webrtc::tokio::Certificate::generate(&mut thread_rng())?,
            )
            .map(|(peer_id, conn), _| (peer_id, StreamMuxerBox::new(conn))))
        })?
        .with_behaviour(|_| Behaviour {
            request_response: request_response::cbor::Behaviour::new(
                [(
                    StreamProtocol::new("/flutter-chat/1"),
                    ProtocolSupport::Full,
                )],
                request_response::Config::default(),
            ),
        })?
        .build();

    let local_webrtc_listener = Multiaddr::empty()
        .with(Protocol::Ip4(std::net::Ipv4Addr::UNSPECIFIED))
        .with(Protocol::Udp(0))
        .with(Protocol::WebRTCDirect);

    swarm
        .listen_on(local_webrtc_listener)
        .map_err(|error| anyhow!("Failed to start local WebRTC listener: {error}"))?;

    let local_peer_id = swarm.local_peer_id().to_string();
    swarm.dial(server_multiaddr.clone())?;

    let outcome = timeout(
        Duration::from_secs(u64::from(timeout_seconds)),
        wait_for_chat_response(&mut swarm, sent_message.clone()),
    )
    .await
    .map_err(|_| anyhow!("Timed out after {timeout_seconds}s waiting for a chat response"))??;

    Ok(Libp2pWebRtcDialResult {
        local_peer_id,
        remote_peer_id: outcome.remote_peer_id,
        dialed_multiaddr: server_multiaddr.to_string(),
        sent_message,
        echoed_message: outcome.echoed_message,
        server_timestamp: outcome.server_timestamp,
        status_message: "Connected to the libp2p WebRTC server and received the echoed chat response."
            .to_owned(),
        explanation: "Flutter called Rust through flutter_rust_bridge. Rust created a native libp2p-webrtc transport, dialed the /webrtc-direct/certhash/... server multiaddr, completed the libp2p handshake, sent a chat request, and returned the server response with an appended timestamp."
            .to_owned(),
    })
}

struct ChatOutcome {
    remote_peer_id: String,
    echoed_message: String,
    server_timestamp: String,
}

async fn wait_for_chat_response(
    swarm: &mut libp2p::Swarm<Behaviour>,
    sent_message: String,
) -> Result<ChatOutcome> {
    let mut pending_request_sent = false;

    loop {
        match swarm.select_next_some().await {
            SwarmEvent::ConnectionEstablished { peer_id, .. } if !pending_request_sent => {
                swarm.behaviour_mut().request_response.send_request(
                    &peer_id,
                    ChatRequest {
                        message: sent_message.clone(),
                    },
                );
                pending_request_sent = true;
            }
            SwarmEvent::Behaviour(BehaviourEvent::RequestResponse(
                request_response::Event::Message {
                    peer,
                    message: request_response::Message::Response { response, .. },
                    ..
                },
            )) => {
                return Ok(ChatOutcome {
                    remote_peer_id: peer.to_string(),
                    echoed_message: response.echoed_message,
                    server_timestamp: response.server_timestamp,
                });
            }
            SwarmEvent::Behaviour(BehaviourEvent::RequestResponse(
                request_response::Event::OutboundFailure { peer, error, .. },
            )) => {
                return Err(anyhow!(
                    "Failed to send chat request to peer {peer}: {error}"
                ));
            }
            SwarmEvent::Behaviour(BehaviourEvent::RequestResponse(
                request_response::Event::InboundFailure { peer, error, .. },
            )) => {
                return Err(anyhow!("Inbound chat failure from peer {peer}: {error}"));
            }
            SwarmEvent::ConnectionClosed { peer_id, cause, .. } => {
                return Err(anyhow!(
                    "Connection to peer {peer_id} closed before chat completed: {cause:?}"
                ));
            }
            SwarmEvent::OutgoingConnectionError { error, .. } => {
                return Err(anyhow!("Outgoing connection failed: {error}"));
            }
            _ => {}
        }
    }
}
