import '../entities/advice.dart';
import '../repositories/advice_repository.dart';

class GetRandomAdviceUseCase {
  final AdviceRepository repository;

  GetRandomAdviceUseCase(this.repository);

  Future<Advice> call() async {
    return repository.getRandomAdvice();
  }
}
