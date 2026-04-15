import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'news/bloc/news_bloc.dart';
import 'news/config/socket_defaults.dart';
import 'news/data/datasources/news_socket_datasource.dart';
import 'news/data/repositories/news_repository.dart';
import 'news/view/news_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => NewsRepository(dataSource: NewsSocketDataSource()),
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Flutter BLoC + Isolate Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF0B7285),
              ),
              useMaterial3: true,
            ),
            home: BlocProvider(
              create: (_) => NewsBloc(
                repository: context.read<NewsRepository>(),
                initialUrl: defaultWebSocketUrl(),
              ),
              child: const NewsPage(),
            ),
          );
        },
      ),
    );
  }
}
