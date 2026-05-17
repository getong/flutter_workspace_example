import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:uuid/uuid.dart';

part 'drift_showcase_database.g.dart';

const Uuid _uuid = Uuid();
final RegExp _offsetDateTimePattern = RegExp(
  r'^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d{1,6})?(Z|[+-]\d{2}:\d{2})$',
);

UuidValue _generateUuidV7() => _parseUuidV7(_uuid.v7());

String _generateUuidV7Sql() => _generateUuidV7().toString();

UuidValue _parseUuidV7(String rawValue) {
  final UuidValue uuidValue = UuidValue.withValidation(rawValue);
  if (!uuidValue.isV7) {
    throw FormatException('Expected a UUID v7 value, got "$rawValue".');
  }
  return uuidValue;
}

String _formatTimeZoneOffset(Duration offset) {
  if (offset.inSeconds % Duration.secondsPerMinute != 0) {
    throw ArgumentError.value(
      offset,
      'offset',
      'UTC offsets with second precision are not supported.',
    );
  }

  final int totalMinutes = offset.inMinutes;
  final String sign = totalMinutes < 0 ? '-' : '+';
  final int absoluteMinutes = totalMinutes.abs();
  final int hours = absoluteMinutes ~/ Duration.minutesPerHour;
  final int minutes = absoluteMinutes % Duration.minutesPerHour;
  return '$sign${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
}

Duration _parseTimeZoneOffset(String rawOffset) {
  if (rawOffset == 'Z') {
    return Duration.zero;
  }

  final int sign = rawOffset.startsWith('-') ? -1 : 1;
  final List<String> parts = rawOffset.substring(1).split(':');
  return Duration(
    hours: sign * int.parse(parts[0]),
    minutes: sign * int.parse(parts[1]),
  );
}

class OffsetDateTimeValue {
  factory OffsetDateTimeValue({
    required DateTime utcInstant,
    required Duration timeZoneOffset,
  }) {
    if (timeZoneOffset.inSeconds % Duration.secondsPerMinute != 0) {
      throw ArgumentError.value(
        timeZoneOffset,
        'timeZoneOffset',
        'UTC offsets with second precision are not supported.',
      );
    }

    return OffsetDateTimeValue._(utcInstant.toUtc(), timeZoneOffset);
  }

  factory OffsetDateTimeValue.nowLocal() {
    final DateTime now = DateTime.now();
    return OffsetDateTimeValue(
      utcInstant: now.toUtc(),
      timeZoneOffset: now.timeZoneOffset,
    );
  }

  factory OffsetDateTimeValue.parse(String rawValue) {
    final String normalized = rawValue.trim();
    final Match? match = _offsetDateTimePattern.firstMatch(normalized);
    if (match == null) {
      throw FormatException(
        'Expected an ISO-8601 datetime with an explicit timezone offset, '
        'got "$rawValue".',
      );
    }

    return OffsetDateTimeValue(
      utcInstant: DateTime.parse(normalized).toUtc(),
      timeZoneOffset: _parseTimeZoneOffset(match.group(1)!),
    );
  }

  const OffsetDateTimeValue._(this.utcInstant, this.timeZoneOffset);

  final DateTime utcInstant;
  final Duration timeZoneOffset;

  String get offsetLabel => _formatTimeZoneOffset(timeZoneOffset);

  String toIso8601String() {
    final DateTime shifted = utcInstant.add(timeZoneOffset);
    final String withoutZone = shifted.toIso8601String().replaceFirst(
      RegExp(r'Z$'),
      '',
    );
    return '$withoutZone${_formatTimeZoneOffset(timeZoneOffset)}';
  }

  @override
  String toString() => toIso8601String();

  @override
  int get hashCode => Object.hash(utcInstant, timeZoneOffset);

  @override
  bool operator ==(Object other) {
    return other is OffsetDateTimeValue &&
        other.utcInstant == utcInstant &&
        other.timeZoneOffset == timeZoneOffset;
  }
}

String _generateOffsetDateTimeSql() => OffsetDateTimeValue.nowLocal().toString();

class UuidV7ValueConverter extends TypeConverter<UuidValue, String>
    with JsonTypeConverter<UuidValue, String> {
  const UuidV7ValueConverter();

  @override
  UuidValue fromSql(String fromDb) => _parseUuidV7(fromDb);

  @override
  String toSql(UuidValue value) => _parseUuidV7(value.toString()).toString();
}

class OffsetDateTimeValueConverter
    extends TypeConverter<OffsetDateTimeValue, String>
    with JsonTypeConverter<OffsetDateTimeValue, String> {
  const OffsetDateTimeValueConverter();

  @override
  OffsetDateTimeValue fromSql(String fromDb) {
    return OffsetDateTimeValue.parse(fromDb);
  }

  @override
  String toSql(OffsetDateTimeValue value) => value.toIso8601String();
}

@DataClassName('DriftTodoEntry')
class DriftTodos extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 120)();

  TextColumn get category => text().withDefault(const Constant('General'))();

  IntColumn get priority => integer().withDefault(const Constant(3))();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  TextColumn get notes => text().nullable()();

  TextColumn get uuidV7 => text()
      .withLength(min: 36, max: 36)
      .map(const UuidV7ValueConverter())
      .clientDefault(_generateUuidV7Sql)();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  TextColumn get createdAtWithTimezone => text()
      .map(const OffsetDateTimeValueConverter())
      .clientDefault(_generateOffsetDateTimeSql)();
}

class DriftTodoSummary {
  const DriftTodoSummary({
    required this.total,
    required this.completed,
    required this.pending,
    required this.highPriority,
  });

  final int total;
  final int completed;
  final int pending;
  final int highPriority;
}

class DriftCategoryCount {
  const DriftCategoryCount({
    required this.category,
    required this.itemCount,
    required this.completedCount,
  });

  final String category;
  final int itemCount;
  final int completedCount;
}

OffsetDateTimeValue _seedOffsetDateTime({
  required int year,
  required int month,
  required int day,
  required int hour,
  required int minute,
  required int offsetHours,
  int offsetMinutes = 0,
}) {
  final Duration offset = Duration(
    hours: offsetHours,
    minutes: offsetHours.isNegative ? -offsetMinutes : offsetMinutes,
  );
  final DateTime utcInstant = DateTime.utc(
    year,
    month,
    day,
    hour,
    minute,
  ).subtract(offset);
  return OffsetDateTimeValue(
    utcInstant: utcInstant,
    timeZoneOffset: offset,
  );
}

@DriftDatabase(tables: <Type>[DriftTodos])
class DriftShowcaseDatabase extends _$DriftShowcaseDatabase {
  DriftShowcaseDatabase()
    : super(driftDatabase(name: 'widget_layout_example2_drift_showcase'));

  @override
  int get schemaVersion => 2;

  Future<void> seedDemoData() async {
    final QueryRow row = await customSelect(
      'SELECT COUNT(*) AS item_count FROM drift_todos',
      readsFrom: <TableInfo<Table, Object?>>{driftTodos},
    ).getSingle();

    if (row.read<int>('item_count') > 0) {
      return;
    }

    await batch((Batch batch) {
      batch.insertAll(driftTodos, _sampleTodoCompanions);
    });
  }

  Future<int> addTodo({
    required String title,
    required String category,
    required int priority,
    String? notes,
    UuidValue? uuidV7,
    OffsetDateTimeValue? createdAtWithTimezone,
  }) {
    return into(driftTodos).insert(
      DriftTodosCompanion.insert(
        title: title,
        category: Value(category),
        priority: Value(priority),
        notes: Value(notes?.trim().isEmpty ?? true ? null : notes!.trim()),
        uuidV7: uuidV7 == null ? const Value.absent() : Value(uuidV7),
        createdAtWithTimezone: createdAtWithTimezone == null
            ? const Value.absent()
            : Value(createdAtWithTimezone),
      ),
    );
  }

  Stream<List<DriftTodoEntry>> watchTodos({
    required String search,
    required bool hideCompleted,
  }) {
    final SimpleSelectStatement<$DriftTodosTable, DriftTodoEntry> query =
        select(driftTodos)..orderBy(<OrderingTerm Function(DriftTodos)>[
          (DriftTodos table) => OrderingTerm.asc(table.completed),
          (DriftTodos table) => OrderingTerm.desc(table.priority),
          (DriftTodos table) => OrderingTerm.desc(table.createdAt),
        ]);

    final String trimmedSearch = search.trim();
    if (trimmedSearch.isNotEmpty) {
      query.where(
        (DriftTodos table) =>
            table.title.contains(trimmedSearch) |
            table.category.contains(trimmedSearch) |
            table.notes.contains(trimmedSearch),
      );
    }

    if (hideCompleted) {
      query.where((DriftTodos table) => table.completed.equals(false));
    }

    return query.watch();
  }

  Stream<DriftTodoSummary> watchSummary() {
    return customSelect(
      'SELECT '
      'COUNT(*) AS total_count, '
      'SUM(CASE WHEN completed = 1 THEN 1 ELSE 0 END) AS completed_count, '
      'SUM(CASE WHEN completed = 0 THEN 1 ELSE 0 END) AS pending_count, '
      'SUM(CASE WHEN priority >= 4 THEN 1 ELSE 0 END) AS high_priority_count '
      'FROM drift_todos',
      readsFrom: <TableInfo<Table, Object?>>{driftTodos},
    ).watchSingle().map((QueryRow row) {
      return DriftTodoSummary(
        total: row.read<int>('total_count'),
        completed: row.read<int>('completed_count'),
        pending: row.read<int>('pending_count'),
        highPriority: row.read<int>('high_priority_count'),
      );
    });
  }

  Stream<List<DriftCategoryCount>> watchCategoryCounts() {
    return customSelect(
      'SELECT '
      'category, '
      'COUNT(*) AS item_count, '
      'SUM(CASE WHEN completed = 1 THEN 1 ELSE 0 END) AS completed_count '
      'FROM drift_todos '
      'GROUP BY category '
      'ORDER BY item_count DESC, category ASC',
      readsFrom: <TableInfo<Table, Object?>>{driftTodos},
    ).watch().map((List<QueryRow> rows) {
      return rows
          .map(
            (QueryRow row) => DriftCategoryCount(
              category: row.read<String>('category'),
              itemCount: row.read<int>('item_count'),
              completedCount: row.read<int>('completed_count'),
            ),
          )
          .toList();
    });
  }

  Future<int> toggleCompleted(DriftTodoEntry entry) {
    return (update(driftTodos)
          ..where((DriftTodos table) => table.id.equals(entry.id)))
        .write(DriftTodosCompanion(completed: Value(!entry.completed)));
  }

  Future<int> increasePriority(int id, int currentPriority) {
    final int nextPriority = currentPriority >= 5 ? 5 : currentPriority + 1;
    return (update(driftTodos)
          ..where((DriftTodos table) => table.id.equals(id)))
        .write(DriftTodosCompanion(priority: Value(nextPriority)));
  }

  Future<int> renameFirstPending() async {
    final DriftTodoEntry? firstPending =
        await (select(driftTodos)
              ..where((DriftTodos table) => table.completed.equals(false))
              ..orderBy(<OrderingTerm Function(DriftTodos)>[
                (DriftTodos table) => OrderingTerm.desc(table.priority),
                (DriftTodos table) => OrderingTerm.asc(table.createdAt),
              ])
              ..limit(1))
            .getSingleOrNull();

    if (firstPending == null) {
      return 0;
    }

    return (update(
      driftTodos,
    )..where((DriftTodos table) => table.id.equals(firstPending.id))).write(
      DriftTodosCompanion(title: Value('${firstPending.title} • reviewed')),
    );
  }

  Future<int> markCategoryDone(String category) {
    return (update(driftTodos)..where(
          (DriftTodos table) =>
              table.category.equals(category) & table.completed.equals(false),
        ))
        .write(const DriftTodosCompanion(completed: Value(true)));
  }

  Future<int> deleteTodo(int id) {
    return (delete(
      driftTodos,
    )..where((DriftTodos table) => table.id.equals(id))).go();
  }

  Future<int> clearCompleted() {
    return (delete(
      driftTodos,
    )..where((DriftTodos table) => table.completed.equals(true))).go();
  }

  Future<void> resetDemo() async {
    await transaction(() async {
      await delete(driftTodos).go();
      await batch((Batch batch) {
        batch.insertAll(driftTodos, _sampleTodoCompanions);
      });
    });
  }

  List<DriftTodosCompanion> get _sampleTodoCompanions => <DriftTodosCompanion>[
    DriftTodosCompanion.insert(
      title: 'Review drift database setup',
      category: Value('Development'),
      priority: Value(5),
      notes: Value(
        'Open the module and inspect the generated SQL-backed list.',
      ),
      uuidV7: Value(_generateUuidV7()),
      createdAtWithTimezone: Value(
        _seedOffsetDateTime(
          year: 2026,
          month: 5,
          day: 17,
          hour: 9,
          minute: 30,
          offsetHours: 8,
        ),
      ),
    ),
    DriftTodosCompanion.insert(
      title: 'Draft migration checklist',
      category: Value('Planning'),
      priority: Value(4),
      notes: Value('Schema changes, seed data, and app upgrade notes.'),
      uuidV7: Value(_generateUuidV7()),
      createdAtWithTimezone: Value(
        _seedOffsetDateTime(
          year: 2026,
          month: 5,
          day: 17,
          hour: 11,
          minute: 15,
          offsetHours: 8,
        ),
      ),
    ),
    DriftTodosCompanion.insert(
      title: 'Polish desktop interactions',
      category: Value('UX'),
      priority: Value(3),
      notes: Value('Verify keyboard and mouse flows on macOS.'),
      uuidV7: Value(_generateUuidV7()),
      createdAtWithTimezone: Value(
        _seedOffsetDateTime(
          year: 2026,
          month: 5,
          day: 16,
          hour: 18,
          minute: 45,
          offsetHours: 9,
        ),
      ),
    ),
    DriftTodosCompanion.insert(
      title: 'Archive completed experiments',
      category: Value('Maintenance'),
      priority: Value(2),
      completed: Value(true),
      notes: Value('Use clear completed to remove these rows.'),
      uuidV7: Value(_generateUuidV7()),
      createdAtWithTimezone: Value(
        _seedOffsetDateTime(
          year: 2026,
          month: 5,
          day: 15,
          hour: 14,
          minute: 5,
          offsetHours: -7,
        ),
      ),
    ),
  ];
}
