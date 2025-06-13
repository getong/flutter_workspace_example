import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'repositories/user_repository.dart';
import 'bloc/user_bloc.dart';
import 'screens/user_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RepositoryProvider Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RepositoryProvider(
        create: (context) => UserRepository(),
        child: BlocProvider(
          create: (context) => UserBloc(
            userRepository: context.read<UserRepository>(),
          ),
          child: const UserListScreen(),
        ),
      ),
    );
  }
}
