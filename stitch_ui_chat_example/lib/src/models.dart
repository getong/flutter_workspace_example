import 'package:flutter/material.dart';

@immutable
class Person {
  const Person({
    required this.name,
    required this.initials,
    required this.role,
    required this.accent,
    required this.fill,
    this.isOnline = false,
    this.icon,
  });

  final String name;
  final String initials;
  final String role;
  final Color accent;
  final Color fill;
  final bool isOnline;
  final IconData? icon;
}

@immutable
class MessageAttachment {
  const MessageAttachment({
    required this.title,
    required this.subtitle,
    required this.colors,
  });

  final String title;
  final String subtitle;
  final List<Color> colors;
}

@immutable
class MessageEntry {
  const MessageEntry({
    required this.text,
    required this.time,
    required this.isMe,
    this.attachment,
  });

  final String text;
  final String time;
  final bool isMe;
  final MessageAttachment? attachment;
}

@immutable
class ChatPreview {
  const ChatPreview({
    required this.person,
    required this.lastMessage,
    required this.timestamp,
    required this.messages,
    this.unreadCount = 0,
    this.senderPrefix,
  });

  final Person person;
  final String lastMessage;
  final String timestamp;
  final int unreadCount;
  final String? senderPrefix;
  final List<MessageEntry> messages;
}

@immutable
class ProfileStats {
  const ProfileStats({
    required this.name,
    required this.email,
    required this.contacts,
    required this.messages,
  });

  final String name;
  final String email;
  final String contacts;
  final String messages;
}

@immutable
class SettingAction {
  const SettingAction({
    required this.label,
    required this.icon,
    required this.accent,
    required this.background,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final Color background;
}
