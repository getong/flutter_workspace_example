import 'package:flutter/cupertino.dart';
import 'package:stream_chat_imessage/channel_preview.dart';
import 'package:stream_chat_imessage/coordinator/app_coordinator.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart'
    show Channel;

class ChannelListView extends StatelessWidget {
  const ChannelListView({Key? key, required this.channels}) : super(key: key);
  final List<Channel> channels;

  @override
  Widget build(BuildContext context) {
    final filteredChannels = List.from(channels)
      ..removeWhere((channel) => channel.lastMessageAt == null);

    return SliverList(
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: ChannelPreview(
            channel: filteredChannels[index],
            onTap: () {
              AppCoordinator().navigateToChannel(filteredChannels[index]);
            },
          ),
        );
      }, childCount: filteredChannels.length),
    );
  }
}
