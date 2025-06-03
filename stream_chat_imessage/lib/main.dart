import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:stream_chat_imessage/coordinator/app_coordinator.dart';
import 'package:stream_chat_imessage/bloc/channel_list_bloc.dart';
import 'package:stream_chat_imessage/channel_list_view.dart';
import 'package:stream_chat_imessage/channel_page_appbar.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final client = StreamChatClient('b67pax5b2wdq', logLevel: Level.INFO); //

  // For demonstration purposes. Fixed user and token.
  await client.connectUser(
    User(
      id: 'cool-shadow-7',
      extraData: const {
        'image':
            'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow',
      },
    ),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY29vbC1zaGFkb3ctNyJ9.gkOlCRb1qgy4joHPaxFwPOdXcGvSPvp6QY0S4mpRkVo',
  );

  runApp(IMessage(client: client));
}

class IMessage extends StatelessWidget {
  const IMessage({Key? key, required this.client}) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en_US', null);

    return CupertinoApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(brightness: Brightness.light),
      navigatorObservers: [_NavigatorObserver()],
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ChannelListBloc(client: client)),
        ],
        child: StreamChatCore(client: client, child: const ChatLoader()),
      ),
    );
  }
}

class _NavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    // Set navigator when route is pushed
    if (navigator != null) {
      AppCoordinator().setNavigator(navigator!);
    }
  }
}

class ChatLoader extends StatefulWidget {
  const ChatLoader({Key? key}) : super(key: key);

  @override
  State<ChatLoader> createState() => _ChatLoaderState();
}

class _ChatLoaderState extends State<ChatLoader> {
  @override
  void initState() {
    super.initState();
    // Wait for client to be connected before loading channels
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final client = StreamChatCore.of(context).client;
      if (client.state.currentUser != null) {
        context.read<ChannelListBloc>().add(LoadChannels());
      } else {
        // Wait for connection
        client.on().listen((event) {
          if (event is Event &&
              event.type == 'health.check' &&
              client.state.currentUser != null) {
            context.read<ChannelListBloc>().add(LoadChannels());
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BlocBuilder<ChannelListBloc, ChannelListState>(
        builder: (context, state) {
          print('Channel list state: $state'); // Debug print

          if (state is ChannelListLoading) {
            return const Center(
              child: SizedBox(
                height: 100.0,
                width: 100.0,
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (state is ChannelListError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  CupertinoButton(
                    onPressed: () {
                      context.read<ChannelListBloc>().add(LoadChannels());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is ChannelListLoaded) {
            return LazyLoadScrollView(
              onEndOfPage: () async {
                if (state.nextPageKey != null) {
                  context.read<ChannelListBloc>().add(
                    LoadMoreChannels(state.nextPageKey!),
                  );
                }
              },
              child: state.channels.isEmpty
                  ? const Center(
                      child: Text('Looks like you are not in any channels'),
                    )
                  : CustomScrollView(
                      slivers: [
                        CupertinoSliverRefreshControl(
                          onRefresh: () async {
                            context.read<ChannelListBloc>().add(
                              RefreshChannels(),
                            );
                          },
                        ),
                        const ChannelPageAppBar(),
                        SliverPadding(
                          sliver: ChannelListView(channels: state.channels),
                          padding: const EdgeInsets.only(top: 16),
                        ),
                      ],
                    ),
            );
          }

          // Initial state
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoActivityIndicator(),
                SizedBox(height: 16),
                Text('Initializing...'),
              ],
            ),
          );
        },
      ),
    );
  }
}
