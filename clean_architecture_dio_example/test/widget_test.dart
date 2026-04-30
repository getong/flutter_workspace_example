// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:clean_architecture_dio_example/main.dart';
import 'package:clean_architecture_dio_example/core/di/di.dart';
import 'package:clean_architecture_dio_example/features/advice/domain/entities/advice.dart';
import 'package:clean_architecture_dio_example/features/advice/domain/repositories/advice_repository.dart';

class _FakeAdviceRepository implements AdviceRepository {
  @override
  Future<Advice> getRandomAdvice() async {
    return const Advice(
      id: 1,
      message: 'Test advice',
      source: 'Test source',
      author: 'Tester',
    );
  }

  @override
  Stream<List<Advice>> watchSavedAdvice() {
    return Stream.value(const [
      Advice(
        id: 1,
        message: 'Test advice',
        source: 'Test source',
        author: 'Tester',
      ),
    ]);
  }
}

void main() {
  setUp(() async {
    await getIt.reset();
    configureDependencies();
    if (getIt.isRegistered<AdviceRepository>()) {
      await getIt.unregister<AdviceRepository>();
    }
    getIt.registerLazySingleton<AdviceRepository>(_FakeAdviceRepository.new);
  });

  testWidgets('shows advice generator shell', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Advice Generator'), findsOneWidget);
    expect(find.text('Fetch'), findsOneWidget);
    expect(find.text('History'), findsOneWidget);
    expect(find.text('Fetch Advice'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.byType(Scaffold), findsWidgets);
  });
}
