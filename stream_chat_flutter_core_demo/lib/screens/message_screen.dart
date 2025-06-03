import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import '../utils/extensions.dart';

/// A list of messages sent in the current channel.
/// When a user taps on a channel in [HomeScreen], a navigator push
/// [MessageScreen] to display the list of messages in the selected channel.
///
/// This is implemented using [MessageListCore], a convenience builder with
/// callbacks for building UIs based on different api results.
class MessageScreen extends StatefulWidget {
  /// Build a MessageScreen
  const MessageScreen({super.key});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final StreamMessageInputController messageInputController =
      StreamMessageInputController();
  late final ScrollController _scrollController;
  final messageListController = MessageListController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    messageInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateList() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// To access the current channel, we can use the `.of()` method on
    /// [StreamChannel] to fetch the closest instance.
    final channel = StreamChannel.of(context).channel;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Iterable<User>>(
          initialData: channel.state?.typingEvents.keys,
          stream: channel.state?.typingEventsStream.map((it) => it.keys),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Text('${snapshot.data!.first.name} is typing...');
            }
            return const SizedBox();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LazyLoadScrollView(
                onEndOfPage: () async {
                  messageListController.paginateData!();
                },
                child: MessageListCore(
                  messageListController: messageListController,
                  emptyBuilder: (BuildContext context) =>
                      const Center(child: Text('Nothing here yet')),
                  loadingBuilder: (BuildContext context) => const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  messageListBuilder:
                      (BuildContext context, List<Message> messages) =>
                          ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            reverse: true,
                            itemBuilder: (BuildContext context, int index) {
                              final item = messages[index];
                              final client = StreamChatCore.of(context).client;
                              if (item.user!.id == client.uid) {
                                return Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(item.text!),
                                  ),
                                );
                              } else {
                                return Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(item.text!),
                                  ),
                                );
                              }
                            },
                          ),
                  errorBuilder: (BuildContext context, error) {
                    print(error.toString());
                    return const Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Text(
                          'Oh no, an error occured. Please see logs.',
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageInputController.textFieldController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message',
                      ),
                    ),
                  ),
                  Material(
                    type: MaterialType.circle,
                    color: Colors.blue,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () async {
                        if (messageInputController.text.isNotEmpty) {
                          await channel.sendMessage(
                            messageInputController.message,
                          );
                          messageInputController.clear();
                          if (mounted) {
                            _updateList();
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Icon(Icons.send, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
