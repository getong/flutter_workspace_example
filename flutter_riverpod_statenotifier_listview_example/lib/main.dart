import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class ListNotifier extends StateNotifier<List<String>> {
  ListNotifier() : super([]);

  @override
  List<String> build() {
    return [];
  }

  void addItem(String item) {
    // state.add(item);
    state = [...state, item];
  }

  void removeItem(int index) {
    state.removeAt(index);
  }
}

final listProvider = StateNotifierProvider<ListNotifier, List<String>>((ref) {
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
            // print('list : $list');
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
            // print('${ref.watch(listProvider)}');
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
