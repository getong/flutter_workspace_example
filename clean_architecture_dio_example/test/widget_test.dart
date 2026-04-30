import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture_dio_example/main.dart';
import 'package:clean_architecture_dio_example/core/di/di.dart';
import 'package:clean_architecture_dio_example/features/advice/domain/entities/advice.dart';
import 'package:clean_architecture_dio_example/features/advice/domain/repositories/advice_repository.dart';

class _FakeAdviceRepository implements AdviceRepository {
  final StreamController<List<Advice>> _historyController =
      StreamController<List<Advice>>.broadcast();
  final List<Advice> _savedAdvice = [
    const Advice(
      id: 1,
      message: 'Old advice',
      source: 'Seed source',
      author: 'Seeder',
    ),
  ];

  _FakeAdviceRepository() {
    _historyController.add(List.unmodifiable(_savedAdvice));
  }

  @override
  Future<Advice> getRandomAdvice() async {
    const newAdvice = Advice(
      id: 2,
      message: 'Fresh advice',
      source: 'API source',
      author: 'Fetcher',
    );

    _savedAdvice.insert(0, newAdvice);
    _historyController.add(List.unmodifiable(_savedAdvice));
    return newAdvice;
  }

  @override
  Future<List<Advice>> getSavedAdvice() async {
    return List.unmodifiable(_savedAdvice);
  }

  @override
  Stream<List<Advice>> watchSavedAdvice() {
    return _historyController.stream;
  }

  Future<void> dispose() async {
    await _historyController.close();
  }
}

void main() {
  late _FakeAdviceRepository repository;

  setUp(() async {
    await getIt.reset();
    configureDependencies();
    if (getIt.isRegistered<AdviceRepository>()) {
      await getIt.unregister<AdviceRepository>();
    }
    repository = _FakeAdviceRepository();
    getIt.registerLazySingleton<AdviceRepository>(() => repository);
  });

  tearDown(() async {
    await repository.dispose();
  });

  testWidgets('history tab shows new advice after fetching', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('Old advice'), findsOneWidget);
    expect(find.text('Menu'), findsOneWidget);
    expect(find.text('Advice'), findsOneWidget);
    expect(find.text('Actions'), findsOneWidget);
    expect(find.text('Overview'), findsWidgets);
    expect(find.text('Inspect'), findsWidgets);

    await tester.tap(find.text('Fetch'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fetch Advice'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh advice'), findsWidgets);

    await tester.tap(find.text('History'));
    await tester.pumpAndSettle();

    expect(find.text('Fresh advice'), findsWidgets);
    expect(find.text('Old advice'), findsOneWidget);
    expect(find.text('Overview'), findsWidgets);
    expect(find.text('Inspect'), findsWidgets);
  });
}
