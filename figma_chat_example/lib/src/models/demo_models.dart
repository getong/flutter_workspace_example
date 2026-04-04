import 'package:flutter/material.dart';

enum AppScreen { login, signup, chat, profile }

class DemoUser {
  const DemoUser({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
    required this.palette,
  });

  final String id;
  final String name;
  final String email;
  final String bio;
  final List<Color> palette;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    final letters = parts.take(2).map((part) => part[0]).join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }

  DemoUser copyWith({String? name, String? email, String? bio}) {
    return DemoUser(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      palette: palette,
    );
  }
}

class DemoContact {
  const DemoContact({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.palette,
  });

  final String id;
  final String name;
  final bool isOnline;
  final List<Color> palette;

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    final letters = parts.take(2).map((part) => part[0]).join();
    return letters.isEmpty ? '?' : letters.toUpperCase();
  }
}

class DemoMessage {
  const DemoMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.senderName,
    required this.sentAt,
  });

  final String id;
  final String text;
  final bool isUser;
  final String senderName;
  final DateTime sentAt;

  factory DemoMessage.user({
    required String id,
    required String text,
    required DateTime sentAt,
  }) {
    return DemoMessage(
      id: id,
      text: text,
      isUser: true,
      senderName: 'You',
      sentAt: sentAt,
    );
  }

  factory DemoMessage.other({
    required String id,
    required String text,
    required String senderName,
    required DateTime sentAt,
  }) {
    return DemoMessage(
      id: id,
      text: text,
      isUser: false,
      senderName: senderName,
      sentAt: sentAt,
    );
  }
}
