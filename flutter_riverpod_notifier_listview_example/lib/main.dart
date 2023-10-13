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
    // state.removeAt(index);
    // state = [...state];
    state = List.from(state)..removeAt(index);
  }
}

final listProvider = NotifierProvider<ListNotifier, List<String>>(() {
  return ListNotifier();
});

void main() {
  runApp(ProviderScope(
      child: MaterialApp(
    title: 'title',
    home: MyApp(),
  )));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riverpod ListView Example'),
      ),
      body: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          textBaseline: TextBaseline.alphabetic,
          children: <Widget>[
            Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                textBaseline: TextBaseline.alphabetic,
                children: <Widget>[
                  Expanded(
                      child: FloatingActionButton(
                    onPressed: () {
                      final list = ref.watch(listProvider);
                      if (list.length > 0) {
                        ref
                            .read(listProvider.notifier)
                            .removeItem(list.length - 1);
                      } else {
                        _showDialog(context);
                      }
                    },
                    child: Icon(Icons.remove),
                    backgroundColor: Colors.blue,
                  )),
                  Expanded(
                      child: FloatingActionButton(
                    onPressed: () {
                      final newItem =
                          DateTime.now().toString(); // Example new item
                      ref.read(listProvider.notifier).addItem(newItem);
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.black,
                  )),
                ]),
            Expanded(
              child: SizedBox(),
            ),
            Expanded(child: Consumer(
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
            )),
          ]),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('no element'),
        content: Text('This is no element, close.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close'),
          ),
        ],
      );
    },
  );
}
