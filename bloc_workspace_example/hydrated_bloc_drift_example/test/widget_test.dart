import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc_drift_example/presentation/fetch_request_bloc.dart';

void main() {
  test('FetchRequestState serializes and restores persisted fields', () {
    final DateTime fetchedAt = DateTime(2026, 3, 31, 12, 30);
    const FetchRequestState original = FetchRequestState(
      status: FetchRequestStatus.success,
      currentUrl: 'https://jsonplaceholder.typicode.com/posts/1',
      responseBody: '{"id":1}',
      lastStatusCode: 200,
      lastRequestSucceeded: true,
      errorMessage: null,
    );

    final FetchRequestState withTimestamp = original.copyWith(
      lastFetchedAt: fetchedAt,
    );
    final FetchRequestState restored = FetchRequestState.fromJson(
      withTimestamp.toJson(),
    );

    expect(restored.status, FetchRequestStatus.success);
    expect(restored.currentUrl, 'https://jsonplaceholder.typicode.com/posts/1');
    expect(restored.responseBody, '{"id":1}');
    expect(restored.lastStatusCode, 200);
    expect(restored.lastRequestSucceeded, isTrue);
    expect(restored.lastFetchedAt, fetchedAt);
    expect(restored.errorMessage, isNull);
  });
}
