import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _Myapp();
}

class _Myapp extends State<MyApp> {
  var a = 1;
  @override
  Widget build(BuildContext context) {
    print("object");
    return MaterialApp(
      title: 'Dict',
      home: Scaffold(
        body: SafeArea(
            child: Wrap(
          children: gettexts(),
        )),
      ),
    );
  }

  gettexts() {
    List<Widget> texts = [];
    for (var i = 0; i <= 10000; i++) {
      texts.add(add1(i));
    }
    return texts;
  }
}

class add1 extends StatefulWidget {
  var i = 1;
  add1(this.i);
  @override
  State<add1> createState() => _add1(i);
}

class _add1 extends State<add1> {
  var a = 0;
  var i = 1;
  _add1(this.i);
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 80,
        height: 30,
        child: Row(children: [
          RepaintBoundary(
            child: TextButton(
              child: Text(i.toString() + ' '),
              //点击后计数器自增
              onPressed: () {
                a++;
                // print(a);
                setState(() {});
              },
            ),
          ),
          Text("$a")
        ]));
  }
}
