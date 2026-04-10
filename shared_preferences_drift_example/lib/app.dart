import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'catalog/catalog.dart';
import 'shared/theme/app_theme.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.repository});

  final CatalogRepository repository;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    widget.repository.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cache Studio',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: BlocProvider(
        create: (_) =>
            CatalogBloc(repository: widget.repository)
              ..add(const CatalogStarted()),
        child: const CatalogPage(),
      ),
    );
  }
}
