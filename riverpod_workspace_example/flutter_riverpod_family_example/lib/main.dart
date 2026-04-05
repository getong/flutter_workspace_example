import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userCounterProvider =
    StateProvider.family<int, String>((ref, userId) => 0); // Initial value is 0

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('User Counters'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              UserCounter(userId: 'user1'),
              UserCounter(userId: 'user2'),
            ],
          ),
        ),
      ),
    );
  }
}

class UserCounter extends ConsumerWidget {
  final String userId;

  UserCounter({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the userCounterProvider with the specific userId
    final provider = userCounterProvider(userId);
    final userCounter = ref.watch(provider);

    return Column(
      children: [
        Text('User ID: $userId'),
        Text('Counter: $userCounter'),
        ElevatedButton(
          onPressed: () {
            // Increment the user-specific counter
            ref.read(provider.notifier).state = userCounter + 1;
          },
          child: Text('Increment Counter'),
        ),
      ],
    );
  }
}
