import 'package:flutter/foundation.dart';

class CounterStore with ChangeNotifier, DiagnosticableTreeMixin {
  int _count = 0;
  static const int _goal = 10;

  int get count => _count;
  int get goal => _goal;
  int get remainingToGoal => _goal - _count;
  bool get isGoalReached => _count >= _goal;

  void increment() {
    _count++;
    notifyListeners();
  }

  void decrement() {
    if (_count == 0) {
      return;
    }
    _count--;
    notifyListeners();
  }

  void reset() {
    if (_count == 0) {
      return;
    }
    _count = 0;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('count', count))
      ..add(IntProperty('goal', goal))
      ..add(FlagProperty('isGoalReached', value: isGoalReached));
  }
}

class TeamScoreStore with ChangeNotifier, DiagnosticableTreeMixin {
  int _homeScore = 12;
  int _awayScore = 10;

  int get homeScore => _homeScore;
  int get awayScore => _awayScore;
  int get totalPoints => _homeScore + _awayScore;

  String get leader {
    if (_homeScore == _awayScore) {
      return 'Tie game';
    }
    return _homeScore > _awayScore ? 'Home team leads' : 'Away team leads';
  }

  void scoreHome(int points) {
    _homeScore += points;
    notifyListeners();
  }

  void scoreAway(int points) {
    _awayScore += points;
    notifyListeners();
  }

  void reset() {
    _homeScore = 12;
    _awayScore = 10;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('homeScore', homeScore))
      ..add(IntProperty('awayScore', awayScore))
      ..add(IntProperty('totalPoints', totalPoints))
      ..add(StringProperty('leader', leader));
  }
}

class StudyPlanStore with ChangeNotifier, DiagnosticableTreeMixin {
  int _completedLessons = 2;
  bool _focusMode = false;
  static const int _totalLessons = 5;

  int get completedLessons => _completedLessons;
  int get totalLessons => _totalLessons;
  bool get focusMode => _focusMode;
  double get progress => _completedLessons / _totalLessons;

  String get progressLabel => '$_completedLessons / $_totalLessons lessons';

  void completeLesson() {
    if (_completedLessons >= _totalLessons) {
      return;
    }
    _completedLessons++;
    notifyListeners();
  }

  void rewindLesson() {
    if (_completedLessons == 0) {
      return;
    }
    _completedLessons--;
    notifyListeners();
  }

  void toggleFocusMode() {
    _focusMode = !_focusMode;
    notifyListeners();
  }

  void reset() {
    _completedLessons = 2;
    _focusMode = false;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IntProperty('completedLessons', completedLessons))
      ..add(IntProperty('totalLessons', totalLessons))
      ..add(PercentProperty('progress', progress))
      ..add(FlagProperty('focusMode', value: focusMode));
  }
}
