import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: DynamicPriceLine(),
    );
  }
}

class DynamicPriceLine extends StatefulWidget {
  @override
  _DynamicPriceLineState createState() => _DynamicPriceLineState();
}

class _DynamicPriceLineState extends State<DynamicPriceLine> {
  List<double> prices = List.generate(100, (index) => 50);
  late Timer _timer;
  double offsetX = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {
        offsetX -= 2;
        prices.removeAt(0);
        double lastPrice = prices.last;
        double newPrice = lastPrice + (Random().nextDouble() * 4 - 2);
        prices.add(newPrice);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(offsetX, 0),
      child: CustomPaint(
        painter: LinePainter(prices),
        size: Size.infinite,
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  final List<double> prices;

  LinePainter(this.prices);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double minY = prices.reduce(min);
    final double maxY = prices.reduce(max);
    final double rangeY = maxY - minY;

    final double scaleX = size.width / (prices.length - 1);
    // final double scaleY = size.height / rangeY;
    final double scaleY = rangeY != 0 ? size.height / rangeY : 1.0;

    for (int i = 1; i < prices.length; i++) {
      canvas.drawLine(
        Offset((i - 1) * scaleX, size.height - (prices[i - 1] - minY) * scaleY),
        Offset(i * scaleX, size.height - (prices[i] - minY) * scaleY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant LinePainter oldDelegate) =>
      oldDelegate.prices != prices;
}

// copy from https://juejin.cn/post/7243756043523850297