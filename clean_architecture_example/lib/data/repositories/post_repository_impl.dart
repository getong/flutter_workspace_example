import '../../domain/repositories/post_repository.dart';
import '../../domain/entities/post.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<List<Post>> getPosts() async {
    return [
      Post(id: 1, title: 'Post 1', body: 'This is the body of post 1'),
      Post(id: 2, title: 'Post 2', body: 'This is the body of post 2'),
    ];
  }
}
