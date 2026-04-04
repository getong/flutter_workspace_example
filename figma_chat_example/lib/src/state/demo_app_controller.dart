import 'package:flutter/material.dart';

import '../models/demo_models.dart';
import '../theme/app_theme.dart';

class DemoScope extends InheritedNotifier<DemoAppController> {
  const DemoScope({
    super.key,
    required DemoAppController controller,
    required super.child,
  }) : super(notifier: controller);

  static DemoAppController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DemoScope>();
    assert(scope != null, 'DemoScope not found in widget tree.');
    return scope!.notifier!;
  }
}

class DemoAppController extends ChangeNotifier {
  DemoAppController() {
    _selectedContactId = _contacts.first.id;
    _messagesByContact = {
      _contacts[0].id: [
        DemoMessage.other(
          id: '1',
          text: 'Hey! How are you doing?',
          senderName: _contacts[0].name,
          sentAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
        DemoMessage.user(
          id: '2',
          text: "I'm doing great! Just working on some projects.",
          sentAt: DateTime.now().subtract(const Duration(minutes: 58)),
        ),
        DemoMessage.other(
          id: '3',
          text: 'That sounds exciting! What are you working on?',
          senderName: _contacts[0].name,
          sentAt: DateTime.now().subtract(const Duration(minutes: 56)),
        ),
        DemoMessage.user(
          id: '4',
          text: "Building a chat application! It's coming along nicely.",
          sentAt: DateTime.now().subtract(const Duration(minutes: 54)),
        ),
      ],
      _contacts[1].id: [
        DemoMessage.other(
          id: '5',
          text: 'Ready for the sprint review later?',
          senderName: _contacts[1].name,
          sentAt: DateTime.now().subtract(const Duration(minutes: 42)),
        ),
        DemoMessage.user(
          id: '6',
          text: 'Almost. I just need to polish the profile flow.',
          sentAt: DateTime.now().subtract(const Duration(minutes: 39)),
        ),
      ],
      _contacts[2].id: [
        DemoMessage.other(
          id: '7',
          text: 'I left you notes on the mockups.',
          senderName: _contacts[2].name,
          sentAt: DateTime.now().subtract(
            const Duration(hours: 2, minutes: 15),
          ),
        ),
      ],
      _contacts[3].id: [
        DemoMessage.other(
          id: '8',
          text: 'Dinner after work?',
          senderName: _contacts[3].name,
          sentAt: DateTime.now().subtract(const Duration(hours: 3)),
        ),
      ],
    };
  }

  DemoUser? _user;
  AppScreen _screen = AppScreen.login;
  late final Map<String, List<DemoMessage>> _messagesByContact;
  late String _selectedContactId;

  final List<DemoContact> _contacts = const [
    DemoContact(
      id: '1',
      name: 'Sarah Johnson',
      isOnline: true,
      palette: [Color(0xFF8B5CF6), Color(0xFF3B82F6)],
    ),
    DemoContact(
      id: '2',
      name: 'Mike Wilson',
      isOnline: true,
      palette: [Color(0xFF0EA5E9), Color(0xFF14B8A6)],
    ),
    DemoContact(
      id: '3',
      name: 'Emma Davis',
      isOnline: false,
      palette: [Color(0xFFF97316), Color(0xFFEF4444)],
    ),
    DemoContact(
      id: '4',
      name: 'Alex Chen',
      isOnline: true,
      palette: [Color(0xFFEC4899), Color(0xFF8B5CF6)],
    ),
  ];

  DemoUser? get user => _user;
  AppScreen get screen => _screen;
  List<DemoContact> get contacts => List.unmodifiable(_contacts);

  DemoContact get selectedContact =>
      _contacts.firstWhere((contact) => contact.id == _selectedContactId);

  List<DemoMessage> get activeMessages =>
      List.unmodifiable(_messagesByContact[_selectedContactId] ?? const []);

  Future<void> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _user = DemoUser(
      id: '1',
      name: 'John Doe',
      email: email,
      bio: 'Love chatting with friends!',
      palette: const [AppColors.purple500, AppColors.blue500],
    );
    _screen = AppScreen.chat;
    notifyListeners();
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    _user = DemoUser(
      id: '1',
      name: name,
      email: email,
      bio: '',
      palette: const [AppColors.purple500, AppColors.blue500],
    );
    _screen = AppScreen.chat;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _screen = AppScreen.login;
    notifyListeners();
  }

  void goToLogin() {
    _screen = AppScreen.login;
    notifyListeners();
  }

  void goToSignup() {
    _screen = AppScreen.signup;
    notifyListeners();
  }

  void goToChat() {
    _screen = _user == null ? AppScreen.login : AppScreen.chat;
    notifyListeners();
  }

  void goToProfile() {
    _screen = _user == null ? AppScreen.login : AppScreen.profile;
    notifyListeners();
  }

  void selectContact(String id) {
    _selectedContactId = id;
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String email,
    required String bio,
  }) {
    final current = _user;
    if (current == null) {
      return;
    }

    _user = current.copyWith(name: name, email: email, bio: bio);
    notifyListeners();
  }

  void sendMessage(String rawText) {
    final trimmed = rawText.trim();
    if (trimmed.isEmpty) {
      return;
    }

    final activeContactId = _selectedContactId;
    final activeContact = selectedContact;
    final messages = _messagesByContact.putIfAbsent(activeContactId, () => []);

    messages.add(
      DemoMessage.user(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        text: trimmed,
        sentAt: DateTime.now(),
      ),
    );
    notifyListeners();

    Future<void>.delayed(const Duration(seconds: 1), () {
      final replyList = _messagesByContact[activeContactId];
      if (replyList == null) {
        return;
      }
      replyList.add(
        DemoMessage.other(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          text: 'Thanks for your message! This is a demo response.',
          senderName: activeContact.name,
          sentAt: DateTime.now(),
        ),
      );
      notifyListeners();
    });
  }
}
