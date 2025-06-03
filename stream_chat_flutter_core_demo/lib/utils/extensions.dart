import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Extensions can be used to add functionality to the SDK. In the example
/// below, we add a simple extensions to the [StreamChatClient].
extension StreamChatClientExtension on StreamChatClient {
  /// Fetches the current user id.
  String get uid => state.currentUser!.id;
}
