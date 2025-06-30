import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'baidu_date_cubit.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<BaiduDateCubit>(BaiduDateCubit());
}
