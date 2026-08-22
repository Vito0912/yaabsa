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
  static const VerificationMeta _downloadOriginMeta = const VerificationMeta('downloadOrigin');
  @override
  late final GeneratedColumn<String> downloadOrigin = GeneratedColumn<String>(
    'download_origin',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _smartProfileIdsMeta = const VerificationMeta('smartProfileIds');
  @override
  late final GeneratedColumn<String> smartProfileIds = GeneratedColumn<String>(
    'smart_profile_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _managedBytesMeta = const VerificationMeta('managedBytes');
  @override
  late final GeneratedColumn<int> managedBytes = GeneratedColumn<int>(
    'managed_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    itemId,
    userId,
    episodeId,
    download,
    downloadOrigin,
    smartProfileIds,
    managedBytes,
    completedAt,
  ];
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
    if (data.containsKey('download_origin')) {
      context.handle(
        _downloadOriginMeta,
        downloadOrigin.isAcceptableOrUnknown(data['download_origin']!, _downloadOriginMeta),
      );
    }
    if (data.containsKey('smart_profile_ids')) {
      context.handle(
        _smartProfileIdsMeta,
        smartProfileIds.isAcceptableOrUnknown(data['smart_profile_ids']!, _smartProfileIdsMeta),
      );
    }
    if (data.containsKey('managed_bytes')) {
      context.handle(_managedBytesMeta, managedBytes.isAcceptableOrUnknown(data['managed_bytes']!, _managedBytesMeta));
    }
    if (data.containsKey('completed_at')) {
      context.handle(_completedAtMeta, completedAt.isAcceptableOrUnknown(data['completed_at']!, _completedAtMeta));
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
      downloadOrigin: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}download_origin'],
      )!,
      smartProfileIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}smart_profile_ids'],
      )!,
      managedBytes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}managed_bytes']),
      completedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}completed_at']),
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
  final String downloadOrigin;
  final String smartProfileIds;
  final int? managedBytes;
  final int? completedAt;
  const StoredDownloadsEntry({
    required this.itemId,
    required this.userId,
    this.episodeId,
    required this.download,
    required this.downloadOrigin,
    required this.smartProfileIds,
    this.managedBytes,
    this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['download'] = Variable<String>(download);
    map['download_origin'] = Variable<String>(downloadOrigin);
    map['smart_profile_ids'] = Variable<String>(smartProfileIds);
    if (!nullToAbsent || managedBytes != null) {
      map['managed_bytes'] = Variable<int>(managedBytes);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    return map;
  }

  StoredDownloadsCompanion toCompanion(bool nullToAbsent) {
    return StoredDownloadsCompanion(
      itemId: Value(itemId),
      userId: Value(userId),
      episodeId: episodeId == null && nullToAbsent ? const Value.absent() : Value(episodeId),
      download: Value(download),
      downloadOrigin: Value(downloadOrigin),
      smartProfileIds: Value(smartProfileIds),
      managedBytes: managedBytes == null && nullToAbsent ? const Value.absent() : Value(managedBytes),
      completedAt: completedAt == null && nullToAbsent ? const Value.absent() : Value(completedAt),
    );
  }

  factory StoredDownloadsEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredDownloadsEntry(
      itemId: serializer.fromJson<String>(json['itemId']),
      userId: serializer.fromJson<String>(json['userId']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      download: serializer.fromJson<String>(json['download']),
      downloadOrigin: serializer.fromJson<String>(json['downloadOrigin']),
      smartProfileIds: serializer.fromJson<String>(json['smartProfileIds']),
      managedBytes: serializer.fromJson<int?>(json['managedBytes']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
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
      'downloadOrigin': serializer.toJson<String>(downloadOrigin),
      'smartProfileIds': serializer.toJson<String>(smartProfileIds),
      'managedBytes': serializer.toJson<int?>(managedBytes),
      'completedAt': serializer.toJson<int?>(completedAt),
    };
  }

  StoredDownloadsEntry copyWith({
    String? itemId,
    String? userId,
    Value<String?> episodeId = const Value.absent(),
    String? download,
    String? downloadOrigin,
    String? smartProfileIds,
    Value<int?> managedBytes = const Value.absent(),
    Value<int?> completedAt = const Value.absent(),
  }) => StoredDownloadsEntry(
    itemId: itemId ?? this.itemId,
    userId: userId ?? this.userId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    download: download ?? this.download,
    downloadOrigin: downloadOrigin ?? this.downloadOrigin,
    smartProfileIds: smartProfileIds ?? this.smartProfileIds,
    managedBytes: managedBytes.present ? managedBytes.value : this.managedBytes,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
  );
  StoredDownloadsEntry copyWithCompanion(StoredDownloadsCompanion data) {
    return StoredDownloadsEntry(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      userId: data.userId.present ? data.userId.value : this.userId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      download: data.download.present ? data.download.value : this.download,
      downloadOrigin: data.downloadOrigin.present ? data.downloadOrigin.value : this.downloadOrigin,
      smartProfileIds: data.smartProfileIds.present ? data.smartProfileIds.value : this.smartProfileIds,
      managedBytes: data.managedBytes.present ? data.managedBytes.value : this.managedBytes,
      completedAt: data.completedAt.present ? data.completedAt.value : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredDownloadsEntry(')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('download: $download, ')
          ..write('downloadOrigin: $downloadOrigin, ')
          ..write('smartProfileIds: $smartProfileIds, ')
          ..write('managedBytes: $managedBytes, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(itemId, userId, episodeId, download, downloadOrigin, smartProfileIds, managedBytes, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredDownloadsEntry &&
          other.itemId == this.itemId &&
          other.userId == this.userId &&
          other.episodeId == this.episodeId &&
          other.download == this.download &&
          other.downloadOrigin == this.downloadOrigin &&
          other.smartProfileIds == this.smartProfileIds &&
          other.managedBytes == this.managedBytes &&
          other.completedAt == this.completedAt);
}

class StoredDownloadsCompanion extends UpdateCompanion<StoredDownloadsEntry> {
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String?> episodeId;
  final Value<String> download;
  final Value<String> downloadOrigin;
  final Value<String> smartProfileIds;
  final Value<int?> managedBytes;
  final Value<int?> completedAt;
  final Value<int> rowid;
  const StoredDownloadsCompanion({
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.download = const Value.absent(),
    this.downloadOrigin = const Value.absent(),
    this.smartProfileIds = const Value.absent(),
    this.managedBytes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredDownloadsCompanion.insert({
    required String itemId,
    required String userId,
    this.episodeId = const Value.absent(),
    required String download,
    this.downloadOrigin = const Value.absent(),
    this.smartProfileIds = const Value.absent(),
    this.managedBytes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       userId = Value(userId),
       download = Value(download);
  static Insertable<StoredDownloadsEntry> custom({
    Expression<String>? itemId,
    Expression<String>? userId,
    Expression<String>? episodeId,
    Expression<String>? download,
    Expression<String>? downloadOrigin,
    Expression<String>? smartProfileIds,
    Expression<int>? managedBytes,
    Expression<int>? completedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (userId != null) 'user_id': userId,
      if (episodeId != null) 'episode_id': episodeId,
      if (download != null) 'download': download,
      if (downloadOrigin != null) 'download_origin': downloadOrigin,
      if (smartProfileIds != null) 'smart_profile_ids': smartProfileIds,
      if (managedBytes != null) 'managed_bytes': managedBytes,
      if (completedAt != null) 'completed_at': completedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredDownloadsCompanion copyWith({
    Value<String>? itemId,
    Value<String>? userId,
    Value<String?>? episodeId,
    Value<String>? download,
    Value<String>? downloadOrigin,
    Value<String>? smartProfileIds,
    Value<int?>? managedBytes,
    Value<int?>? completedAt,
    Value<int>? rowid,
  }) {
    return StoredDownloadsCompanion(
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      episodeId: episodeId ?? this.episodeId,
      download: download ?? this.download,
      downloadOrigin: downloadOrigin ?? this.downloadOrigin,
      smartProfileIds: smartProfileIds ?? this.smartProfileIds,
      managedBytes: managedBytes ?? this.managedBytes,
      completedAt: completedAt ?? this.completedAt,
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
    if (downloadOrigin.present) {
      map['download_origin'] = Variable<String>(downloadOrigin.value);
    }
    if (smartProfileIds.present) {
      map['smart_profile_ids'] = Variable<String>(smartProfileIds.value);
    }
    if (managedBytes.present) {
      map['managed_bytes'] = Variable<int>(managedBytes.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
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
          ..write('downloadOrigin: $downloadOrigin, ')
          ..write('smartProfileIds: $smartProfileIds, ')
          ..write('managedBytes: $managedBytes, ')
          ..write('completedAt: $completedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoredDownloadFilesTable extends StoredDownloadFiles
    with TableInfo<$StoredDownloadFilesTable, StoredDownloadFileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredDownloadFilesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _fileKeyMeta = const VerificationMeta('fileKey');
  @override
  late final GeneratedColumn<String> fileKey = GeneratedColumn<String>(
    'file_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _trackJsonMeta = const VerificationMeta('trackJson');
  @override
  late final GeneratedColumn<String> trackJson = GeneratedColumn<String>(
    'track_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _auxiliaryPathMeta = const VerificationMeta('auxiliaryPath');
  @override
  late final GeneratedColumn<String> auxiliaryPath = GeneratedColumn<String>(
    'auxiliary_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sidecarPathMeta = const VerificationMeta('sidecarPath');
  @override
  late final GeneratedColumn<String> sidecarPath = GeneratedColumn<String>(
    'sidecar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [itemId, userId, episodeId, fileKey, trackJson, auxiliaryPath, sidecarPath];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stored_download_files';
  @override
  VerificationContext validateIntegrity(Insertable<StoredDownloadFileEntry> instance, {bool isInserting = false}) {
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
    if (data.containsKey('file_key')) {
      context.handle(_fileKeyMeta, fileKey.isAcceptableOrUnknown(data['file_key']!, _fileKeyMeta));
    } else if (isInserting) {
      context.missing(_fileKeyMeta);
    }
    if (data.containsKey('track_json')) {
      context.handle(_trackJsonMeta, trackJson.isAcceptableOrUnknown(data['track_json']!, _trackJsonMeta));
    }
    if (data.containsKey('auxiliary_path')) {
      context.handle(
        _auxiliaryPathMeta,
        auxiliaryPath.isAcceptableOrUnknown(data['auxiliary_path']!, _auxiliaryPathMeta),
      );
    }
    if (data.containsKey('sidecar_path')) {
      context.handle(_sidecarPathMeta, sidecarPath.isAcceptableOrUnknown(data['sidecar_path']!, _sidecarPathMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {itemId, userId, episodeId, fileKey};
  @override
  StoredDownloadFileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoredDownloadFileEntry(
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      episodeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}episode_id']),
      fileKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}file_key'])!,
      trackJson: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}track_json']),
      auxiliaryPath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}auxiliary_path']),
      sidecarPath: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}sidecar_path']),
    );
  }

  @override
  $StoredDownloadFilesTable createAlias(String alias) {
    return $StoredDownloadFilesTable(attachedDatabase, alias);
  }
}

class StoredDownloadFileEntry extends DataClass implements Insertable<StoredDownloadFileEntry> {
  final String itemId;
  final String userId;
  final String? episodeId;
  final String fileKey;
  final String? trackJson;
  final String? auxiliaryPath;
  final String? sidecarPath;
  const StoredDownloadFileEntry({
    required this.itemId,
    required this.userId,
    this.episodeId,
    required this.fileKey,
    this.trackJson,
    this.auxiliaryPath,
    this.sidecarPath,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['item_id'] = Variable<String>(itemId);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['file_key'] = Variable<String>(fileKey);
    if (!nullToAbsent || trackJson != null) {
      map['track_json'] = Variable<String>(trackJson);
    }
    if (!nullToAbsent || auxiliaryPath != null) {
      map['auxiliary_path'] = Variable<String>(auxiliaryPath);
    }
    if (!nullToAbsent || sidecarPath != null) {
      map['sidecar_path'] = Variable<String>(sidecarPath);
    }
    return map;
  }

  StoredDownloadFilesCompanion toCompanion(bool nullToAbsent) {
    return StoredDownloadFilesCompanion(
      itemId: Value(itemId),
      userId: Value(userId),
      episodeId: episodeId == null && nullToAbsent ? const Value.absent() : Value(episodeId),
      fileKey: Value(fileKey),
      trackJson: trackJson == null && nullToAbsent ? const Value.absent() : Value(trackJson),
      auxiliaryPath: auxiliaryPath == null && nullToAbsent ? const Value.absent() : Value(auxiliaryPath),
      sidecarPath: sidecarPath == null && nullToAbsent ? const Value.absent() : Value(sidecarPath),
    );
  }

  factory StoredDownloadFileEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoredDownloadFileEntry(
      itemId: serializer.fromJson<String>(json['itemId']),
      userId: serializer.fromJson<String>(json['userId']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      fileKey: serializer.fromJson<String>(json['fileKey']),
      trackJson: serializer.fromJson<String?>(json['trackJson']),
      auxiliaryPath: serializer.fromJson<String?>(json['auxiliaryPath']),
      sidecarPath: serializer.fromJson<String?>(json['sidecarPath']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'itemId': serializer.toJson<String>(itemId),
      'userId': serializer.toJson<String>(userId),
      'episodeId': serializer.toJson<String?>(episodeId),
      'fileKey': serializer.toJson<String>(fileKey),
      'trackJson': serializer.toJson<String?>(trackJson),
      'auxiliaryPath': serializer.toJson<String?>(auxiliaryPath),
      'sidecarPath': serializer.toJson<String?>(sidecarPath),
    };
  }

  StoredDownloadFileEntry copyWith({
    String? itemId,
    String? userId,
    Value<String?> episodeId = const Value.absent(),
    String? fileKey,
    Value<String?> trackJson = const Value.absent(),
    Value<String?> auxiliaryPath = const Value.absent(),
    Value<String?> sidecarPath = const Value.absent(),
  }) => StoredDownloadFileEntry(
    itemId: itemId ?? this.itemId,
    userId: userId ?? this.userId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    fileKey: fileKey ?? this.fileKey,
    trackJson: trackJson.present ? trackJson.value : this.trackJson,
    auxiliaryPath: auxiliaryPath.present ? auxiliaryPath.value : this.auxiliaryPath,
    sidecarPath: sidecarPath.present ? sidecarPath.value : this.sidecarPath,
  );
  StoredDownloadFileEntry copyWithCompanion(StoredDownloadFilesCompanion data) {
    return StoredDownloadFileEntry(
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      userId: data.userId.present ? data.userId.value : this.userId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      fileKey: data.fileKey.present ? data.fileKey.value : this.fileKey,
      trackJson: data.trackJson.present ? data.trackJson.value : this.trackJson,
      auxiliaryPath: data.auxiliaryPath.present ? data.auxiliaryPath.value : this.auxiliaryPath,
      sidecarPath: data.sidecarPath.present ? data.sidecarPath.value : this.sidecarPath,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoredDownloadFileEntry(')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('auxiliaryPath: $auxiliaryPath, ')
          ..write('sidecarPath: $sidecarPath')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(itemId, userId, episodeId, fileKey, trackJson, auxiliaryPath, sidecarPath);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoredDownloadFileEntry &&
          other.itemId == this.itemId &&
          other.userId == this.userId &&
          other.episodeId == this.episodeId &&
          other.fileKey == this.fileKey &&
          other.trackJson == this.trackJson &&
          other.auxiliaryPath == this.auxiliaryPath &&
          other.sidecarPath == this.sidecarPath);
}

class StoredDownloadFilesCompanion extends UpdateCompanion<StoredDownloadFileEntry> {
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String?> episodeId;
  final Value<String> fileKey;
  final Value<String?> trackJson;
  final Value<String?> auxiliaryPath;
  final Value<String?> sidecarPath;
  final Value<int> rowid;
  const StoredDownloadFilesCompanion({
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.fileKey = const Value.absent(),
    this.trackJson = const Value.absent(),
    this.auxiliaryPath = const Value.absent(),
    this.sidecarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoredDownloadFilesCompanion.insert({
    required String itemId,
    required String userId,
    this.episodeId = const Value.absent(),
    required String fileKey,
    this.trackJson = const Value.absent(),
    this.auxiliaryPath = const Value.absent(),
    this.sidecarPath = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : itemId = Value(itemId),
       userId = Value(userId),
       fileKey = Value(fileKey);
  static Insertable<StoredDownloadFileEntry> custom({
    Expression<String>? itemId,
    Expression<String>? userId,
    Expression<String>? episodeId,
    Expression<String>? fileKey,
    Expression<String>? trackJson,
    Expression<String>? auxiliaryPath,
    Expression<String>? sidecarPath,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (itemId != null) 'item_id': itemId,
      if (userId != null) 'user_id': userId,
      if (episodeId != null) 'episode_id': episodeId,
      if (fileKey != null) 'file_key': fileKey,
      if (trackJson != null) 'track_json': trackJson,
      if (auxiliaryPath != null) 'auxiliary_path': auxiliaryPath,
      if (sidecarPath != null) 'sidecar_path': sidecarPath,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoredDownloadFilesCompanion copyWith({
    Value<String>? itemId,
    Value<String>? userId,
    Value<String?>? episodeId,
    Value<String>? fileKey,
    Value<String?>? trackJson,
    Value<String?>? auxiliaryPath,
    Value<String?>? sidecarPath,
    Value<int>? rowid,
  }) {
    return StoredDownloadFilesCompanion(
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      episodeId: episodeId ?? this.episodeId,
      fileKey: fileKey ?? this.fileKey,
      trackJson: trackJson ?? this.trackJson,
      auxiliaryPath: auxiliaryPath ?? this.auxiliaryPath,
      sidecarPath: sidecarPath ?? this.sidecarPath,
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
    if (fileKey.present) {
      map['file_key'] = Variable<String>(fileKey.value);
    }
    if (trackJson.present) {
      map['track_json'] = Variable<String>(trackJson.value);
    }
    if (auxiliaryPath.present) {
      map['auxiliary_path'] = Variable<String>(auxiliaryPath.value);
    }
    if (sidecarPath.present) {
      map['sidecar_path'] = Variable<String>(sidecarPath.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoredDownloadFilesCompanion(')
          ..write('itemId: $itemId, ')
          ..write('userId: $userId, ')
          ..write('episodeId: $episodeId, ')
          ..write('fileKey: $fileKey, ')
          ..write('trackJson: $trackJson, ')
          ..write('auxiliaryPath: $auxiliaryPath, ')
          ..write('sidecarPath: $sidecarPath, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmartDownloadProfilesTable extends SmartDownloadProfiles
    with TableInfo<$SmartDownloadProfilesTable, SmartDownloadProfileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmartDownloadProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
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
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _policyMeta = const VerificationMeta('policy');
  @override
  late final GeneratedColumn<String> policy = GeneratedColumn<String>(
    'policy',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta('enabled');
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("enabled" IN (0, 1))'),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, userId, name, policy, enabled, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smart_download_profiles';
  @override
  VerificationContext validateIntegrity(Insertable<SmartDownloadProfileEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(_userIdMeta, userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta));
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(_nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('policy')) {
      context.handle(_policyMeta, policy.isAcceptableOrUnknown(data['policy']!, _policyMeta));
    } else if (isInserting) {
      context.missing(_policyMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(_enabledMeta, enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id, userId};
  @override
  SmartDownloadProfileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmartDownloadProfileEntry(
      id: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      userId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}user_id'])!,
      name: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      policy: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}policy'])!,
      enabled: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}enabled'])!,
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SmartDownloadProfilesTable createAlias(String alias) {
    return $SmartDownloadProfilesTable(attachedDatabase, alias);
  }
}

class SmartDownloadProfileEntry extends DataClass implements Insertable<SmartDownloadProfileEntry> {
  final String id;
  final String userId;
  final String name;
  final String policy;
  final bool enabled;
  final int updatedAt;
  const SmartDownloadProfileEntry({
    required this.id,
    required this.userId,
    required this.name,
    required this.policy,
    required this.enabled,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['name'] = Variable<String>(name);
    map['policy'] = Variable<String>(policy);
    map['enabled'] = Variable<bool>(enabled);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SmartDownloadProfilesCompanion toCompanion(bool nullToAbsent) {
    return SmartDownloadProfilesCompanion(
      id: Value(id),
      userId: Value(userId),
      name: Value(name),
      policy: Value(policy),
      enabled: Value(enabled),
      updatedAt: Value(updatedAt),
    );
  }

  factory SmartDownloadProfileEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmartDownloadProfileEntry(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      name: serializer.fromJson<String>(json['name']),
      policy: serializer.fromJson<String>(json['policy']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'name': serializer.toJson<String>(name),
      'policy': serializer.toJson<String>(policy),
      'enabled': serializer.toJson<bool>(enabled),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SmartDownloadProfileEntry copyWith({
    String? id,
    String? userId,
    String? name,
    String? policy,
    bool? enabled,
    int? updatedAt,
  }) => SmartDownloadProfileEntry(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    name: name ?? this.name,
    policy: policy ?? this.policy,
    enabled: enabled ?? this.enabled,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SmartDownloadProfileEntry copyWithCompanion(SmartDownloadProfilesCompanion data) {
    return SmartDownloadProfileEntry(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      name: data.name.present ? data.name.value : this.name,
      policy: data.policy.present ? data.policy.value : this.policy,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmartDownloadProfileEntry(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('policy: $policy, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, name, policy, enabled, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmartDownloadProfileEntry &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.name == this.name &&
          other.policy == this.policy &&
          other.enabled == this.enabled &&
          other.updatedAt == this.updatedAt);
}

class SmartDownloadProfilesCompanion extends UpdateCompanion<SmartDownloadProfileEntry> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> name;
  final Value<String> policy;
  final Value<bool> enabled;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SmartDownloadProfilesCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.name = const Value.absent(),
    this.policy = const Value.absent(),
    this.enabled = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmartDownloadProfilesCompanion.insert({
    required String id,
    required String userId,
    required String name,
    required String policy,
    this.enabled = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       name = Value(name),
       policy = Value(policy),
       updatedAt = Value(updatedAt);
  static Insertable<SmartDownloadProfileEntry> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? name,
    Expression<String>? policy,
    Expression<bool>? enabled,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (name != null) 'name': name,
      if (policy != null) 'policy': policy,
      if (enabled != null) 'enabled': enabled,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmartDownloadProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? name,
    Value<String>? policy,
    Value<bool>? enabled,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SmartDownloadProfilesCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      policy: policy ?? this.policy,
      enabled: enabled ?? this.enabled,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (policy.present) {
      map['policy'] = Variable<String>(policy.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmartDownloadProfilesCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('name: $name, ')
          ..write('policy: $policy, ')
          ..write('enabled: $enabled, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmartDownloadSourcesTable extends SmartDownloadSources
    with TableInfo<$SmartDownloadSourcesTable, SmartDownloadSourceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmartDownloadSourcesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryIdMeta = const VerificationMeta('libraryId');
  @override
  late final GeneratedColumn<String> libraryId = GeneratedColumn<String>(
    'library_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta('displayName');
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descendingMeta = const VerificationMeta('descending');
  @override
  late final GeneratedColumn<bool> descending = GeneratedColumn<bool>(
    'descending',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways('CHECK ("descending" IN (0, 1))'),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceRevisionMeta = const VerificationMeta('sourceRevision');
  @override
  late final GeneratedColumn<int> sourceRevision = GeneratedColumn<int>(
    'source_revision',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _candidateSnapshotMeta = const VerificationMeta('candidateSnapshot');
  @override
  late final GeneratedColumn<String> candidateSnapshot = GeneratedColumn<String>(
    'candidate_snapshot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    sourceType,
    sourceId,
    libraryId,
    displayName,
    descending,
    sourceRevision,
    candidateSnapshot,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smart_download_sources';
  @override
  VerificationContext validateIntegrity(Insertable<SmartDownloadSourceEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta, profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('source_type')) {
      context.handle(_sourceTypeMeta, sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta, sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('library_id')) {
      context.handle(_libraryIdMeta, libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta));
    } else if (isInserting) {
      context.missing(_libraryIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(_displayNameMeta, displayName.isAcceptableOrUnknown(data['display_name']!, _displayNameMeta));
    }
    if (data.containsKey('descending')) {
      context.handle(_descendingMeta, descending.isAcceptableOrUnknown(data['descending']!, _descendingMeta));
    }
    if (data.containsKey('source_revision')) {
      context.handle(
        _sourceRevisionMeta,
        sourceRevision.isAcceptableOrUnknown(data['source_revision']!, _sourceRevisionMeta),
      );
    }
    if (data.containsKey('candidate_snapshot')) {
      context.handle(
        _candidateSnapshotMeta,
        candidateSnapshot.isAcceptableOrUnknown(data['candidate_snapshot']!, _candidateSnapshotMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, sourceType, sourceId};
  @override
  SmartDownloadSourceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmartDownloadSourceEntry(
      profileId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      sourceType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      sourceId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      libraryId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}library_id'])!,
      displayName: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}display_name']),
      descending: attachedDatabase.typeMapping.read(DriftSqlType.bool, data['${effectivePrefix}descending'])!,
      sourceRevision: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}source_revision']),
      candidateSnapshot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}candidate_snapshot'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SmartDownloadSourcesTable createAlias(String alias) {
    return $SmartDownloadSourcesTable(attachedDatabase, alias);
  }
}

class SmartDownloadSourceEntry extends DataClass implements Insertable<SmartDownloadSourceEntry> {
  final String profileId;
  final String sourceType;
  final String sourceId;
  final String libraryId;
  final String? displayName;
  final bool descending;
  final int? sourceRevision;
  final String? candidateSnapshot;
  final int updatedAt;
  const SmartDownloadSourceEntry({
    required this.profileId,
    required this.sourceType,
    required this.sourceId,
    required this.libraryId,
    this.displayName,
    required this.descending,
    this.sourceRevision,
    this.candidateSnapshot,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    map['library_id'] = Variable<String>(libraryId);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['descending'] = Variable<bool>(descending);
    if (!nullToAbsent || sourceRevision != null) {
      map['source_revision'] = Variable<int>(sourceRevision);
    }
    if (!nullToAbsent || candidateSnapshot != null) {
      map['candidate_snapshot'] = Variable<String>(candidateSnapshot);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SmartDownloadSourcesCompanion toCompanion(bool nullToAbsent) {
    return SmartDownloadSourcesCompanion(
      profileId: Value(profileId),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      libraryId: Value(libraryId),
      displayName: displayName == null && nullToAbsent ? const Value.absent() : Value(displayName),
      descending: Value(descending),
      sourceRevision: sourceRevision == null && nullToAbsent ? const Value.absent() : Value(sourceRevision),
      candidateSnapshot: candidateSnapshot == null && nullToAbsent ? const Value.absent() : Value(candidateSnapshot),
      updatedAt: Value(updatedAt),
    );
  }

  factory SmartDownloadSourceEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmartDownloadSourceEntry(
      profileId: serializer.fromJson<String>(json['profileId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      libraryId: serializer.fromJson<String>(json['libraryId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      descending: serializer.fromJson<bool>(json['descending']),
      sourceRevision: serializer.fromJson<int?>(json['sourceRevision']),
      candidateSnapshot: serializer.fromJson<String?>(json['candidateSnapshot']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'libraryId': serializer.toJson<String>(libraryId),
      'displayName': serializer.toJson<String?>(displayName),
      'descending': serializer.toJson<bool>(descending),
      'sourceRevision': serializer.toJson<int?>(sourceRevision),
      'candidateSnapshot': serializer.toJson<String?>(candidateSnapshot),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SmartDownloadSourceEntry copyWith({
    String? profileId,
    String? sourceType,
    String? sourceId,
    String? libraryId,
    Value<String?> displayName = const Value.absent(),
    bool? descending,
    Value<int?> sourceRevision = const Value.absent(),
    Value<String?> candidateSnapshot = const Value.absent(),
    int? updatedAt,
  }) => SmartDownloadSourceEntry(
    profileId: profileId ?? this.profileId,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    libraryId: libraryId ?? this.libraryId,
    displayName: displayName.present ? displayName.value : this.displayName,
    descending: descending ?? this.descending,
    sourceRevision: sourceRevision.present ? sourceRevision.value : this.sourceRevision,
    candidateSnapshot: candidateSnapshot.present ? candidateSnapshot.value : this.candidateSnapshot,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SmartDownloadSourceEntry copyWithCompanion(SmartDownloadSourcesCompanion data) {
    return SmartDownloadSourceEntry(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      sourceType: data.sourceType.present ? data.sourceType.value : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      displayName: data.displayName.present ? data.displayName.value : this.displayName,
      descending: data.descending.present ? data.descending.value : this.descending,
      sourceRevision: data.sourceRevision.present ? data.sourceRevision.value : this.sourceRevision,
      candidateSnapshot: data.candidateSnapshot.present ? data.candidateSnapshot.value : this.candidateSnapshot,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmartDownloadSourceEntry(')
          ..write('profileId: $profileId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('libraryId: $libraryId, ')
          ..write('displayName: $displayName, ')
          ..write('descending: $descending, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('candidateSnapshot: $candidateSnapshot, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    sourceType,
    sourceId,
    libraryId,
    displayName,
    descending,
    sourceRevision,
    candidateSnapshot,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmartDownloadSourceEntry &&
          other.profileId == this.profileId &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.libraryId == this.libraryId &&
          other.displayName == this.displayName &&
          other.descending == this.descending &&
          other.sourceRevision == this.sourceRevision &&
          other.candidateSnapshot == this.candidateSnapshot &&
          other.updatedAt == this.updatedAt);
}

class SmartDownloadSourcesCompanion extends UpdateCompanion<SmartDownloadSourceEntry> {
  final Value<String> profileId;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<String> libraryId;
  final Value<String?> displayName;
  final Value<bool> descending;
  final Value<int?> sourceRevision;
  final Value<String?> candidateSnapshot;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SmartDownloadSourcesCompanion({
    this.profileId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.descending = const Value.absent(),
    this.sourceRevision = const Value.absent(),
    this.candidateSnapshot = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmartDownloadSourcesCompanion.insert({
    required String profileId,
    required String sourceType,
    required String sourceId,
    required String libraryId,
    this.displayName = const Value.absent(),
    this.descending = const Value.absent(),
    this.sourceRevision = const Value.absent(),
    this.candidateSnapshot = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       libraryId = Value(libraryId),
       updatedAt = Value(updatedAt);
  static Insertable<SmartDownloadSourceEntry> custom({
    Expression<String>? profileId,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? libraryId,
    Expression<String>? displayName,
    Expression<bool>? descending,
    Expression<int>? sourceRevision,
    Expression<String>? candidateSnapshot,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (libraryId != null) 'library_id': libraryId,
      if (displayName != null) 'display_name': displayName,
      if (descending != null) 'descending': descending,
      if (sourceRevision != null) 'source_revision': sourceRevision,
      if (candidateSnapshot != null) 'candidate_snapshot': candidateSnapshot,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmartDownloadSourcesCompanion copyWith({
    Value<String>? profileId,
    Value<String>? sourceType,
    Value<String>? sourceId,
    Value<String>? libraryId,
    Value<String?>? displayName,
    Value<bool>? descending,
    Value<int?>? sourceRevision,
    Value<String?>? candidateSnapshot,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SmartDownloadSourcesCompanion(
      profileId: profileId ?? this.profileId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      libraryId: libraryId ?? this.libraryId,
      displayName: displayName ?? this.displayName,
      descending: descending ?? this.descending,
      sourceRevision: sourceRevision ?? this.sourceRevision,
      candidateSnapshot: candidateSnapshot ?? this.candidateSnapshot,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<String>(libraryId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (descending.present) {
      map['descending'] = Variable<bool>(descending.value);
    }
    if (sourceRevision.present) {
      map['source_revision'] = Variable<int>(sourceRevision.value);
    }
    if (candidateSnapshot.present) {
      map['candidate_snapshot'] = Variable<String>(candidateSnapshot.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmartDownloadSourcesCompanion(')
          ..write('profileId: $profileId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('libraryId: $libraryId, ')
          ..write('displayName: $displayName, ')
          ..write('descending: $descending, ')
          ..write('sourceRevision: $sourceRevision, ')
          ..write('candidateSnapshot: $candidateSnapshot, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SmartDownloadClaimsTable extends SmartDownloadClaims
    with TableInfo<$SmartDownloadClaimsTable, SmartDownloadClaimEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SmartDownloadClaimsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _profileIdMeta = const VerificationMeta('profileId');
  @override
  late final GeneratedColumn<String> profileId = GeneratedColumn<String>(
    'profile_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _referenceKeyMeta = const VerificationMeta('referenceKey');
  @override
  late final GeneratedColumn<String> referenceKey = GeneratedColumn<String>(
    'reference_key',
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
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta('sourceType');
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceIdMeta = const VerificationMeta('sourceId');
  @override
  late final GeneratedColumn<String> sourceId = GeneratedColumn<String>(
    'source_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<String> state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedBytesMeta = const VerificationMeta('estimatedBytes');
  @override
  late final GeneratedColumn<int> estimatedBytes = GeneratedColumn<int>(
    'estimated_bytes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta('completedAt');
  @override
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta('updatedAt');
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    profileId,
    referenceKey,
    itemId,
    episodeId,
    sourceType,
    sourceId,
    state,
    estimatedBytes,
    completedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'smart_download_claims';
  @override
  VerificationContext validateIntegrity(Insertable<SmartDownloadClaimEntry> instance, {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('profile_id')) {
      context.handle(_profileIdMeta, profileId.isAcceptableOrUnknown(data['profile_id']!, _profileIdMeta));
    } else if (isInserting) {
      context.missing(_profileIdMeta);
    }
    if (data.containsKey('reference_key')) {
      context.handle(_referenceKeyMeta, referenceKey.isAcceptableOrUnknown(data['reference_key']!, _referenceKeyMeta));
    } else if (isInserting) {
      context.missing(_referenceKeyMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(_itemIdMeta, itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta));
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(_episodeIdMeta, episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta));
    }
    if (data.containsKey('source_type')) {
      context.handle(_sourceTypeMeta, sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta));
    } else if (isInserting) {
      context.missing(_sourceTypeMeta);
    }
    if (data.containsKey('source_id')) {
      context.handle(_sourceIdMeta, sourceId.isAcceptableOrUnknown(data['source_id']!, _sourceIdMeta));
    } else if (isInserting) {
      context.missing(_sourceIdMeta);
    }
    if (data.containsKey('state')) {
      context.handle(_stateMeta, state.isAcceptableOrUnknown(data['state']!, _stateMeta));
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('estimated_bytes')) {
      context.handle(
        _estimatedBytesMeta,
        estimatedBytes.isAcceptableOrUnknown(data['estimated_bytes']!, _estimatedBytesMeta),
      );
    }
    if (data.containsKey('completed_at')) {
      context.handle(_completedAtMeta, completedAt.isAcceptableOrUnknown(data['completed_at']!, _completedAtMeta));
    }
    if (data.containsKey('updated_at')) {
      context.handle(_updatedAtMeta, updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta));
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {profileId, referenceKey};
  @override
  SmartDownloadClaimEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SmartDownloadClaimEntry(
      profileId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}profile_id'])!,
      referenceKey: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}reference_key'])!,
      itemId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}item_id'])!,
      episodeId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}episode_id']),
      sourceType: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source_type'])!,
      sourceId: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}source_id'])!,
      state: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}state'])!,
      estimatedBytes: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}estimated_bytes']),
      completedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}completed_at']),
      updatedAt: attachedDatabase.typeMapping.read(DriftSqlType.int, data['${effectivePrefix}updated_at'])!,
    );
  }

  @override
  $SmartDownloadClaimsTable createAlias(String alias) {
    return $SmartDownloadClaimsTable(attachedDatabase, alias);
  }
}

class SmartDownloadClaimEntry extends DataClass implements Insertable<SmartDownloadClaimEntry> {
  final String profileId;
  final String referenceKey;
  final String itemId;
  final String? episodeId;
  final String sourceType;
  final String sourceId;
  final String state;
  final int? estimatedBytes;
  final int? completedAt;
  final int updatedAt;
  const SmartDownloadClaimEntry({
    required this.profileId,
    required this.referenceKey,
    required this.itemId,
    this.episodeId,
    required this.sourceType,
    required this.sourceId,
    required this.state,
    this.estimatedBytes,
    this.completedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['profile_id'] = Variable<String>(profileId);
    map['reference_key'] = Variable<String>(referenceKey);
    map['item_id'] = Variable<String>(itemId);
    if (!nullToAbsent || episodeId != null) {
      map['episode_id'] = Variable<String>(episodeId);
    }
    map['source_type'] = Variable<String>(sourceType);
    map['source_id'] = Variable<String>(sourceId);
    map['state'] = Variable<String>(state);
    if (!nullToAbsent || estimatedBytes != null) {
      map['estimated_bytes'] = Variable<int>(estimatedBytes);
    }
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  SmartDownloadClaimsCompanion toCompanion(bool nullToAbsent) {
    return SmartDownloadClaimsCompanion(
      profileId: Value(profileId),
      referenceKey: Value(referenceKey),
      itemId: Value(itemId),
      episodeId: episodeId == null && nullToAbsent ? const Value.absent() : Value(episodeId),
      sourceType: Value(sourceType),
      sourceId: Value(sourceId),
      state: Value(state),
      estimatedBytes: estimatedBytes == null && nullToAbsent ? const Value.absent() : Value(estimatedBytes),
      completedAt: completedAt == null && nullToAbsent ? const Value.absent() : Value(completedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SmartDownloadClaimEntry.fromJson(Map<String, dynamic> json, {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SmartDownloadClaimEntry(
      profileId: serializer.fromJson<String>(json['profileId']),
      referenceKey: serializer.fromJson<String>(json['referenceKey']),
      itemId: serializer.fromJson<String>(json['itemId']),
      episodeId: serializer.fromJson<String?>(json['episodeId']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      sourceId: serializer.fromJson<String>(json['sourceId']),
      state: serializer.fromJson<String>(json['state']),
      estimatedBytes: serializer.fromJson<int?>(json['estimatedBytes']),
      completedAt: serializer.fromJson<int?>(json['completedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'profileId': serializer.toJson<String>(profileId),
      'referenceKey': serializer.toJson<String>(referenceKey),
      'itemId': serializer.toJson<String>(itemId),
      'episodeId': serializer.toJson<String?>(episodeId),
      'sourceType': serializer.toJson<String>(sourceType),
      'sourceId': serializer.toJson<String>(sourceId),
      'state': serializer.toJson<String>(state),
      'estimatedBytes': serializer.toJson<int?>(estimatedBytes),
      'completedAt': serializer.toJson<int?>(completedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  SmartDownloadClaimEntry copyWith({
    String? profileId,
    String? referenceKey,
    String? itemId,
    Value<String?> episodeId = const Value.absent(),
    String? sourceType,
    String? sourceId,
    String? state,
    Value<int?> estimatedBytes = const Value.absent(),
    Value<int?> completedAt = const Value.absent(),
    int? updatedAt,
  }) => SmartDownloadClaimEntry(
    profileId: profileId ?? this.profileId,
    referenceKey: referenceKey ?? this.referenceKey,
    itemId: itemId ?? this.itemId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    sourceType: sourceType ?? this.sourceType,
    sourceId: sourceId ?? this.sourceId,
    state: state ?? this.state,
    estimatedBytes: estimatedBytes.present ? estimatedBytes.value : this.estimatedBytes,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SmartDownloadClaimEntry copyWithCompanion(SmartDownloadClaimsCompanion data) {
    return SmartDownloadClaimEntry(
      profileId: data.profileId.present ? data.profileId.value : this.profileId,
      referenceKey: data.referenceKey.present ? data.referenceKey.value : this.referenceKey,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      episodeId: data.episodeId.present ? data.episodeId.value : this.episodeId,
      sourceType: data.sourceType.present ? data.sourceType.value : this.sourceType,
      sourceId: data.sourceId.present ? data.sourceId.value : this.sourceId,
      state: data.state.present ? data.state.value : this.state,
      estimatedBytes: data.estimatedBytes.present ? data.estimatedBytes.value : this.estimatedBytes,
      completedAt: data.completedAt.present ? data.completedAt.value : this.completedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SmartDownloadClaimEntry(')
          ..write('profileId: $profileId, ')
          ..write('referenceKey: $referenceKey, ')
          ..write('itemId: $itemId, ')
          ..write('episodeId: $episodeId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('state: $state, ')
          ..write('estimatedBytes: $estimatedBytes, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    profileId,
    referenceKey,
    itemId,
    episodeId,
    sourceType,
    sourceId,
    state,
    estimatedBytes,
    completedAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SmartDownloadClaimEntry &&
          other.profileId == this.profileId &&
          other.referenceKey == this.referenceKey &&
          other.itemId == this.itemId &&
          other.episodeId == this.episodeId &&
          other.sourceType == this.sourceType &&
          other.sourceId == this.sourceId &&
          other.state == this.state &&
          other.estimatedBytes == this.estimatedBytes &&
          other.completedAt == this.completedAt &&
          other.updatedAt == this.updatedAt);
}

class SmartDownloadClaimsCompanion extends UpdateCompanion<SmartDownloadClaimEntry> {
  final Value<String> profileId;
  final Value<String> referenceKey;
  final Value<String> itemId;
  final Value<String?> episodeId;
  final Value<String> sourceType;
  final Value<String> sourceId;
  final Value<String> state;
  final Value<int?> estimatedBytes;
  final Value<int?> completedAt;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const SmartDownloadClaimsCompanion({
    this.profileId = const Value.absent(),
    this.referenceKey = const Value.absent(),
    this.itemId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.sourceId = const Value.absent(),
    this.state = const Value.absent(),
    this.estimatedBytes = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SmartDownloadClaimsCompanion.insert({
    required String profileId,
    required String referenceKey,
    required String itemId,
    this.episodeId = const Value.absent(),
    required String sourceType,
    required String sourceId,
    required String state,
    this.estimatedBytes = const Value.absent(),
    this.completedAt = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : profileId = Value(profileId),
       referenceKey = Value(referenceKey),
       itemId = Value(itemId),
       sourceType = Value(sourceType),
       sourceId = Value(sourceId),
       state = Value(state),
       updatedAt = Value(updatedAt);
  static Insertable<SmartDownloadClaimEntry> custom({
    Expression<String>? profileId,
    Expression<String>? referenceKey,
    Expression<String>? itemId,
    Expression<String>? episodeId,
    Expression<String>? sourceType,
    Expression<String>? sourceId,
    Expression<String>? state,
    Expression<int>? estimatedBytes,
    Expression<int>? completedAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (profileId != null) 'profile_id': profileId,
      if (referenceKey != null) 'reference_key': referenceKey,
      if (itemId != null) 'item_id': itemId,
      if (episodeId != null) 'episode_id': episodeId,
      if (sourceType != null) 'source_type': sourceType,
      if (sourceId != null) 'source_id': sourceId,
      if (state != null) 'state': state,
      if (estimatedBytes != null) 'estimated_bytes': estimatedBytes,
      if (completedAt != null) 'completed_at': completedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SmartDownloadClaimsCompanion copyWith({
    Value<String>? profileId,
    Value<String>? referenceKey,
    Value<String>? itemId,
    Value<String?>? episodeId,
    Value<String>? sourceType,
    Value<String>? sourceId,
    Value<String>? state,
    Value<int?>? estimatedBytes,
    Value<int?>? completedAt,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return SmartDownloadClaimsCompanion(
      profileId: profileId ?? this.profileId,
      referenceKey: referenceKey ?? this.referenceKey,
      itemId: itemId ?? this.itemId,
      episodeId: episodeId ?? this.episodeId,
      sourceType: sourceType ?? this.sourceType,
      sourceId: sourceId ?? this.sourceId,
      state: state ?? this.state,
      estimatedBytes: estimatedBytes ?? this.estimatedBytes,
      completedAt: completedAt ?? this.completedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (profileId.present) {
      map['profile_id'] = Variable<String>(profileId.value);
    }
    if (referenceKey.present) {
      map['reference_key'] = Variable<String>(referenceKey.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<String>(itemId.value);
    }
    if (episodeId.present) {
      map['episode_id'] = Variable<String>(episodeId.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (sourceId.present) {
      map['source_id'] = Variable<String>(sourceId.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(state.value);
    }
    if (estimatedBytes.present) {
      map['estimated_bytes'] = Variable<int>(estimatedBytes.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SmartDownloadClaimsCompanion(')
          ..write('profileId: $profileId, ')
          ..write('referenceKey: $referenceKey, ')
          ..write('itemId: $itemId, ')
          ..write('episodeId: $episodeId, ')
          ..write('sourceType: $sourceType, ')
          ..write('sourceId: $sourceId, ')
          ..write('state: $state, ')
          ..write('estimatedBytes: $estimatedBytes, ')
          ..write('completedAt: $completedAt, ')
          ..write('updatedAt: $updatedAt, ')
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
  static const VerificationMeta _detailsJsonMeta = const VerificationMeta('detailsJson');
  @override
  late final GeneratedColumn<String> detailsJson = GeneratedColumn<String>(
    'details_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  List<GeneratedColumn> get $columns => [id, itemId, userId, episodeId, type, currentTime, detailsJson, created];
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
    if (data.containsKey('details_json')) {
      context.handle(_detailsJsonMeta, detailsJson.isAcceptableOrUnknown(data['details_json']!, _detailsJsonMeta));
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
      detailsJson: attachedDatabase.typeMapping.read(DriftSqlType.string, data['${effectivePrefix}details_json']),
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
  final String? detailsJson;
  final DateTime created;
  const PlayerHistoryEntry({
    required this.id,
    required this.itemId,
    required this.userId,
    this.episodeId,
    required this.type,
    required this.currentTime,
    this.detailsJson,
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
    if (!nullToAbsent || detailsJson != null) {
      map['details_json'] = Variable<String>(detailsJson);
    }
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
      detailsJson: detailsJson == null && nullToAbsent ? const Value.absent() : Value(detailsJson),
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
      detailsJson: serializer.fromJson<String?>(json['detailsJson']),
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
      'detailsJson': serializer.toJson<String?>(detailsJson),
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
    Value<String?> detailsJson = const Value.absent(),
    DateTime? created,
  }) => PlayerHistoryEntry(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    userId: userId ?? this.userId,
    episodeId: episodeId.present ? episodeId.value : this.episodeId,
    type: type ?? this.type,
    currentTime: currentTime ?? this.currentTime,
    detailsJson: detailsJson.present ? detailsJson.value : this.detailsJson,
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
      detailsJson: data.detailsJson.present ? data.detailsJson.value : this.detailsJson,
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
          ..write('detailsJson: $detailsJson, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemId, userId, episodeId, type, currentTime, detailsJson, created);
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
          other.detailsJson == this.detailsJson &&
          other.created == this.created);
}

class PlayerHistoryCompanion extends UpdateCompanion<PlayerHistoryEntry> {
  final Value<int> id;
  final Value<String> itemId;
  final Value<String> userId;
  final Value<String?> episodeId;
  final Value<String> type;
  final Value<double> currentTime;
  final Value<String?> detailsJson;
  final Value<DateTime> created;
  const PlayerHistoryCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.userId = const Value.absent(),
    this.episodeId = const Value.absent(),
    this.type = const Value.absent(),
    this.currentTime = const Value.absent(),
    this.detailsJson = const Value.absent(),
    this.created = const Value.absent(),
  });
  PlayerHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String itemId,
    required String userId,
    this.episodeId = const Value.absent(),
    required String type,
    required double currentTime,
    this.detailsJson = const Value.absent(),
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
    Expression<String>? detailsJson,
    Expression<DateTime>? created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (userId != null) 'user_id': userId,
      if (episodeId != null) 'episode_id': episodeId,
      if (type != null) 'type': type,
      if (currentTime != null) 'current_time': currentTime,
      if (detailsJson != null) 'details_json': detailsJson,
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
    Value<String?>? detailsJson,
    Value<DateTime>? created,
  }) {
    return PlayerHistoryCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      userId: userId ?? this.userId,
      episodeId: episodeId ?? this.episodeId,
      type: type ?? this.type,
      currentTime: currentTime ?? this.currentTime,
      detailsJson: detailsJson ?? this.detailsJson,
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
    if (detailsJson.present) {
      map['details_json'] = Variable<String>(detailsJson.value);
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
          ..write('detailsJson: $detailsJson, ')
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
  late final $StoredDownloadFilesTable storedDownloadFiles = $StoredDownloadFilesTable(this);
  late final $SmartDownloadProfilesTable smartDownloadProfiles = $SmartDownloadProfilesTable(this);
  late final $SmartDownloadSourcesTable smartDownloadSources = $SmartDownloadSourcesTable(this);
  late final $SmartDownloadClaimsTable smartDownloadClaims = $SmartDownloadClaimsTable(this);
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
    storedDownloadFiles,
    smartDownloadProfiles,
    smartDownloadSources,
    smartDownloadClaims,
    playerHistory,
  ];
}

typedef $$GlobalSettingsTableCreateCompanionBuilder = GlobalSettingsCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$GlobalSettingsTableUpdateCompanionBuilder = GlobalSettingsCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

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
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => GlobalSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => GlobalSettingsCompanion.insert(key: key, value: value, rowid: rowid),
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
typedef $$UserSettingsTableCreateCompanionBuilder = UserSettingsCompanion Function({
  required String userId,
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$UserSettingsTableUpdateCompanionBuilder = UserSettingsCompanion Function({
  Value<String> userId,
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

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
          updateCompanionCallback: ({
            Value<String> userId = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => UserSettingsCompanion(userId: userId, key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
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
typedef $$BookPlaybackSpeedsTableCreateCompanionBuilder = BookPlaybackSpeedsCompanion Function({
  required String userId,
  required String itemId,
  required double speed,
  Value<DateTime> updatedAt,
  Value<int> rowid,
});
typedef $$BookPlaybackSpeedsTableUpdateCompanionBuilder = BookPlaybackSpeedsCompanion Function({
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
typedef $$StoredUsersTableCreateCompanionBuilder = StoredUsersCompanion Function({
  required String id,
  required String userDataJson,
  Value<int> rowid,
});
typedef $$StoredUsersTableUpdateCompanionBuilder = StoredUsersCompanion Function({
  Value<String> id,
  Value<String> userDataJson,
  Value<int> rowid,
});

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
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> userDataJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => StoredUsersCompanion(id: id, userDataJson: userDataJson, rowid: rowid),
          createCompanionCallback: ({
            required String id,
            required String userDataJson,
            Value<int> rowid = const Value.absent(),
          }) => StoredUsersCompanion.insert(id: id, userDataJson: userDataJson, rowid: rowid),
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
typedef $$StoredSyncsTableCreateCompanionBuilder = StoredSyncsCompanion Function({
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
typedef $$StoredSyncsTableUpdateCompanionBuilder = StoredSyncsCompanion Function({
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
typedef $$StoredMediaProgressTableCreateCompanionBuilder = StoredMediaProgressCompanion Function({
  required String progressId,
  required String userId,
  required String itemId,
  Value<String?> episodeId,
  required DateTime lastUpdated,
  required String mediaProgress,
  Value<int> rowid,
});
typedef $$StoredMediaProgressTableUpdateCompanionBuilder = StoredMediaProgressCompanion Function({
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
typedef $$StoredBookmarkSyncsTableCreateCompanionBuilder = StoredBookmarkSyncsCompanion Function({
  required String userId,
  required String itemId,
  required int time,
  Value<String?> title,
  Value<bool> deleted,
  required DateTime updatedAt,
  Value<int> rowid,
});
typedef $$StoredBookmarkSyncsTableUpdateCompanionBuilder = StoredBookmarkSyncsCompanion Function({
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
typedef $$StoredDownloadsTableCreateCompanionBuilder = StoredDownloadsCompanion Function({
  required String itemId,
  required String userId,
  Value<String?> episodeId,
  required String download,
  Value<String> downloadOrigin,
  Value<String> smartProfileIds,
  Value<int?> managedBytes,
  Value<int?> completedAt,
  Value<int> rowid,
});
typedef $$StoredDownloadsTableUpdateCompanionBuilder = StoredDownloadsCompanion Function({
  Value<String> itemId,
  Value<String> userId,
  Value<String?> episodeId,
  Value<String> download,
  Value<String> downloadOrigin,
  Value<String> smartProfileIds,
  Value<int?> managedBytes,
  Value<int?> completedAt,
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

  ColumnFilters<String> get downloadOrigin =>
      $composableBuilder(column: $table.downloadOrigin, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get smartProfileIds =>
      $composableBuilder(column: $table.smartProfileIds, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get managedBytes =>
      $composableBuilder(column: $table.managedBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnFilters(column));
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

  ColumnOrderings<String> get downloadOrigin =>
      $composableBuilder(column: $table.downloadOrigin, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get smartProfileIds =>
      $composableBuilder(column: $table.smartProfileIds, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get managedBytes =>
      $composableBuilder(column: $table.managedBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnOrderings(column));
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

  GeneratedColumn<String> get downloadOrigin =>
      $composableBuilder(column: $table.downloadOrigin, builder: (column) => column);

  GeneratedColumn<String> get smartProfileIds =>
      $composableBuilder(column: $table.smartProfileIds, builder: (column) => column);

  GeneratedColumn<int> get managedBytes => $composableBuilder(column: $table.managedBytes, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(column: $table.completedAt, builder: (column) => column);
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
                Value<String> downloadOrigin = const Value.absent(),
                Value<String> smartProfileIds = const Value.absent(),
                Value<int?> managedBytes = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredDownloadsCompanion(
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                download: download,
                downloadOrigin: downloadOrigin,
                smartProfileIds: smartProfileIds,
                managedBytes: managedBytes,
                completedAt: completedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String userId,
                Value<String?> episodeId = const Value.absent(),
                required String download,
                Value<String> downloadOrigin = const Value.absent(),
                Value<String> smartProfileIds = const Value.absent(),
                Value<int?> managedBytes = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredDownloadsCompanion.insert(
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                download: download,
                downloadOrigin: downloadOrigin,
                smartProfileIds: smartProfileIds,
                managedBytes: managedBytes,
                completedAt: completedAt,
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
typedef $$StoredDownloadFilesTableCreateCompanionBuilder = StoredDownloadFilesCompanion Function({
  required String itemId,
  required String userId,
  Value<String?> episodeId,
  required String fileKey,
  Value<String?> trackJson,
  Value<String?> auxiliaryPath,
  Value<String?> sidecarPath,
  Value<int> rowid,
});
typedef $$StoredDownloadFilesTableUpdateCompanionBuilder = StoredDownloadFilesCompanion Function({
  Value<String> itemId,
  Value<String> userId,
  Value<String?> episodeId,
  Value<String> fileKey,
  Value<String?> trackJson,
  Value<String?> auxiliaryPath,
  Value<String?> sidecarPath,
  Value<int> rowid,
});

class $$StoredDownloadFilesTableFilterComposer extends Composer<_$AppDatabase, $StoredDownloadFilesTable> {
  $$StoredDownloadFilesTableFilterComposer({
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

  ColumnFilters<String> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get trackJson =>
      $composableBuilder(column: $table.trackJson, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get auxiliaryPath =>
      $composableBuilder(column: $table.auxiliaryPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sidecarPath =>
      $composableBuilder(column: $table.sidecarPath, builder: (column) => ColumnFilters(column));
}

class $$StoredDownloadFilesTableOrderingComposer extends Composer<_$AppDatabase, $StoredDownloadFilesTable> {
  $$StoredDownloadFilesTableOrderingComposer({
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

  ColumnOrderings<String> get fileKey =>
      $composableBuilder(column: $table.fileKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get trackJson =>
      $composableBuilder(column: $table.trackJson, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get auxiliaryPath =>
      $composableBuilder(column: $table.auxiliaryPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sidecarPath =>
      $composableBuilder(column: $table.sidecarPath, builder: (column) => ColumnOrderings(column));
}

class $$StoredDownloadFilesTableAnnotationComposer extends Composer<_$AppDatabase, $StoredDownloadFilesTable> {
  $$StoredDownloadFilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get episodeId => $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<String> get fileKey => $composableBuilder(column: $table.fileKey, builder: (column) => column);

  GeneratedColumn<String> get trackJson => $composableBuilder(column: $table.trackJson, builder: (column) => column);

  GeneratedColumn<String> get auxiliaryPath =>
      $composableBuilder(column: $table.auxiliaryPath, builder: (column) => column);

  GeneratedColumn<String> get sidecarPath =>
      $composableBuilder(column: $table.sidecarPath, builder: (column) => column);
}

class $$StoredDownloadFilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoredDownloadFilesTable,
          StoredDownloadFileEntry,
          $$StoredDownloadFilesTableFilterComposer,
          $$StoredDownloadFilesTableOrderingComposer,
          $$StoredDownloadFilesTableAnnotationComposer,
          $$StoredDownloadFilesTableCreateCompanionBuilder,
          $$StoredDownloadFilesTableUpdateCompanionBuilder,
          (StoredDownloadFileEntry, BaseReferences<_$AppDatabase, $StoredDownloadFilesTable, StoredDownloadFileEntry>),
          StoredDownloadFileEntry,
          PrefetchHooks Function()
        > {
  $$StoredDownloadFilesTableTableManager(_$AppDatabase db, $StoredDownloadFilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$StoredDownloadFilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$StoredDownloadFilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$StoredDownloadFilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> itemId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                Value<String> fileKey = const Value.absent(),
                Value<String?> trackJson = const Value.absent(),
                Value<String?> auxiliaryPath = const Value.absent(),
                Value<String?> sidecarPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredDownloadFilesCompanion(
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                fileKey: fileKey,
                trackJson: trackJson,
                auxiliaryPath: auxiliaryPath,
                sidecarPath: sidecarPath,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String itemId,
                required String userId,
                Value<String?> episodeId = const Value.absent(),
                required String fileKey,
                Value<String?> trackJson = const Value.absent(),
                Value<String?> auxiliaryPath = const Value.absent(),
                Value<String?> sidecarPath = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredDownloadFilesCompanion.insert(
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                fileKey: fileKey,
                trackJson: trackJson,
                auxiliaryPath: auxiliaryPath,
                sidecarPath: sidecarPath,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoredDownloadFilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoredDownloadFilesTable,
      StoredDownloadFileEntry,
      $$StoredDownloadFilesTableFilterComposer,
      $$StoredDownloadFilesTableOrderingComposer,
      $$StoredDownloadFilesTableAnnotationComposer,
      $$StoredDownloadFilesTableCreateCompanionBuilder,
      $$StoredDownloadFilesTableUpdateCompanionBuilder,
      (StoredDownloadFileEntry, BaseReferences<_$AppDatabase, $StoredDownloadFilesTable, StoredDownloadFileEntry>),
      StoredDownloadFileEntry,
      PrefetchHooks Function()
    >;
typedef $$SmartDownloadProfilesTableCreateCompanionBuilder = SmartDownloadProfilesCompanion Function({
  required String id,
  required String userId,
  required String name,
  required String policy,
  Value<bool> enabled,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SmartDownloadProfilesTableUpdateCompanionBuilder = SmartDownloadProfilesCompanion Function({
  Value<String> id,
  Value<String> userId,
  Value<String> name,
  Value<String> policy,
  Value<bool> enabled,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SmartDownloadProfilesTableFilterComposer extends Composer<_$AppDatabase, $SmartDownloadProfilesTable> {
  $$SmartDownloadProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get policy =>
      $composableBuilder(column: $table.policy, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SmartDownloadProfilesTableOrderingComposer extends Composer<_$AppDatabase, $SmartDownloadProfilesTable> {
  $$SmartDownloadProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get policy =>
      $composableBuilder(column: $table.policy, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SmartDownloadProfilesTableAnnotationComposer extends Composer<_$AppDatabase, $SmartDownloadProfilesTable> {
  $$SmartDownloadProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId => $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get name => $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get policy => $composableBuilder(column: $table.policy, builder: (column) => column);

  GeneratedColumn<bool> get enabled => $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SmartDownloadProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmartDownloadProfilesTable,
          SmartDownloadProfileEntry,
          $$SmartDownloadProfilesTableFilterComposer,
          $$SmartDownloadProfilesTableOrderingComposer,
          $$SmartDownloadProfilesTableAnnotationComposer,
          $$SmartDownloadProfilesTableCreateCompanionBuilder,
          $$SmartDownloadProfilesTableUpdateCompanionBuilder,
          (
            SmartDownloadProfileEntry,
            BaseReferences<_$AppDatabase, $SmartDownloadProfilesTable, SmartDownloadProfileEntry>,
          ),
          SmartDownloadProfileEntry,
          PrefetchHooks Function()
        > {
  $$SmartDownloadProfilesTableTableManager(_$AppDatabase db, $SmartDownloadProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SmartDownloadProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SmartDownloadProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SmartDownloadProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> policy = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmartDownloadProfilesCompanion(
                id: id,
                userId: userId,
                name: name,
                policy: policy,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String name,
                required String policy,
                Value<bool> enabled = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SmartDownloadProfilesCompanion.insert(
                id: id,
                userId: userId,
                name: name,
                policy: policy,
                enabled: enabled,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmartDownloadProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmartDownloadProfilesTable,
      SmartDownloadProfileEntry,
      $$SmartDownloadProfilesTableFilterComposer,
      $$SmartDownloadProfilesTableOrderingComposer,
      $$SmartDownloadProfilesTableAnnotationComposer,
      $$SmartDownloadProfilesTableCreateCompanionBuilder,
      $$SmartDownloadProfilesTableUpdateCompanionBuilder,
      (
        SmartDownloadProfileEntry,
        BaseReferences<_$AppDatabase, $SmartDownloadProfilesTable, SmartDownloadProfileEntry>,
      ),
      SmartDownloadProfileEntry,
      PrefetchHooks Function()
    >;
typedef $$SmartDownloadSourcesTableCreateCompanionBuilder = SmartDownloadSourcesCompanion Function({
  required String profileId,
  required String sourceType,
  required String sourceId,
  required String libraryId,
  Value<String?> displayName,
  Value<bool> descending,
  Value<int?> sourceRevision,
  Value<String?> candidateSnapshot,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SmartDownloadSourcesTableUpdateCompanionBuilder = SmartDownloadSourcesCompanion Function({
  Value<String> profileId,
  Value<String> sourceType,
  Value<String> sourceId,
  Value<String> libraryId,
  Value<String?> displayName,
  Value<bool> descending,
  Value<int?> sourceRevision,
  Value<String?> candidateSnapshot,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SmartDownloadSourcesTableFilterComposer extends Composer<_$AppDatabase, $SmartDownloadSourcesTable> {
  $$SmartDownloadSourcesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType =>
      $composableBuilder(column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get descending =>
      $composableBuilder(column: $table.descending, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceRevision =>
      $composableBuilder(column: $table.sourceRevision, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get candidateSnapshot =>
      $composableBuilder(column: $table.candidateSnapshot, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SmartDownloadSourcesTableOrderingComposer extends Composer<_$AppDatabase, $SmartDownloadSourcesTable> {
  $$SmartDownloadSourcesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType =>
      $composableBuilder(column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get descending =>
      $composableBuilder(column: $table.descending, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceRevision =>
      $composableBuilder(column: $table.sourceRevision, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get candidateSnapshot =>
      $composableBuilder(column: $table.candidateSnapshot, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SmartDownloadSourcesTableAnnotationComposer extends Composer<_$AppDatabase, $SmartDownloadSourcesTable> {
  $$SmartDownloadSourcesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId => $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<String> get sourceId => $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get libraryId => $composableBuilder(column: $table.libraryId, builder: (column) => column);

  GeneratedColumn<String> get displayName =>
      $composableBuilder(column: $table.displayName, builder: (column) => column);

  GeneratedColumn<bool> get descending => $composableBuilder(column: $table.descending, builder: (column) => column);

  GeneratedColumn<int> get sourceRevision =>
      $composableBuilder(column: $table.sourceRevision, builder: (column) => column);

  GeneratedColumn<String> get candidateSnapshot =>
      $composableBuilder(column: $table.candidateSnapshot, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SmartDownloadSourcesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmartDownloadSourcesTable,
          SmartDownloadSourceEntry,
          $$SmartDownloadSourcesTableFilterComposer,
          $$SmartDownloadSourcesTableOrderingComposer,
          $$SmartDownloadSourcesTableAnnotationComposer,
          $$SmartDownloadSourcesTableCreateCompanionBuilder,
          $$SmartDownloadSourcesTableUpdateCompanionBuilder,
          (
            SmartDownloadSourceEntry,
            BaseReferences<_$AppDatabase, $SmartDownloadSourcesTable, SmartDownloadSourceEntry>,
          ),
          SmartDownloadSourceEntry,
          PrefetchHooks Function()
        > {
  $$SmartDownloadSourcesTableTableManager(_$AppDatabase db, $SmartDownloadSourcesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SmartDownloadSourcesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SmartDownloadSourcesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SmartDownloadSourcesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> libraryId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<bool> descending = const Value.absent(),
                Value<int?> sourceRevision = const Value.absent(),
                Value<String?> candidateSnapshot = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmartDownloadSourcesCompanion(
                profileId: profileId,
                sourceType: sourceType,
                sourceId: sourceId,
                libraryId: libraryId,
                displayName: displayName,
                descending: descending,
                sourceRevision: sourceRevision,
                candidateSnapshot: candidateSnapshot,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String sourceType,
                required String sourceId,
                required String libraryId,
                Value<String?> displayName = const Value.absent(),
                Value<bool> descending = const Value.absent(),
                Value<int?> sourceRevision = const Value.absent(),
                Value<String?> candidateSnapshot = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SmartDownloadSourcesCompanion.insert(
                profileId: profileId,
                sourceType: sourceType,
                sourceId: sourceId,
                libraryId: libraryId,
                displayName: displayName,
                descending: descending,
                sourceRevision: sourceRevision,
                candidateSnapshot: candidateSnapshot,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmartDownloadSourcesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmartDownloadSourcesTable,
      SmartDownloadSourceEntry,
      $$SmartDownloadSourcesTableFilterComposer,
      $$SmartDownloadSourcesTableOrderingComposer,
      $$SmartDownloadSourcesTableAnnotationComposer,
      $$SmartDownloadSourcesTableCreateCompanionBuilder,
      $$SmartDownloadSourcesTableUpdateCompanionBuilder,
      (SmartDownloadSourceEntry, BaseReferences<_$AppDatabase, $SmartDownloadSourcesTable, SmartDownloadSourceEntry>),
      SmartDownloadSourceEntry,
      PrefetchHooks Function()
    >;
typedef $$SmartDownloadClaimsTableCreateCompanionBuilder = SmartDownloadClaimsCompanion Function({
  required String profileId,
  required String referenceKey,
  required String itemId,
  Value<String?> episodeId,
  required String sourceType,
  required String sourceId,
  required String state,
  Value<int?> estimatedBytes,
  Value<int?> completedAt,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$SmartDownloadClaimsTableUpdateCompanionBuilder = SmartDownloadClaimsCompanion Function({
  Value<String> profileId,
  Value<String> referenceKey,
  Value<String> itemId,
  Value<String?> episodeId,
  Value<String> sourceType,
  Value<String> sourceId,
  Value<String> state,
  Value<int?> estimatedBytes,
  Value<int?> completedAt,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$SmartDownloadClaimsTableFilterComposer extends Composer<_$AppDatabase, $SmartDownloadClaimsTable> {
  $$SmartDownloadClaimsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get referenceKey =>
      $composableBuilder(column: $table.referenceKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceType =>
      $composableBuilder(column: $table.sourceType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get estimatedBytes =>
      $composableBuilder(column: $table.estimatedBytes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnFilters(column));
}

class $$SmartDownloadClaimsTableOrderingComposer extends Composer<_$AppDatabase, $SmartDownloadClaimsTable> {
  $$SmartDownloadClaimsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get profileId =>
      $composableBuilder(column: $table.profileId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get referenceKey =>
      $composableBuilder(column: $table.referenceKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceType =>
      $composableBuilder(column: $table.sourceType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceId =>
      $composableBuilder(column: $table.sourceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get estimatedBytes =>
      $composableBuilder(column: $table.estimatedBytes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get completedAt =>
      $composableBuilder(column: $table.completedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => ColumnOrderings(column));
}

class $$SmartDownloadClaimsTableAnnotationComposer extends Composer<_$AppDatabase, $SmartDownloadClaimsTable> {
  $$SmartDownloadClaimsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get profileId => $composableBuilder(column: $table.profileId, builder: (column) => column);

  GeneratedColumn<String> get referenceKey =>
      $composableBuilder(column: $table.referenceKey, builder: (column) => column);

  GeneratedColumn<String> get itemId => $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get episodeId => $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(column: $table.sourceType, builder: (column) => column);

  GeneratedColumn<String> get sourceId => $composableBuilder(column: $table.sourceId, builder: (column) => column);

  GeneratedColumn<String> get state => $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get estimatedBytes =>
      $composableBuilder(column: $table.estimatedBytes, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(column: $table.completedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$SmartDownloadClaimsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SmartDownloadClaimsTable,
          SmartDownloadClaimEntry,
          $$SmartDownloadClaimsTableFilterComposer,
          $$SmartDownloadClaimsTableOrderingComposer,
          $$SmartDownloadClaimsTableAnnotationComposer,
          $$SmartDownloadClaimsTableCreateCompanionBuilder,
          $$SmartDownloadClaimsTableUpdateCompanionBuilder,
          (SmartDownloadClaimEntry, BaseReferences<_$AppDatabase, $SmartDownloadClaimsTable, SmartDownloadClaimEntry>),
          SmartDownloadClaimEntry,
          PrefetchHooks Function()
        > {
  $$SmartDownloadClaimsTableTableManager(_$AppDatabase db, $SmartDownloadClaimsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SmartDownloadClaimsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SmartDownloadClaimsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SmartDownloadClaimsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> profileId = const Value.absent(),
                Value<String> referenceKey = const Value.absent(),
                Value<String> itemId = const Value.absent(),
                Value<String?> episodeId = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<String> sourceId = const Value.absent(),
                Value<String> state = const Value.absent(),
                Value<int?> estimatedBytes = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SmartDownloadClaimsCompanion(
                profileId: profileId,
                referenceKey: referenceKey,
                itemId: itemId,
                episodeId: episodeId,
                sourceType: sourceType,
                sourceId: sourceId,
                state: state,
                estimatedBytes: estimatedBytes,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String profileId,
                required String referenceKey,
                required String itemId,
                Value<String?> episodeId = const Value.absent(),
                required String sourceType,
                required String sourceId,
                required String state,
                Value<int?> estimatedBytes = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SmartDownloadClaimsCompanion.insert(
                profileId: profileId,
                referenceKey: referenceKey,
                itemId: itemId,
                episodeId: episodeId,
                sourceType: sourceType,
                sourceId: sourceId,
                state: state,
                estimatedBytes: estimatedBytes,
                completedAt: completedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0.map((e) => (e.readTable(table), BaseReferences(db, table, e))).toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SmartDownloadClaimsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SmartDownloadClaimsTable,
      SmartDownloadClaimEntry,
      $$SmartDownloadClaimsTableFilterComposer,
      $$SmartDownloadClaimsTableOrderingComposer,
      $$SmartDownloadClaimsTableAnnotationComposer,
      $$SmartDownloadClaimsTableCreateCompanionBuilder,
      $$SmartDownloadClaimsTableUpdateCompanionBuilder,
      (SmartDownloadClaimEntry, BaseReferences<_$AppDatabase, $SmartDownloadClaimsTable, SmartDownloadClaimEntry>),
      SmartDownloadClaimEntry,
      PrefetchHooks Function()
    >;
typedef $$PlayerHistoryTableCreateCompanionBuilder = PlayerHistoryCompanion Function({
  Value<int> id,
  required String itemId,
  required String userId,
  Value<String?> episodeId,
  required String type,
  required double currentTime,
  Value<String?> detailsJson,
  Value<DateTime> created,
});
typedef $$PlayerHistoryTableUpdateCompanionBuilder = PlayerHistoryCompanion Function({
  Value<int> id,
  Value<String> itemId,
  Value<String> userId,
  Value<String?> episodeId,
  Value<String> type,
  Value<double> currentTime,
  Value<String?> detailsJson,
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

  ColumnFilters<String> get detailsJson =>
      $composableBuilder(column: $table.detailsJson, builder: (column) => ColumnFilters(column));

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

  ColumnOrderings<String> get detailsJson =>
      $composableBuilder(column: $table.detailsJson, builder: (column) => ColumnOrderings(column));

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

  GeneratedColumn<String> get detailsJson =>
      $composableBuilder(column: $table.detailsJson, builder: (column) => column);

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
                Value<String?> detailsJson = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
              }) => PlayerHistoryCompanion(
                id: id,
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                type: type,
                currentTime: currentTime,
                detailsJson: detailsJson,
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
                Value<String?> detailsJson = const Value.absent(),
                Value<DateTime> created = const Value.absent(),
              }) => PlayerHistoryCompanion.insert(
                id: id,
                itemId: itemId,
                userId: userId,
                episodeId: episodeId,
                type: type,
                currentTime: currentTime,
                detailsJson: detailsJson,
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
  $$StoredDownloadFilesTableTableManager get storedDownloadFiles =>
      $$StoredDownloadFilesTableTableManager(_db, _db.storedDownloadFiles);
  $$SmartDownloadProfilesTableTableManager get smartDownloadProfiles =>
      $$SmartDownloadProfilesTableTableManager(_db, _db.smartDownloadProfiles);
  $$SmartDownloadSourcesTableTableManager get smartDownloadSources =>
      $$SmartDownloadSourcesTableTableManager(_db, _db.smartDownloadSources);
  $$SmartDownloadClaimsTableTableManager get smartDownloadClaims =>
      $$SmartDownloadClaimsTableTableManager(_db, _db.smartDownloadClaims);
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
