// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CatalogEntriesTable extends CatalogEntries
    with TableInfo<$CatalogEntriesTable, CatalogEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CatalogEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _summaryMeta = const VerificationMeta(
    'summary',
  );
  @override
  late final GeneratedColumn<String> summary = GeneratedColumn<String>(
    'summary',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
    'price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stockMeta = const VerificationMeta('stock');
  @override
  late final GeneratedColumn<int> stock = GeneratedColumn<int>(
    'stock',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPopularMeta = const VerificationMeta(
    'isPopular',
  );
  @override
  late final GeneratedColumn<bool> isPopular = GeneratedColumn<bool>(
    'is_popular',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_popular" IN (0, 1))',
    ),
  );
  static const VerificationMeta _remoteUpdatedAtMeta = const VerificationMeta(
    'remoteUpdatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> remoteUpdatedAt =
      GeneratedColumn<DateTime>(
        'remote_updated_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _cachedAtMeta = const VerificationMeta(
    'cachedAt',
  );
  @override
  late final GeneratedColumn<DateTime> cachedAt = GeneratedColumn<DateTime>(
    'cached_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    summary,
    category,
    price,
    stock,
    isPopular,
    remoteUpdatedAt,
    cachedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'catalog_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CatalogEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('summary')) {
      context.handle(
        _summaryMeta,
        summary.isAcceptableOrUnknown(data['summary']!, _summaryMeta),
      );
    } else if (isInserting) {
      context.missing(_summaryMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
        _priceMeta,
        price.isAcceptableOrUnknown(data['price']!, _priceMeta),
      );
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('stock')) {
      context.handle(
        _stockMeta,
        stock.isAcceptableOrUnknown(data['stock']!, _stockMeta),
      );
    } else if (isInserting) {
      context.missing(_stockMeta);
    }
    if (data.containsKey('is_popular')) {
      context.handle(
        _isPopularMeta,
        isPopular.isAcceptableOrUnknown(data['is_popular']!, _isPopularMeta),
      );
    } else if (isInserting) {
      context.missing(_isPopularMeta);
    }
    if (data.containsKey('remote_updated_at')) {
      context.handle(
        _remoteUpdatedAtMeta,
        remoteUpdatedAt.isAcceptableOrUnknown(
          data['remote_updated_at']!,
          _remoteUpdatedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remoteUpdatedAtMeta);
    }
    if (data.containsKey('cached_at')) {
      context.handle(
        _cachedAtMeta,
        cachedAt.isAcceptableOrUnknown(data['cached_at']!, _cachedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_cachedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CatalogEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CatalogEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      summary: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}summary'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      price: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}price'],
      )!,
      stock: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}stock'],
      )!,
      isPopular: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_popular'],
      )!,
      remoteUpdatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}remote_updated_at'],
      )!,
      cachedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cached_at'],
      )!,
    );
  }

  @override
  $CatalogEntriesTable createAlias(String alias) {
    return $CatalogEntriesTable(attachedDatabase, alias);
  }
}

class CatalogEntry extends DataClass implements Insertable<CatalogEntry> {
  final String id;
  final String title;
  final String summary;
  final String category;
  final double price;
  final int stock;
  final bool isPopular;
  final DateTime remoteUpdatedAt;
  final DateTime cachedAt;
  const CatalogEntry({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.price,
    required this.stock,
    required this.isPopular,
    required this.remoteUpdatedAt,
    required this.cachedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['summary'] = Variable<String>(summary);
    map['category'] = Variable<String>(category);
    map['price'] = Variable<double>(price);
    map['stock'] = Variable<int>(stock);
    map['is_popular'] = Variable<bool>(isPopular);
    map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt);
    map['cached_at'] = Variable<DateTime>(cachedAt);
    return map;
  }

  CatalogEntriesCompanion toCompanion(bool nullToAbsent) {
    return CatalogEntriesCompanion(
      id: Value(id),
      title: Value(title),
      summary: Value(summary),
      category: Value(category),
      price: Value(price),
      stock: Value(stock),
      isPopular: Value(isPopular),
      remoteUpdatedAt: Value(remoteUpdatedAt),
      cachedAt: Value(cachedAt),
    );
  }

  factory CatalogEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CatalogEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      summary: serializer.fromJson<String>(json['summary']),
      category: serializer.fromJson<String>(json['category']),
      price: serializer.fromJson<double>(json['price']),
      stock: serializer.fromJson<int>(json['stock']),
      isPopular: serializer.fromJson<bool>(json['isPopular']),
      remoteUpdatedAt: serializer.fromJson<DateTime>(json['remoteUpdatedAt']),
      cachedAt: serializer.fromJson<DateTime>(json['cachedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'summary': serializer.toJson<String>(summary),
      'category': serializer.toJson<String>(category),
      'price': serializer.toJson<double>(price),
      'stock': serializer.toJson<int>(stock),
      'isPopular': serializer.toJson<bool>(isPopular),
      'remoteUpdatedAt': serializer.toJson<DateTime>(remoteUpdatedAt),
      'cachedAt': serializer.toJson<DateTime>(cachedAt),
    };
  }

  CatalogEntry copyWith({
    String? id,
    String? title,
    String? summary,
    String? category,
    double? price,
    int? stock,
    bool? isPopular,
    DateTime? remoteUpdatedAt,
    DateTime? cachedAt,
  }) => CatalogEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    summary: summary ?? this.summary,
    category: category ?? this.category,
    price: price ?? this.price,
    stock: stock ?? this.stock,
    isPopular: isPopular ?? this.isPopular,
    remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
    cachedAt: cachedAt ?? this.cachedAt,
  );
  CatalogEntry copyWithCompanion(CatalogEntriesCompanion data) {
    return CatalogEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      summary: data.summary.present ? data.summary.value : this.summary,
      category: data.category.present ? data.category.value : this.category,
      price: data.price.present ? data.price.value : this.price,
      stock: data.stock.present ? data.stock.value : this.stock,
      isPopular: data.isPopular.present ? data.isPopular.value : this.isPopular,
      remoteUpdatedAt: data.remoteUpdatedAt.present
          ? data.remoteUpdatedAt.value
          : this.remoteUpdatedAt,
      cachedAt: data.cachedAt.present ? data.cachedAt.value : this.cachedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CatalogEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('stock: $stock, ')
          ..write('isPopular: $isPopular, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('cachedAt: $cachedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    summary,
    category,
    price,
    stock,
    isPopular,
    remoteUpdatedAt,
    cachedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CatalogEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.summary == this.summary &&
          other.category == this.category &&
          other.price == this.price &&
          other.stock == this.stock &&
          other.isPopular == this.isPopular &&
          other.remoteUpdatedAt == this.remoteUpdatedAt &&
          other.cachedAt == this.cachedAt);
}

class CatalogEntriesCompanion extends UpdateCompanion<CatalogEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> summary;
  final Value<String> category;
  final Value<double> price;
  final Value<int> stock;
  final Value<bool> isPopular;
  final Value<DateTime> remoteUpdatedAt;
  final Value<DateTime> cachedAt;
  final Value<int> rowid;
  const CatalogEntriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.summary = const Value.absent(),
    this.category = const Value.absent(),
    this.price = const Value.absent(),
    this.stock = const Value.absent(),
    this.isPopular = const Value.absent(),
    this.remoteUpdatedAt = const Value.absent(),
    this.cachedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CatalogEntriesCompanion.insert({
    required String id,
    required String title,
    required String summary,
    required String category,
    required double price,
    required int stock,
    required bool isPopular,
    required DateTime remoteUpdatedAt,
    required DateTime cachedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       summary = Value(summary),
       category = Value(category),
       price = Value(price),
       stock = Value(stock),
       isPopular = Value(isPopular),
       remoteUpdatedAt = Value(remoteUpdatedAt),
       cachedAt = Value(cachedAt);
  static Insertable<CatalogEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? summary,
    Expression<String>? category,
    Expression<double>? price,
    Expression<int>? stock,
    Expression<bool>? isPopular,
    Expression<DateTime>? remoteUpdatedAt,
    Expression<DateTime>? cachedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (summary != null) 'summary': summary,
      if (category != null) 'category': category,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
      if (isPopular != null) 'is_popular': isPopular,
      if (remoteUpdatedAt != null) 'remote_updated_at': remoteUpdatedAt,
      if (cachedAt != null) 'cached_at': cachedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CatalogEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? summary,
    Value<String>? category,
    Value<double>? price,
    Value<int>? stock,
    Value<bool>? isPopular,
    Value<DateTime>? remoteUpdatedAt,
    Value<DateTime>? cachedAt,
    Value<int>? rowid,
  }) {
    return CatalogEntriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      summary: summary ?? this.summary,
      category: category ?? this.category,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      isPopular: isPopular ?? this.isPopular,
      remoteUpdatedAt: remoteUpdatedAt ?? this.remoteUpdatedAt,
      cachedAt: cachedAt ?? this.cachedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (summary.present) {
      map['summary'] = Variable<String>(summary.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (stock.present) {
      map['stock'] = Variable<int>(stock.value);
    }
    if (isPopular.present) {
      map['is_popular'] = Variable<bool>(isPopular.value);
    }
    if (remoteUpdatedAt.present) {
      map['remote_updated_at'] = Variable<DateTime>(remoteUpdatedAt.value);
    }
    if (cachedAt.present) {
      map['cached_at'] = Variable<DateTime>(cachedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CatalogEntriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('summary: $summary, ')
          ..write('category: $category, ')
          ..write('price: $price, ')
          ..write('stock: $stock, ')
          ..write('isPopular: $isPopular, ')
          ..write('remoteUpdatedAt: $remoteUpdatedAt, ')
          ..write('cachedAt: $cachedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CatalogEntriesTable catalogEntries = $CatalogEntriesTable(this);
  late final Index idxCatalogPopularTitle = Index(
    'idx_catalog_popular_title',
    'CREATE INDEX idx_catalog_popular_title ON catalog_entries (is_popular, title)',
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    catalogEntries,
    idxCatalogPopularTitle,
  ];
}

typedef $$CatalogEntriesTableCreateCompanionBuilder =
    CatalogEntriesCompanion Function({
      required String id,
      required String title,
      required String summary,
      required String category,
      required double price,
      required int stock,
      required bool isPopular,
      required DateTime remoteUpdatedAt,
      required DateTime cachedAt,
      Value<int> rowid,
    });
typedef $$CatalogEntriesTableUpdateCompanionBuilder =
    CatalogEntriesCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> summary,
      Value<String> category,
      Value<double> price,
      Value<int> stock,
      Value<bool> isPopular,
      Value<DateTime> remoteUpdatedAt,
      Value<DateTime> cachedAt,
      Value<int> rowid,
    });

class $$CatalogEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CatalogEntriesTable> {
  $$CatalogEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPopular => $composableBuilder(
    column: $table.isPopular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CatalogEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CatalogEntriesTable> {
  $$CatalogEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get summary => $composableBuilder(
    column: $table.summary,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get price => $composableBuilder(
    column: $table.price,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stock => $composableBuilder(
    column: $table.stock,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPopular => $composableBuilder(
    column: $table.isPopular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get cachedAt => $composableBuilder(
    column: $table.cachedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CatalogEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CatalogEntriesTable> {
  $$CatalogEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get summary =>
      $composableBuilder(column: $table.summary, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<int> get stock =>
      $composableBuilder(column: $table.stock, builder: (column) => column);

  GeneratedColumn<bool> get isPopular =>
      $composableBuilder(column: $table.isPopular, builder: (column) => column);

  GeneratedColumn<DateTime> get remoteUpdatedAt => $composableBuilder(
    column: $table.remoteUpdatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get cachedAt =>
      $composableBuilder(column: $table.cachedAt, builder: (column) => column);
}

class $$CatalogEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CatalogEntriesTable,
          CatalogEntry,
          $$CatalogEntriesTableFilterComposer,
          $$CatalogEntriesTableOrderingComposer,
          $$CatalogEntriesTableAnnotationComposer,
          $$CatalogEntriesTableCreateCompanionBuilder,
          $$CatalogEntriesTableUpdateCompanionBuilder,
          (
            CatalogEntry,
            BaseReferences<_$AppDatabase, $CatalogEntriesTable, CatalogEntry>,
          ),
          CatalogEntry,
          PrefetchHooks Function()
        > {
  $$CatalogEntriesTableTableManager(
    _$AppDatabase db,
    $CatalogEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CatalogEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CatalogEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CatalogEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> summary = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<double> price = const Value.absent(),
                Value<int> stock = const Value.absent(),
                Value<bool> isPopular = const Value.absent(),
                Value<DateTime> remoteUpdatedAt = const Value.absent(),
                Value<DateTime> cachedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CatalogEntriesCompanion(
                id: id,
                title: title,
                summary: summary,
                category: category,
                price: price,
                stock: stock,
                isPopular: isPopular,
                remoteUpdatedAt: remoteUpdatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String summary,
                required String category,
                required double price,
                required int stock,
                required bool isPopular,
                required DateTime remoteUpdatedAt,
                required DateTime cachedAt,
                Value<int> rowid = const Value.absent(),
              }) => CatalogEntriesCompanion.insert(
                id: id,
                title: title,
                summary: summary,
                category: category,
                price: price,
                stock: stock,
                isPopular: isPopular,
                remoteUpdatedAt: remoteUpdatedAt,
                cachedAt: cachedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CatalogEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CatalogEntriesTable,
      CatalogEntry,
      $$CatalogEntriesTableFilterComposer,
      $$CatalogEntriesTableOrderingComposer,
      $$CatalogEntriesTableAnnotationComposer,
      $$CatalogEntriesTableCreateCompanionBuilder,
      $$CatalogEntriesTableUpdateCompanionBuilder,
      (
        CatalogEntry,
        BaseReferences<_$AppDatabase, $CatalogEntriesTable, CatalogEntry>,
      ),
      CatalogEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CatalogEntriesTableTableManager get catalogEntries =>
      $$CatalogEntriesTableTableManager(_db, _db.catalogEntries);
}
