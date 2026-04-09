import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;

  Stream<bool> get onStatusChange;

  void dispose();
}

class NetworkInfoImpl implements NetworkInfo {
  NetworkInfoImpl({
    required Connectivity connectivity,
    required InternetConnectionChecker internetConnectionChecker,
  }) : _connectivity = connectivity,
       _internetConnectionChecker = internetConnectionChecker;

  final Connectivity _connectivity;
  final InternetConnectionChecker _internetConnectionChecker;

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      return false;
    }

    return _internetConnectionChecker.hasConnection;
  }

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.asyncMap((result) async {
        if (result.contains(ConnectivityResult.none)) {
          return false;
        }

        return _internetConnectionChecker.hasConnection;
      }).distinct();

  @override
  void dispose() {
    _internetConnectionChecker.dispose();
  }
}
