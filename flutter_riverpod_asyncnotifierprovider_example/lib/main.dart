import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';

class User {
  String name;
  int age;
  User({required this.name, required this.age});
}

class SomeAsyncNotifier extends AsyncNotifier<List<User>> {
  List<User> _list = [];

  @override
  FutureOr<List<User>> build() async {
    await Future.delayed(Duration(seconds: 3));
    return _list;
  }

  Future<void> addUser(User user) async {
    state = AsyncValue.loading();
    await Future.delayed(Duration(seconds: 3));
    _list = [..._list, user];
    state = AsyncValue.data(_list);
  }
}

final someAsyncNotifierProvider =
    AsyncNotifierProvider<SomeAsyncNotifier, List<User>>(
        () => SomeAsyncNotifier());

class SomeScreen extends ConsumerStatefulWidget {
  @override
  SomeScreenState createState() => SomeScreenState();
}

class SomeScreenState extends ConsumerState<SomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ref.watch(someAsyncNotifierProvider).when(
          loading: () => CircularProgressIndicator(),
          error: (error, stackTrace) => Text('Could not load data: $error'),
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return TextButton(
                  child: Text(data[index].name),
                  onPressed: () {
                    User user = User(name: 'hyuil', age: 30);
                    ref.read(someAsyncNotifierProvider.notifier).addUser(user);
                  },
                );
              },
            );
          },
        );
  }
}

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the data provider to asynchronously obtain the data
    final dataAsyncValue = ref.watch(someAsyncNotifierProvider);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Async Riverpod Example'),
        ),
        body: Center(
          child: SomeScreen(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Access the CounterNotifier and call its increment method
            User user = User(name: 'hyuil', age: 30);
            ref.read(someAsyncNotifierProvider.notifier).addUser(user);
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
