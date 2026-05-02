import 'dart:math';

class PricePoint {
  const PricePoint({required this.x, required this.y});

  final double x;
  final double y;
}

List<PricePoint> get pricePoints {
  final Random random = Random();
  return List<PricePoint>.generate(12, (int index) {
    return PricePoint(x: index.toDouble(), y: random.nextDouble());
  });
}
