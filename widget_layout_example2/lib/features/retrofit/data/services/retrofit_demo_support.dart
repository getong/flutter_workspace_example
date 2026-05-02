import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'retrofit_demo_support.g.dart';

Dio buildJsonPlaceholderDio() {
  return Dio(
    BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      headers: const <String, Object>{
        'accept': 'application/json',
        'x-demo-client': 'widget_layout_example2',
      },
    ),
  );
}

@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class RetrofitDemoApi {
  factory RetrofitDemoApi(Dio dio) = _RetrofitDemoApi;

  @GET('/posts')
  Future<HttpResponse<List<RetrofitPost>>> fetchPosts(
    @Query('userId') int userId,
    @Query('_limit') int limit,
    @Header('x-demo-operation') String operation,
  );

  @GET('/posts/{id}')
  Future<HttpResponse<RetrofitPost>> fetchPostById(
    @Path('id') int postId,
    @Header('x-demo-operation') String operation,
  );

  @POST('/posts')
  @Headers(<String, dynamic>{'content-type': 'application/json; charset=UTF-8'})
  Future<HttpResponse<RetrofitPost>> createPost(
    @Body() RetrofitDraftPost post,
    @Header('x-demo-operation') String operation,
  );
}

class RetrofitDraftPost {
  const RetrofitDraftPost({
    required this.userId,
    required this.title,
    required this.body,
  });

  final int userId;
  final String title;
  final String body;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{'userId': userId, 'title': title, 'body': body};
  }
}

class RetrofitPost {
  const RetrofitPost({
    required this.userId,
    required this.title,
    required this.body,
    this.id,
  });

  factory RetrofitPost.fromJson(Map<String, dynamic> json) {
    return RetrofitPost(
      id: json['id'] as int?,
      userId: json['userId'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
    );
  }

  final int? id;
  final int userId;
  final String title;
  final String body;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}
