import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'socket_bloc.dart';

// ncat -l 12345 --keep-open --exec "/bin/cat"

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
  final ScrollController _scrollController = ScrollController();
  final List<Widget> _messageWidgets = [];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // A method to handle automatic scrolling
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      final position = _scrollController.position.maxScrollExtent;
      _scrollController.animateTo(
        position,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final socketBloc = BlocProvider.of<SocketBloc>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Socket BLoC Example')),
      drawer: Drawer(
          width: 50.0,
          child:
              BlocBuilder<SocketBloc, SocketState>(builder: (context, state) {
            if (state is SocketDisconnected || state is SocketInitial) {
              return ConnectionButtion();
            } else {
              return DisConnectionButtion();
            }
          })),
      body: Center(
        child: BlocBuilder<SocketBloc, SocketState>(
          builder: (context, state) {
            if ((state is SocketDisconnected || state is SocketInitial)) {
              // Show a message when disconnected
              return ConnectionButtion();
            } else {
              // By default, show an empty container
              return Column(
                children: [
                  Expanded(
                    child: BlocConsumer<SocketBloc, SocketState>(
                      listener: (context, state) {
                        if (state is MessageReceived) {
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => _scrollToBottom());
                        }
                      },
                      builder: (context, state) {
                        List<String> messages = state.messages;
                        return ListView(
                          controller: _scrollController,
                          children: messages
                              .map((message) => ListTile(title: Text(message)))
                              .toList(),
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
                        tooltip: 'send msg',
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
