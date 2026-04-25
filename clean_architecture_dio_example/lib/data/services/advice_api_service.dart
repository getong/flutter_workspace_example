import 'package:dio/dio.dart';

import '../models/advice_model.dart';

class AdviceApiService {
  final Dio _dio;
  static const Duration _requestTimeout = Duration(milliseconds: 1200);

  AdviceApiService(this._dio);

  Future<AdviceModel> fetchRandomAdvice() async {
    final response = await _dio.get<Map<String, dynamic>>(
      '/',
      options: Options(
        sendTimeout: _requestTimeout,
        receiveTimeout: _requestTimeout,
      ),
      queryParameters: <String, dynamic>{
        'c': 'k',
        'encode': 'json',
        'charset': 'utf-8',
        'max_length': 80,
        '_': DateTime.now().millisecondsSinceEpoch.toString(),
      },
    );

    if (response.statusCode != 200 || response.data == null) {
      throw DioException.badResponse(
        statusCode: response.statusCode ?? 500,
        requestOptions: response.requestOptions,
        response: response,
      );
    }

    return AdviceModel.fromJson(response.data!);
  }
}
