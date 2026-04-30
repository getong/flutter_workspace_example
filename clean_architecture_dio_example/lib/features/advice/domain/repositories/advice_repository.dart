import '../entities/advice.dart';

abstract class AdviceRepository {
  Future<Advice> getRandomAdvice();

  Stream<List<Advice>> watchSavedAdvice();
}
