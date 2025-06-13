import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/bloc_builder_example.dart';
import 'widgets/bloc_consumer_example.dart';
import 'counter/counter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlocProvider vs BlocBuilder Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('BlocProvider vs BlocBuilder'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'BlocBuilder'),
              Tab(text: 'BlocConsumer'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [BlocBuilderExample(), BlocConsumerExample()],
        ),
      ),
    );
  }
}
