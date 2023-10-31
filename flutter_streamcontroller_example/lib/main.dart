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
      home: PageA(),
    );
  }
}

class PageA extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('平方页面'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return PageC();
                }));
              },
              child: Text('To Page B'),
            ),
            StreamBuilder<int>(
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  return Text('${snapshot.data! * snapshot.data!}');
                } else {
                  return Text('no data');
                }
              },
              stream: StateSubject().streamController.stream,
            )
          ],
        ),
      ),
    );
  }
}

class PageC extends StatelessWidget {
  int num = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发射数据页面'),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                StateSubject().update(num++);
              },
              child: Text('发射数据'),
            ),
          ],
        ),
      ),
    );
  }
}

class StateSubject {
  static final StateSubject _instance = StateSubject._();

  factory StateSubject() => StateSubject._instance;

  StreamController<int> streamController = StreamController<int>.broadcast();

  StateSubject._();

  void update(int num) {
    streamController.sink.add(num);
  }
}
