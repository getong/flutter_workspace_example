import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dateProvider = Provider((ref) {
  return DateTime.now();
});

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DateTime date = ref.watch(dateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('flutter_riverpod refresh example'),
      ),
      body: Center(
        child: Text('$date'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.refresh(dateProvider),
        child: Icon(Icons.update),
      ),
    );
  }
}

void main() {
  runApp(ProviderScope(child: MyApp()));
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
      home: MyWidget(),
    );
  }
}
