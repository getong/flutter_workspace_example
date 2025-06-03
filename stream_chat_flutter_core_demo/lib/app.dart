import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'screens/home_screen.dart';

/// Example application using Stream Chat core widgets.
/// Stream Chat Core is a set of Flutter wrappers which provide basic
/// functionality for building Flutter applications using Stream.
///
/// If you'd prefer using pre-made UI widgets for your app, please see our other
/// package, `stream_chat_flutter`.
class StreamExample extends StatelessWidget {
  /// Minimal example using Stream's core Flutter package.
  ///
  /// If you'd prefer using pre-made UI widgets for your app, please see our
  /// other package, `stream_chat_flutter`.
  const StreamExample({super.key, required this.client});

  /// Instance of Stream Client.
  /// Stream's [StreamChatClient] can be used to connect to our servers and
  /// set the default user for the application. Performing these actions
  /// trigger a websocket connection allowing for real-time updates.
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Stream Chat Core Example',
    home: HomeScreen(),
    builder: (context, child) => StreamChatCore(client: client, child: child!),
  );
}
