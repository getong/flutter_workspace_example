import 'package:dio/dio.dart';
import 'dart:async';
// import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'provider.g.dart';

@riverpod
String urlAddress(ref) {
  return 'http://127.0.0.1:8080/protobuf-stream';
}

@riverpod
class ListNotifier extends _$ListNotifier {
  final List<int> buffer = [];

  @override
  Stream<List<int>> build() async* {
    final response = ref.watch(dioClientNotifierProvider
        .select((dioClient) => dioClient.value?._response));

    try {
      if (response != null) {
        await for (final data in response.data.stream) {
          yield data;
        }
      } else {
        print("response is null");
      }
    } catch (error) {
      // Handle any error that occurs during stream iteration
      print("An error occurred: $error");
    }
  }
}

@riverpod
class DioClientNotifier extends _$DioClientNotifier {
  late DioClient _dioClient;
  bool connected = false;

  Future<void> _initializeDioClient() async {
    _dioClient = await DioClient.connect(url: ref.watch(urlAddressProvider));
    state = AsyncData(_dioClient);
    connected = true;
  }

  @override
  FutureOr<DioClient> build() async {
    await _initializeDioClient();
    return _dioClient;
  }

  Future<void> connectToServer(String url) async {
    if (!connected) {
      state = AsyncLoading();
      try {
        _dioClient =
            await DioClient.connect(url: ref.watch(urlAddressProvider));
        state = AsyncData(_dioClient);
        connected = true; // Update the connected status
      } catch (error, stackTrace) {
        state = AsyncError(error, stackTrace);
      }
    }
  }

  Future<void> disconnectFromServer() async {
    if (connected) {
      await _dioClient.disconnectFromServer();
      state = AsyncData(_dioClient);
      connected = false;
    }
  }

  Future<void> sendData(String data) async {
    // if (connected) {
    //   await _dioClient.sendData(data);
    // } else {
    //   print('Error: DioClient is not properly initialized.');
    // }
  }

  Future<void> sendByteData(List<int> data) async {
    // if (connected) {
    //   await _dioClient.sendByteData(data);
    // } else {
    //   print('Error: DioClient is not properly initialized.');
    // }
  }
}

class DioClient {
  late Dio? _dio;
  late String? _baseUrl;
  late Response? _response;

  DioClient(this._dio, this._baseUrl, this._response) {}

  static Future<DioClient> connect({required String url}) async {
    try {
      var dio = Dio();
      Response response = await dio.get(
        url,
        options: Options(
          responseType: ResponseType.stream,
          followRedirects: false,
          receiveTimeout: Duration(seconds: 3), // Corrected here
        ),
      );
      var dioClient = DioClient(dio, url, response);
      return dioClient;
    } catch (e) {
      throw ('Connection failed: $e');
    }
  }

  Future<void> disconnectFromServer() async {
    _dio!.close();
    _baseUrl = null;
    _response = null;
  }

  Future<void> get() async {
    _response = await _dio!.get(_baseUrl!);
  }

  Future<void> sendByteData(List<int> data) async {
    // socket.add(data);
    print("data : ${data}");
  }
}
