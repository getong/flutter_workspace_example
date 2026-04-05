import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'baidu_date_state.dart';

class BaiduDateCubit extends Cubit<BaiduDateState?> {
  final Dio dio = GetIt.instance<Dio>();

  BaiduDateCubit() : super(null);

  Future<void> fetchDate() async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await dio.get('https://www.baidu.com');
      stopwatch.stop();
      final dateHeader = response.headers.value('date');
      emit(
        BaiduDateState(
          dateHeader: dateHeader,
          responseMilliseconds: stopwatch.elapsedMilliseconds,
        ),
      );
    } catch (_) {
      emit(
        BaiduDateState(
          dateHeader: 'Failed to fetch date from baidu.com',
          responseMilliseconds: null,
        ),
      );
    }
  }
}
