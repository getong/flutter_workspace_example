import 'package:flutter/cupertino.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_imessage/message_page.dart';
import 'package:animations/animations.dart';

class AppCoordinator {
  static final AppCoordinator _instance = AppCoordinator._internal();
  factory AppCoordinator() => _instance;
  AppCoordinator._internal();

  NavigatorState? _navigator;

  void setNavigator(NavigatorState navigator) {
    _navigator = navigator;
  }

  void navigateToChannel(Channel channel) {
    if (_navigator == null) return;

    _navigator!.push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) =>
            StreamChannel(channel: channel, child: const MessagePage()),
        transitionsBuilder: (_, animation, secondaryAnimation, child) =>
            SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
      ),
    );
  }

  void navigateBack() {
    if (_navigator == null) return;
    _navigator!.pop();
  }
}
