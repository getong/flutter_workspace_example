import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ListNotifier extends Notifier<List<String>> {
  @override
  List<String> build() {
    return [];
  }

  void addItem(String item) {
    // this does not update ListView result
    // state.add(item);

    // This will update UI
    state = [...state, item];
  }

  void removeItem(int index) {
    state.removeAt(index);
  }
}

final listProvider = NotifierProvider<ListNotifier, List<String>>(() {
    return ListNotifier();
});

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Riverpod ListView Example'),
        ),
        body: Consumer(
          builder: (context, ref, child) {
            final list = ref.watch(listProvider);
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Row(
                  children: <Widget>[
                    Text(index.toString()),
                    Text(list[index]),
                  ],
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final newItem = DateTime.now().toString(); // Example new item
            ref.read(listProvider.notifier).addItem(newItem);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}