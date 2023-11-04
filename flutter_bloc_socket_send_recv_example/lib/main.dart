import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'socket_bloc.dart'; // Import the SocketBloc

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket BLoC Example',
      home: BlocProvider(
        create: (context) => SocketBloc(),
        child: SocketPage(),
      ),
    );
  }
}

class SocketPage extends StatefulWidget {
  @override
  _SocketPageState createState() => _SocketPageState();
}

class _SocketPageState extends State<SocketPage> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketBloc = BlocProvider.of<SocketBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Socket BLoC Example')),
      body: Center(
        child: BlocBuilder<SocketBloc, SocketState>(
          builder: (context, state) {
            if (state is SocketDisconnected || state is SocketInitial) {
              // Show a message when disconnected
              return ConnectionButtion();
            } else {
              // By default, show an empty container
              return Column(
                children: [
                  DisConnectionButtion(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(state.messages[index]),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _textController,
                          decoration: InputDecoration(
                            labelText: 'Send a message',
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              socketBloc.add(SendMessage(value));
                              _textController.clear();
                            }
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          if (_textController.text.isNotEmpty) {
                            socketBloc.add(SendMessage(_textController.text));
                            _textController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

class ConnectionButtion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => BlocProvider.of<SocketBloc>(context)
          .add(SocketConnect('127.0.0.1', 12345)),
      tooltip: 'Connect',
      backgroundColor:
          Colors.green, // Use a different color to indicate connect
      child: Icon(Icons.link),
    );
  }
}

class DisConnectionButtion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final socketBloc = BlocProvider.of<SocketBloc>(context);
    return FloatingActionButton(
      onPressed: () => socketBloc.add(SocketDisconnect()),
      tooltip: 'Disconnect',
      backgroundColor:
          Colors.red, // Use a different color to indicate disconnect
      child: Icon(Icons.link_off),
    );
  }
}
