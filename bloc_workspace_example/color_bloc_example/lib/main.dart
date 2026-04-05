import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'color_bloc.dart';
import 'color_state.dart';
import 'color_event.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Color Bloc Example',
      home: BlocProvider(
        create: (context) => ColorBloc(),
        child: ColorScreen(),
      ),
    );
  }
}

class ColorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Bloc Example'),
        backgroundColor: Colors.grey[800],
      ),
      body: BlocBuilder<ColorBloc, ColorState>(
        builder: (context, state) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            color: state.color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Current Color: ${state.runtimeType.toString().replaceAll('ColorState', '')}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<ColorBloc>().add(ChangeToRedEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Red'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ColorBloc>().add(ChangeToBlueEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Blue'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        context.read<ColorBloc>().add(ChangeToGreenEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text('Green'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ColorBloc>().add(ChangeToOrangeEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('Orange'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
