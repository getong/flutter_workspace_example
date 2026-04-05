import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<IncrementEvent>((event, emit) {
      emit(state + event.value);
    });

    on<DecrementEvent>((event, emit) {
      emit(state - event.value);
    });
  }

  @override
  Stream<int> mapEventToState(CounterEvent event) async* {
    if (event is IncrementEvent) {
      yield state + event.value;
    } else if (event is DecrementEvent) {
      yield state - event.value;
    }
  }
}

abstract class CounterEvent {}

class IncrementEvent extends CounterEvent {
  final int value;

  IncrementEvent(this.value);

  IncrementEvent operator +(int other) {
    return IncrementEvent(this.value + other);
  }
}

class DecrementEvent extends CounterEvent {
  final int value;

  DecrementEvent(this.value);

  DecrementEvent operator -(int other) {
    return DecrementEvent(this.value - other);
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Counter App'),
      ),
      body: Center(
        child: BlocBuilder<CounterBloc, int>(
          builder: (context, count) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Count: $count',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(IncrementEvent(1));
                      },
                      child: Icon(Icons.add),
                    ),
                    SizedBox(width: 16),
                    FloatingActionButton(
                      onPressed: () {
                        context.read<CounterBloc>().add(DecrementEvent(1));
                      },
                      child: Icon(Icons.remove),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Bloc Example',
      home: BlocProvider(
        create: (context) => CounterBloc(),
        child: CounterPage(),
      ),
    );
  }
}
