import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:widget_layout_example2/app_navigation.dart';
import 'package:widget_layout_example2/features/retrofit/data/services/retrofit_demo_support.dart';

@RoutePage(name: RouteName.retrofit)
class RetrofitPage extends StatefulWidget {
  const RetrofitPage({super.key});

  @override
  State<RetrofitPage> createState() => _RetrofitPageState();
}

class _RetrofitPageState extends State<RetrofitPage> {
  static const String _retrofitSnippet = '''
@RestApi(baseUrl: 'https://jsonplaceholder.typicode.com')
abstract class RetrofitDemoApi {
  factory RetrofitDemoApi(Dio dio) = _RetrofitDemoApi;

  @GET('/posts')
  Future<HttpResponse<List<RetrofitPost>>> fetchPosts(
    @Query('userId') int userId,
    @Query('_limit') int limit,
    @Header('x-demo-operation') String operation,
  );
}
''';

  late final RetrofitDemoApi _api;

  bool _isLoading = false;
  int _selectedUserId = 1;
  String _statusMessage =
      'Ready. Run any Retrofit action to inspect typed responses.';
  int? _lastStatusCode;
  List<RetrofitPost> _posts = const <RetrofitPost>[];
  RetrofitPost? _focusedPost;
  RetrofitPost? _createdPost;

  @override
  void initState() {
    super.initState();
    _api = RetrofitDemoApi(buildJsonPlaceholderDio());
  }

  Future<void> _loadPosts() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Calling @GET /posts with query parameters...';
    });

    try {
      final HttpResponse<List<RetrofitPost>> response = await _api.fetchPosts(
        _selectedUserId,
        6,
        'retrofit-posts',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _posts = response.data;
        _focusedPost = null;
        _lastStatusCode = response.response.statusCode;
        _statusMessage =
            'Loaded ${response.data.length} typed posts through the generated client.';
      });
    } on DioException catch (error) {
      _handleError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadPostDetail() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Calling @GET /posts/{id} with a path parameter...';
    });

    try {
      final HttpResponse<RetrofitPost> response = await _api.fetchPostById(
        1,
        'retrofit-detail',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _focusedPost = response.data;
        _lastStatusCode = response.response.statusCode;
        _statusMessage =
            'Loaded a single typed post using a Retrofit path parameter.';
      });
    } on DioException catch (error) {
      _handleError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _createPost() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Calling @POST /posts with a typed body...';
    });

    final RetrofitDraftPost draft = RetrofitDraftPost(
      userId: _selectedUserId,
      title: 'Retrofit draft for user $_selectedUserId',
      body:
          'This request body is serialized from a Dart model before Dio sends it.',
    );

    try {
      final HttpResponse<RetrofitPost> response = await _api.createPost(
        draft,
        'retrofit-create',
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _createdPost = response.data;
        _posts = <RetrofitPost>[response.data, ..._posts];
        _lastStatusCode = response.response.statusCode;
        _statusMessage =
            'POST completed. Retrofit serialized the body and parsed the response model.';
      });
    } on DioException catch (error) {
      _handleError(error);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _handleError(DioException error) {
    if (!mounted) {
      return;
    }

    setState(() {
      _lastStatusCode = error.response?.statusCode;
      _statusMessage =
          'Retrofit request failed: ${error.message ?? error.type.name}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('retrofit Module')),
      body: SelectionArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: <Widget>[
            Text(
              'retrofit generates a typed API client on top of Dio. This page '
              'shows `@GET`, `@POST`, query parameters, path parameters, '
              'typed request bodies, and `HttpResponse<T>` handling.',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Generated Client Actions',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedUserId,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'userId',
                      ),
                      items: List<DropdownMenuItem<int>>.generate(5, (
                        int index,
                      ) {
                        final int userId = index + 1;
                        return DropdownMenuItem<int>(
                          value: userId,
                          child: Text('User $userId'),
                        );
                      }),
                      onChanged: _isLoading
                          ? null
                          : (int? value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedUserId = value;
                              });
                            },
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        FilledButton.icon(
                          onPressed: _isLoading ? null : _loadPosts,
                          icon: const Icon(Icons.download_outlined),
                          label: const Text('GET Posts'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: _isLoading ? null : _loadPostDetail,
                          icon: const Icon(Icons.article_outlined),
                          label: const Text('GET Detail'),
                        ),
                        FilledButton.tonalIcon(
                          onPressed: _isLoading ? null : _createPost,
                          icon: const Icon(Icons.send_outlined),
                          label: const Text('POST Draft'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const <Widget>[
                        Chip(label: Text('@GET')),
                        Chip(label: Text('@POST')),
                        Chip(label: Text('@Query')),
                        Chip(label: Text('@Path')),
                        Chip(label: Text('@Body')),
                        Chip(label: Text('HttpResponse<T>')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _statusMessage,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_lastStatusCode != null) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        'Last status code: $_lastStatusCode',
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                    if (_createdPost != null) ...<Widget>[
                      const SizedBox(height: 16),
                      _PostCard(post: _createdPost!, banner: 'Latest POST'),
                    ],
                    const SizedBox(height: 16),
                    _CodeBlock(code: _retrofitSnippet),
                  ],
                ),
              ),
            ),
            if (_focusedPost != null) ...<Widget>[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Focused Detail',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _PostCard(post: _focusedPost!),
                    ],
                  ),
                ),
              ),
            ],
            if (_posts.isNotEmpty) ...<Widget>[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Typed Post List',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: _posts
                            .map((RetrofitPost post) => _PostCard(post: post))
                            .toList(growable: false),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.router.replacePath('/'),
        icon: const Icon(Icons.home),
        label: const Text('Home'),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: SelectableText(
        code.trim(),
        style: theme.textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  const _PostCard({required this.post, this.banner});

  final RetrofitPost post;
  final String? banner;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (banner != null) ...<Widget>[
              Text(
                banner!,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              post.title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(post.body),
            const SizedBox(height: 10),
            Text(
              'postId: ${post.id ?? 'pending'} | userId: ${post.userId}',
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
