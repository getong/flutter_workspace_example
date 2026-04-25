import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/di/di.dart';
import '../bloc/post_bloc.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PostBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Posts')),
        body: BlocBuilder<PostBloc, PostState>(
          builder: (context, state) {
            if (state is PostLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is PostLoaded) {
              return ListView.builder(
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.posts[index].title),
                    subtitle: Text(state.posts[index].body),
                  );
                },
              );
            } else if (state is PostError) {
              return Center(child: Text(state.message));
            }

            return const Center(child: Text('Press the button to fetch posts'));
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.read<PostBloc>().add(FetchPostsEvent());
          },
          child: const Icon(Icons.download),
        ),
      ),
    );
  }
}
