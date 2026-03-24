import 'package:bloc_ws_example/websocket/bloc/ws_bloc.dart';
import 'package:bloc_ws_example/websocket/view/ws_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'websocket/data/ws_repository.dart';

void main() {
  runApp(const WsApp());
}

class WsApp extends StatelessWidget {
  const WsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => WsRepository(),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (_) => WsBloc(repository: context.read<WsRepository>()),
            child: MaterialApp(
              title: 'BLoC WebSocket Example',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              ),
              home: const WsPage(),
            ),
          );
        },
      ),
    );
  }
}
