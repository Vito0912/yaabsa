// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GlobalSettingsTable extends GlobalSettings
    with TableInfo<$GlobalSettingsTable, GlobalSettingEntry> {
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
  VerificationContext validateIntegrity(
    Insertable<GlobalSettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
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
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
    );
  }

  @override
  $GlobalSettingsTable createAlias(String alias) {
    return $GlobalSettingsTable(attachedDatabase, alias);
  }
}

class GlobalSettingEntry extends DataClass
    implements Insertable<GlobalSettingEntry> {
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

  factory GlobalSettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GlobalSettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
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
      identical(this, other) ||
      (other is GlobalSettingEntry &&
          other.key == this.key &&
          other.value == this.value);
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
  GlobalSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
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

  GlobalSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return GlobalSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
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

class $UserSettingsTable extends UserSettings
    with TableInfo<$UserSettingsTable, UserSettingEntry> {
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
  VerificationContext validateIntegrity(
    Insertable<UserSettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
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
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      key:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}key'],
          )!,
      value:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}value'],
          )!,
    );
  }

  @override
  $UserSettingsTable createAlias(String alias) {
    return $UserSettingsTable(attachedDatabase, alias);
  }
}

class UserSettingEntry extends DataClass
    implements Insertable<UserSettingEntry> {
  final String userId;
  final String key;
  final String value;
  const UserSettingEntry({
    required this.userId,
    required this.key,
    required this.value,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserSettingsCompanion toCompanion(bool nullToAbsent) {
    return UserSettingsCompanion(
      userId: Value(userId),
      key: Value(key),
      value: Value(value),
    );
  }

  factory UserSettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      UserSettingEntry(
        userId: userId ?? this.userId,
        key: key ?? this.key,
        value: value ?? this.value,
      );
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
      (other is UserSettingEntry &&
          other.userId == this.userId &&
          other.key == this.key &&
          other.value == this.value);
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

  UserSettingsCompanion copyWith({
    Value<String>? userId,
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
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

class $StoredUsersTable extends StoredUsers
    with TableInfo<$StoredUsersTable, StoredUserEntry> {
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
  static const VerificationMeta _userDataJsonMeta = const VerificationMeta(
    'userDataJson',
  );
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
  VerificationContext validateIntegrity(
    Insertable<StoredUserEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_data_json')) {
      context.handle(
        _userDataJsonMeta,
        userDataJson.isAcceptableOrUnknown(
          data['user_data_json']!,
          _userDataJsonMeta,
        ),
      );
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
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      userDataJson:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_data_json'],
          )!,
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
    return StoredUsersCompanion(
      id: Value(id),
      userDataJson: Value(userDataJson),
    );
  }

  factory StoredUserEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      StoredUserEntry(
        id: id ?? this.id,
        userDataJson: userDataJson ?? this.userDataJson,
      );
  StoredUserEntry copyWithCompanion(StoredUsersCompanion data) {
    return StoredUserEntry(
      id: data.id.present ? data.id.value : this.id,
      userDataJson:
          data.userDataJson.present
              ? data.userDataJson.value
              : this.userDataJson,
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
      (other is StoredUserEntry &&
          other.id == this.id &&
          other.userDataJson == this.userDataJson);
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
  StoredUsersCompanion.insert({
    required String id,
    required String userDataJson,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
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

  StoredUsersCompanion copyWith({
    Value<String>? id,
    Value<String>? userDataJson,
    Value<int>? rowid,
  }) {
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

class $StoredSyncsTable extends StoredSyncs
    with TableInfo<$StoredSyncsTable, StoredSyncEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoredSyncsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
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
  static const VerificationMeta _episodeIdMeta = const VerificationMeta(
    'episodeId',
  );
  @override
  late final GeneratedColumn<String> episodeId = GeneratedColumn<String>(
    'episode_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentTimeMeta = const VerificationMeta(
    'currentTime',
  );
  @override
  late final GeneratedColumn<double> currentTime = GeneratedColumn<double>(
    'current_time',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeListenedMeta = const VerificationMeta(
    'timeListened',
  );
  @override
  late final GeneratedColumn<double> timeListened = GeneratedColumn<double>(
    'time_listened',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMeta = const VerificationMeta(
    'duration',
  );
  @override
  late final GeneratedColumn<double> duration = GeneratedColumn<double>(
    'duration',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionLocalMeta = const VerificationMeta(
    'sessionLocal',
  );
  @override
  late final GeneratedColumn<bool> sessionLocal = GeneratedColumn<bool>(
    'session_local',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("session_local" IN (0, 1))',
    ),
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mediaProgressMeta = const VerificationMeta(
    'mediaProgress',
  );
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
  VerificationContext validateIntegrity(
    Insertable<StoredSyncEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('episode_id')) {
      context.handle(
        _episodeIdMeta,
        episodeId.isAcceptableOrUnknown(data['episode_id']!, _episodeIdMeta),
      );
    }
    if (data.containsKey('current_time')) {
      context.handle(
        _currentTimeMeta,
        currentTime.isAcceptableOrUnknown(
          data['current_time']!,
          _currentTimeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_currentTimeMeta);
    }
    if (data.containsKey('time_listened')) {
      context.handle(
        _timeListenedMeta,
        timeListened.isAcceptableOrUnknown(
          data['time_listened']!,
          _timeListenedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeListenedMeta);
    }
    if (data.containsKey('duration')) {
      context.handle(
        _durationMeta,
        duration.isAcceptableOrUnknown(data['duration']!, _durationMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMeta);
    }
    if (data.containsKey('session_local')) {
      context.handle(
        _sessionLocalMeta,
        sessionLocal.isAcceptableOrUnknown(
          data['session_local']!,
          _sessionLocalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sessionLocalMeta);
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastUpdatedMeta);
    }
    if (data.containsKey('media_progress')) {
      context.handle(
        _mediaProgressMeta,
        mediaProgress.isAcceptableOrUnknown(
          data['media_progress']!,
          _mediaProgressMeta,
        ),
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
      sessionId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}session_id'],
          )!,
      itemId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}item_id'],
          )!,
      userId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}user_id'],
          )!,
      episodeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}episode_id'],
      ),
      currentTime:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}current_time'],
          )!,
      timeListened:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}time_listened'],
          )!,
      duration:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}duration'],
          )!,
      sessionLocal:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}session_local'],
          )!,
      lastUpdated:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}last_updated'],
          )!,
      mediaProgress:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}media_progress'],
          )!,
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
      episodeId:
          episodeId == null && nullToAbsent
              ? const Value.absent()
              : Value(episodeId),
      currentTime: Value(currentTime),
      timeListened: Value(timeListened),
      duration: Value(duration),
      sessionLocal: Value(sessionLocal),
      lastUpdated: Value(lastUpdated),
      mediaProgress: Value(mediaProgress),
    );
  }

  factory StoredSyncEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
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
      currentTime:
          data.currentTime.present ? data.currentTime.value : this.currentTime,
      timeListened:
          data.timeListened.present
              ? data.timeListened.value
              : this.timeListened,
      duration: data.duration.present ? data.duration.value : this.duration,
      sessionLocal:
          data.sessionLocal.present
              ? data.sessionLocal.value
              : this.sessionLocal,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      mediaProgress:
          data.mediaProgress.present
              ? data.mediaProgress.value
              : this.mediaProgress,
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GlobalSettingsTable globalSettings = $GlobalSettingsTable(this);
  late final $UserSettingsTable userSettings = $UserSettingsTable(this);
  late final $StoredUsersTable storedUsers = $StoredUsersTable(this);
  late final $StoredSyncsTable storedSyncs = $StoredSyncsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    globalSettings,
    userSettings,
    storedUsers,
    storedSyncs,
  ];
}

typedef $$GlobalSettingsTableCreateCompanionBuilder =
    GlobalSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$GlobalSettingsTableUpdateCompanionBuilder =
    GlobalSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$GlobalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $GlobalSettingsTable> {
  $$GlobalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GlobalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $GlobalSettingsTable> {
  $$GlobalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GlobalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GlobalSettingsTable> {
  $$GlobalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
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
          (
            GlobalSettingEntry,
            BaseReferences<
              _$AppDatabase,
              $GlobalSettingsTable,
              GlobalSettingEntry
            >,
          ),
          GlobalSettingEntry,
          PrefetchHooks Function()
        > {
  $$GlobalSettingsTableTableManager(
    _$AppDatabase db,
    $GlobalSettingsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$GlobalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$GlobalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$GlobalSettingsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) =>
                  GlobalSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => GlobalSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
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
      (
        GlobalSettingEntry,
        BaseReferences<_$AppDatabase, $GlobalSettingsTable, GlobalSettingEntry>,
      ),
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
    UserSettingsCompanion Function({
      Value<String> userId,
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$UserSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserSettingsTable> {
  $$UserSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
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
          (
            UserSettingEntry,
            BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingEntry>,
          ),
          UserSettingEntry,
          PrefetchHooks Function()
        > {
  $$UserSettingsTableTableManager(_$AppDatabase db, $UserSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$UserSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$UserSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$UserSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion(
                userId: userId,
                key: key,
                value: value,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => UserSettingsCompanion.insert(
                userId: userId,
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
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
      (
        UserSettingEntry,
        BaseReferences<_$AppDatabase, $UserSettingsTable, UserSettingEntry>,
      ),
      UserSettingEntry,
      PrefetchHooks Function()
    >;
typedef $$StoredUsersTableCreateCompanionBuilder =
    StoredUsersCompanion Function({
      required String id,
      required String userDataJson,
      Value<int> rowid,
    });
typedef $$StoredUsersTableUpdateCompanionBuilder =
    StoredUsersCompanion Function({
      Value<String> id,
      Value<String> userDataJson,
      Value<int> rowid,
    });

class $$StoredUsersTableFilterComposer
    extends Composer<_$AppDatabase, $StoredUsersTable> {
  $$StoredUsersTableFilterComposer({
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

  ColumnFilters<String> get userDataJson => $composableBuilder(
    column: $table.userDataJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoredUsersTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredUsersTable> {
  $$StoredUsersTableOrderingComposer({
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

  ColumnOrderings<String> get userDataJson => $composableBuilder(
    column: $table.userDataJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredUsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredUsersTable> {
  $$StoredUsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userDataJson => $composableBuilder(
    column: $table.userDataJson,
    builder: (column) => column,
  );
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
          (
            StoredUserEntry,
            BaseReferences<_$AppDatabase, $StoredUsersTable, StoredUserEntry>,
          ),
          StoredUserEntry,
          PrefetchHooks Function()
        > {
  $$StoredUsersTableTableManager(_$AppDatabase db, $StoredUsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$StoredUsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StoredUsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$StoredUsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userDataJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoredUsersCompanion(
                id: id,
                userDataJson: userDataJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userDataJson,
                Value<int> rowid = const Value.absent(),
              }) => StoredUsersCompanion.insert(
                id: id,
                userDataJson: userDataJson,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
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
      (
        StoredUserEntry,
        BaseReferences<_$AppDatabase, $StoredUsersTable, StoredUserEntry>,
      ),
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

class $$StoredSyncsTableFilterComposer
    extends Composer<_$AppDatabase, $StoredSyncsTable> {
  $$StoredSyncsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get currentTime => $composableBuilder(
    column: $table.currentTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get timeListened => $composableBuilder(
    column: $table.timeListened,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sessionLocal => $composableBuilder(
    column: $table.sessionLocal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaProgress => $composableBuilder(
    column: $table.mediaProgress,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoredSyncsTableOrderingComposer
    extends Composer<_$AppDatabase, $StoredSyncsTable> {
  $$StoredSyncsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get episodeId => $composableBuilder(
    column: $table.episodeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get currentTime => $composableBuilder(
    column: $table.currentTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get timeListened => $composableBuilder(
    column: $table.timeListened,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get duration => $composableBuilder(
    column: $table.duration,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sessionLocal => $composableBuilder(
    column: $table.sessionLocal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaProgress => $composableBuilder(
    column: $table.mediaProgress,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoredSyncsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoredSyncsTable> {
  $$StoredSyncsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get episodeId =>
      $composableBuilder(column: $table.episodeId, builder: (column) => column);

  GeneratedColumn<double> get currentTime => $composableBuilder(
    column: $table.currentTime,
    builder: (column) => column,
  );

  GeneratedColumn<double> get timeListened => $composableBuilder(
    column: $table.timeListened,
    builder: (column) => column,
  );

  GeneratedColumn<double> get duration =>
      $composableBuilder(column: $table.duration, builder: (column) => column);

  GeneratedColumn<bool> get sessionLocal => $composableBuilder(
    column: $table.sessionLocal,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaProgress => $composableBuilder(
    column: $table.mediaProgress,
    builder: (column) => column,
  );
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
          (
            StoredSyncEntry,
            BaseReferences<_$AppDatabase, $StoredSyncsTable, StoredSyncEntry>,
          ),
          StoredSyncEntry,
          PrefetchHooks Function()
        > {
  $$StoredSyncsTableTableManager(_$AppDatabase db, $StoredSyncsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$StoredSyncsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$StoredSyncsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () =>
                  $$StoredSyncsTableAnnotationComposer($db: db, $table: table),
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
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
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
      (
        StoredSyncEntry,
        BaseReferences<_$AppDatabase, $StoredSyncsTable, StoredSyncEntry>,
      ),
      StoredSyncEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GlobalSettingsTableTableManager get globalSettings =>
      $$GlobalSettingsTableTableManager(_db, _db.globalSettings);
  $$UserSettingsTableTableManager get userSettings =>
      $$UserSettingsTableTableManager(_db, _db.userSettings);
  $$StoredUsersTableTableManager get storedUsers =>
      $$StoredUsersTableTableManager(_db, _db.storedUsers);
  $$StoredSyncsTableTableManager get storedSyncs =>
      $$StoredSyncsTableTableManager(_db, _db.storedSyncs);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appDatabaseHash() => r'8c69eb46d45206533c176c88a926608e79ca927d';

/// See also [appDatabase].
@ProviderFor(appDatabase)
final appDatabaseProvider = Provider<AppDatabase>.internal(
  appDatabase,
  name: r'appDatabaseProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appDatabaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppDatabaseRef = ProviderRef<AppDatabase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
