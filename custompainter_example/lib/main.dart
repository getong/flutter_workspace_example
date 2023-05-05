import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: GraphicaWidget(),
      ),
    );
  }
}

class GraphicaWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: Graphica(
        backgroundColor: Colors.grey,
        dxLineColor: Colors.grey,
        dyLineColor: Colors.grey,
        indicatorsPadding: 16,
        dxIndicatorsColor: Colors.black,
        graphs: [
          GraphData(
            color: Colors.blue,
            values: [1, 5, 3, 2, 5],
          ),
          GraphData(
            color: Colors.red,
            values: [2, 3, 5, 1, 3],
          ),
        ],
        dxIndicators: [
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
          'Sunday',
        ],
        dyIndicators: [
          '0',
          '2',
          '4',
          '6',
          '8',
          '10',
        ],
        lineWidth: 2,
        graphsWidth: 3,
      ),
      size: Size.infinite,
    );
  }
}

class GraphData {
  final Color color;
  final List<int> values;

  GraphData({
    required this.color,
    required this.values,
  });
}

class Graphica extends CustomPainter {
  final List<GraphData> graphs;
  final int indicatorsPadding;
  final List<String>? dxIndicators;
  final List<String>? dyIndicators;
  final Color? dxIndicatorsColor;
  final Color? dyIndicatorsColor;
  final Color backgroundColor;
  final Color dxLineColor;
  final Color dyLineColor;
  final double lineWidth;
  final double graphsWidth;
  final int xCap;
  final int yCap;
  final List<TextPainter> _dxTextPainters = [];
  final List<TextPainter> _dyTextPainters = [];

  Graphica({
    this.backgroundColor = Colors.white,
    this.dxLineColor = Colors.black,
    this.dyLineColor = Colors.black,
    this.lineWidth = 1.0,
    required this.graphs,
    this.indicatorsPadding = 8,
    this.dxIndicators,
    List<String>? dyIndicators,
    this.dyIndicatorsColor,
    this.dxIndicatorsColor,
    this.graphsWidth = 2,
  })  : xCap =
            graphs.map((g) => g.values.length).reduce((a, b) => a > b ? a : b),
        yCap = graphs
            .map((g) => g.values.reduce((a, b) => a > b ? a : b))
            .reduce((a, b) => a > b ? a : b),
        dyIndicators = dyIndicators?.reversed.toList() {
    _initTextPainters();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    final w = size.width;

    _paintBackground(canvas, h, w);

    final xCap =
        graphs.map((g) => g.values.length).reduce((a, b) => a > b ? a : b);
    final yCap = graphs
        .map((g) => g.values.reduce((a, b) => a > b ? a : b))
        .reduce((a, b) => a > b ? a : b);

    final dxStep = w / (xCap - 1);
    final dyStep = h / yCap;

    if (dxIndicators != null) {
      _paintXIndicators(canvas, dxStep, h);
    }

    if (dyIndicators != null) {
      _paintYIndicators(canvas, dyStep);
    }

    _paintXLines(canvas, dxStep, h);
    _paintYLines(canvas, dyStep, w, h);

    for (final g in graphs) {
      final values = g.values;
      for (int index = 0; index < values.length - 1; index++) {
        canvas.drawLine(
          Offset(dxStep * index, h - (h / yCap * values[index])),
          Offset(dxStep * (index + 1), h - (h / yCap * values[index + 1])),
          Paint()
            ..color = g.color
            ..strokeWidth = graphsWidth,
        );
      }
    }
  }

  void _initTextPainters() {
    if (dxIndicators != null) {
      for (final indicator in dxIndicators!) {
        _dxTextPainters.add(
          TextPainter(
            text: TextSpan(
                text: indicator, style: TextStyle(color: dxIndicatorsColor)),
            textDirection: TextDirection.ltr,
          )..layout(),
        );
      }
    }

    if (dyIndicators != null) {
      for (final indicator in dyIndicators!) {
        _dyTextPainters.add(
          TextPainter(
            text: TextSpan(
                text: indicator, style: TextStyle(color: dyIndicatorsColor)),
            textDirection: TextDirection.ltr,
          )..layout(),
        );
      }
    }
  }

  void _paintBackground(Canvas canvas, double h, double w) {
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, Offset(w, h)),
      Paint()
        ..style = PaintingStyle.fill
        ..color = backgroundColor,
    );
  }

  void _paintXLines(Canvas canvas, double dxStep, double h) {
    for (var x = 0; x < xCap; x++) {
      canvas.drawLine(
        Offset(dxStep * x, 0),
        Offset(dxStep * x, h),
        Paint()
          ..color = dxLineColor
          ..strokeWidth = lineWidth,
      );
    }
  }

  void _paintYLines(Canvas canvas, double dyStep, double w, double h) {
    for (var y = 0; y < yCap; y++) {
      canvas.drawLine(
        Offset(0, h - dyStep * y),
        Offset(w, h - dyStep * y),
        Paint()
          ..color = dyLineColor
          ..strokeWidth = lineWidth,
      );
    }
  }

  void _paintXIndicators(Canvas canvas, double dxStep, double h) {
    for (var x = 0; x < xCap; x++) {
      _dxTextPainters[x].paint(
        canvas,
        Offset(x * dxStep, h + indicatorsPadding),
      );
    }
  }

  void _paintYIndicators(Canvas canvas, double dyStep) {
    for (var y = 0; y < yCap + 1; y++) {
      _dyTextPainters[y].paint(
        canvas,
        Offset(-_dyTextPainters[y].width - indicatorsPadding, y * dyStep),
      );
    }
  }

  @override
  bool shouldRepaint(covariant Graphica oldDelegate) {
    return oldDelegate.graphs != graphs ||
        oldDelegate.dxIndicators != dxIndicators ||
        oldDelegate.dyIndicators != dyIndicators ||
        oldDelegate.dxIndicatorsColor != dxIndicatorsColor ||
        oldDelegate.dyIndicatorsColor != dyIndicatorsColor ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.dxLineColor != dxLineColor ||
        oldDelegate.dyLineColor != dyLineColor ||
        oldDelegate.lineWidth != lineWidth ||
        oldDelegate.graphsWidth != graphsWidth;
  }
}
