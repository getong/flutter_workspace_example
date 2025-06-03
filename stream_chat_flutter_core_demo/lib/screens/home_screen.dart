import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'message_screen.dart';

/// Basic layout displaying a list of [Channel]s the user is a part of.
/// This is implemented using a [StreamChannelListController].
///
/// [StreamChannelListController] is a controller that lets you manage a list of
/// channels.
class HomeScreen extends StatefulWidget {
  /// Builds a basic layout displaying a list of [Channel]s the user is a
  /// part of.
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controller used for loading more data and controlling pagination in
  /// [StreamChannelListController].
  late final channelListController = StreamChannelListController(
    client: StreamChatCore.of(context).client,
    filter: Filter.and([
      Filter.equal('type', 'messaging'),
      Filter.in_('members', [StreamChatCore.of(context).currentUser!.id]),
    ]),
  );

  @override
  void initState() {
    channelListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    channelListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Channels')),
    body: PagedValueListenableBuilder<int, Channel>(
      valueListenable: channelListController,
      builder: (context, value, child) {
        return value.when(
          (channels, nextPageKey, error) => LazyLoadScrollView(
            onEndOfPage: () async {
              if (nextPageKey != null) {
                channelListController.loadMore(nextPageKey);
              }
            },
            child: ListView.builder(
              /// We're using the channels length when there are no more
              /// pages to load and there are no errors with pagination.
              /// In case we need to show a loading indicator or and error
              /// tile we're increasing the count by 1.
              itemCount: (nextPageKey != null || error != null)
                  ? channels.length + 1
                  : channels.length,
              itemBuilder: (BuildContext context, int index) {
                if (index == channels.length) {
                  if (error != null) {
                    return TextButton(
                      onPressed: () {
                        channelListController.retry();
                      },
                      child: Text(error.message),
                    );
                  }
                  return CircularProgressIndicator();
                }

                final item = channels[index];
                return ListTile(
                  title: Text(item.name ?? ''),
                  subtitle: StreamBuilder<Message?>(
                    stream: item.state!.lastMessageStream,
                    initialData: item.state!.lastMessage,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.text!);
                      }

                      return const SizedBox();
                    },
                  ),
                  onTap: () {
                    /// Display a list of messages when the user taps on
                    /// an item. We can use [StreamChannel] to wrap our
                    /// [MessageScreen] screen with the selected channel.
                    ///
                    /// This allows us to use a built-in inherited widget
                    /// for accessing our `channel` later on.
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => StreamChannel(
                          channel: item,
                          child: const MessageScreen(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          loading: () => const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          ),
          error: (e) => Center(
            child: Text(
              'Oh no, something went wrong. '
              'Please check your config. $e',
            ),
          ),
        );
      },
    ),
  );
}
