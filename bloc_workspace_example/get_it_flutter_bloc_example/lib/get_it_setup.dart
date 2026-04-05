import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'baidu_date_cubit.dart';
import 'package:go_router/go_router.dart';
import 'app_router.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<BaiduDateCubit>(BaiduDateCubit());
  getIt.registerSingleton<GoRouter>(appRouter);
}
