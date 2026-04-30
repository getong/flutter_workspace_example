import 'dart:async';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../local/advice_database.dart';
import '../../domain/entities/advice.dart';
import '../../domain/repositories/advice_repository.dart';
import '../services/advice_api_service.dart';
import '../services/fallback_advice_service.dart';

@LazySingleton(as: AdviceRepository)
class AdviceRepositoryImpl implements AdviceRepository {
  final AdviceApiService _apiService;
  final AdviceDatabase _adviceDatabase;
  final FallbackAdviceService _fallbackAdviceService;
  Advice? _cachedAdvice;
  static const Duration _fastResponseBudget = Duration(milliseconds: 1200);

  AdviceRepositoryImpl(
    this._apiService,
    this._adviceDatabase,
    this._fallbackAdviceService,
  );

  @override
  Future<Advice> getRandomAdvice() async {
    try {
      final advice = await _fetchRemoteAdvice().timeout(_fastResponseBudget);
      return _storeAndRemember(advice);
    } on TimeoutException {
      final fallbackAdvice =
          _cachedAdvice ??
          await _adviceDatabase.getLatestAdvice() ??
          _fallbackAdviceService.getRandomAdvice();
      return _storeAndRemember(fallbackAdvice);
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode != null) {
        throw Exception('Request failed with status code $statusCode.');
      }

      if (_shouldUseFallback(error)) {
        final fallbackAdvice =
            _cachedAdvice ??
            await _adviceDatabase.getLatestAdvice() ??
            _fallbackAdviceService.getRandomAdvice();
        return _storeAndRemember(fallbackAdvice);
      }

      throw Exception('Unable to reach the advice service.');
    } on FormatException catch (error) {
      throw Exception(error.message);
    }
  }

  @override
  Future<List<Advice>> getSavedAdvice() {
    return _adviceDatabase.getSavedAdvice();
  }

  @override
  Stream<List<Advice>> watchSavedAdvice() {
    return _adviceDatabase.watchSavedAdvice();
  }

  Future<Advice> _fetchRemoteAdvice() async {
    final adviceModel = await _apiService.fetchRandomAdvice();
    return adviceModel;
  }

  Future<Advice> _storeAndRemember(Advice advice) async {
    _cachedAdvice = advice;
    await _adviceDatabase.cacheAdvice(advice);
    return advice;
  }

  bool _shouldUseFallback(DioException error) {
    return switch (error.type) {
      DioExceptionType.connectionTimeout => true,
      DioExceptionType.sendTimeout => true,
      DioExceptionType.receiveTimeout => true,
      DioExceptionType.connectionError => true,
      DioExceptionType.unknown => true,
      _ => false,
    };
  }
}
