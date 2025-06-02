import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

// Events
abstract class ChannelListEvent {}

class LoadChannels extends ChannelListEvent {}

class RefreshChannels extends ChannelListEvent {}

class LoadMoreChannels extends ChannelListEvent {
  final int nextPageKey;
  LoadMoreChannels(this.nextPageKey);
}

// States
abstract class ChannelListState {}

class ChannelListInitial extends ChannelListState {}

class ChannelListLoading extends ChannelListState {}

class ChannelListLoaded extends ChannelListState {
  final List<Channel> channels;
  final int? nextPageKey;
  final String? error;

  ChannelListLoaded({required this.channels, this.nextPageKey, this.error});
}

class ChannelListError extends ChannelListState {
  final String message;
  ChannelListError(this.message);
}

// BLoC
class ChannelListBloc extends Bloc<ChannelListEvent, ChannelListState> {
  final StreamChatClient client;
  StreamChannelListController? _controller;

  ChannelListBloc({required this.client}) : super(ChannelListInitial()) {
    on<LoadChannels>(_onLoadChannels);
    on<RefreshChannels>(_onRefreshChannels);
    on<LoadMoreChannels>(_onLoadMoreChannels);
  }

  void _onLoadChannels(
    LoadChannels event,
    Emitter<ChannelListState> emit,
  ) async {
    emit(ChannelListLoading());

    try {
      final currentUser = client.state.currentUser;
      if (currentUser == null) {
        emit(ChannelListError('User not connected'));
        return;
      }

      _controller = StreamChannelListController(
        client: client,
        filter: Filter.and([
          Filter.in_('members', [currentUser.id]),
          Filter.equal('type', 'messaging'),
        ]),
        channelStateSort: const [SortOption('last_message_at')],
        limit: 20,
      );

      // Listen to controller changes
      _controller!.addListener(() {
        final value = _controller!.value;
        if (value != null && !isClosed) {
          value.when(
            (channels, nextPageKey, error) {
              if (!isClosed) {
                emit(
                  ChannelListLoaded(
                    channels: channels,
                    nextPageKey: nextPageKey,
                    error: error?.toString(),
                  ),
                );
              }
            },
            loading: () {
              if (!isClosed) {
                emit(ChannelListLoading());
              }
            },
            error: (e) {
              if (!isClosed) {
                emit(ChannelListError(e.toString()));
              }
            },
          );
        }
      });

      await _controller!.doInitialLoad();

      // Emit initial state if available
      final initialValue = _controller!.value;
      if (initialValue != null && !isClosed) {
        initialValue.when(
          (channels, nextPageKey, error) {
            emit(
              ChannelListLoaded(
                channels: channels,
                nextPageKey: nextPageKey,
                error: error?.toString(),
              ),
            );
          },
          loading: () => emit(ChannelListLoading()),
          error: (e) => emit(ChannelListError(e.toString())),
        );
      }
    } catch (e) {
      if (!isClosed) {
        emit(ChannelListError(e.toString()));
      }
    }
  }

  void _onRefreshChannels(
    RefreshChannels event,
    Emitter<ChannelListState> emit,
  ) async {
    if (_controller != null) {
      await _controller!.refresh();
    }
  }

  void _onLoadMoreChannels(
    LoadMoreChannels event,
    Emitter<ChannelListState> emit,
  ) async {
    if (_controller != null) {
      _controller!.loadMore(event.nextPageKey);
    }
  }

  @override
  Future<void> close() {
    _controller?.dispose();
    return super.close();
  }
}
