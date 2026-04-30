import '../entities/advice.dart';

abstract class AdviceRepository {
  Future<Advice> getRandomAdvice();

  Future<List<Advice>> getSavedAdvice();

  Stream<List<Advice>> watchSavedAdvice();
}
