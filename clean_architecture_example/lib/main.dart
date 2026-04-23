import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'domain/repositories/post_repository.dart';
import 'presentation/bloc/post_bloc.dart';
import 'presentation/views/posts_view.dart';

final getIt = GetIt.instance;

void setup() {
  getIt.registerLazySingleton<PostRepository>(() => PostRepositoryImpl());
  getIt.registerLazySingleton<GetPostsUseCase>(
    () => GetPostsUseCase(getIt<PostRepository>()),
  );
}

void main() {
  setup();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Clean Architecture',
      home: BlocProvider(
        create: (_) => PostBloc(getIt<GetPostsUseCase>()),
        child: PostsView(),
      ),
    );
  }
}
