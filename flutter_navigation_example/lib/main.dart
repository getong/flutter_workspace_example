import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Flutter Navigation',
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Go to the detail screen'),
          onPressed: () async {
            var message = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DetailScreen(
                    message: 'This is a message from the home screen'
                ),
              ),
            );
            print(message);
          },
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String message;

  const DetailScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(message),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, 'This is a message from the Detail screen');
              },
              child: const Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}
