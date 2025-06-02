import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart';
import 'package:http/http.dart' as http;
import 'web3_event.dart';
import 'web3_state.dart';

class Web3Bloc extends Bloc<Web3Event, Web3State> {
  late Web3Client _client;
  late http.Client _httpClient;

  Web3Bloc() : super(Web3Initial()) {
    _httpClient = http.Client();
    // Initialize client with a reliable public RPC endpoint
    _client = Web3Client('https://ethereum-rpc.publicnode.com', _httpClient);
    on<ConnectToNetwork>(_onConnectToNetwork);
    on<GetBalance>(_onGetBalance);
  }

  void _onConnectToNetwork(
      ConnectToNetwork event, Emitter<Web3State> emit) async {
    emit(Web3Loading());
    try {
      final networkId = await _client.getNetworkId();
      emit(Web3Connected('Ethereum Mainnet (ID: $networkId)'));
    } catch (e) {
      emit(Web3Error('Failed to connect: ${e.toString()}'));
    }
  }

  void _onGetBalance(GetBalance event, Emitter<Web3State> emit) async {
    emit(Web3Loading());
    try {
      // Create EthereumAddress from hex string
      final address = EthereumAddress.fromHex(event.address);
      final balance = await _client.getBalance(address);
      // Convert Wei to Ether manually (1 ETH = 10^18 Wei)
      final balanceInEther = balance.getInWei / BigInt.from(10).pow(18);
      emit(Web3BalanceLoaded(balanceInEther.toString(), event.address));
    } catch (e) {
      emit(Web3Error('Failed to get balance: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _client.dispose();
    _httpClient.close();
    return super.close();
  }
}
