import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wallet/wallet.dart';
import 'package:dio/dio.dart';
import 'web3_event.dart';
import 'web3_state.dart';

// Custom Dio Web3 client
class DioWeb3Client {
  final Dio _dio;
  final String _rpcUrl;

  DioWeb3Client(this._rpcUrl)
      : _dio = Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: {'Content-Type': 'application/json'},
        ));

  Future<int> getNetworkId() async {
    final response = await _dio.post(_rpcUrl, data: {
      'jsonrpc': '2.0',
      'method': 'net_version',
      'params': [],
      'id': 1,
    });
    return int.parse(response.data['result']);
  }

  Future<BigInt> getBalance(String address) async {
    final response = await _dio.post(_rpcUrl, data: {
      'jsonrpc': '2.0',
      'method': 'eth_getBalance',
      'params': [address, 'latest'],
      'id': 1,
    });
    return BigInt.parse(response.data['result'].substring(2), radix: 16);
  }

  void dispose() {
    _dio.close();
  }
}

class Web3Bloc extends Bloc<Web3Event, Web3State> {
  late DioWeb3Client _client;

  Web3Bloc() : super(Web3Initial()) {
    _client = DioWeb3Client('https://ethereum-rpc.publicnode.com');
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
      final balance = await _client.getBalance(event.address);
      // Convert Wei to Ether manually (1 ETH = 10^18 Wei)
      final balanceInEther = balance / BigInt.from(10).pow(18);
      emit(Web3BalanceLoaded(balanceInEther.toString(), event.address));
    } catch (e) {
      emit(Web3Error('Failed to get balance: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _client.dispose();
    return super.close();
  }
}
