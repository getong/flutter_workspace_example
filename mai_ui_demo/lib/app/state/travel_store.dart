import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared, locally persisted state for all four tabs.
class TravelStore extends ChangeNotifier {
  TravelStore(this.preferences) {
    saved = (preferences.getStringList('saved') ?? ['shaxi', 'lijiang'])
        .toSet();
    preparations = List.generate(
      3,
      (i) => preferences.getBool('prep_$i') ?? i < 2,
    );
    name = preferences.getString('name') ?? '旅行者小A';
    notifications = preferences.getBool('notifications') ?? true;
    unread = preferences.getBool('unread') ?? true;
  }
  final SharedPreferences preferences;
  late Set<String> saved;
  late List<bool> preparations;
  late String name;
  late bool notifications, unread;
  int day = 0;
  String? saveError;
  int get completed => preparations.where((v) => v).length;
  int get daysUntilDeparture {
    final now = DateTime.now();
    return DateTime(
      2026,
      10,
      7,
    ).difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Future<void> _persist(Future<bool> operation) async {
    try {
      if (!await operation) throw StateError('Save failed');
    } catch (_) {
      saveError = '暂时无法保存，修改仅在本次打开时有效。';
      notifyListeners();
    }
  }

  void dismissError() {
    saveError = null;
    notifyListeners();
  }

  void selectDay(int value) {
    day = value;
    notifyListeners();
  }

  void toggleSaved(String id) {
    saved.contains(id) ? saved.remove(id) : saved.add(id);
    notifyListeners();
    _persist(preferences.setStringList('saved', saved.toList()));
  }

  void togglePreparation(int index) {
    preparations[index] = !preparations[index];
    notifyListeners();
    _persist(preferences.setBool('prep_$index', preparations[index]));
  }

  void rename(String value) {
    name = value.trim();
    notifyListeners();
    _persist(preferences.setString('name', name));
  }

  void setNotifications(bool value) {
    notifications = value;
    notifyListeners();
    _persist(preferences.setBool('notifications', value));
  }

  void readNotifications() {
    unread = false;
    notifyListeners();
    _persist(preferences.setBool('unread', false));
  }
}
