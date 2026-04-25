import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_posts_usecase.dart';
import '../../domain/entities/post.dart';

abstract class PostEvent {}

class FetchPostsEvent extends PostEvent {}

abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  final List<Post> posts;
  PostLoaded(this.posts);
}

class PostError extends PostState {
  final String message;
  PostError(this.message);
}

class PostBloc extends Bloc<PostEvent, PostState> {
  final GetPostsUseCase getPostsUseCase;

  PostBloc(this.getPostsUseCase) : super(PostInitial()) {
    on<FetchPostsEvent>((event, emit) async {
      emit(PostLoading());
      try {
        final posts = await getPostsUseCase();
        emit(PostLoaded(posts));
      } catch (e) {
        emit(PostError('Failed to fetch posts'));
      }
    });
  }
}
