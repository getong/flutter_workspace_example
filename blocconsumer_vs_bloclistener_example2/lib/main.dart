import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/orders_bloc.dart';
import 'screens/order_completed_screen.dart';
import 'widgets/control_buttons_widget.dart';
import 'widgets/bloc_examples_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlocConsumer vs BlocListener Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => OrdersBloc(),
        child: const MyHomePage(title: 'Bloc Examples'),
      ),
      routes: {
        'OrderCompletedScreen': (context) => const OrderCompletedScreen(),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ControlButtonsWidget(),
            SizedBox(height: 20),
            BlocExamplesWidget(),
          ],
        ),
      ),
    );
  }
}
