import 'package:flutter/material.dart';
import 'dart:async';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
  // 声明
  late StreamController _streamController;
  // 订阅者
  late StreamSubscription _streamSubscription;
  // 数据对象
  String _string = "";

  @override
  void initState() {
    super.initState();
    _streamController = StreamController();
    _streamSubscription = _streamController.stream.listen((event) {
      if (mounted) {
        setState(() {
          _string = event;
        });
      }
    });
  }

  @override
  void dispose() {
    // 销毁
    _streamSubscription?.cancel();
    _streamController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("StreamController 的订阅暂停、恢复、发送测试"),
      ),
      body: Container(
        child: Column(
          children: [
            Text(_string),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () => _streamSubscription.pause(),
                    child: Text("暂停")),
                ElevatedButton(
                    onPressed: () => _streamSubscription.resume(),
                    child: Text("恢复")),
                ElevatedButton(
                    onPressed: () =>
                        _streamController.add(DateTime.now().toString()),
                    child: Text("发送数据")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
