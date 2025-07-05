import 'package:flutter/foundation.dart';
import '../models/progress_data.dart';

class RecordComparison {
  static void demonstrateRecordVsAlternatives() {
    debugPrint('=== DART RECORDS vs ALTERNATIVES ===');

    // 1. DART RECORDS (Modern, Recommended)
    debugPrint('\n1. DART RECORDS (Built-in, Type-safe):');
    var recordData = (0.75, true); // Creates (double, bool) record
    debugPrint('Record: $recordData');
    debugPrint('Progress: ${recordData.$1}'); // Type-safe access
    debugPrint('Done: ${recordData.$2}');

    // Named records (even better!)
    var namedRecord = (progress: 0.75, isDone: true);
    debugPrint('Named Record: $namedRecord');
    debugPrint('Progress: ${namedRecord.progress}'); // Named access!
    debugPrint('Done: ${namedRecord.isDone}');

    // 2. CUSTOM CLASS (Old way)
    debugPrint('\n2. CUSTOM CLASS (Verbose):');
    var classData = ProgressData(0.75, true);
    debugPrint('Class: ${classData.progress}, ${classData.isDone}');

    // 3. LIST AS TUPLE (Not recommended - error-prone!)
    debugPrint('\n3. LIST AS TUPLE (Error-prone, avoid!):');
    var listTuple = [0.75, true]; // dynamic types, no safety!
    debugPrint('List: $listTuple');
    debugPrint('Progress: ${listTuple[0]}'); // Could crash if wrong type!
    debugPrint('Done: ${listTuple[1]}');

    // 4. MAP (Overkill for simple data)
    debugPrint('\n4. MAP (Overkill):');
    var mapData = {'progress': 0.75, 'isDone': true};
    debugPrint('Map: $mapData');
    debugPrint('Progress: ${mapData['progress']}');

    debugPrint('\n=== WINNER: DART RECORDS! ===');
  }

  // Example: Using List as tuple (not recommended)
  static List<dynamic> createProgressTuple(double progress, bool isDone) {
    return [progress, isDone]; // Error-prone!
  }

  // Example: Using Map as data structure
  static Map<String, dynamic> createProgressMap(double progress, bool isDone) {
    return {'progress': progress, 'isDone': isDone};
  }

  // Example: Using Record (recommended)
  static (double, bool) createProgressRecord(double progress, bool isDone) {
    return (progress, isDone);
  }

  // Example: Using Named Record (best!)
  static ({double progress, bool isDone}) createNamedProgressRecord(
    double progress,
    bool isDone,
  ) {
    return (progress: progress, isDone: isDone);
  }
}
