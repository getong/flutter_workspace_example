import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class BaiduDateCubit extends Cubit<String?> {
  final Dio dio;

  BaiduDateCubit(this.dio) : super(null);

  Future<void> fetchDate() async {
    try {
      final response = await dio.get('https://www.baidu.com');
      final dateHeader = response.headers.value('date');
      emit(dateHeader);
    } catch (_) {
      emit('Failed to fetch date from baidu.com');
    }
  }
}
