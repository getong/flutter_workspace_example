# web_socket_channel_example

This Flutter app is configured to connect to the Axum websocket endpoint in:

- `/Users/gerald/personal_infos/rust_example/supabase_workspace_example/supabase_rs_signup_signin_example`

## Screens

The app now has two sections:

- `Auth`: signup and signin UI for the Rust Axum auth handlers
- `WebSocket`: websocket client for the Rust `/ws` endpoint

## Target WebSocket Endpoint

The Rust server exposes:

- `ws://127.0.0.1:3000/ws` for desktop, iOS simulator, and Flutter web
- `ws://10.0.2.2:3000/ws` for the Android emulator

The app now defaults to those URLs automatically.

## Behavior

On connect, the Flutter client immediately sends a JSON hello message so the
Rust Axum server starts its greeting and tick event stream.

Manual messages are sent as JSON in this shape:

```json
{
  "event": "manual_text",
  "payload": {
    "message": "hello",
    "sentAt": "2026-04-07T00:00:00.000Z",
    "client": "flutter"
  }
}
```

Incoming JSON frames are pretty-printed in the UI.

## Run

Start the Rust server first, then run the Flutter app:

```bash
flutter pub get
flutter run
```

If you are testing on a physical device, replace the default URL with your
computer's LAN IP and port `3000`.
