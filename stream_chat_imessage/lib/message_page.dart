import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_imessage/bloc/message_bloc.dart';
import 'package:stream_chat_imessage/message_list_view.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show
        LazyLoadScrollView,
        MessageListController,
        MessageListCore,
        StreamChannel,
        StreamChatCore;

import 'package:stream_chat_imessage/channel_image.dart';
import 'package:stream_chat_imessage/channel_name_text.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final streamChannel = StreamChannel.of(context);

    return BlocProvider(
      create: (context) =>
          MessageBloc()..add(LoadMessages(streamChannel.channel)),
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          middle: Column(
            children: [
              ChannelImage(size: 32, channel: streamChannel.channel),
              ChannelNameText(
                channel: streamChannel.channel,
                size: 10,
                fontWeight: FontWeight.w300,
              ),
            ],
          ),
        ),
        child: StreamChatCore(
          client: streamChannel.channel.client,
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoading) {
                return const Center(child: CupertinoActivityIndicator());
              }

              if (state is MessageError) {
                return const Center(child: Text('Error loading messages'));
              }

              if (state is MessageLoaded || state is MessageSending) {
                final messages = state is MessageLoaded
                    ? state.messages
                    : (state as MessageSending).messages;

                return LazyLoadScrollView(
                  onStartOfPage: () async {
                    context.read<MessageBloc>().add(LoadMoreMessages());
                  },
                  child: MessageListView(messages: messages),
                );
              }

              return const Center(child: Text('Nothing here...'));
            },
          ),
        ),
      ),
    );
  }
}
