// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GlobalSettingsTable extends GlobalSettings with TableInfo<$GlobalSettingsTable, GlobalSettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GlobalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'global_settings';
  @override
  VerificationContext validateIntegrity(Insertable<GlobalSettingEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  GlobalSettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GlobalSettingEntry(
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $GlobalSettingsTable createAlias(String alias) {
    return $GlobalSettingsTable(attachedDatabase, alias);
  }
}

class GlobalSettingEntry extends DataClass implements Insertable<GlobalSettingEntry> {
  final String key;
  final String value;
  const GlobalSettingEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  GlobalSettingsCompanion toCompanion(bool nullToAbsent) {
    return GlobalSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory GlobalSettingEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GlobalSettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'key': serializer.toJson<String>(key), 'value': serializer.toJson<String>(value)};
  }

  GlobalSettingEntry copyWith({String? key, String? value}) =>
      GlobalSettingEntry(key: key ?? this.key, value: value ?? this.value);
  GlobalSettingEntry copyWithCompanion(GlobalSettingsCompanion data) {
    return GlobalSettingEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GlobalSettingEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is GlobalSettingEntry && other.key == this.key && other.value == this.value);
}

class GlobalSettingsCompanion extends UpdateCompanion<GlobalSettingEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const GlobalSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GlobalSettingsCompanion.insert({required String key, required String value, this.rowid = const Value.absent()})
    : key = Value(key),
      value = Value(value);
  static Insertable<GlobalSettingEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GlobalSettingsCompanion copyWith({Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return GlobalSettingsCompanion(key: key ?? this.key, value: value ?? this.value, rowid: rowid ?? this.rowid);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GlobalSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserSettingsTable extends UserSettings with TableInfo<$UserSettingsTable, UserSettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_settings';
  @override
  VerificationContext validateIntegrity(Insertable<UserSettingEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(_keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(_valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, key};
  @override
  UserSettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserSettingEntry(
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      key: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSettingEntry extends DataClass implements Insertable<UserSettingEntry> {
  final String userId;
  final String key;
  final String value;
  const UserSettingEntry({required this.userId, required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(userId: Value(userId), key: Value(key), value: Value(value));
  }

  factory UserSettingEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserSettingEntry(
      userId: serializer.fromJson<String>(json['userId']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserSettingEntry copyWith({String? userId, String? key, String? value}) =>
      UserSettingEntry(userId: userId ?? this.userId, key: key ?? this.key, value: value ?? this.value);
  UserSettingEntry copyWithCompanion(UserSettingsCompanion data) {
    return UserSettingEntry(
      userId: data.userId.present ? data.userId.value : this.userId,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingEntry(')
          ..write('userId: $userId, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserSettingEntry && other.userId == this.userId && other.key == this.key && other.value == this.value);
}

class UserSettingsCompanion extends UpdateCompanion<UserSettingEntry> {
  final Value<String> userId;
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const UserSettingsCompanion({
    this.userId = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserSettingsCompanion.insert({
    required String userId,
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       key = Value(key),
       value = Value(value);
  static Insertable<UserSettingEntry> custom({
    Expression<String>? userId,
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserSettingsCompanion copyWith({Value<String>? userId, Value<String>? key, Value<String>? value, Value<int>? rowid}) {
    return UserSettingsCompanion(
      userId: userId ?? this.userId,
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserSettingsCompanion(')
          ..write('userId: $userId, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BookPlaybackSpeedsTable extends BookPlaybackSpeeds
    with TableInfo<$BookPlaybackSpeedsTable, BookPlaybackSpeedEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookPlaybackSpeedsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMeta = const VerificationMeta('speed');
  @override
  late final GeneratedColumn<double> speed = GeneratedColumn<double>(
    'speed',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, itemId, speed, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'book_playback_speeds';
  @override
  VerificationContext validateIntegrity(Insertable<BookPlaybackSpeedEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta, itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('speed')) {
      context.handle(_speedMeta, speed.isAcceptableOrUnknown(data['speed']!, _speedMeta));
    } else if (isInserting) {
      context.missing(_speedMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, itemId};
  @override
  BookPlaybackSpeedEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookPlaybackSpeedEntry(
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      speed: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}speed'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $BookPlaybackSpeedsTable createAlias(String alias) {
    return $BookPlaybackSpeedsTable(attachedDatabase, alias);
  }
}

class BookPlaybackSpeedEntry extends DataClass implements Insertable<BookPlaybackSpeedEntry> {
  final String userId;
  final String itemId;
  final double speed;
  final DateTime updatedAt;
  const BookPlaybackSpeedEntry({
    required this.userId,
    required this.itemId,
    required this.speed,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['item_id'] = Variable<String>(itemId);
    map['speed'] = Variable<double>(speed);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BookPlaybackSpeedsCompanion toCompanion(bool nullToAbsent) {
    return BookPlaybackSpeedsCompanion(
      userId: Value(userId),
      itemId: Value(itemId),
      speed: Value(speed),
      updatedAt: Value(updatedAt),
    );
  }

  factory BookPlaybackSpeedEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookPlaybackSpeedEntry(
      userId: serializer.fromJson<String>(json['userId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      speed: serializer.fromJson<double>(json['speed']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'itemId': serializer.toJson<String>(itemId),
      'speed': serializer.toJson<double>(speed),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  BookPlaybackSpeedEntry copyWith({String? userId, String? itemId, double? speed, DateTime? updatedAt}) =>
      BookPlaybackSpeedEntry(
        userId: userId ?? this.userId,
        itemId: itemId ?? this.itemId,
        speed: speed ?? this.speed,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  BookPlaybackSpeedEntry copyWithCompanion(BookPlaybackSpeedsCompanion data) {
    return BookPlaybackSpeedEntry(
      userId: data.userId.present ? data.userId.value : this.userId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      speed: data.speed.present ? data.speed.value : this.speed,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookPlaybackSpeedEntry(')
          ..write('userId: $userId, ')
          ..write('itemId: $itemId, ')
          ..write('speed: $speed, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, itemId, speed, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookPlaybackSpeedEntry &&
          other.userId == this.userId &&
          other.itemId == this.itemId &&
          other.speed == this.speed &&
          other.updatedAt == this.updatedAt);
}

class BookPlaybackSpeedsCompanion extends UpdateCompanion<BookPlaybackSpeedEntry> {
  final Value<String> userId;
  final Value<String> itemId;
  final Value<double> speed;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BookPlaybackSpeedsCompanion({
    this.userId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.speed = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BookPlaybackSpeedsCompanion.insert({
    required String userId,
    required String itemId,
    required double speed,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       itemId = Value(itemId),
       speed = Value(speed);
  static Insertable<BookPlaybackSpeedEntry> custom({
    Expression<String>? userId,
    Expression<String>? itemId,
    Expression<double>? speed,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (itemId != null) 'item_id': itemId,
      if (speed != null) 'speed': speed,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BookPlaybackSpeedsCompanion copyWith({
    Value<String>? userId,
    Value<String>? itemId,
    Value<double>? speed,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BookPlaybackSpeedsCompanion(
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      speed: speed ?? this.speed,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (speed.present) {
      map['speed'] = Variable<double>(speed.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookPlaybackSpeedsCompanion(')
          ..write('userId: $userId, ')
          ..write('itemId: $itemId, ')
          ..write('speed: $speed, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredUsersTable extends StoredUsers with TableInfo<$StoredUsersTable, StoredUserEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredUsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userDataJsonMeta = const VerificationMeta('userDataJson');
  @override
  late final GeneratedColumn<String> userDataJson = GeneratedColumn<String>(
    'user_data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userDataJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_users';
  @override
  VerificationContext validateIntegrity(Insertable<StoredUserEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_data_json')) {
      context.handle(_userDataJsonMeta, userDataJson.isAcceptableOrUnknown(data['user_data_json']!, _userDataJsonMeta));
    } else if (isInserting) {
      context.missing(_userDataJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoredUserEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredUserEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userDataJson: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_data_json'])!,
    );
  }

  @override
  $StoredUsersTable createAlias(String alias) {
    return $StoredUsersTable(attachedDatabase, alias);
  }
}

class StoredUserEntry extends DataClass implements Insertable<StoredUserEntry> {
  final String id;
  final String userDataJson;
  const StoredUserEntry({required this.id, required this.userDataJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_data_json'] = Variable<String>(userDataJson);
    return map;
  }

  StoredUsersCompanion toCompanion(bool nullToAbsent) {
    return StoredUsersCompanion(id: Value(id), userDataJson: Value(userDataJson));
  }

  factory StoredUserEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredUserEntry(
      id: serializer.fromJson<String>(json['id']),
      userDataJson: serializer.fromJson<String>(json['userDataJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userDataJson': serializer.toJson<String>(userDataJson),
    };
  }

  StoredUserEntry copyWith({String? id, String? userDataJson}) =>
      StoredUserEntry(id: id ?? this.id, userDataJson: userDataJson ?? this.userDataJson);
  StoredUserEntry copyWithCompanion(StoredUsersCompanion data) {
    return StoredUserEntry(
      id: data.id.present ? data.id.value : this.id,
      userDataJson: data.userDataJson.present ? data.userDataJson.value : this.userDataJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredUserEntry(')
          ..write('id: $id, ')
          ..write('userDataJson: $userDataJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userDataJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredUserEntry && other.id == this.id && other.userDataJson == this.userDataJson);
}

class StoredUsersCompanion extends UpdateCompanion<StoredUserEntry> {
  final Value<String> id;
  final Value<String> userDataJson;
  final Value<int> rowid;
  const StoredUsersCompanion({
    this.id = const Value.absent(),
    this.userDataJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredUsersCompanion.insert({required String id, required String userDataJson, this.rowid = const Value.absent()})
    : id = Value(id),
      userDataJson = Value(userDataJson);
  static Insertable<StoredUserEntry> custom({
    Expression<String>? id,
    Expression<String>? userDataJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userDataJson != null) 'user_data_json': userDataJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredUsersCompanion copyWith({Value<String>? id, Value<String>? userDataJson, Value<int>? rowid}) {
    return StoredUsersCompanion(
      id: id ?? this.id,
      userDataJson: userDataJson ?? this.userDataJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userDataJson.present) {
      map['user_data_json'] = Variable<String>(userDataJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredUsersCompanion(')
          ..write('id: $id, ')
          ..write('userDataJson: $userDataJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredSyncsTable extends StoredSyncs with TableInfo<$StoredSyncsTable, StoredSyncEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredSyncsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta('sessionId');
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeIdMeta = const VerificationMeta('episodeId');
  @override
  late final GeneratedColumn<String> episodeId = GeneratedColumn<String>(
    'episode_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentTimeMeta = const VerificationMeta('currentTime');
  @override
  late final GeneratedColumn<double> currentTime = GeneratedColumn<double>(
    'current_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeListenedMeta = const VerificationMeta('timeListened');
  @override
  late final GeneratedColumn<double> timeListened = GeneratedColumn<double>(
    'time_listened',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta('duration');
  @override
  late final GeneratedColumn<double> duration = GeneratedColumn<double>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionLocalMeta = const VerificationMeta('sessionLocal');
  @override
  late final GeneratedColumn<bool> sessionLocal = GeneratedColumn<bool>(
    'session_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("session_local" IN (0, 1))'),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaProgressMeta = const VerificationMeta('mediaProgress');
  @override
  late final GeneratedColumn<String> mediaProgress = GeneratedColumn<String>(
    'media_progress',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    sessionId,
    itemId,
    userId,
    episodeId,
    currentTime,
    timeListened,
    duration,
    sessionLocal,
    lastUpdated,
    mediaProgress,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_syncs';
  @override
  VerificationContext validateIntegrity(Insertable<StoredSyncEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(_sessionIdMeta, sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta));
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta, itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(_episodeIdMeta, episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta));
    }
    if (data.containsKey('current_time')) {
      context.handle(_currentTimeMeta, currentTime.isAcceptableOrUnknown(data['current_time']!, _currentTimeMeta));
    } else if (isInserting) {
      context.missing(_currentTimeMeta);
    }
    if (data.containsKey('time_listened')) {
      context.handle(_timeListenedMeta, timeListened.isAcceptableOrUnknown(data['time_listened']!, _timeListenedMeta));
    } else if (isInserting) {
      context.missing(_timeListenedMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(_durationMeta, duration.isAcceptableOrUnknown(data['duration']!, _durationMeta));
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('session_local')) {
      context.handle(_sessionLocalMeta, sessionLocal.isAcceptableOrUnknown(data['session_local']!, _sessionLocalMeta));
    } else if (isInserting) {
      context.missing(_sessionLocalMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(_lastUpdatedMeta, lastUpdated.isAcceptableOrUnknown(data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('media_progress')) {
      context.handle(
        _mediaProgressMeta,
        mediaProgress.isAcceptableOrUnknown(data['media_progress']!, _mediaProgressMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaProgressMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {sessionId};
  @override
  StoredSyncEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredSyncEntry(
      sessionId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}session_id'])!,
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      episodeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}episode_id']),
      currentTime: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}current_time'])!,
      timeListened: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}time_listened'])!,
      duration: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}duration'])!,
      sessionLocal: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}session_local'])!,
      lastUpdated: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      mediaProgress: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}media_progress'])!,
    );
  }

  @override
  $StoredSyncsTable createAlias(String alias) {
    return $StoredSyncsTable(attachedDatabase, alias);
  }
}

class StoredSyncEntry extends DataClass implements Insertable<StoredSyncEntry> {
  final String sessionId;
  final String itemId;
  final String userId;
  final String? episodeId;
  final double currentTime;
  final double timeListened;
  final double duration;
  final bool sessionLocal;
  final DateTime lastUpdated;
  final String mediaProgress;
  const StoredSyncEntry({
    required this.sessionId,
    required this.itemId,
    required this.userId,
    this.episodeId,
    required this.currentTime,
    required this.timeListened,
    required this.duration,
    required this.sessionLocal,
    required this.lastUpdated,
    required this.mediaProgress,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['session_id'] = Variable<String>(sessionId);
    map['item_id'] = Variable<String>(itemId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['current_time'] = Variable<double>(currentTime);
    map['time_listened'] = Variable<double>(timeListened);
    map['duration'] = Variable<double>(duration);
    map['session_local'] = Variable<bool>(sessionLocal);
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['media_progress'] = Variable<String>(mediaProgress);
    return map;
  }

  StoredSyncsCompanion toCompanion(bool nullToAbsent) {
    return StoredSyncsCompanion(
      sessionId: Value(sessionId),
      itemId: Value(itemId),
      userId: Value(userId),
      episodeId: episodeId == null && nullToAbsent ? const Value.absent() : Value(episodeId),
      currentTime: Value(currentTime),
      timeListened: Value(timeListened),
      duration: Value(duration),
      sessionLocal: Value(sessionLocal),
      lastUpdated: Value(lastUpdated),
      mediaProgress: Value(mediaProgress),
    );
  }

  factory StoredSyncEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredSyncEntry(
      sessionId: serializer.fromJson<String>(json['sessionId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      userId: serializer.fromJson<String>(json['userId']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      currentTime: serializer.fromJson<double>(json['currentTime']),
      timeListened: serializer.fromJson<double>(json['timeListened']),
      duration: serializer.fromJson<double>(json['duration']),
      sessionLocal: serializer.fromJson<bool>(json['sessionLocal']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      mediaProgress: serializer.fromJson<String>(json['mediaProgress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'sessionId': serializer.toJson<String>(sessionId),
      'itemId': serializer.toJson<String>(itemId),
      'userId': serializer.toJson<String>(userId),
      'episodeId': serializer.toJson<String?>(episodeId),
      'currentTime': serializer.toJson<double>(currentTime),
      'timeListened': serializer.toJson<double>(timeListened),
      'duration': serializer.toJson<double>(duration),
      'sessionLocal': serializer.toJson<bool>(sessionLocal),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'mediaProgress': serializer.toJson<String>(mediaProgress),
    };
  }

  StoredSyncEntry copyWith({
    String? sessionId,
    String? itemId,
    String? userId,
    Value<String?> episodeId = const Value.absent(),
    double? currentTime,
    double? timeListened,
    double? duration,
    bool? sessionLocal,
    DateTime? lastUpdated,
    String? mediaProgress,
  }) => StoredSyncEntry(
    sessionId: sessionId ?? this.sessionId,
    itemId: itemId ?? this.itemId,
    userId: userId ?? this.userId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    currentTime: currentTime ?? this.currentTime,
    timeListened: timeListened ?? this.timeListened,
    duration: duration ?? this.duration,
    sessionLocal: sessionLocal ?? this.sessionLocal,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    mediaProgress: mediaProgress ?? this.mediaProgress,
  );
  StoredSyncEntry copyWithCompanion(StoredSyncsCompanion data) {
    return StoredSyncEntry(
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      userId: data.userId.present ? data.userId.value : this.userId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      currentTime: data.currentTime.present ? data.currentTime.value : this.currentTime,
      timeListened: data.timeListened.present ? data.timeListened.value : this.timeListened,
      duration: data.duration.present ? data.duration.value : this.duration,
      sessionLocal: data.sessionLocal.present ? data.sessionLocal.value : this.sessionLocal,
      lastUpdated: data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      mediaProgress: data.mediaProgress.present ? data.mediaProgress.value : this.mediaProgress,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredSyncEntry(')
          ..write('sessionId: $sessionId, ')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('currentTime: $currentTime, ')
          ..write('timeListened: $timeListened, ')
          ..write('duration: $duration, ')
          ..write('sessionLocal: $sessionLocal, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('mediaProgress: $mediaProgress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    sessionId,
    itemId,
    userId,
    episodeId,
    currentTime,
    timeListened,
    duration,
    sessionLocal,
    lastUpdated,
    mediaProgress,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredSyncEntry &&
          other.sessionId == this.sessionId &&
          other.itemId == this.itemId &&
          other.userId == this.userId &&
          other.episodeId == this.episodeId &&
          other.currentTime == this.currentTime &&
          other.timeListened == this.timeListened &&
          other.duration == this.duration &&
          other.sessionLocal == this.sessionLocal &&
          other.lastUpdated == this.lastUpdated &&
          other.mediaProgress == this.mediaProgress);
}

class StoredSyncsCompanion extends UpdateCompanion<StoredSyncEntry> {
  final Value<String> sessionId;
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String?> episodeId;
  final Value<double> currentTime;
  final Value<double> timeListened;
  final Value<double> duration;
  final Value<bool> sessionLocal;
  final Value<DateTime> lastUpdated;
  final Value<String> mediaProgress;
  final Value<int> rowid;
  const StoredSyncsCompanion({
    this.sessionId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.currentTime = const Value.absent(),
    this.timeListened = const Value.absent(),
    this.duration = const Value.absent(),
    this.sessionLocal = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.mediaProgress = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredSyncsCompanion.insert({
    required String sessionId,
    required String itemId,
    required String userId,
    this.episodeId = const Value.absent(),
    required double currentTime,
    required double timeListened,
    required double duration,
    required bool sessionLocal,
    required DateTime lastUpdated,
    required String mediaProgress,
    this.rowid = const Value.absent(),
  }) : sessionId = Value(sessionId),
       itemId = Value(itemId),
       userId = Value(userId),
       currentTime = Value(currentTime),
       timeListened = Value(timeListened),
       duration = Value(duration),
       sessionLocal = Value(sessionLocal),
       lastUpdated = Value(lastUpdated),
       mediaProgress = Value(mediaProgress);
  static Insertable<StoredSyncEntry> custom({
    Expression<String>? sessionId,
    Expression<String>? itemId,
    Expression<String>? userId,
    Expression<String>? episodeId,
    Expression<double>? currentTime,
    Expression<double>? timeListened,
    Expression<double>? duration,
    Expression<bool>? sessionLocal,
    Expression<DateTime>? lastUpdated,
    Expression<String>? mediaProgress,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (sessionId != null) 'session_id': sessionId,
      if (itemId != null) 'item_id': itemId,
      if (userId != null) 'user_id': userId,
      if (episodeId != null) 'episode_id': episodeId,
      if (currentTime != null) 'current_time': currentTime,
      if (timeListened != null) 'time_listened': timeListened,
      if (duration != null) 'duration': duration,
      if (sessionLocal != null) 'session_local': sessionLocal,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (mediaProgress != null) 'media_progress': mediaProgress,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredSyncsCompanion copyWith({
    Value<String>? sessionId,
    Value<String>? itemId,
    Value<String>? userId,
    Value<String?>? episodeId,
    Value<double>? currentTime,
    Value<double>? timeListened,
    Value<double>? duration,
    Value<bool>? sessionLocal,
    Value<DateTime>? lastUpdated,
    Value<String>? mediaProgress,
    Value<int>? rowid,
  }) {
    return StoredSyncsCompanion(
      sessionId: sessionId ?? this.sessionId,
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      episodeId: episodeId ?? this.episodeId,
      currentTime: currentTime ?? this.currentTime,
      timeListened: timeListened ?? this.timeListened,
      duration: duration ?? this.duration,
      sessionLocal: sessionLocal ?? this.sessionLocal,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      mediaProgress: mediaProgress ?? this.mediaProgress,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<String>(episodeId.value);
    }
    if (currentTime.present) {
      map['current_time'] = Variable<double>(currentTime.value);
    }
    if (timeListened.present) {
      map['time_listened'] = Variable<double>(timeListened.value);
    }
    if (duration.present) {
      map['duration'] = Variable<double>(duration.value);
    }
    if (sessionLocal.present) {
      map['session_local'] = Variable<bool>(sessionLocal.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (mediaProgress.present) {
      map['media_progress'] = Variable<String>(mediaProgress.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredSyncsCompanion(')
          ..write('sessionId: $sessionId, ')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('currentTime: $currentTime, ')
          ..write('timeListened: $timeListened, ')
          ..write('duration: $duration, ')
          ..write('sessionLocal: $sessionLocal, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('mediaProgress: $mediaProgress, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredMediaProgressTable extends StoredMediaProgress
    with TableInfo<$StoredMediaProgressTable, StoredMediaProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredMediaProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _progressIdMeta = const VerificationMeta('progressId');
  @override
  late final GeneratedColumn<String> progressId = GeneratedColumn<String>(
    'progress_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeIdMeta = const VerificationMeta('episodeId');
  @override
  late final GeneratedColumn<String> episodeId = GeneratedColumn<String>(
    'episode_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta('lastUpdated');
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaProgressMeta = const VerificationMeta('mediaProgress');
  @override
  late final GeneratedColumn<String> mediaProgress = GeneratedColumn<String>(
    'media_progress',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [progressId, userId, itemId, episodeId, lastUpdated, mediaProgress];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_media_progress';
  @override
  VerificationContext validateIntegrity(Insertable<StoredMediaProgressEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('progress_id')) {
      context.handle(_progressIdMeta, progressId.isAcceptableOrUnknown(data['progress_id']!, _progressIdMeta));
    } else if (isInserting) {
      context.missing(_progressIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta, itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(_episodeIdMeta, episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta));
    }
    if (data.containsKey('last_updated')) {
      context.handle(_lastUpdatedMeta, lastUpdated.isAcceptableOrUnknown(data['last_updated']!, _lastUpdatedMeta));
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('media_progress')) {
      context.handle(
        _mediaProgressMeta,
        mediaProgress.isAcceptableOrUnknown(data['media_progress']!, _mediaProgressMeta),
      );
    } else if (isInserting) {
      context.missing(_mediaProgressMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {progressId};
  @override
  StoredMediaProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredMediaProgressEntry(
      progressId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}progress_id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      episodeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}episode_id']),
      lastUpdated: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}last_updated'])!,
      mediaProgress: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}media_progress'])!,
    );
  }

  @override
  $StoredMediaProgressTable createAlias(String alias) {
    return $StoredMediaProgressTable(attachedDatabase, alias);
  }
}

class StoredMediaProgressEntry extends DataClass implements Insertable<StoredMediaProgressEntry> {
  final String progressId;
  final String userId;
  final String itemId;
  final String? episodeId;
  final DateTime lastUpdated;
  final String mediaProgress;
  const StoredMediaProgressEntry({
    required this.progressId,
    required this.userId,
    required this.itemId,
    this.episodeId,
    required this.lastUpdated,
    required this.mediaProgress,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['progress_id'] = Variable<String>(progressId);
    map['user_id'] = Variable<String>(userId);
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['last_updated'] = Variable<DateTime>(lastUpdated);
    map['media_progress'] = Variable<String>(mediaProgress);
    return map;
  }

  StoredMediaProgressCompanion toCompanion(bool nullToAbsent) {
    return StoredMediaProgressCompanion(
      progressId: Value(progressId),
      userId: Value(userId),
      itemId: Value(itemId),
      episodeId: episodeId == null && nullToAbsent ? const Value.absent() : Value(episodeId),
      lastUpdated: Value(lastUpdated),
      mediaProgress: Value(mediaProgress),
    );
  }

  factory StoredMediaProgressEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredMediaProgressEntry(
      progressId: serializer.fromJson<String>(json['progressId']),
      userId: serializer.fromJson<String>(json['userId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      lastUpdated: serializer.fromJson<DateTime>(json['lastUpdated']),
      mediaProgress: serializer.fromJson<String>(json['mediaProgress']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'progressId': serializer.toJson<String>(progressId),
      'userId': serializer.toJson<String>(userId),
      'itemId': serializer.toJson<String>(itemId),
      'episodeId': serializer.toJson<String?>(episodeId),
      'lastUpdated': serializer.toJson<DateTime>(lastUpdated),
      'mediaProgress': serializer.toJson<String>(mediaProgress),
    };
  }

  StoredMediaProgressEntry copyWith({
    String? progressId,
    String? userId,
    String? itemId,
    Value<String?> episodeId = const Value.absent(),
    DateTime? lastUpdated,
    String? mediaProgress,
  }) => StoredMediaProgressEntry(
    progressId: progressId ?? this.progressId,
    userId: userId ?? this.userId,
    itemId: itemId ?? this.itemId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    lastUpdated: lastUpdated ?? this.lastUpdated,
    mediaProgress: mediaProgress ?? this.mediaProgress,
  );
  StoredMediaProgressEntry copyWithCompanion(StoredMediaProgressCompanion data) {
    return StoredMediaProgressEntry(
      progressId: data.progressId.present ? data.progressId.value : this.progressId,
      userId: data.userId.present ? data.userId.value : this.userId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      lastUpdated: data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      mediaProgress: data.mediaProgress.present ? data.mediaProgress.value : this.mediaProgress,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredMediaProgressEntry(')
          ..write('progressId: $progressId, ')
          ..write('userId: $userId, ')
          ..write('itemId: $itemId, ')
          ..write('episodeId: $episodeId, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('mediaProgress: $mediaProgress')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(progressId, userId, itemId, episodeId, lastUpdated, mediaProgress);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredMediaProgressEntry &&
          other.progressId == this.progressId &&
          other.userId == this.userId &&
          other.itemId == this.itemId &&
          other.episodeId == this.episodeId &&
          other.lastUpdated == this.lastUpdated &&
          other.mediaProgress == this.mediaProgress);
}

class StoredMediaProgressCompanion extends UpdateCompanion<StoredMediaProgressEntry> {
  final Value<String> progressId;
  final Value<String> userId;
  final Value<String> itemId;
  final Value<String?> episodeId;
  final Value<DateTime> lastUpdated;
  final Value<String> mediaProgress;
  final Value<int> rowid;
  const StoredMediaProgressCompanion({
    this.progressId = const Value.absent(),
    this.userId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.mediaProgress = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredMediaProgressCompanion.insert({
    required String progressId,
    required String userId,
    required String itemId,
    this.episodeId = const Value.absent(),
    required DateTime lastUpdated,
    required String mediaProgress,
    this.rowid = const Value.absent(),
  }) : progressId = Value(progressId),
       userId = Value(userId),
       itemId = Value(itemId),
       lastUpdated = Value(lastUpdated),
       mediaProgress = Value(mediaProgress);
  static Insertable<StoredMediaProgressEntry> custom({
    Expression<String>? progressId,
    Expression<String>? userId,
    Expression<String>? itemId,
    Expression<String>? episodeId,
    Expression<DateTime>? lastUpdated,
    Expression<String>? mediaProgress,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (progressId != null) 'progress_id': progressId,
      if (userId != null) 'user_id': userId,
      if (itemId != null) 'item_id': itemId,
      if (episodeId != null) 'episode_id': episodeId,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (mediaProgress != null) 'media_progress': mediaProgress,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredMediaProgressCompanion copyWith({
    Value<String>? progressId,
    Value<String>? userId,
    Value<String>? itemId,
    Value<String?>? episodeId,
    Value<DateTime>? lastUpdated,
    Value<String>? mediaProgress,
    Value<int>? rowid,
  }) {
    return StoredMediaProgressCompanion(
      progressId: progressId ?? this.progressId,
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      episodeId: episodeId ?? this.episodeId,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      mediaProgress: mediaProgress ?? this.mediaProgress,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (progressId.present) {
      map['progress_id'] = Variable<String>(progressId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<String>(episodeId.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (mediaProgress.present) {
      map['media_progress'] = Variable<String>(mediaProgress.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredMediaProgressCompanion(')
          ..write('progressId: $progressId, ')
          ..write('userId: $userId, ')
          ..write('itemId: $itemId, ')
          ..write('episodeId: $episodeId, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('mediaProgress: $mediaProgress, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredBookmarkSyncsTable extends StoredBookmarkSyncs
    with TableInfo<$StoredBookmarkSyncsTable, StoredBookmarkSyncEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredBookmarkSyncsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeMeta = const VerificationMeta('time');
  @override
  late final GeneratedColumn<int> time = GeneratedColumn<int>(
    'time',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta('deleted');
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("deleted" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [userId, itemId, time, title, deleted, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_bookmark_syncs';
  @override
  VerificationContext validateIntegrity(Insertable<StoredBookmarkSyncEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta, itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('time')) {
      context.handle(_timeMeta, time.isAcceptableOrUnknown(data['time']!, _timeMeta));
    } else if (isInserting) {
      context.missing(_timeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(_titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('deleted')) {
      context.handle(_deletedMeta, deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId, itemId, time};
  @override
  StoredBookmarkSyncEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredBookmarkSyncEntry(
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      time: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}time'])!,
      title: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}title']),
      deleted: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}deleted'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $StoredBookmarkSyncsTable createAlias(String alias) {
    return $StoredBookmarkSyncsTable(attachedDatabase, alias);
  }
}

class StoredBookmarkSyncEntry extends DataClass implements Insertable<StoredBookmarkSyncEntry> {
  final String userId;
  final String itemId;
  final int time;
  final String? title;
  final bool deleted;
  final DateTime updatedAt;
  const StoredBookmarkSyncEntry({
    required this.userId,
    required this.itemId,
    required this.time,
    this.title,
    required this.deleted,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['item_id'] = Variable<String>(itemId);
    map['time'] = Variable<int>(time);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['deleted'] = Variable<bool>(deleted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  StoredBookmarkSyncsCompanion toCompanion(bool nullToAbsent) {
    return StoredBookmarkSyncsCompanion(
      userId: Value(userId),
      itemId: Value(itemId),
      time: Value(time),
      title: title == null && nullToAbsent ? const Value.absent() : Value(title),
      deleted: Value(deleted),
      updatedAt: Value(updatedAt),
    );
  }

  factory StoredBookmarkSyncEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredBookmarkSyncEntry(
      userId: serializer.fromJson<String>(json['userId']),
      itemId: serializer.fromJson<String>(json['itemId']),
      time: serializer.fromJson<int>(json['time']),
      title: serializer.fromJson<String?>(json['title']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'itemId': serializer.toJson<String>(itemId),
      'time': serializer.toJson<int>(time),
      'title': serializer.toJson<String?>(title),
      'deleted': serializer.toJson<bool>(deleted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  StoredBookmarkSyncEntry copyWith({
    String? userId,
    String? itemId,
    int? time,
    Value<String?> title = const Value.absent(),
    bool? deleted,
    DateTime? updatedAt,
  }) => StoredBookmarkSyncEntry(
    userId: userId ?? this.userId,
    itemId: itemId ?? this.itemId,
    time: time ?? this.time,
    title: title.present ? title.value : this.title,
    deleted: deleted ?? this.deleted,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StoredBookmarkSyncEntry copyWithCompanion(StoredBookmarkSyncsCompanion data) {
    return StoredBookmarkSyncEntry(
      userId: data.userId.present ? data.userId.value : this.userId,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      time: data.time.present ? data.time.value : this.time,
      title: data.title.present ? data.title.value : this.title,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredBookmarkSyncEntry(')
          ..write('userId: $userId, ')
          ..write('itemId: $itemId, ')
          ..write('time: $time, ')
          ..write('title: $title, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(userId, itemId, time, title, deleted, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredBookmarkSyncEntry &&
          other.userId == this.userId &&
          other.itemId == this.itemId &&
          other.time == this.time &&
          other.title == this.title &&
          other.deleted == this.deleted &&
          other.updatedAt == this.updatedAt);
}

class StoredBookmarkSyncsCompanion extends UpdateCompanion<StoredBookmarkSyncEntry> {
  final Value<String> userId;
  final Value<String> itemId;
  final Value<int> time;
  final Value<String?> title;
  final Value<bool> deleted;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const StoredBookmarkSyncsCompanion({
    this.userId = const Value.absent(),
    this.itemId = const Value.absent(),
    this.time = const Value.absent(),
    this.title = const Value.absent(),
    this.deleted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredBookmarkSyncsCompanion.insert({
    required String userId,
    required String itemId,
    required int time,
    this.title = const Value.absent(),
    this.deleted = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : userId = Value(userId),
       itemId = Value(itemId),
       time = Value(time),
       updatedAt = Value(updatedAt);
  static Insertable<StoredBookmarkSyncEntry> custom({
    Expression<String>? userId,
    Expression<String>? itemId,
    Expression<int>? time,
    Expression<String>? title,
    Expression<bool>? deleted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (itemId != null) 'item_id': itemId,
      if (time != null) 'time': time,
      if (title != null) 'title': title,
      if (deleted != null) 'deleted': deleted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredBookmarkSyncsCompanion copyWith({
    Value<String>? userId,
    Value<String>? itemId,
    Value<int>? time,
    Value<String?>? title,
    Value<bool>? deleted,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return StoredBookmarkSyncsCompanion(
      userId: userId ?? this.userId,
      itemId: itemId ?? this.itemId,
      time: time ?? this.time,
      title: title ?? this.title,
      deleted: deleted ?? this.deleted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (time.present) {
      map['time'] = Variable<int>(time.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredBookmarkSyncsCompanion(')
          ..write('userId: $userId, ')
          ..write('itemId: $itemId, ')
          ..write('time: $time, ')
          ..write('title: $title, ')
          ..write('deleted: $deleted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredDownloadsTable extends StoredDownloads with TableInfo<$StoredDownloadsTable, StoredDownloadsEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredDownloadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeIdMeta = const VerificationMeta('episodeId');
  @override
  late final GeneratedColumn<String> episodeId = GeneratedColumn<String>(
    'episode_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _downloadMeta = const VerificationMeta('download');
  @override
  late final GeneratedColumn<String> download = GeneratedColumn<String>(
    'download',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, userId, episodeId, download];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_downloads';
  @override
  VerificationContext validateIntegrity(Insertable<StoredDownloadsEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta, itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(_episodeIdMeta, episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta));
    }
    if (data.containsKey('download')) {
      context.handle(_downloadMeta, download.isAcceptableOrUnknown(data['download']!, _downloadMeta));
    } else if (isInserting) {
      context.missing(_downloadMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, userId, episodeId};
  @override
  StoredDownloadsEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredDownloadsEntry(
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      episodeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}episode_id']),
      download: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}download'])!,
    );
  }

  @override
  $StoredDownloadsTable createAlias(String alias) {
    return $StoredDownloadsTable(attachedDatabase, alias);
  }
}

class StoredDownloadsEntry extends DataClass implements Insertable<StoredDownloadsEntry> {
  final String itemId;
  final String userId;
  final String? episodeId;
  final String download;
  const StoredDownloadsEntry({required this.itemId, required this.userId, this.episodeId, required this.download});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['download'] = Variable<String>(download);
    return map;
  }

  StoredDownloadsCompanion toCompanion(bool nullToAbsent) {
    return StoredDownloadsCompanion(
      itemId: Value(itemId),
      userId: Value(userId),
      episodeId: episodeId == null && nullToAbsent ? const Value.absent() : Value(episodeId),
      download: Value(download),
    );
  }

  factory StoredDownloadsEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredDownloadsEntry(
      itemId: serializer.fromJson<String>(json['itemId']),
      userId: serializer.fromJson<String>(json['userId']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      download: serializer.fromJson<String>(json['download']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'userId': serializer.toJson<String>(userId),
      'episodeId': serializer.toJson<String?>(episodeId),
      'download': serializer.toJson<String>(download),
    };
  }

  StoredDownloadsEntry copyWith({
    String? itemId,
    String? userId,
    Value<String?> episodeId = const Value.absent(),
    String? download,
  }) => StoredDownloadsEntry(
    itemId: itemId ?? this.itemId,
    userId: userId ?? this.userId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    download: download ?? this.download,
  );
  StoredDownloadsEntry copyWithCompanion(StoredDownloadsCompanion data) {
    return StoredDownloadsEntry(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      userId: data.userId.present ? data.userId.value : this.userId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      download: data.download.present ? data.download.value : this.download,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredDownloadsEntry(')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('download: $download')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, userId, episodeId, download);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredDownloadsEntry &&
          other.itemId == this.itemId &&
          other.userId == this.userId &&
          other.episodeId == this.episodeId &&
          other.download == this.download);
}

class StoredDownloadsCompanion extends UpdateCompanion<StoredDownloadsEntry> {
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String?> episodeId;
  final Value<String> download;
  final Value<int> rowid;
  const StoredDownloadsCompanion({
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.download = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredDownloadsCompanion.insert({
    required String itemId,
    required String userId,
    this.episodeId = const Value.absent(),
    required String download,
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       userId = Value(userId),
       download = Value(download);
  static Insertable<StoredDownloadsEntry> custom({
    Expression<String>? itemId,
    Expression<String>? userId,
    Expression<String>? episodeId,
    Expression<String>? download,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (userId != null) 'user_id': userId,
      if (episodeId != null) 'episode_id': episodeId,
      if (download != null) 'download': download,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredDownloadsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? userId,
    Value<String?>? episodeId,
    Value<String>? download,
    Value<int>? rowid,
  }) {
    return StoredDownloadsCompanion(
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      episodeId: episodeId ?? this.episodeId,
      download: download ?? this.download,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<String>(episodeId.value);
    }
    if (download.present) {
      map['download'] = Variable<String>(download.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredDownloadsCompanion(')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('download: $download, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlayerHistoryTable extends PlayerHistory with TableInfo<$PlayerHistoryTable, PlayerHistoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlayerHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<String> itemId = GeneratedColumn<String>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _episodeIdMeta = const VerificationMeta('episodeId');
  @override
  late final GeneratedColumn<String> episodeId = GeneratedColumn<String>(
    'episode_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currentTimeMeta = const VerificationMeta('currentTime');
  @override
  late final GeneratedColumn<double> currentTime = GeneratedColumn<double>(
    'current_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdMeta = const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime> created = GeneratedColumn<DateTime>(
    'created',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, itemId, userId, episodeId, type, currentTime, created];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'player_history';
  @override
  VerificationContext validateIntegrity(Insertable<PlayerHistoryEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta, itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(_episodeIdMeta, episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta));
    }
    if (data.containsKey('type')) {
      context.handle(_typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('current_time')) {
      context.handle(_currentTimeMeta, currentTime.isAcceptableOrUnknown(data['current_time']!, _currentTimeMeta));
    } else if (isInserting) {
      context.missing(_currentTimeMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta, created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlayerHistoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlayerHistoryEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      episodeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}episode_id']),
      type: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      currentTime: attachedDatabase.typeMapping.read(DriftSqlType.double, data['${effectivePrefix}current_time'])!,
      created: attachedDatabase.typeMapping.read(DriftSqlType.dateTime, data['${effectivePrefix}created'])!,
    );
  }

  @override
  $PlayerHistoryTable createAlias(String alias) {
    return $PlayerHistoryTable(attachedDatabase, alias);
  }
}

class PlayerHistoryEntry extends DataClass implements Insertable<PlayerHistoryEntry> {
  final int id;
  final String itemId;
  final String userId;
  final String? episodeId;
  final String type;
  final double currentTime;
  final DateTime created;
  const PlayerHistoryEntry({
    required this.id,
    required this.itemId,
    required this.userId,
    this.episodeId,
    required this.type,
    required this.currentTime,
    required this.created,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<String>(itemId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['type'] = Variable<String>(type);
    map['current_time'] = Variable<double>(currentTime);
    map['created'] = Variable<DateTime>(created);
    return map;
  }

  PlayerHistoryCompanion toCompanion(bool nullToAbsent) {
    return PlayerHistoryCompanion(
      id: Value(id),
      itemId: Value(itemId),
      userId: Value(userId),
      episodeId: episodeId == null && nullToAbsent ? const Value.absent() : Value(episodeId),
      type: Value(type),
      currentTime: Value(currentTime),
      created: Value(created),
    );
  }

  factory PlayerHistoryEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlayerHistoryEntry(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<String>(json['itemId']),
      userId: serializer.fromJson<String>(json['userId']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      type: serializer.fromJson<String>(json['type']),
      currentTime: serializer.fromJson<double>(json['currentTime']),
      created: serializer.fromJson<DateTime>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<String>(itemId),
      'userId': serializer.toJson<String>(userId),
      'episodeId': serializer.toJson<String?>(episodeId),
      'type': serializer.toJson<String>(type),
      'currentTime': serializer.toJson<double>(currentTime),
      'created': serializer.toJson<DateTime>(created),
    };
  }

  PlayerHistoryEntry copyWith({
    int? id,
    String? itemId,
    String? userId,
    Value<String?> episodeId = const Value.absent(),
    String? type,
    double? currentTime,
    DateTime? created,
  }) => PlayerHistoryEntry(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    userId: userId ?? this.userId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    type: type ?? this.type,
    currentTime: currentTime ?? this.currentTime,
    created: created ?? this.created,
  );
  PlayerHistoryEntry copyWithCompanion(PlayerHistoryCompanion data) {
    return PlayerHistoryEntry(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      userId: data.userId.present ? data.userId.value : this.userId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      type: data.type.present ? data.type.value : this.type,
      currentTime: data.currentTime.present ? data.currentTime.value : this.currentTime,
      created: data.created.present ? data.created.value : this.created,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlayerHistoryEntry(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('type: $type, ')
          ..write('currentTime: $currentTime, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, userId, episodeId, type, currentTime, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlayerHistoryEntry &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.userId == this.userId &&
          other.episodeId == this.episodeId &&
          other.type == this.type &&
          other.currentTime == this.currentTime &&
          other.created == this.created);
}

class PlayerHistoryCompanion extends UpdateCompanion<PlayerHistoryEntry> {
  final Value<int> id;
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String?> episodeId;
  final Value<String> type;
  final Value<double> currentTime;
  final Value<DateTime> created;
  const PlayerHistoryCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.type = const Value.absent(),
    this.currentTime = const Value.absent(),
    this.created = const Value.absent(),
  });
  PlayerHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String itemId,
    required String userId,
    this.episodeId = const Value.absent(),
    required String type,
    required double currentTime,
    this.created = const Value.absent(),
  }) : itemId = Value(itemId),
       userId = Value(userId),
       type = Value(type),
       currentTime = Value(currentTime);
  static Insertable<PlayerHistoryEntry> custom({
    Expression<int>? id,
    Expression<String>? itemId,
    Expression<String>? userId,
    Expression<String>? episodeId,
    Expression<String>? type,
    Expression<double>? currentTime,
    Expression<DateTime>? created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (userId != null) 'user_id': userId,
      if (episodeId != null) 'episode_id': episodeId,
      if (type != null) 'type': type,
      if (currentTime != null) 'current_time': currentTime,
      if (created != null) 'created': created,
    });
  }

  PlayerHistoryCompanion copyWith({
    Value<int>? id,
    Value<String>? itemId,
    Value<String>? userId,
    Value<String?>? episodeId,
    Value<String>? type,
    Value<double>? currentTime,
    Value<DateTime>? created,
  }) {
    return PlayerHistoryCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      episodeId: episodeId ?? this.episodeId,
      type: type ?? this.type,
      currentTime: currentTime ?? this.currentTime,
      created: created ?? this.created,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<String>(episodeId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (currentTime.present) {
      map['current_time'] = Variable<double>(currentTime.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlayerHistoryCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('type: $type, ')
          ..write('currentTime: $currentTime, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GlobalSettingsTable globalSettings = $GlobalSettingsTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $BookPlaybackSpeedsTable bookPlaybackSpeeds = $BookPlaybackSpeedsTable(this);
  late final $StoredUsersTable storedUsers = $StoredUsersTable(this);
  late final $StoredSyncsTable storedSyncs = $StoredSyncsTable(this);
  late final $StoredMediaProgressTable storedMediaProgress = $StoredMediaProgressTable(this);
  late final $StoredBookmarkSyncsTable storedBookmarkSyncs = $StoredBookmarkSyncsTable(this);
  late final $StoredDownloadsTable storedDownloads = $StoredDownloadsTable(this);
  late final $PlayerHistoryTable playerHistory = $PlayerHistoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    globalSettings,
    userSettings,
    bookPlaybackSpeeds,
    storedUsers,
    storedSyncs,
    storedMediaProgress,
    storedBookmarkSyncs,
    storedDownloads,
    playerHistory,
  ];
}

typedef $$GlobalSettingsTableCreateCompanionBuilder =
    GlobalSettingsCompanion Function({required String key, required String value, Value<int> rowid});
typedef $$GlobalSettingsTableUpdateCompanionBuilder =
    GlobalSettingsCompanion Function({Value<String> key, Value<String> value, Value<int> rowid});

class $$GlobalSettingsTableFilterComposer extends Composer<_$AppDatabase, $GlobalSettingsTable> {
  $$GlobalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$GlobalSettingsTableOrderingComposer extends Composer<_$AppDatabase, $GlobalSettingsTable> {
  $$GlobalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$GlobalSettingsTableAnnotationComposer extends Composer<_$AppDatabase, $GlobalSettingsTable> {
  $$GlobalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$GlobalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GlobalSettingsTable,
          GlobalSettingEntry,
          $$GlobalSettingsTableFilterComposer,
          $$GlobalSettingsTableOrderingComposer,
          $$GlobalSettingsTableAnnotationComposer,
          $$GlobalSettingsTableCreateCompanionBuilder,
          $$GlobalSettingsTableUpdateCompanionBuilder,
          (GlobalSettingEntry, BaseReferences<_$AppDatabase, $GlobalSettingsTable, GlobalSettingEntry>),
          GlobalSettingEntry,
          PrefetchHooks Function()
        > {
  $$GlobalSettingsTableTableManager(_$AppDatabase db, $GlobalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$GlobalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$GlobalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$GlobalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GlobalSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({required String key, required String value, Value<int> rowid = const Value.absent()}) =>
                  GlobalSettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GlobalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GlobalSettingsTable,
      GlobalSettingEntry,
      $$GlobalSettingsTableFilterComposer,
      $$GlobalSettingsTableOrderingComposer,
      $$GlobalSettingsTableAnnotationComposer,
      $$GlobalSettingsTableCreateCompanionBuilder,
      $$GlobalSettingsTableUpdateCompanionBuilder,
      (GlobalSettingEntry, BaseReferences<_$AppDatabase, $GlobalSettingsTable, GlobalSettingEntry>),
      GlobalSettingEntry,
      PrefetchHooks Function()
    >;
typedef $$UserSettingsTableCreateCompanionBuilder =
    UserSettingsCompanion Function({
      required String userId,
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$UserSettingsTableUpdateCompanionBuilder =
    UserSettingsCompanion Function({Value<String> userId, Value<String> key, Value<String> value, Value<int> rowid});

class $$UserSettingsTableFilterComposer extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$UserSettingsTableOrderingComposer extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$UserSettingsTableAnnotationComposer extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserSettingsTable,
          UserSettingEntry,
          $$UserSettingsTableFilterComposer,
          $$UserSettingsTableOrderingComposer,
          $$UserSettingsTableAnnotationComposer,
          $$UserSettingsTableCreateCompanionBuilder,
          $$UserSettingsTableUpdateCompanionBuilder,
          (UserSettingEntry, BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingEntry>),
          UserSettingEntry,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion(userId: userId, key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String userId,
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion.insert(userId: userId, key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserSettingsTable,
      UserSettingEntry,
      $$UserSettingsTableFilterComposer,
      $$UserSettingsTableOrderingComposer,
      $$UserSettingsTableAnnotationComposer,
      $$UserSettingsTableCreateCompanionBuilder,
      $$UserSettingsTableUpdateCompanionBuilder,
      (UserSettingEntry, BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingEntry>),
      UserSettingEntry,
      PrefetchHooks Function()
    >;
typedef $$BookPlaybackSpeedsTableCreateCompanionBuilder =
    BookPlaybackSpeedsCompanion Function({
      required String userId,
      required String itemId,
      required double speed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$BookPlaybackSpeedsTableUpdateCompanionBuilder =
    BookPlaybackSpeedsCompanion Function({
      Value<String> userId,
      Value<String> itemId,
      Value<double> speed,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BookPlaybackSpeedsTableFilterComposer extends Composer<_$AppDatabase, $BookPlaybackSpeedsTable> {
  $$BookPlaybackSpeedsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$BookPlaybackSpeedsTableOrderingComposer extends Composer<_$AppDatabase, $BookPlaybackSpeedsTable> {
  $$BookPlaybackSpeedsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get speed =>
      $composableBuilder(column: $table.speed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$BookPlaybackSpeedsTableAnnotationComposer extends Composer<_$AppDatabase, $BookPlaybackSpeedsTable> {
  $$BookPlaybackSpeedsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<double> get speed => $composableBuilder(column: $table.speed, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BookPlaybackSpeedsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookPlaybackSpeedsTable,
          BookPlaybackSpeedEntry,
          $$BookPlaybackSpeedsTableFilterComposer,
          $$BookPlaybackSpeedsTableOrderingComposer,
          $$BookPlaybackSpeedsTableAnnotationComposer,
          $$BookPlaybackSpeedsTableCreateCompanionBuilder,
          $$BookPlaybackSpeedsTableUpdateCompanionBuilder,
          (BookPlaybackSpeedEntry, BaseReferences<_$AppDatabase, $BookPlaybackSpeedsTable, BookPlaybackSpeedEntry>),
          BookPlaybackSpeedEntry,
          PrefetchHooks Function()
        > {
  $$BookPlaybackSpeedsTableTableManager(_$AppDatabase db, $BookPlaybackSpeedsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$BookPlaybackSpeedsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$BookPlaybackSpeedsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$BookPlaybackSpeedsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<double> speed = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookPlaybackSpeedsCompanion(
                userId: userId,
                itemId: itemId,
                speed: speed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String itemId,
                required double speed,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BookPlaybackSpeedsCompanion.insert(
                userId: userId,
                itemId: itemId,
                speed: speed,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BookPlaybackSpeedsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookPlaybackSpeedsTable,
      BookPlaybackSpeedEntry,
      $$BookPlaybackSpeedsTableFilterComposer,
      $$BookPlaybackSpeedsTableOrderingComposer,
      $$BookPlaybackSpeedsTableAnnotationComposer,
      $$BookPlaybackSpeedsTableCreateCompanionBuilder,
      $$BookPlaybackSpeedsTableUpdateCompanionBuilder,
      (BookPlaybackSpeedEntry, BaseReferences<_$AppDatabase, $BookPlaybackSpeedsTable, BookPlaybackSpeedEntry>),
      BookPlaybackSpeedEntry,
      PrefetchHooks Function()
    >;
typedef $$StoredUsersTableCreateCompanionBuilder =
    StoredUsersCompanion Function({required String id, required String userDataJson, Value<int> rowid});
typedef $$StoredUsersTableUpdateCompanionBuilder =
    StoredUsersCompanion Function({Value<String> id, Value<String> userDataJson, Value<int> rowid});

class $$StoredUsersTableFilterComposer extends Composer<_$AppDatabase, $StoredUsersTable> {
  $$StoredUsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userDataJson =>
      $composableBuilder(column: $table.userDataJson, builder: (column) => ColumnFilters(column));
}

class $$StoredUsersTableOrderingComposer extends Composer<_$AppDatabase, $StoredUsersTable> {
  $$StoredUsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userDataJson =>
      $composableBuilder(column: $table.userDataJson, builder: (column) => ColumnOrderings(column));
}

class $$StoredUsersTableAnnotationComposer extends Composer<_$AppDatabase, $StoredUsersTable> {
  $$StoredUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userDataJson =>
      $composableBuilder(column: $table.userDataJson, builder: (column) => column);
}

class $$StoredUsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredUsersTable,
          StoredUserEntry,
          $$StoredUsersTableFilterComposer,
          $$StoredUsersTableOrderingComposer,
          $$StoredUsersTableAnnotationComposer,
          $$StoredUsersTableCreateCompanionBuilder,
          $$StoredUsersTableUpdateCompanionBuilder,
          (StoredUserEntry, BaseReferences<_$AppDatabase, $StoredUsersTable, StoredUserEntry>),
          StoredUserEntry,
          PrefetchHooks Function()
        > {
  $$StoredUsersTableTableManager(_$AppDatabase db, $StoredUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StoredUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StoredUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StoredUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredUsersCompanion(id: id, userDataJson: userDataJson, rowid: rowid),
          createCompanionCallback:
              ({required String id, required String userDataJson, Value<int> rowid = const Value.absent()}) =>
                  StoredUsersCompanion.insert(id: id, userDataJson: userDataJson, rowid: rowid),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredUsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredUsersTable,
      StoredUserEntry,
      $$StoredUsersTableFilterComposer,
      $$StoredUsersTableOrderingComposer,
      $$StoredUsersTableAnnotationComposer,
      $$StoredUsersTableCreateCompanionBuilder,
      $$StoredUsersTableUpdateCompanionBuilder,
      (StoredUserEntry, BaseReferences<_$AppDatabase, $StoredUsersTable, StoredUserEntry>),
      StoredUserEntry,
      PrefetchHooks Function()
    >;
typedef $$StoredSyncsTableCreateCompanionBuilder =
    StoredSyncsCompanion Function({
      required String sessionId,
      required String itemId,
      required String userId,
      Value<String?> episodeId,
      required double currentTime,
      required double timeListened,
      required double duration,
      required bool sessionLocal,
      required DateTime lastUpdated,
      required String mediaProgress,
      Value<int> rowid,
    });
typedef $$StoredSyncsTableUpdateCompanionBuilder =
    StoredSyncsCompanion Function({
      Value<String> sessionId,
      Value<String> itemId,
      Value<String> userId,
      Value<String?> episodeId,
      Value<double> currentTime,
      Value<double> timeListened,
      Value<double> duration,
      Value<bool> sessionLocal,
      Value<DateTime> lastUpdated,
      Value<String> mediaProgress,
      Value<int> rowid,
    });

class $$StoredSyncsTableFilterComposer extends Composer<_$AppDatabase, $StoredSyncsTable> {
  $$StoredSyncsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentTime =>
      $composableBuilder(column: $table.currentTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get timeListened =>
      $composableBuilder(column: $table.timeListened, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get sessionLocal =>
      $composableBuilder(column: $table.sessionLocal, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated =>
      $composableBuilder(column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaProgress =>
      $composableBuilder(column: $table.mediaProgress, builder: (column) => ColumnFilters(column));
}

class $$StoredSyncsTableOrderingComposer extends Composer<_$AppDatabase, $StoredSyncsTable> {
  $$StoredSyncsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentTime =>
      $composableBuilder(column: $table.currentTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get timeListened =>
      $composableBuilder(column: $table.timeListened, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get sessionLocal =>
      $composableBuilder(column: $table.sessionLocal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated =>
      $composableBuilder(column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaProgress =>
      $composableBuilder(column: $table.mediaProgress, builder: (column) => ColumnOrderings(column));
}

class $$StoredSyncsTableAnnotationComposer extends Composer<_$AppDatabase, $StoredSyncsTable> {
  $$StoredSyncsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId => $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get episodeId => $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<double> get currentTime =>
      $composableBuilder(column: $table.currentTime, builder: (column) => column);

  GeneratedColumn<double> get timeListened =>
      $composableBuilder(column: $table.timeListened, builder: (column) => column);

  GeneratedColumn<double> get duration => $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get sessionLocal =>
      $composableBuilder(column: $table.sessionLocal, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated =>
      $composableBuilder(column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<String> get mediaProgress =>
      $composableBuilder(column: $table.mediaProgress, builder: (column) => column);
}

class $$StoredSyncsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredSyncsTable,
          StoredSyncEntry,
          $$StoredSyncsTableFilterComposer,
          $$StoredSyncsTableOrderingComposer,
          $$StoredSyncsTableAnnotationComposer,
          $$StoredSyncsTableCreateCompanionBuilder,
          $$StoredSyncsTableUpdateCompanionBuilder,
          (StoredSyncEntry, BaseReferences<_$AppDatabase, $StoredSyncsTable, StoredSyncEntry>),
          StoredSyncEntry,
          PrefetchHooks Function()
        > {
  $$StoredSyncsTableTableManager(_$AppDatabase db, $StoredSyncsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StoredSyncsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StoredSyncsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StoredSyncsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> sessionId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                Value<double> currentTime = const Value.absent(),
                Value<double> timeListened = const Value.absent(),
                Value<double> duration = const Value.absent(),
                Value<bool> sessionLocal = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<String> mediaProgress = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredSyncsCompanion(
                sessionId: sessionId,
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                currentTime: currentTime,
                timeListened: timeListened,
                duration: duration,
                sessionLocal: sessionLocal,
                lastUpdated: lastUpdated,
                mediaProgress: mediaProgress,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String sessionId,
                required String itemId,
                required String userId,
                Value<String?> episodeId = const Value.absent(),
                required double currentTime,
                required double timeListened,
                required double duration,
                required bool sessionLocal,
                required DateTime lastUpdated,
                required String mediaProgress,
                Value<int> rowid = const Value.absent(),
              }) => StoredSyncsCompanion.insert(
                sessionId: sessionId,
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                currentTime: currentTime,
                timeListened: timeListened,
                duration: duration,
                sessionLocal: sessionLocal,
                lastUpdated: lastUpdated,
                mediaProgress: mediaProgress,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredSyncsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredSyncsTable,
      StoredSyncEntry,
      $$StoredSyncsTableFilterComposer,
      $$StoredSyncsTableOrderingComposer,
      $$StoredSyncsTableAnnotationComposer,
      $$StoredSyncsTableCreateCompanionBuilder,
      $$StoredSyncsTableUpdateCompanionBuilder,
      (StoredSyncEntry, BaseReferences<_$AppDatabase, $StoredSyncsTable, StoredSyncEntry>),
      StoredSyncEntry,
      PrefetchHooks Function()
    >;
typedef $$StoredMediaProgressTableCreateCompanionBuilder =
    StoredMediaProgressCompanion Function({
      required String progressId,
      required String userId,
      required String itemId,
      Value<String?> episodeId,
      required DateTime lastUpdated,
      required String mediaProgress,
      Value<int> rowid,
    });
typedef $$StoredMediaProgressTableUpdateCompanionBuilder =
    StoredMediaProgressCompanion Function({
      Value<String> progressId,
      Value<String> userId,
      Value<String> itemId,
      Value<String?> episodeId,
      Value<DateTime> lastUpdated,
      Value<String> mediaProgress,
      Value<int> rowid,
    });

class $$StoredMediaProgressTableFilterComposer extends Composer<_$AppDatabase, $StoredMediaProgressTable> {
  $$StoredMediaProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get progressId =>
      $composableBuilder(column: $table.progressId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastUpdated =>
      $composableBuilder(column: $table.lastUpdated, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mediaProgress =>
      $composableBuilder(column: $table.mediaProgress, builder: (column) => ColumnFilters(column));
}

class $$StoredMediaProgressTableOrderingComposer extends Composer<_$AppDatabase, $StoredMediaProgressTable> {
  $$StoredMediaProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get progressId =>
      $composableBuilder(column: $table.progressId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastUpdated =>
      $composableBuilder(column: $table.lastUpdated, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mediaProgress =>
      $composableBuilder(column: $table.mediaProgress, builder: (column) => ColumnOrderings(column));
}

class $$StoredMediaProgressTableAnnotationComposer extends Composer<_$AppDatabase, $StoredMediaProgressTable> {
  $$StoredMediaProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get progressId => $composableBuilder(column: $table.progressId, builder: (column) => column);

  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get episodeId => $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated =>
      $composableBuilder(column: $table.lastUpdated, builder: (column) => column);

  GeneratedColumn<String> get mediaProgress =>
      $composableBuilder(column: $table.mediaProgress, builder: (column) => column);
}

class $$StoredMediaProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredMediaProgressTable,
          StoredMediaProgressEntry,
          $$StoredMediaProgressTableFilterComposer,
          $$StoredMediaProgressTableOrderingComposer,
          $$StoredMediaProgressTableAnnotationComposer,
          $$StoredMediaProgressTableCreateCompanionBuilder,
          $$StoredMediaProgressTableUpdateCompanionBuilder,
          (
            StoredMediaProgressEntry,
            BaseReferences<_$AppDatabase, $StoredMediaProgressTable, StoredMediaProgressEntry>,
          ),
          StoredMediaProgressEntry,
          PrefetchHooks Function()
        > {
  $$StoredMediaProgressTableTableManager(_$AppDatabase db, $StoredMediaProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StoredMediaProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StoredMediaProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StoredMediaProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> progressId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                Value<DateTime> lastUpdated = const Value.absent(),
                Value<String> mediaProgress = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredMediaProgressCompanion(
                progressId: progressId,
                userId: userId,
                itemId: itemId,
                episodeId: episodeId,
                lastUpdated: lastUpdated,
                mediaProgress: mediaProgress,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String progressId,
                required String userId,
                required String itemId,
                Value<String?> episodeId = const Value.absent(),
                required DateTime lastUpdated,
                required String mediaProgress,
                Value<int> rowid = const Value.absent(),
              }) => StoredMediaProgressCompanion.insert(
                progressId: progressId,
                userId: userId,
                itemId: itemId,
                episodeId: episodeId,
                lastUpdated: lastUpdated,
                mediaProgress: mediaProgress,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredMediaProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredMediaProgressTable,
      StoredMediaProgressEntry,
      $$StoredMediaProgressTableFilterComposer,
      $$StoredMediaProgressTableOrderingComposer,
      $$StoredMediaProgressTableAnnotationComposer,
      $$StoredMediaProgressTableCreateCompanionBuilder,
      $$StoredMediaProgressTableUpdateCompanionBuilder,
      (StoredMediaProgressEntry, BaseReferences<_$AppDatabase, $StoredMediaProgressTable, StoredMediaProgressEntry>),
      StoredMediaProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$StoredBookmarkSyncsTableCreateCompanionBuilder =
    StoredBookmarkSyncsCompanion Function({
      required String userId,
      required String itemId,
      required int time,
      Value<String?> title,
      Value<bool> deleted,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$StoredBookmarkSyncsTableUpdateCompanionBuilder =
    StoredBookmarkSyncsCompanion Function({
      Value<String> userId,
      Value<String> itemId,
      Value<int> time,
      Value<String?> title,
      Value<bool> deleted,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$StoredBookmarkSyncsTableFilterComposer extends Composer<_$AppDatabase, $StoredBookmarkSyncsTable> {
  $$StoredBookmarkSyncsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get time => $composableBuilder(column: $table.time, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$StoredBookmarkSyncsTableOrderingComposer extends Composer<_$AppDatabase, $StoredBookmarkSyncsTable> {
  $$StoredBookmarkSyncsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get time =>
      $composableBuilder(column: $table.time, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$StoredBookmarkSyncsTableAnnotationComposer extends Composer<_$AppDatabase, $StoredBookmarkSyncsTable> {
  $$StoredBookmarkSyncsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get time => $composableBuilder(column: $table.time, builder: (column) => column);

  GeneratedColumn<String> get title => $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get deleted => $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StoredBookmarkSyncsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredBookmarkSyncsTable,
          StoredBookmarkSyncEntry,
          $$StoredBookmarkSyncsTableFilterComposer,
          $$StoredBookmarkSyncsTableOrderingComposer,
          $$StoredBookmarkSyncsTableAnnotationComposer,
          $$StoredBookmarkSyncsTableCreateCompanionBuilder,
          $$StoredBookmarkSyncsTableUpdateCompanionBuilder,
          (StoredBookmarkSyncEntry, BaseReferences<_$AppDatabase, $StoredBookmarkSyncsTable, StoredBookmarkSyncEntry>),
          StoredBookmarkSyncEntry,
          PrefetchHooks Function()
        > {
  $$StoredBookmarkSyncsTableTableManager(_$AppDatabase db, $StoredBookmarkSyncsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StoredBookmarkSyncsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StoredBookmarkSyncsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StoredBookmarkSyncsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<int> time = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredBookmarkSyncsCompanion(
                userId: userId,
                itemId: itemId,
                time: time,
                title: title,
                deleted: deleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String itemId,
                required int time,
                Value<String?> title = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StoredBookmarkSyncsCompanion.insert(
                userId: userId,
                itemId: itemId,
                time: time,
                title: title,
                deleted: deleted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredBookmarkSyncsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredBookmarkSyncsTable,
      StoredBookmarkSyncEntry,
      $$StoredBookmarkSyncsTableFilterComposer,
      $$StoredBookmarkSyncsTableOrderingComposer,
      $$StoredBookmarkSyncsTableAnnotationComposer,
      $$StoredBookmarkSyncsTableCreateCompanionBuilder,
      $$StoredBookmarkSyncsTableUpdateCompanionBuilder,
      (StoredBookmarkSyncEntry, BaseReferences<_$AppDatabase, $StoredBookmarkSyncsTable, StoredBookmarkSyncEntry>),
      StoredBookmarkSyncEntry,
      PrefetchHooks Function()
    >;
typedef $$StoredDownloadsTableCreateCompanionBuilder =
    StoredDownloadsCompanion Function({
      required String itemId,
      required String userId,
      Value<String?> episodeId,
      required String download,
      Value<int> rowid,
    });
typedef $$StoredDownloadsTableUpdateCompanionBuilder =
    StoredDownloadsCompanion Function({
      Value<String> itemId,
      Value<String> userId,
      Value<String?> episodeId,
      Value<String> download,
      Value<int> rowid,
    });

class $$StoredDownloadsTableFilterComposer extends Composer<_$AppDatabase, $StoredDownloadsTable> {
  $$StoredDownloadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get download =>
      $composableBuilder(column: $table.download, builder: (column) => ColumnFilters(column));
}

class $$StoredDownloadsTableOrderingComposer extends Composer<_$AppDatabase, $StoredDownloadsTable> {
  $$StoredDownloadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get download =>
      $composableBuilder(column: $table.download, builder: (column) => ColumnOrderings(column));
}

class $$StoredDownloadsTableAnnotationComposer extends Composer<_$AppDatabase, $StoredDownloadsTable> {
  $$StoredDownloadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get episodeId => $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<String> get download => $composableBuilder(column: $table.download, builder: (column) => column);
}

class $$StoredDownloadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredDownloadsTable,
          StoredDownloadsEntry,
          $$StoredDownloadsTableFilterComposer,
          $$StoredDownloadsTableOrderingComposer,
          $$StoredDownloadsTableAnnotationComposer,
          $$StoredDownloadsTableCreateCompanionBuilder,
          $$StoredDownloadsTableUpdateCompanionBuilder,
          (StoredDownloadsEntry, BaseReferences<_$AppDatabase, $StoredDownloadsTable, StoredDownloadsEntry>),
          StoredDownloadsEntry,
          PrefetchHooks Function()
        > {
  $$StoredDownloadsTableTableManager(_$AppDatabase db, $StoredDownloadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StoredDownloadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StoredDownloadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StoredDownloadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                Value<String> download = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredDownloadsCompanion(
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                download: download,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String userId,
                Value<String?> episodeId = const Value.absent(),
                required String download,
                Value<int> rowid = const Value.absent(),
              }) => StoredDownloadsCompanion.insert(
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                download: download,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredDownloadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredDownloadsTable,
      StoredDownloadsEntry,
      $$StoredDownloadsTableFilterComposer,
      $$StoredDownloadsTableOrderingComposer,
      $$StoredDownloadsTableAnnotationComposer,
      $$StoredDownloadsTableCreateCompanionBuilder,
      $$StoredDownloadsTableUpdateCompanionBuilder,
      (StoredDownloadsEntry, BaseReferences<_$AppDatabase, $StoredDownloadsTable, StoredDownloadsEntry>),
      StoredDownloadsEntry,
      PrefetchHooks Function()
    >;
typedef $$PlayerHistoryTableCreateCompanionBuilder =
    PlayerHistoryCompanion Function({
      Value<int> id,
      required String itemId,
      required String userId,
      Value<String?> episodeId,
      required String type,
      required double currentTime,
      Value<DateTime> created,
    });
typedef $$PlayerHistoryTableUpdateCompanionBuilder =
    PlayerHistoryCompanion Function({
      Value<int> id,
      Value<String> itemId,
      Value<String> userId,
      Value<String?> episodeId,
      Value<String> type,
      Value<double> currentTime,
      Value<DateTime> created,
    });

class $$PlayerHistoryTableFilterComposer extends Composer<_$AppDatabase, $PlayerHistoryTable> {
  $$PlayerHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get currentTime =>
      $composableBuilder(column: $table.currentTime, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => ColumnFilters(column));
}

class $$PlayerHistoryTableOrderingComposer extends Composer<_$AppDatabase, $PlayerHistoryTable> {
  $$PlayerHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get currentTime =>
      $composableBuilder(column: $table.currentTime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get created =>
      $composableBuilder(column: $table.created, builder: (column) => ColumnOrderings(column));
}

class $$PlayerHistoryTableAnnotationComposer extends Composer<_$AppDatabase, $PlayerHistoryTable> {
  $$PlayerHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get episodeId => $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<String> get type => $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get currentTime =>
      $composableBuilder(column: $table.currentTime, builder: (column) => column);

  GeneratedColumn<DateTime> get created => $composableBuilder(column: $table.created, builder: (column) => column);
}

class $$PlayerHistoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlayerHistoryTable,
          PlayerHistoryEntry,
          $$PlayerHistoryTableFilterComposer,
          $$PlayerHistoryTableOrderingComposer,
          $$PlayerHistoryTableAnnotationComposer,
          $$PlayerHistoryTableCreateCompanionBuilder,
          $$PlayerHistoryTableUpdateCompanionBuilder,
          (PlayerHistoryEntry, BaseReferences<_$AppDatabase, $PlayerHistoryTable, PlayerHistoryEntry>),
          PlayerHistoryEntry,
          PrefetchHooks Function()
        > {
  $$PlayerHistoryTableTableManager(_$AppDatabase db, $PlayerHistoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PlayerHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PlayerHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PlayerHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> currentTime = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
              }) => PlayerHistoryCompanion(
                id: id,
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                type: type,
                currentTime: currentTime,
                created: created,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String itemId,
                required String userId,
                Value<String?> episodeId = const Value.absent(),
                required String type,
                required double currentTime,
                Value<DateTime> created = const Value.absent(),
              }) => PlayerHistoryCompanion.insert(
                id: id,
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                type: type,
                currentTime: currentTime,
                created: created,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PlayerHistoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlayerHistoryTable,
      PlayerHistoryEntry,
      $$PlayerHistoryTableFilterComposer,
      $$PlayerHistoryTableOrderingComposer,
      $$PlayerHistoryTableAnnotationComposer,
      $$PlayerHistoryTableCreateCompanionBuilder,
      $$PlayerHistoryTableUpdateCompanionBuilder,
      (PlayerHistoryEntry, BaseReferences<_$AppDatabase, $PlayerHistoryTable, PlayerHistoryEntry>),
      PlayerHistoryEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GlobalSettingsTableTableManager get globalSettings => $$GlobalSettingsTableTableManager(_db, _db.globalSettings);
  $$UserSettingsTableTableManager get userSettings => $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$BookPlaybackSpeedsTableTableManager get bookPlaybackSpeeds =>
      $$BookPlaybackSpeedsTableTableManager(_db, _db.bookPlaybackSpeeds);
  $$StoredUsersTableTableManager get storedUsers => $$StoredUsersTableTableManager(_db, _db.storedUsers);
  $$StoredSyncsTableTableManager get storedSyncs => $$StoredSyncsTableTableManager(_db, _db.storedSyncs);
  $$StoredMediaProgressTableTableManager get storedMediaProgress =>
      $$StoredMediaProgressTableTableManager(_db, _db.storedMediaProgress);
  $$StoredBookmarkSyncsTableTableManager get storedBookmarkSyncs =>
      $$StoredBookmarkSyncsTableTableManager(_db, _db.storedBookmarkSyncs);
  $$StoredDownloadsTableTableManager get storedDownloads =>
      $$StoredDownloadsTableTableManager(_db, _db.storedDownloads);
  $$PlayerHistoryTableTableManager get playerHistory => $$PlayerHistoryTableTableManager(_db, _db.playerHistory);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appDatabase)
final appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider extends $FunctionalProvider<AppDatabase, AppDatabase, AppDatabase>
    with $Provider<AppDatabase> {
  AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<AppDatabase> $createElement($ProviderPointer pointer) => $ProviderElement(pointer);

  @override
  AppDatabase create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppDatabase value) {
    return $ProviderOverride(origin: this, providerOverride: $SyncValueProvider<AppDatabase>(value));
  }
}

String _$appDatabaseHash() => r'5d15367791f4e72539df881fa486de268755ed06';
