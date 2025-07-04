import 'package:flutter/material.dart';
import 'package:flutter_rust_bridge_codegen_example/src/rust/api/simple.dart';
import 'package:flutter_rust_bridge_codegen_example/src/rust/frb_generated.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('flutter_rust_bridge quickstart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Action: Call Rust `greet("Tom")`\nResult: `${greet(name: "Tom")}`',
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: hello(a: "World"),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      'Action: Call Rust `hello("World")`\nResult: `${snapshot.data}`',
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return const Text('Loading hello result...');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
