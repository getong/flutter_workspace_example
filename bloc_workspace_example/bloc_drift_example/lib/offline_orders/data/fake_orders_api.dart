class FakeOrdersApi {
  const FakeOrdersApi();

  Future<void> createOrder({
    required String customerName,
    required double total,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    if (customerName.trim().isEmpty) {
      throw const FakeOrdersApiException('Customer name is required.');
    }

    if (total <= 0) {
      throw const FakeOrdersApiException('Order total must be greater than 0.');
    }
  }
}

class FakeOrdersApiException implements Exception {
  const FakeOrdersApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
