// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _installIdMeta = const VerificationMeta(
    'installId',
  );
  @override
  late final GeneratedColumn<String> installId = GeneratedColumn<String>(
    'install_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userNameMeta = const VerificationMeta(
    'userName',
  );
  @override
  late final GeneratedColumn<String> userName = GeneratedColumn<String>(
    'user_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _wakeTimeMeta = const VerificationMeta(
    'wakeTime',
  );
  @override
  late final GeneratedColumn<String> wakeTime = GeneratedColumn<String>(
    'wake_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('07:30'),
  );
  static const VerificationMeta _bedTimeMeta = const VerificationMeta(
    'bedTime',
  );
  @override
  late final GeneratedColumn<String> bedTime = GeneratedColumn<String>(
    'bed_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('23:00'),
  );
  static const VerificationMeta _dayStartHourMeta = const VerificationMeta(
    'dayStartHour',
  );
  @override
  late final GeneratedColumn<int> dayStartHour = GeneratedColumn<int>(
    'day_start_hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _moodCheckInModeMeta = const VerificationMeta(
    'moodCheckInMode',
  );
  @override
  late final GeneratedColumn<String> moodCheckInMode = GeneratedColumn<String>(
    'mood_check_in_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('daily'),
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reduceMotionMeta = const VerificationMeta(
    'reduceMotion',
  );
  @override
  late final GeneratedColumn<bool> reduceMotion = GeneratedColumn<bool>(
    'reduce_motion',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reduce_motion" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _soundMeta = const VerificationMeta('sound');
  @override
  late final GeneratedColumn<bool> sound = GeneratedColumn<bool>(
    'sound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("sound" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _hapticsMeta = const VerificationMeta(
    'haptics',
  );
  @override
  late final GeneratedColumn<bool> haptics = GeneratedColumn<bool>(
    'haptics',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyMorningMeta = const VerificationMeta(
    'notifyMorning',
  );
  @override
  late final GeneratedColumn<bool> notifyMorning = GeneratedColumn<bool>(
    'notify_morning',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_morning" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyAdventureMeta = const VerificationMeta(
    'notifyAdventure',
  );
  @override
  late final GeneratedColumn<bool> notifyAdventure = GeneratedColumn<bool>(
    'notify_adventure',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_adventure" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _notifyEveningMeta = const VerificationMeta(
    'notifyEvening',
  );
  @override
  late final GeneratedColumn<bool> notifyEvening = GeneratedColumn<bool>(
    'notify_evening',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("notify_evening" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _onboardingStepMeta = const VerificationMeta(
    'onboardingStep',
  );
  @override
  late final GeneratedColumn<String> onboardingStep = GeneratedColumn<String>(
    'onboarding_step',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingDoneAtMeta = const VerificationMeta(
    'onboardingDoneAt',
  );
  @override
  late final GeneratedColumn<DateTime> onboardingDoneAt =
      GeneratedColumn<DateTime>(
        'onboarding_done_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    installId,
    userName,
    wakeTime,
    bedTime,
    dayStartHour,
    moodCheckInMode,
    paused,
    reduceMotion,
    sound,
    haptics,
    notifyMorning,
    notifyAdventure,
    notifyEvening,
    onboardingStep,
    onboardingDoneAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('install_id')) {
      context.handle(
        _installIdMeta,
        installId.isAcceptableOrUnknown(data['install_id']!, _installIdMeta),
      );
    } else if (isInserting) {
      context.missing(_installIdMeta);
    }
    if (data.containsKey('user_name')) {
      context.handle(
        _userNameMeta,
        userName.isAcceptableOrUnknown(data['user_name']!, _userNameMeta),
      );
    }
    if (data.containsKey('wake_time')) {
      context.handle(
        _wakeTimeMeta,
        wakeTime.isAcceptableOrUnknown(data['wake_time']!, _wakeTimeMeta),
      );
    }
    if (data.containsKey('bed_time')) {
      context.handle(
        _bedTimeMeta,
        bedTime.isAcceptableOrUnknown(data['bed_time']!, _bedTimeMeta),
      );
    }
    if (data.containsKey('day_start_hour')) {
      context.handle(
        _dayStartHourMeta,
        dayStartHour.isAcceptableOrUnknown(
          data['day_start_hour']!,
          _dayStartHourMeta,
        ),
      );
    }
    if (data.containsKey('mood_check_in_mode')) {
      context.handle(
        _moodCheckInModeMeta,
        moodCheckInMode.isAcceptableOrUnknown(
          data['mood_check_in_mode']!,
          _moodCheckInModeMeta,
        ),
      );
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('reduce_motion')) {
      context.handle(
        _reduceMotionMeta,
        reduceMotion.isAcceptableOrUnknown(
          data['reduce_motion']!,
          _reduceMotionMeta,
        ),
      );
    }
    if (data.containsKey('sound')) {
      context.handle(
        _soundMeta,
        sound.isAcceptableOrUnknown(data['sound']!, _soundMeta),
      );
    }
    if (data.containsKey('haptics')) {
      context.handle(
        _hapticsMeta,
        haptics.isAcceptableOrUnknown(data['haptics']!, _hapticsMeta),
      );
    }
    if (data.containsKey('notify_morning')) {
      context.handle(
        _notifyMorningMeta,
        notifyMorning.isAcceptableOrUnknown(
          data['notify_morning']!,
          _notifyMorningMeta,
        ),
      );
    }
    if (data.containsKey('notify_adventure')) {
      context.handle(
        _notifyAdventureMeta,
        notifyAdventure.isAcceptableOrUnknown(
          data['notify_adventure']!,
          _notifyAdventureMeta,
        ),
      );
    }
    if (data.containsKey('notify_evening')) {
      context.handle(
        _notifyEveningMeta,
        notifyEvening.isAcceptableOrUnknown(
          data['notify_evening']!,
          _notifyEveningMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_step')) {
      context.handle(
        _onboardingStepMeta,
        onboardingStep.isAcceptableOrUnknown(
          data['onboarding_step']!,
          _onboardingStepMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_done_at')) {
      context.handle(
        _onboardingDoneAtMeta,
        onboardingDoneAt.isAcceptableOrUnknown(
          data['onboarding_done_at']!,
          _onboardingDoneAtMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      installId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}install_id'],
      )!,
      userName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_name'],
      )!,
      wakeTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}wake_time'],
      )!,
      bedTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bed_time'],
      )!,
      dayStartHour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_start_hour'],
      )!,
      moodCheckInMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mood_check_in_mode'],
      )!,
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      reduceMotion: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reduce_motion'],
      )!,
      sound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}sound'],
      )!,
      haptics: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics'],
      )!,
      notifyMorning: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_morning'],
      )!,
      notifyAdventure: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_adventure'],
      )!,
      notifyEvening: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}notify_evening'],
      )!,
      onboardingStep: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}onboarding_step'],
      ),
      onboardingDoneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}onboarding_done_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }
}

class Profile extends DataClass implements Insertable<Profile> {
  final int id;
  final String installId;
  final String userName;

  /// `HH:mm` local time.
  final String wakeTime;
  final String bedTime;
  final int dayStartHour;

  /// `daily`, `every_open` or `off`.
  final String moodCheckInMode;
  final bool paused;
  final bool reduceMotion;
  final bool sound;
  final bool haptics;
  final bool notifyMorning;
  final bool notifyAdventure;
  final bool notifyEvening;

  /// Id of the onboarding question to resume at, or null.
  final String? onboardingStep;
  final DateTime? onboardingDoneAt;
  final DateTime createdAt;
  const Profile({
    required this.id,
    required this.installId,
    required this.userName,
    required this.wakeTime,
    required this.bedTime,
    required this.dayStartHour,
    required this.moodCheckInMode,
    required this.paused,
    required this.reduceMotion,
    required this.sound,
    required this.haptics,
    required this.notifyMorning,
    required this.notifyAdventure,
    required this.notifyEvening,
    this.onboardingStep,
    this.onboardingDoneAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['install_id'] = Variable<String>(installId);
    map['user_name'] = Variable<String>(userName);
    map['wake_time'] = Variable<String>(wakeTime);
    map['bed_time'] = Variable<String>(bedTime);
    map['day_start_hour'] = Variable<int>(dayStartHour);
    map['mood_check_in_mode'] = Variable<String>(moodCheckInMode);
    map['paused'] = Variable<bool>(paused);
    map['reduce_motion'] = Variable<bool>(reduceMotion);
    map['sound'] = Variable<bool>(sound);
    map['haptics'] = Variable<bool>(haptics);
    map['notify_morning'] = Variable<bool>(notifyMorning);
    map['notify_adventure'] = Variable<bool>(notifyAdventure);
    map['notify_evening'] = Variable<bool>(notifyEvening);
    if (!nullToAbsent || onboardingStep != null) {
      map['onboarding_step'] = Variable<String>(onboardingStep);
    }
    if (!nullToAbsent || onboardingDoneAt != null) {
      map['onboarding_done_at'] = Variable<DateTime>(onboardingDoneAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      installId: Value(installId),
      userName: Value(userName),
      wakeTime: Value(wakeTime),
      bedTime: Value(bedTime),
      dayStartHour: Value(dayStartHour),
      moodCheckInMode: Value(moodCheckInMode),
      paused: Value(paused),
      reduceMotion: Value(reduceMotion),
      sound: Value(sound),
      haptics: Value(haptics),
      notifyMorning: Value(notifyMorning),
      notifyAdventure: Value(notifyAdventure),
      notifyEvening: Value(notifyEvening),
      onboardingStep: onboardingStep == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardingStep),
      onboardingDoneAt: onboardingDoneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardingDoneAt),
      createdAt: Value(createdAt),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<int>(json['id']),
      installId: serializer.fromJson<String>(json['installId']),
      userName: serializer.fromJson<String>(json['userName']),
      wakeTime: serializer.fromJson<String>(json['wakeTime']),
      bedTime: serializer.fromJson<String>(json['bedTime']),
      dayStartHour: serializer.fromJson<int>(json['dayStartHour']),
      moodCheckInMode: serializer.fromJson<String>(json['moodCheckInMode']),
      paused: serializer.fromJson<bool>(json['paused']),
      reduceMotion: serializer.fromJson<bool>(json['reduceMotion']),
      sound: serializer.fromJson<bool>(json['sound']),
      haptics: serializer.fromJson<bool>(json['haptics']),
      notifyMorning: serializer.fromJson<bool>(json['notifyMorning']),
      notifyAdventure: serializer.fromJson<bool>(json['notifyAdventure']),
      notifyEvening: serializer.fromJson<bool>(json['notifyEvening']),
      onboardingStep: serializer.fromJson<String?>(json['onboardingStep']),
      onboardingDoneAt: serializer.fromJson<DateTime?>(
        json['onboardingDoneAt'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'installId': serializer.toJson<String>(installId),
      'userName': serializer.toJson<String>(userName),
      'wakeTime': serializer.toJson<String>(wakeTime),
      'bedTime': serializer.toJson<String>(bedTime),
      'dayStartHour': serializer.toJson<int>(dayStartHour),
      'moodCheckInMode': serializer.toJson<String>(moodCheckInMode),
      'paused': serializer.toJson<bool>(paused),
      'reduceMotion': serializer.toJson<bool>(reduceMotion),
      'sound': serializer.toJson<bool>(sound),
      'haptics': serializer.toJson<bool>(haptics),
      'notifyMorning': serializer.toJson<bool>(notifyMorning),
      'notifyAdventure': serializer.toJson<bool>(notifyAdventure),
      'notifyEvening': serializer.toJson<bool>(notifyEvening),
      'onboardingStep': serializer.toJson<String?>(onboardingStep),
      'onboardingDoneAt': serializer.toJson<DateTime?>(onboardingDoneAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Profile copyWith({
    int? id,
    String? installId,
    String? userName,
    String? wakeTime,
    String? bedTime,
    int? dayStartHour,
    String? moodCheckInMode,
    bool? paused,
    bool? reduceMotion,
    bool? sound,
    bool? haptics,
    bool? notifyMorning,
    bool? notifyAdventure,
    bool? notifyEvening,
    Value<String?> onboardingStep = const Value.absent(),
    Value<DateTime?> onboardingDoneAt = const Value.absent(),
    DateTime? createdAt,
  }) => Profile(
    id: id ?? this.id,
    installId: installId ?? this.installId,
    userName: userName ?? this.userName,
    wakeTime: wakeTime ?? this.wakeTime,
    bedTime: bedTime ?? this.bedTime,
    dayStartHour: dayStartHour ?? this.dayStartHour,
    moodCheckInMode: moodCheckInMode ?? this.moodCheckInMode,
    paused: paused ?? this.paused,
    reduceMotion: reduceMotion ?? this.reduceMotion,
    sound: sound ?? this.sound,
    haptics: haptics ?? this.haptics,
    notifyMorning: notifyMorning ?? this.notifyMorning,
    notifyAdventure: notifyAdventure ?? this.notifyAdventure,
    notifyEvening: notifyEvening ?? this.notifyEvening,
    onboardingStep: onboardingStep.present
        ? onboardingStep.value
        : this.onboardingStep,
    onboardingDoneAt: onboardingDoneAt.present
        ? onboardingDoneAt.value
        : this.onboardingDoneAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      installId: data.installId.present ? data.installId.value : this.installId,
      userName: data.userName.present ? data.userName.value : this.userName,
      wakeTime: data.wakeTime.present ? data.wakeTime.value : this.wakeTime,
      bedTime: data.bedTime.present ? data.bedTime.value : this.bedTime,
      dayStartHour: data.dayStartHour.present
          ? data.dayStartHour.value
          : this.dayStartHour,
      moodCheckInMode: data.moodCheckInMode.present
          ? data.moodCheckInMode.value
          : this.moodCheckInMode,
      paused: data.paused.present ? data.paused.value : this.paused,
      reduceMotion: data.reduceMotion.present
          ? data.reduceMotion.value
          : this.reduceMotion,
      sound: data.sound.present ? data.sound.value : this.sound,
      haptics: data.haptics.present ? data.haptics.value : this.haptics,
      notifyMorning: data.notifyMorning.present
          ? data.notifyMorning.value
          : this.notifyMorning,
      notifyAdventure: data.notifyAdventure.present
          ? data.notifyAdventure.value
          : this.notifyAdventure,
      notifyEvening: data.notifyEvening.present
          ? data.notifyEvening.value
          : this.notifyEvening,
      onboardingStep: data.onboardingStep.present
          ? data.onboardingStep.value
          : this.onboardingStep,
      onboardingDoneAt: data.onboardingDoneAt.present
          ? data.onboardingDoneAt.value
          : this.onboardingDoneAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('installId: $installId, ')
          ..write('userName: $userName, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('bedTime: $bedTime, ')
          ..write('dayStartHour: $dayStartHour, ')
          ..write('moodCheckInMode: $moodCheckInMode, ')
          ..write('paused: $paused, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('sound: $sound, ')
          ..write('haptics: $haptics, ')
          ..write('notifyMorning: $notifyMorning, ')
          ..write('notifyAdventure: $notifyAdventure, ')
          ..write('notifyEvening: $notifyEvening, ')
          ..write('onboardingStep: $onboardingStep, ')
          ..write('onboardingDoneAt: $onboardingDoneAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    installId,
    userName,
    wakeTime,
    bedTime,
    dayStartHour,
    moodCheckInMode,
    paused,
    reduceMotion,
    sound,
    haptics,
    notifyMorning,
    notifyAdventure,
    notifyEvening,
    onboardingStep,
    onboardingDoneAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.installId == this.installId &&
          other.userName == this.userName &&
          other.wakeTime == this.wakeTime &&
          other.bedTime == this.bedTime &&
          other.dayStartHour == this.dayStartHour &&
          other.moodCheckInMode == this.moodCheckInMode &&
          other.paused == this.paused &&
          other.reduceMotion == this.reduceMotion &&
          other.sound == this.sound &&
          other.haptics == this.haptics &&
          other.notifyMorning == this.notifyMorning &&
          other.notifyAdventure == this.notifyAdventure &&
          other.notifyEvening == this.notifyEvening &&
          other.onboardingStep == this.onboardingStep &&
          other.onboardingDoneAt == this.onboardingDoneAt &&
          other.createdAt == this.createdAt);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<int> id;
  final Value<String> installId;
  final Value<String> userName;
  final Value<String> wakeTime;
  final Value<String> bedTime;
  final Value<int> dayStartHour;
  final Value<String> moodCheckInMode;
  final Value<bool> paused;
  final Value<bool> reduceMotion;
  final Value<bool> sound;
  final Value<bool> haptics;
  final Value<bool> notifyMorning;
  final Value<bool> notifyAdventure;
  final Value<bool> notifyEvening;
  final Value<String?> onboardingStep;
  final Value<DateTime?> onboardingDoneAt;
  final Value<DateTime> createdAt;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.installId = const Value.absent(),
    this.userName = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.bedTime = const Value.absent(),
    this.dayStartHour = const Value.absent(),
    this.moodCheckInMode = const Value.absent(),
    this.paused = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.sound = const Value.absent(),
    this.haptics = const Value.absent(),
    this.notifyMorning = const Value.absent(),
    this.notifyAdventure = const Value.absent(),
    this.notifyEvening = const Value.absent(),
    this.onboardingStep = const Value.absent(),
    this.onboardingDoneAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String installId,
    this.userName = const Value.absent(),
    this.wakeTime = const Value.absent(),
    this.bedTime = const Value.absent(),
    this.dayStartHour = const Value.absent(),
    this.moodCheckInMode = const Value.absent(),
    this.paused = const Value.absent(),
    this.reduceMotion = const Value.absent(),
    this.sound = const Value.absent(),
    this.haptics = const Value.absent(),
    this.notifyMorning = const Value.absent(),
    this.notifyAdventure = const Value.absent(),
    this.notifyEvening = const Value.absent(),
    this.onboardingStep = const Value.absent(),
    this.onboardingDoneAt = const Value.absent(),
    required DateTime createdAt,
  }) : installId = Value(installId),
       createdAt = Value(createdAt);
  static Insertable<Profile> custom({
    Expression<int>? id,
    Expression<String>? installId,
    Expression<String>? userName,
    Expression<String>? wakeTime,
    Expression<String>? bedTime,
    Expression<int>? dayStartHour,
    Expression<String>? moodCheckInMode,
    Expression<bool>? paused,
    Expression<bool>? reduceMotion,
    Expression<bool>? sound,
    Expression<bool>? haptics,
    Expression<bool>? notifyMorning,
    Expression<bool>? notifyAdventure,
    Expression<bool>? notifyEvening,
    Expression<String>? onboardingStep,
    Expression<DateTime>? onboardingDoneAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (installId != null) 'install_id': installId,
      if (userName != null) 'user_name': userName,
      if (wakeTime != null) 'wake_time': wakeTime,
      if (bedTime != null) 'bed_time': bedTime,
      if (dayStartHour != null) 'day_start_hour': dayStartHour,
      if (moodCheckInMode != null) 'mood_check_in_mode': moodCheckInMode,
      if (paused != null) 'paused': paused,
      if (reduceMotion != null) 'reduce_motion': reduceMotion,
      if (sound != null) 'sound': sound,
      if (haptics != null) 'haptics': haptics,
      if (notifyMorning != null) 'notify_morning': notifyMorning,
      if (notifyAdventure != null) 'notify_adventure': notifyAdventure,
      if (notifyEvening != null) 'notify_evening': notifyEvening,
      if (onboardingStep != null) 'onboarding_step': onboardingStep,
      if (onboardingDoneAt != null) 'onboarding_done_at': onboardingDoneAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? installId,
    Value<String>? userName,
    Value<String>? wakeTime,
    Value<String>? bedTime,
    Value<int>? dayStartHour,
    Value<String>? moodCheckInMode,
    Value<bool>? paused,
    Value<bool>? reduceMotion,
    Value<bool>? sound,
    Value<bool>? haptics,
    Value<bool>? notifyMorning,
    Value<bool>? notifyAdventure,
    Value<bool>? notifyEvening,
    Value<String?>? onboardingStep,
    Value<DateTime?>? onboardingDoneAt,
    Value<DateTime>? createdAt,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      installId: installId ?? this.installId,
      userName: userName ?? this.userName,
      wakeTime: wakeTime ?? this.wakeTime,
      bedTime: bedTime ?? this.bedTime,
      dayStartHour: dayStartHour ?? this.dayStartHour,
      moodCheckInMode: moodCheckInMode ?? this.moodCheckInMode,
      paused: paused ?? this.paused,
      reduceMotion: reduceMotion ?? this.reduceMotion,
      sound: sound ?? this.sound,
      haptics: haptics ?? this.haptics,
      notifyMorning: notifyMorning ?? this.notifyMorning,
      notifyAdventure: notifyAdventure ?? this.notifyAdventure,
      notifyEvening: notifyEvening ?? this.notifyEvening,
      onboardingStep: onboardingStep ?? this.onboardingStep,
      onboardingDoneAt: onboardingDoneAt ?? this.onboardingDoneAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (installId.present) {
      map['install_id'] = Variable<String>(installId.value);
    }
    if (userName.present) {
      map['user_name'] = Variable<String>(userName.value);
    }
    if (wakeTime.present) {
      map['wake_time'] = Variable<String>(wakeTime.value);
    }
    if (bedTime.present) {
      map['bed_time'] = Variable<String>(bedTime.value);
    }
    if (dayStartHour.present) {
      map['day_start_hour'] = Variable<int>(dayStartHour.value);
    }
    if (moodCheckInMode.present) {
      map['mood_check_in_mode'] = Variable<String>(moodCheckInMode.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (reduceMotion.present) {
      map['reduce_motion'] = Variable<bool>(reduceMotion.value);
    }
    if (sound.present) {
      map['sound'] = Variable<bool>(sound.value);
    }
    if (haptics.present) {
      map['haptics'] = Variable<bool>(haptics.value);
    }
    if (notifyMorning.present) {
      map['notify_morning'] = Variable<bool>(notifyMorning.value);
    }
    if (notifyAdventure.present) {
      map['notify_adventure'] = Variable<bool>(notifyAdventure.value);
    }
    if (notifyEvening.present) {
      map['notify_evening'] = Variable<bool>(notifyEvening.value);
    }
    if (onboardingStep.present) {
      map['onboarding_step'] = Variable<String>(onboardingStep.value);
    }
    if (onboardingDoneAt.present) {
      map['onboarding_done_at'] = Variable<DateTime>(onboardingDoneAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('installId: $installId, ')
          ..write('userName: $userName, ')
          ..write('wakeTime: $wakeTime, ')
          ..write('bedTime: $bedTime, ')
          ..write('dayStartHour: $dayStartHour, ')
          ..write('moodCheckInMode: $moodCheckInMode, ')
          ..write('paused: $paused, ')
          ..write('reduceMotion: $reduceMotion, ')
          ..write('sound: $sound, ')
          ..write('haptics: $haptics, ')
          ..write('notifyMorning: $notifyMorning, ')
          ..write('notifyAdventure: $notifyAdventure, ')
          ..write('notifyEvening: $notifyEvening, ')
          ..write('onboardingStep: $onboardingStep, ')
          ..write('onboardingDoneAt: $onboardingDoneAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PetsTable extends Pets with TableInfo<$PetsTable, Pet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
  static const VerificationMeta _pronounsMeta = const VerificationMeta(
    'pronouns',
  );
  @override
  late final GeneratedColumn<String> pronouns = GeneratedColumn<String>(
    'pronouns',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eggColorMeta = const VerificationMeta(
    'eggColor',
  );
  @override
  late final GeneratedColumn<String> eggColor = GeneratedColumn<String>(
    'egg_color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _traitMeta = const VerificationMeta('trait');
  @override
  late final GeneratedColumn<String> trait = GeneratedColumn<String>(
    'trait',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _traitStatsMeta = const VerificationMeta(
    'traitStats',
  );
  @override
  late final GeneratedColumn<String> traitStats = GeneratedColumn<String>(
    'trait_stats',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _hatchedAtMeta = const VerificationMeta(
    'hatchedAt',
  );
  @override
  late final GeneratedColumn<DateTime> hatchedAt = GeneratedColumn<DateTime>(
    'hatched_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    pronouns,
    eggColor,
    trait,
    traitStats,
    hatchedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Pet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('pronouns')) {
      context.handle(
        _pronounsMeta,
        pronouns.isAcceptableOrUnknown(data['pronouns']!, _pronounsMeta),
      );
    } else if (isInserting) {
      context.missing(_pronounsMeta);
    }
    if (data.containsKey('egg_color')) {
      context.handle(
        _eggColorMeta,
        eggColor.isAcceptableOrUnknown(data['egg_color']!, _eggColorMeta),
      );
    } else if (isInserting) {
      context.missing(_eggColorMeta);
    }
    if (data.containsKey('trait')) {
      context.handle(
        _traitMeta,
        trait.isAcceptableOrUnknown(data['trait']!, _traitMeta),
      );
    } else if (isInserting) {
      context.missing(_traitMeta);
    }
    if (data.containsKey('trait_stats')) {
      context.handle(
        _traitStatsMeta,
        traitStats.isAcceptableOrUnknown(data['trait_stats']!, _traitStatsMeta),
      );
    }
    if (data.containsKey('hatched_at')) {
      context.handle(
        _hatchedAtMeta,
        hatchedAt.isAcceptableOrUnknown(data['hatched_at']!, _hatchedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_hatchedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      pronouns: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pronouns'],
      )!,
      eggColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}egg_color'],
      )!,
      trait: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trait'],
      )!,
      traitStats: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}trait_stats'],
      )!,
      hatchedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}hatched_at'],
      )!,
    );
  }

  @override
  $PetsTable createAlias(String alias) {
    return $PetsTable(attachedDatabase, alias);
  }
}

class Pet extends DataClass implements Insertable<Pet> {
  final int id;
  final String name;

  /// A `Pronouns` name: `she`, `he` or `they`.
  final String pronouns;
  final String eggColor;

  /// The `Trait` name chosen in onboarding.
  final String trait;

  /// JSON map of trait name to score.
  final String traitStats;
  final DateTime hatchedAt;
  const Pet({
    required this.id,
    required this.name,
    required this.pronouns,
    required this.eggColor,
    required this.trait,
    required this.traitStats,
    required this.hatchedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['pronouns'] = Variable<String>(pronouns);
    map['egg_color'] = Variable<String>(eggColor);
    map['trait'] = Variable<String>(trait);
    map['trait_stats'] = Variable<String>(traitStats);
    map['hatched_at'] = Variable<DateTime>(hatchedAt);
    return map;
  }

  PetsCompanion toCompanion(bool nullToAbsent) {
    return PetsCompanion(
      id: Value(id),
      name: Value(name),
      pronouns: Value(pronouns),
      eggColor: Value(eggColor),
      trait: Value(trait),
      traitStats: Value(traitStats),
      hatchedAt: Value(hatchedAt),
    );
  }

  factory Pet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pet(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      pronouns: serializer.fromJson<String>(json['pronouns']),
      eggColor: serializer.fromJson<String>(json['eggColor']),
      trait: serializer.fromJson<String>(json['trait']),
      traitStats: serializer.fromJson<String>(json['traitStats']),
      hatchedAt: serializer.fromJson<DateTime>(json['hatchedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'pronouns': serializer.toJson<String>(pronouns),
      'eggColor': serializer.toJson<String>(eggColor),
      'trait': serializer.toJson<String>(trait),
      'traitStats': serializer.toJson<String>(traitStats),
      'hatchedAt': serializer.toJson<DateTime>(hatchedAt),
    };
  }

  Pet copyWith({
    int? id,
    String? name,
    String? pronouns,
    String? eggColor,
    String? trait,
    String? traitStats,
    DateTime? hatchedAt,
  }) => Pet(
    id: id ?? this.id,
    name: name ?? this.name,
    pronouns: pronouns ?? this.pronouns,
    eggColor: eggColor ?? this.eggColor,
    trait: trait ?? this.trait,
    traitStats: traitStats ?? this.traitStats,
    hatchedAt: hatchedAt ?? this.hatchedAt,
  );
  Pet copyWithCompanion(PetsCompanion data) {
    return Pet(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      pronouns: data.pronouns.present ? data.pronouns.value : this.pronouns,
      eggColor: data.eggColor.present ? data.eggColor.value : this.eggColor,
      trait: data.trait.present ? data.trait.value : this.trait,
      traitStats: data.traitStats.present
          ? data.traitStats.value
          : this.traitStats,
      hatchedAt: data.hatchedAt.present ? data.hatchedAt.value : this.hatchedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Pet(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pronouns: $pronouns, ')
          ..write('eggColor: $eggColor, ')
          ..write('trait: $trait, ')
          ..write('traitStats: $traitStats, ')
          ..write('hatchedAt: $hatchedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, pronouns, eggColor, trait, traitStats, hatchedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pet &&
          other.id == this.id &&
          other.name == this.name &&
          other.pronouns == this.pronouns &&
          other.eggColor == this.eggColor &&
          other.trait == this.trait &&
          other.traitStats == this.traitStats &&
          other.hatchedAt == this.hatchedAt);
}

class PetsCompanion extends UpdateCompanion<Pet> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> pronouns;
  final Value<String> eggColor;
  final Value<String> trait;
  final Value<String> traitStats;
  final Value<DateTime> hatchedAt;
  const PetsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.pronouns = const Value.absent(),
    this.eggColor = const Value.absent(),
    this.trait = const Value.absent(),
    this.traitStats = const Value.absent(),
    this.hatchedAt = const Value.absent(),
  });
  PetsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String pronouns,
    required String eggColor,
    required String trait,
    this.traitStats = const Value.absent(),
    required DateTime hatchedAt,
  }) : name = Value(name),
       pronouns = Value(pronouns),
       eggColor = Value(eggColor),
       trait = Value(trait),
       hatchedAt = Value(hatchedAt);
  static Insertable<Pet> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? pronouns,
    Expression<String>? eggColor,
    Expression<String>? trait,
    Expression<String>? traitStats,
    Expression<DateTime>? hatchedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (pronouns != null) 'pronouns': pronouns,
      if (eggColor != null) 'egg_color': eggColor,
      if (trait != null) 'trait': trait,
      if (traitStats != null) 'trait_stats': traitStats,
      if (hatchedAt != null) 'hatched_at': hatchedAt,
    });
  }

  PetsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? pronouns,
    Value<String>? eggColor,
    Value<String>? trait,
    Value<String>? traitStats,
    Value<DateTime>? hatchedAt,
  }) {
    return PetsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      pronouns: pronouns ?? this.pronouns,
      eggColor: eggColor ?? this.eggColor,
      trait: trait ?? this.trait,
      traitStats: traitStats ?? this.traitStats,
      hatchedAt: hatchedAt ?? this.hatchedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (pronouns.present) {
      map['pronouns'] = Variable<String>(pronouns.value);
    }
    if (eggColor.present) {
      map['egg_color'] = Variable<String>(eggColor.value);
    }
    if (trait.present) {
      map['trait'] = Variable<String>(trait.value);
    }
    if (traitStats.present) {
      map['trait_stats'] = Variable<String>(traitStats.value);
    }
    if (hatchedAt.present) {
      map['hatched_at'] = Variable<DateTime>(hatchedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PetsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('pronouns: $pronouns, ')
          ..write('eggColor: $eggColor, ')
          ..write('trait: $trait, ')
          ..write('traitStats: $traitStats, ')
          ..write('hatchedAt: $hatchedAt')
          ..write(')'))
        .toString();
  }
}

class $OnboardingAnswersTable extends OnboardingAnswers
    with TableInfo<$OnboardingAnswersTable, OnboardingAnswer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OnboardingAnswersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _questionIdMeta = const VerificationMeta(
    'questionId',
  );
  @override
  late final GeneratedColumn<String> questionId = GeneratedColumn<String>(
    'question_id',
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
  static const VerificationMeta _answeredAtMeta = const VerificationMeta(
    'answeredAt',
  );
  @override
  late final GeneratedColumn<DateTime> answeredAt = GeneratedColumn<DateTime>(
    'answered_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [questionId, value, answeredAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'onboarding_answers';
  @override
  VerificationContext validateIntegrity(
    Insertable<OnboardingAnswer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('question_id')) {
      context.handle(
        _questionIdMeta,
        questionId.isAcceptableOrUnknown(data['question_id']!, _questionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_questionIdMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('answered_at')) {
      context.handle(
        _answeredAtMeta,
        answeredAt.isAcceptableOrUnknown(data['answered_at']!, _answeredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_answeredAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {questionId};
  @override
  OnboardingAnswer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OnboardingAnswer(
      questionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}question_id'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      answeredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}answered_at'],
      )!,
    );
  }

  @override
  $OnboardingAnswersTable createAlias(String alias) {
    return $OnboardingAnswersTable(attachedDatabase, alias);
  }
}

class OnboardingAnswer extends DataClass
    implements Insertable<OnboardingAnswer> {
  final String questionId;

  /// JSON: a string or a list of strings.
  final String value;
  final DateTime answeredAt;
  const OnboardingAnswer({
    required this.questionId,
    required this.value,
    required this.answeredAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['question_id'] = Variable<String>(questionId);
    map['value'] = Variable<String>(value);
    map['answered_at'] = Variable<DateTime>(answeredAt);
    return map;
  }

  OnboardingAnswersCompanion toCompanion(bool nullToAbsent) {
    return OnboardingAnswersCompanion(
      questionId: Value(questionId),
      value: Value(value),
      answeredAt: Value(answeredAt),
    );
  }

  factory OnboardingAnswer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OnboardingAnswer(
      questionId: serializer.fromJson<String>(json['questionId']),
      value: serializer.fromJson<String>(json['value']),
      answeredAt: serializer.fromJson<DateTime>(json['answeredAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'questionId': serializer.toJson<String>(questionId),
      'value': serializer.toJson<String>(value),
      'answeredAt': serializer.toJson<DateTime>(answeredAt),
    };
  }

  OnboardingAnswer copyWith({
    String? questionId,
    String? value,
    DateTime? answeredAt,
  }) => OnboardingAnswer(
    questionId: questionId ?? this.questionId,
    value: value ?? this.value,
    answeredAt: answeredAt ?? this.answeredAt,
  );
  OnboardingAnswer copyWithCompanion(OnboardingAnswersCompanion data) {
    return OnboardingAnswer(
      questionId: data.questionId.present
          ? data.questionId.value
          : this.questionId,
      value: data.value.present ? data.value.value : this.value,
      answeredAt: data.answeredAt.present
          ? data.answeredAt.value
          : this.answeredAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingAnswer(')
          ..write('questionId: $questionId, ')
          ..write('value: $value, ')
          ..write('answeredAt: $answeredAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(questionId, value, answeredAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OnboardingAnswer &&
          other.questionId == this.questionId &&
          other.value == this.value &&
          other.answeredAt == this.answeredAt);
}

class OnboardingAnswersCompanion extends UpdateCompanion<OnboardingAnswer> {
  final Value<String> questionId;
  final Value<String> value;
  final Value<DateTime> answeredAt;
  final Value<int> rowid;
  const OnboardingAnswersCompanion({
    this.questionId = const Value.absent(),
    this.value = const Value.absent(),
    this.answeredAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OnboardingAnswersCompanion.insert({
    required String questionId,
    required String value,
    required DateTime answeredAt,
    this.rowid = const Value.absent(),
  }) : questionId = Value(questionId),
       value = Value(value),
       answeredAt = Value(answeredAt);
  static Insertable<OnboardingAnswer> custom({
    Expression<String>? questionId,
    Expression<String>? value,
    Expression<DateTime>? answeredAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (questionId != null) 'question_id': questionId,
      if (value != null) 'value': value,
      if (answeredAt != null) 'answered_at': answeredAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OnboardingAnswersCompanion copyWith({
    Value<String>? questionId,
    Value<String>? value,
    Value<DateTime>? answeredAt,
    Value<int>? rowid,
  }) {
    return OnboardingAnswersCompanion(
      questionId: questionId ?? this.questionId,
      value: value ?? this.value,
      answeredAt: answeredAt ?? this.answeredAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (questionId.present) {
      map['question_id'] = Variable<String>(questionId.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (answeredAt.present) {
      map['answered_at'] = Variable<DateTime>(answeredAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OnboardingAnswersCompanion(')
          ..write('questionId: $questionId, ')
          ..write('value: $value, ')
          ..write('answeredAt: $answeredAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
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
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaMeta = const VerificationMeta('area');
  @override
  late final GeneratedColumn<String> area = GeneratedColumn<String>(
    'area',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sectionMeta = const VerificationMeta(
    'section',
  );
  @override
  late final GeneratedColumn<String> section = GeneratedColumn<String>(
    'section',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weekdaysMaskMeta = const VerificationMeta(
    'weekdaysMask',
  );
  @override
  late final GeneratedColumn<int> weekdaysMask = GeneratedColumn<int>(
    'weekdays_mask',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(127),
  );
  static const VerificationMeta _timesPerDayMeta = const VerificationMeta(
    'timesPerDay',
  );
  @override
  late final GeneratedColumn<int> timesPerDay = GeneratedColumn<int>(
    'times_per_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _essentialMeta = const VerificationMeta(
    'essential',
  );
  @override
  late final GeneratedColumn<bool> essential = GeneratedColumn<bool>(
    'essential',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("essential" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
    'reminder_time',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _libraryIdMeta = const VerificationMeta(
    'libraryId',
  );
  @override
  late final GeneratedColumn<String> libraryId = GeneratedColumn<String>(
    'library_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedAtMeta = const VerificationMeta(
    'archivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> archivedAt = GeneratedColumn<DateTime>(
    'archived_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    icon,
    area,
    section,
    weekdaysMask,
    timesPerDay,
    essential,
    reminderTime,
    sortOrder,
    libraryId,
    archivedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('area')) {
      context.handle(
        _areaMeta,
        area.isAcceptableOrUnknown(data['area']!, _areaMeta),
      );
    } else if (isInserting) {
      context.missing(_areaMeta);
    }
    if (data.containsKey('section')) {
      context.handle(
        _sectionMeta,
        section.isAcceptableOrUnknown(data['section']!, _sectionMeta),
      );
    } else if (isInserting) {
      context.missing(_sectionMeta);
    }
    if (data.containsKey('weekdays_mask')) {
      context.handle(
        _weekdaysMaskMeta,
        weekdaysMask.isAcceptableOrUnknown(
          data['weekdays_mask']!,
          _weekdaysMaskMeta,
        ),
      );
    }
    if (data.containsKey('times_per_day')) {
      context.handle(
        _timesPerDayMeta,
        timesPerDay.isAcceptableOrUnknown(
          data['times_per_day']!,
          _timesPerDayMeta,
        ),
      );
    }
    if (data.containsKey('essential')) {
      context.handle(
        _essentialMeta,
        essential.isAcceptableOrUnknown(data['essential']!, _essentialMeta),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('library_id')) {
      context.handle(
        _libraryIdMeta,
        libraryId.isAcceptableOrUnknown(data['library_id']!, _libraryIdMeta),
      );
    }
    if (data.containsKey('archived_at')) {
      context.handle(
        _archivedAtMeta,
        archivedAt.isAcceptableOrUnknown(data['archived_at']!, _archivedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      area: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area'],
      )!,
      section: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}section'],
      )!,
      weekdaysMask: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays_mask'],
      )!,
      timesPerDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}times_per_day'],
      )!,
      essential: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}essential'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_time'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      libraryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}library_id'],
      ),
      archivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}archived_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final int id;
  final String title;

  /// An emoji.
  final String icon;
  final String area;

  /// A `GoalSection` id: `start_day`, `any_time` or `end_day`.
  final String section;

  /// Bit 0 = Monday … bit 6 = Sunday; 127 = every day.
  final int weekdaysMask;
  final int timesPerDay;
  final bool essential;

  /// `HH:mm`, or null for no reminder.
  final String? reminderTime;
  final int sortOrder;

  /// The `GoalTemplate` id this came from, if any.
  final String? libraryId;
  final DateTime? archivedAt;
  final DateTime createdAt;
  const Goal({
    required this.id,
    required this.title,
    required this.icon,
    required this.area,
    required this.section,
    required this.weekdaysMask,
    required this.timesPerDay,
    required this.essential,
    this.reminderTime,
    required this.sortOrder,
    this.libraryId,
    this.archivedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['icon'] = Variable<String>(icon);
    map['area'] = Variable<String>(area);
    map['section'] = Variable<String>(section);
    map['weekdays_mask'] = Variable<int>(weekdaysMask);
    map['times_per_day'] = Variable<int>(timesPerDay);
    map['essential'] = Variable<bool>(essential);
    if (!nullToAbsent || reminderTime != null) {
      map['reminder_time'] = Variable<String>(reminderTime);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || libraryId != null) {
      map['library_id'] = Variable<String>(libraryId);
    }
    if (!nullToAbsent || archivedAt != null) {
      map['archived_at'] = Variable<DateTime>(archivedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      title: Value(title),
      icon: Value(icon),
      area: Value(area),
      section: Value(section),
      weekdaysMask: Value(weekdaysMask),
      timesPerDay: Value(timesPerDay),
      essential: Value(essential),
      reminderTime: reminderTime == null && nullToAbsent
          ? const Value.absent()
          : Value(reminderTime),
      sortOrder: Value(sortOrder),
      libraryId: libraryId == null && nullToAbsent
          ? const Value.absent()
          : Value(libraryId),
      archivedAt: archivedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(archivedAt),
      createdAt: Value(createdAt),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      icon: serializer.fromJson<String>(json['icon']),
      area: serializer.fromJson<String>(json['area']),
      section: serializer.fromJson<String>(json['section']),
      weekdaysMask: serializer.fromJson<int>(json['weekdaysMask']),
      timesPerDay: serializer.fromJson<int>(json['timesPerDay']),
      essential: serializer.fromJson<bool>(json['essential']),
      reminderTime: serializer.fromJson<String?>(json['reminderTime']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      libraryId: serializer.fromJson<String?>(json['libraryId']),
      archivedAt: serializer.fromJson<DateTime?>(json['archivedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'icon': serializer.toJson<String>(icon),
      'area': serializer.toJson<String>(area),
      'section': serializer.toJson<String>(section),
      'weekdaysMask': serializer.toJson<int>(weekdaysMask),
      'timesPerDay': serializer.toJson<int>(timesPerDay),
      'essential': serializer.toJson<bool>(essential),
      'reminderTime': serializer.toJson<String?>(reminderTime),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'libraryId': serializer.toJson<String?>(libraryId),
      'archivedAt': serializer.toJson<DateTime?>(archivedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Goal copyWith({
    int? id,
    String? title,
    String? icon,
    String? area,
    String? section,
    int? weekdaysMask,
    int? timesPerDay,
    bool? essential,
    Value<String?> reminderTime = const Value.absent(),
    int? sortOrder,
    Value<String?> libraryId = const Value.absent(),
    Value<DateTime?> archivedAt = const Value.absent(),
    DateTime? createdAt,
  }) => Goal(
    id: id ?? this.id,
    title: title ?? this.title,
    icon: icon ?? this.icon,
    area: area ?? this.area,
    section: section ?? this.section,
    weekdaysMask: weekdaysMask ?? this.weekdaysMask,
    timesPerDay: timesPerDay ?? this.timesPerDay,
    essential: essential ?? this.essential,
    reminderTime: reminderTime.present ? reminderTime.value : this.reminderTime,
    sortOrder: sortOrder ?? this.sortOrder,
    libraryId: libraryId.present ? libraryId.value : this.libraryId,
    archivedAt: archivedAt.present ? archivedAt.value : this.archivedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      icon: data.icon.present ? data.icon.value : this.icon,
      area: data.area.present ? data.area.value : this.area,
      section: data.section.present ? data.section.value : this.section,
      weekdaysMask: data.weekdaysMask.present
          ? data.weekdaysMask.value
          : this.weekdaysMask,
      timesPerDay: data.timesPerDay.present
          ? data.timesPerDay.value
          : this.timesPerDay,
      essential: data.essential.present ? data.essential.value : this.essential,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      libraryId: data.libraryId.present ? data.libraryId.value : this.libraryId,
      archivedAt: data.archivedAt.present
          ? data.archivedAt.value
          : this.archivedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('area: $area, ')
          ..write('section: $section, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('essential: $essential, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('libraryId: $libraryId, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    icon,
    area,
    section,
    weekdaysMask,
    timesPerDay,
    essential,
    reminderTime,
    sortOrder,
    libraryId,
    archivedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.title == this.title &&
          other.icon == this.icon &&
          other.area == this.area &&
          other.section == this.section &&
          other.weekdaysMask == this.weekdaysMask &&
          other.timesPerDay == this.timesPerDay &&
          other.essential == this.essential &&
          other.reminderTime == this.reminderTime &&
          other.sortOrder == this.sortOrder &&
          other.libraryId == this.libraryId &&
          other.archivedAt == this.archivedAt &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> icon;
  final Value<String> area;
  final Value<String> section;
  final Value<int> weekdaysMask;
  final Value<int> timesPerDay;
  final Value<bool> essential;
  final Value<String?> reminderTime;
  final Value<int> sortOrder;
  final Value<String?> libraryId;
  final Value<DateTime?> archivedAt;
  final Value<DateTime> createdAt;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.icon = const Value.absent(),
    this.area = const Value.absent(),
    this.section = const Value.absent(),
    this.weekdaysMask = const Value.absent(),
    this.timesPerDay = const Value.absent(),
    this.essential = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.libraryId = const Value.absent(),
    this.archivedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  GoalsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String icon,
    required String area,
    required String section,
    this.weekdaysMask = const Value.absent(),
    this.timesPerDay = const Value.absent(),
    this.essential = const Value.absent(),
    this.reminderTime = const Value.absent(),
    required int sortOrder,
    this.libraryId = const Value.absent(),
    this.archivedAt = const Value.absent(),
    required DateTime createdAt,
  }) : title = Value(title),
       icon = Value(icon),
       area = Value(area),
       section = Value(section),
       sortOrder = Value(sortOrder),
       createdAt = Value(createdAt);
  static Insertable<Goal> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? icon,
    Expression<String>? area,
    Expression<String>? section,
    Expression<int>? weekdaysMask,
    Expression<int>? timesPerDay,
    Expression<bool>? essential,
    Expression<String>? reminderTime,
    Expression<int>? sortOrder,
    Expression<String>? libraryId,
    Expression<DateTime>? archivedAt,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (icon != null) 'icon': icon,
      if (area != null) 'area': area,
      if (section != null) 'section': section,
      if (weekdaysMask != null) 'weekdays_mask': weekdaysMask,
      if (timesPerDay != null) 'times_per_day': timesPerDay,
      if (essential != null) 'essential': essential,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (libraryId != null) 'library_id': libraryId,
      if (archivedAt != null) 'archived_at': archivedAt,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  GoalsCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String>? icon,
    Value<String>? area,
    Value<String>? section,
    Value<int>? weekdaysMask,
    Value<int>? timesPerDay,
    Value<bool>? essential,
    Value<String?>? reminderTime,
    Value<int>? sortOrder,
    Value<String?>? libraryId,
    Value<DateTime?>? archivedAt,
    Value<DateTime>? createdAt,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      area: area ?? this.area,
      section: section ?? this.section,
      weekdaysMask: weekdaysMask ?? this.weekdaysMask,
      timesPerDay: timesPerDay ?? this.timesPerDay,
      essential: essential ?? this.essential,
      reminderTime: reminderTime ?? this.reminderTime,
      sortOrder: sortOrder ?? this.sortOrder,
      libraryId: libraryId ?? this.libraryId,
      archivedAt: archivedAt ?? this.archivedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (area.present) {
      map['area'] = Variable<String>(area.value);
    }
    if (section.present) {
      map['section'] = Variable<String>(section.value);
    }
    if (weekdaysMask.present) {
      map['weekdays_mask'] = Variable<int>(weekdaysMask.value);
    }
    if (timesPerDay.present) {
      map['times_per_day'] = Variable<int>(timesPerDay.value);
    }
    if (essential.present) {
      map['essential'] = Variable<bool>(essential.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (libraryId.present) {
      map['library_id'] = Variable<String>(libraryId.value);
    }
    if (archivedAt.present) {
      map['archived_at'] = Variable<DateTime>(archivedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('icon: $icon, ')
          ..write('area: $area, ')
          ..write('section: $section, ')
          ..write('weekdaysMask: $weekdaysMask, ')
          ..write('timesPerDay: $timesPerDay, ')
          ..write('essential: $essential, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('libraryId: $libraryId, ')
          ..write('archivedAt: $archivedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CompletionsTable extends Completions
    with TableInfo<$CompletionsTable, Completion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appDayMeta = const VerificationMeta('appDay');
  @override
  late final GeneratedColumn<String> appDay = GeneratedColumn<String>(
    'app_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, goalId, appDay, completedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Completion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('app_day')) {
      context.handle(
        _appDayMeta,
        appDay.isAcceptableOrUnknown(data['app_day']!, _appDayMeta),
      );
    } else if (isInserting) {
      context.missing(_appDayMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_completedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Completion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Completion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      appDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_day'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      )!,
    );
  }

  @override
  $CompletionsTable createAlias(String alias) {
    return $CompletionsTable(attachedDatabase, alias);
  }
}

class Completion extends DataClass implements Insertable<Completion> {
  final int id;
  final int goalId;

  /// `AppDay.key` of the day it counts for.
  final String appDay;
  final DateTime completedAt;
  const Completion({
    required this.id,
    required this.goalId,
    required this.appDay,
    required this.completedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['goal_id'] = Variable<int>(goalId);
    map['app_day'] = Variable<String>(appDay);
    map['completed_at'] = Variable<DateTime>(completedAt);
    return map;
  }

  CompletionsCompanion toCompanion(bool nullToAbsent) {
    return CompletionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      appDay: Value(appDay),
      completedAt: Value(completedAt),
    );
  }

  factory Completion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Completion(
      id: serializer.fromJson<int>(json['id']),
      goalId: serializer.fromJson<int>(json['goalId']),
      appDay: serializer.fromJson<String>(json['appDay']),
      completedAt: serializer.fromJson<DateTime>(json['completedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'goalId': serializer.toJson<int>(goalId),
      'appDay': serializer.toJson<String>(appDay),
      'completedAt': serializer.toJson<DateTime>(completedAt),
    };
  }

  Completion copyWith({
    int? id,
    int? goalId,
    String? appDay,
    DateTime? completedAt,
  }) => Completion(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    appDay: appDay ?? this.appDay,
    completedAt: completedAt ?? this.completedAt,
  );
  Completion copyWithCompanion(CompletionsCompanion data) {
    return Completion(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      appDay: data.appDay.present ? data.appDay.value : this.appDay,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Completion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('appDay: $appDay, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, appDay, completedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Completion &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.appDay == this.appDay &&
          other.completedAt == this.completedAt);
}

class CompletionsCompanion extends UpdateCompanion<Completion> {
  final Value<int> id;
  final Value<int> goalId;
  final Value<String> appDay;
  final Value<DateTime> completedAt;
  const CompletionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.appDay = const Value.absent(),
    this.completedAt = const Value.absent(),
  });
  CompletionsCompanion.insert({
    this.id = const Value.absent(),
    required int goalId,
    required String appDay,
    required DateTime completedAt,
  }) : goalId = Value(goalId),
       appDay = Value(appDay),
       completedAt = Value(completedAt);
  static Insertable<Completion> custom({
    Expression<int>? id,
    Expression<int>? goalId,
    Expression<String>? appDay,
    Expression<DateTime>? completedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (appDay != null) 'app_day': appDay,
      if (completedAt != null) 'completed_at': completedAt,
    });
  }

  CompletionsCompanion copyWith({
    Value<int>? id,
    Value<int>? goalId,
    Value<String>? appDay,
    Value<DateTime>? completedAt,
  }) {
    return CompletionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      appDay: appDay ?? this.appDay,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (appDay.present) {
      map['app_day'] = Variable<String>(appDay.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CompletionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('appDay: $appDay, ')
          ..write('completedAt: $completedAt')
          ..write(')'))
        .toString();
  }
}

class $SkipsTable extends Skips with TableInfo<$SkipsTable, Skip> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SkipsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<int> goalId = GeneratedColumn<int>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appDayMeta = const VerificationMeta('appDay');
  @override
  late final GeneratedColumn<String> appDay = GeneratedColumn<String>(
    'app_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [goalId, appDay];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'skips';
  @override
  VerificationContext validateIntegrity(
    Insertable<Skip> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('app_day')) {
      context.handle(
        _appDayMeta,
        appDay.isAcceptableOrUnknown(data['app_day']!, _appDayMeta),
      );
    } else if (isInserting) {
      context.missing(_appDayMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {goalId, appDay};
  @override
  Skip map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Skip(
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}goal_id'],
      )!,
      appDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_day'],
      )!,
    );
  }

  @override
  $SkipsTable createAlias(String alias) {
    return $SkipsTable(attachedDatabase, alias);
  }
}

class Skip extends DataClass implements Insertable<Skip> {
  final int goalId;
  final String appDay;
  const Skip({required this.goalId, required this.appDay});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['goal_id'] = Variable<int>(goalId);
    map['app_day'] = Variable<String>(appDay);
    return map;
  }

  SkipsCompanion toCompanion(bool nullToAbsent) {
    return SkipsCompanion(goalId: Value(goalId), appDay: Value(appDay));
  }

  factory Skip.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Skip(
      goalId: serializer.fromJson<int>(json['goalId']),
      appDay: serializer.fromJson<String>(json['appDay']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'goalId': serializer.toJson<int>(goalId),
      'appDay': serializer.toJson<String>(appDay),
    };
  }

  Skip copyWith({int? goalId, String? appDay}) =>
      Skip(goalId: goalId ?? this.goalId, appDay: appDay ?? this.appDay);
  Skip copyWithCompanion(SkipsCompanion data) {
    return Skip(
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      appDay: data.appDay.present ? data.appDay.value : this.appDay,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Skip(')
          ..write('goalId: $goalId, ')
          ..write('appDay: $appDay')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(goalId, appDay);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Skip &&
          other.goalId == this.goalId &&
          other.appDay == this.appDay);
}

class SkipsCompanion extends UpdateCompanion<Skip> {
  final Value<int> goalId;
  final Value<String> appDay;
  final Value<int> rowid;
  const SkipsCompanion({
    this.goalId = const Value.absent(),
    this.appDay = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SkipsCompanion.insert({
    required int goalId,
    required String appDay,
    this.rowid = const Value.absent(),
  }) : goalId = Value(goalId),
       appDay = Value(appDay);
  static Insertable<Skip> custom({
    Expression<int>? goalId,
    Expression<String>? appDay,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (goalId != null) 'goal_id': goalId,
      if (appDay != null) 'app_day': appDay,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SkipsCompanion copyWith({
    Value<int>? goalId,
    Value<String>? appDay,
    Value<int>? rowid,
  }) {
    return SkipsCompanion(
      goalId: goalId ?? this.goalId,
      appDay: appDay ?? this.appDay,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (goalId.present) {
      map['goal_id'] = Variable<int>(goalId.value);
    }
    if (appDay.present) {
      map['app_day'] = Variable<String>(appDay.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SkipsCompanion(')
          ..write('goalId: $goalId, ')
          ..write('appDay: $appDay, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DaysTable extends Days with TableInfo<$DaysTable, Day> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _appDayMeta = const VerificationMeta('appDay');
  @override
  late final GeneratedColumn<String> appDay = GeneratedColumn<String>(
    'app_day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lowEnergyMeta = const VerificationMeta(
    'lowEnergy',
  );
  @override
  late final GeneratedColumn<bool> lowEnergy = GeneratedColumn<bool>(
    'low_energy',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("low_energy" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _adventureStartedAtMeta =
      const VerificationMeta('adventureStartedAt');
  @override
  late final GeneratedColumn<DateTime> adventureStartedAt =
      GeneratedColumn<DateTime>(
        'adventure_started_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _adventureEndsAtMeta = const VerificationMeta(
    'adventureEndsAt',
  );
  @override
  late final GeneratedColumn<DateTime> adventureEndsAt =
      GeneratedColumn<DateTime>(
        'adventure_ends_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _storyIdMeta = const VerificationMeta(
    'storyId',
  );
  @override
  late final GeneratedColumn<String> storyId = GeneratedColumn<String>(
    'story_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _adventureClaimedMeta = const VerificationMeta(
    'adventureClaimed',
  );
  @override
  late final GeneratedColumn<bool> adventureClaimed = GeneratedColumn<bool>(
    'adventure_claimed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("adventure_claimed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _surpriseGivenMeta = const VerificationMeta(
    'surpriseGiven',
  );
  @override
  late final GeneratedColumn<bool> surpriseGiven = GeneratedColumn<bool>(
    'surprise_given',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("surprise_given" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    appDay,
    lowEnergy,
    adventureStartedAt,
    adventureEndsAt,
    storyId,
    adventureClaimed,
    surpriseGiven,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'days';
  @override
  VerificationContext validateIntegrity(
    Insertable<Day> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('app_day')) {
      context.handle(
        _appDayMeta,
        appDay.isAcceptableOrUnknown(data['app_day']!, _appDayMeta),
      );
    } else if (isInserting) {
      context.missing(_appDayMeta);
    }
    if (data.containsKey('low_energy')) {
      context.handle(
        _lowEnergyMeta,
        lowEnergy.isAcceptableOrUnknown(data['low_energy']!, _lowEnergyMeta),
      );
    }
    if (data.containsKey('adventure_started_at')) {
      context.handle(
        _adventureStartedAtMeta,
        adventureStartedAt.isAcceptableOrUnknown(
          data['adventure_started_at']!,
          _adventureStartedAtMeta,
        ),
      );
    }
    if (data.containsKey('adventure_ends_at')) {
      context.handle(
        _adventureEndsAtMeta,
        adventureEndsAt.isAcceptableOrUnknown(
          data['adventure_ends_at']!,
          _adventureEndsAtMeta,
        ),
      );
    }
    if (data.containsKey('story_id')) {
      context.handle(
        _storyIdMeta,
        storyId.isAcceptableOrUnknown(data['story_id']!, _storyIdMeta),
      );
    }
    if (data.containsKey('adventure_claimed')) {
      context.handle(
        _adventureClaimedMeta,
        adventureClaimed.isAcceptableOrUnknown(
          data['adventure_claimed']!,
          _adventureClaimedMeta,
        ),
      );
    }
    if (data.containsKey('surprise_given')) {
      context.handle(
        _surpriseGivenMeta,
        surpriseGiven.isAcceptableOrUnknown(
          data['surprise_given']!,
          _surpriseGivenMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {appDay};
  @override
  Day map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Day(
      appDay: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_day'],
      )!,
      lowEnergy: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}low_energy'],
      )!,
      adventureStartedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}adventure_started_at'],
      ),
      adventureEndsAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}adventure_ends_at'],
      ),
      storyId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story_id'],
      ),
      adventureClaimed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}adventure_claimed'],
      )!,
      surpriseGiven: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}surprise_given'],
      )!,
    );
  }

  @override
  $DaysTable createAlias(String alias) {
    return $DaysTable(attachedDatabase, alias);
  }
}

class Day extends DataClass implements Insertable<Day> {
  final String appDay;
  final bool lowEnergy;
  final DateTime? adventureStartedAt;
  final DateTime? adventureEndsAt;
  final String? storyId;
  final bool adventureClaimed;
  final bool surpriseGiven;
  const Day({
    required this.appDay,
    required this.lowEnergy,
    this.adventureStartedAt,
    this.adventureEndsAt,
    this.storyId,
    required this.adventureClaimed,
    required this.surpriseGiven,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['app_day'] = Variable<String>(appDay);
    map['low_energy'] = Variable<bool>(lowEnergy);
    if (!nullToAbsent || adventureStartedAt != null) {
      map['adventure_started_at'] = Variable<DateTime>(adventureStartedAt);
    }
    if (!nullToAbsent || adventureEndsAt != null) {
      map['adventure_ends_at'] = Variable<DateTime>(adventureEndsAt);
    }
    if (!nullToAbsent || storyId != null) {
      map['story_id'] = Variable<String>(storyId);
    }
    map['adventure_claimed'] = Variable<bool>(adventureClaimed);
    map['surprise_given'] = Variable<bool>(surpriseGiven);
    return map;
  }

  DaysCompanion toCompanion(bool nullToAbsent) {
    return DaysCompanion(
      appDay: Value(appDay),
      lowEnergy: Value(lowEnergy),
      adventureStartedAt: adventureStartedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(adventureStartedAt),
      adventureEndsAt: adventureEndsAt == null && nullToAbsent
          ? const Value.absent()
          : Value(adventureEndsAt),
      storyId: storyId == null && nullToAbsent
          ? const Value.absent()
          : Value(storyId),
      adventureClaimed: Value(adventureClaimed),
      surpriseGiven: Value(surpriseGiven),
    );
  }

  factory Day.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Day(
      appDay: serializer.fromJson<String>(json['appDay']),
      lowEnergy: serializer.fromJson<bool>(json['lowEnergy']),
      adventureStartedAt: serializer.fromJson<DateTime?>(
        json['adventureStartedAt'],
      ),
      adventureEndsAt: serializer.fromJson<DateTime?>(json['adventureEndsAt']),
      storyId: serializer.fromJson<String?>(json['storyId']),
      adventureClaimed: serializer.fromJson<bool>(json['adventureClaimed']),
      surpriseGiven: serializer.fromJson<bool>(json['surpriseGiven']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'appDay': serializer.toJson<String>(appDay),
      'lowEnergy': serializer.toJson<bool>(lowEnergy),
      'adventureStartedAt': serializer.toJson<DateTime?>(adventureStartedAt),
      'adventureEndsAt': serializer.toJson<DateTime?>(adventureEndsAt),
      'storyId': serializer.toJson<String?>(storyId),
      'adventureClaimed': serializer.toJson<bool>(adventureClaimed),
      'surpriseGiven': serializer.toJson<bool>(surpriseGiven),
    };
  }

  Day copyWith({
    String? appDay,
    bool? lowEnergy,
    Value<DateTime?> adventureStartedAt = const Value.absent(),
    Value<DateTime?> adventureEndsAt = const Value.absent(),
    Value<String?> storyId = const Value.absent(),
    bool? adventureClaimed,
    bool? surpriseGiven,
  }) => Day(
    appDay: appDay ?? this.appDay,
    lowEnergy: lowEnergy ?? this.lowEnergy,
    adventureStartedAt: adventureStartedAt.present
        ? adventureStartedAt.value
        : this.adventureStartedAt,
    adventureEndsAt: adventureEndsAt.present
        ? adventureEndsAt.value
        : this.adventureEndsAt,
    storyId: storyId.present ? storyId.value : this.storyId,
    adventureClaimed: adventureClaimed ?? this.adventureClaimed,
    surpriseGiven: surpriseGiven ?? this.surpriseGiven,
  );
  Day copyWithCompanion(DaysCompanion data) {
    return Day(
      appDay: data.appDay.present ? data.appDay.value : this.appDay,
      lowEnergy: data.lowEnergy.present ? data.lowEnergy.value : this.lowEnergy,
      adventureStartedAt: data.adventureStartedAt.present
          ? data.adventureStartedAt.value
          : this.adventureStartedAt,
      adventureEndsAt: data.adventureEndsAt.present
          ? data.adventureEndsAt.value
          : this.adventureEndsAt,
      storyId: data.storyId.present ? data.storyId.value : this.storyId,
      adventureClaimed: data.adventureClaimed.present
          ? data.adventureClaimed.value
          : this.adventureClaimed,
      surpriseGiven: data.surpriseGiven.present
          ? data.surpriseGiven.value
          : this.surpriseGiven,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Day(')
          ..write('appDay: $appDay, ')
          ..write('lowEnergy: $lowEnergy, ')
          ..write('adventureStartedAt: $adventureStartedAt, ')
          ..write('adventureEndsAt: $adventureEndsAt, ')
          ..write('storyId: $storyId, ')
          ..write('adventureClaimed: $adventureClaimed, ')
          ..write('surpriseGiven: $surpriseGiven')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    appDay,
    lowEnergy,
    adventureStartedAt,
    adventureEndsAt,
    storyId,
    adventureClaimed,
    surpriseGiven,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Day &&
          other.appDay == this.appDay &&
          other.lowEnergy == this.lowEnergy &&
          other.adventureStartedAt == this.adventureStartedAt &&
          other.adventureEndsAt == this.adventureEndsAt &&
          other.storyId == this.storyId &&
          other.adventureClaimed == this.adventureClaimed &&
          other.surpriseGiven == this.surpriseGiven);
}

class DaysCompanion extends UpdateCompanion<Day> {
  final Value<String> appDay;
  final Value<bool> lowEnergy;
  final Value<DateTime?> adventureStartedAt;
  final Value<DateTime?> adventureEndsAt;
  final Value<String?> storyId;
  final Value<bool> adventureClaimed;
  final Value<bool> surpriseGiven;
  final Value<int> rowid;
  const DaysCompanion({
    this.appDay = const Value.absent(),
    this.lowEnergy = const Value.absent(),
    this.adventureStartedAt = const Value.absent(),
    this.adventureEndsAt = const Value.absent(),
    this.storyId = const Value.absent(),
    this.adventureClaimed = const Value.absent(),
    this.surpriseGiven = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DaysCompanion.insert({
    required String appDay,
    this.lowEnergy = const Value.absent(),
    this.adventureStartedAt = const Value.absent(),
    this.adventureEndsAt = const Value.absent(),
    this.storyId = const Value.absent(),
    this.adventureClaimed = const Value.absent(),
    this.surpriseGiven = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : appDay = Value(appDay);
  static Insertable<Day> custom({
    Expression<String>? appDay,
    Expression<bool>? lowEnergy,
    Expression<DateTime>? adventureStartedAt,
    Expression<DateTime>? adventureEndsAt,
    Expression<String>? storyId,
    Expression<bool>? adventureClaimed,
    Expression<bool>? surpriseGiven,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (appDay != null) 'app_day': appDay,
      if (lowEnergy != null) 'low_energy': lowEnergy,
      if (adventureStartedAt != null)
        'adventure_started_at': adventureStartedAt,
      if (adventureEndsAt != null) 'adventure_ends_at': adventureEndsAt,
      if (storyId != null) 'story_id': storyId,
      if (adventureClaimed != null) 'adventure_claimed': adventureClaimed,
      if (surpriseGiven != null) 'surprise_given': surpriseGiven,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DaysCompanion copyWith({
    Value<String>? appDay,
    Value<bool>? lowEnergy,
    Value<DateTime?>? adventureStartedAt,
    Value<DateTime?>? adventureEndsAt,
    Value<String?>? storyId,
    Value<bool>? adventureClaimed,
    Value<bool>? surpriseGiven,
    Value<int>? rowid,
  }) {
    return DaysCompanion(
      appDay: appDay ?? this.appDay,
      lowEnergy: lowEnergy ?? this.lowEnergy,
      adventureStartedAt: adventureStartedAt ?? this.adventureStartedAt,
      adventureEndsAt: adventureEndsAt ?? this.adventureEndsAt,
      storyId: storyId ?? this.storyId,
      adventureClaimed: adventureClaimed ?? this.adventureClaimed,
      surpriseGiven: surpriseGiven ?? this.surpriseGiven,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (appDay.present) {
      map['app_day'] = Variable<String>(appDay.value);
    }
    if (lowEnergy.present) {
      map['low_energy'] = Variable<bool>(lowEnergy.value);
    }
    if (adventureStartedAt.present) {
      map['adventure_started_at'] = Variable<DateTime>(
        adventureStartedAt.value,
      );
    }
    if (adventureEndsAt.present) {
      map['adventure_ends_at'] = Variable<DateTime>(adventureEndsAt.value);
    }
    if (storyId.present) {
      map['story_id'] = Variable<String>(storyId.value);
    }
    if (adventureClaimed.present) {
      map['adventure_claimed'] = Variable<bool>(adventureClaimed.value);
    }
    if (surpriseGiven.present) {
      map['surprise_given'] = Variable<bool>(surpriseGiven.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DaysCompanion(')
          ..write('appDay: $appDay, ')
          ..write('lowEnergy: $lowEnergy, ')
          ..write('adventureStartedAt: $adventureStartedAt, ')
          ..write('adventureEndsAt: $adventureEndsAt, ')
          ..write('storyId: $storyId, ')
          ..write('adventureClaimed: $adventureClaimed, ')
          ..write('surpriseGiven: $surpriseGiven, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WalletLedgerTable extends WalletLedger
    with TableInfo<$WalletLedgerTable, WalletLedgerData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletLedgerTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _refIdMeta = const VerificationMeta('refId');
  @override
  late final GeneratedColumn<String> refId = GeneratedColumn<String>(
    'ref_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, amount, reason, refId, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_ledger';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletLedgerData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('ref_id')) {
      context.handle(
        _refIdMeta,
        refId.isAcceptableOrUnknown(data['ref_id']!, _refIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WalletLedgerData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletLedgerData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      refId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ref_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletLedgerTable createAlias(String alias) {
    return $WalletLedgerTable(attachedDatabase, alias);
  }
}

class WalletLedgerData extends DataClass
    implements Insertable<WalletLedgerData> {
  final int id;
  final int amount;

  /// `goal`, `goal_undo`, `surprise`, `adventure`, `milestone` or `purchase`.
  final String reason;
  final String? refId;
  final DateTime createdAt;
  const WalletLedgerData({
    required this.id,
    required this.amount,
    required this.reason,
    this.refId,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['amount'] = Variable<int>(amount);
    map['reason'] = Variable<String>(reason);
    if (!nullToAbsent || refId != null) {
      map['ref_id'] = Variable<String>(refId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletLedgerCompanion toCompanion(bool nullToAbsent) {
    return WalletLedgerCompanion(
      id: Value(id),
      amount: Value(amount),
      reason: Value(reason),
      refId: refId == null && nullToAbsent
          ? const Value.absent()
          : Value(refId),
      createdAt: Value(createdAt),
    );
  }

  factory WalletLedgerData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletLedgerData(
      id: serializer.fromJson<int>(json['id']),
      amount: serializer.fromJson<int>(json['amount']),
      reason: serializer.fromJson<String>(json['reason']),
      refId: serializer.fromJson<String?>(json['refId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'amount': serializer.toJson<int>(amount),
      'reason': serializer.toJson<String>(reason),
      'refId': serializer.toJson<String?>(refId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletLedgerData copyWith({
    int? id,
    int? amount,
    String? reason,
    Value<String?> refId = const Value.absent(),
    DateTime? createdAt,
  }) => WalletLedgerData(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    reason: reason ?? this.reason,
    refId: refId.present ? refId.value : this.refId,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletLedgerData copyWithCompanion(WalletLedgerCompanion data) {
    return WalletLedgerData(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      reason: data.reason.present ? data.reason.value : this.reason,
      refId: data.refId.present ? data.refId.value : this.refId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletLedgerData(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('refId: $refId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, amount, reason, refId, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletLedgerData &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.reason == this.reason &&
          other.refId == this.refId &&
          other.createdAt == this.createdAt);
}

class WalletLedgerCompanion extends UpdateCompanion<WalletLedgerData> {
  final Value<int> id;
  final Value<int> amount;
  final Value<String> reason;
  final Value<String?> refId;
  final Value<DateTime> createdAt;
  const WalletLedgerCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.reason = const Value.absent(),
    this.refId = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WalletLedgerCompanion.insert({
    this.id = const Value.absent(),
    required int amount,
    required String reason,
    this.refId = const Value.absent(),
    required DateTime createdAt,
  }) : amount = Value(amount),
       reason = Value(reason),
       createdAt = Value(createdAt);
  static Insertable<WalletLedgerData> custom({
    Expression<int>? id,
    Expression<int>? amount,
    Expression<String>? reason,
    Expression<String>? refId,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (reason != null) 'reason': reason,
      if (refId != null) 'ref_id': refId,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WalletLedgerCompanion copyWith({
    Value<int>? id,
    Value<int>? amount,
    Value<String>? reason,
    Value<String?>? refId,
    Value<DateTime>? createdAt,
  }) {
    return WalletLedgerCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      reason: reason ?? this.reason,
      refId: refId ?? this.refId,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (refId.present) {
      map['ref_id'] = Variable<String>(refId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletLedgerCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('reason: $reason, ')
          ..write('refId: $refId, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $PetsTable pets = $PetsTable(this);
  late final $OnboardingAnswersTable onboardingAnswers =
      $OnboardingAnswersTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $CompletionsTable completions = $CompletionsTable(this);
  late final $SkipsTable skips = $SkipsTable(this);
  late final $DaysTable days = $DaysTable(this);
  late final $WalletLedgerTable walletLedger = $WalletLedgerTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    profiles,
    pets,
    onboardingAnswers,
    goals,
    completions,
    skips,
    days,
    walletLedger,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  required String installId,
  Value<String> userName,
  Value<String> wakeTime,
  Value<String> bedTime,
  Value<int> dayStartHour,
  Value<String> moodCheckInMode,
  Value<bool> paused,
  Value<bool> reduceMotion,
  Value<bool> sound,
  Value<bool> haptics,
  Value<bool> notifyMorning,
  Value<bool> notifyAdventure,
  Value<bool> notifyEvening,
  Value<String?> onboardingStep,
  Value<DateTime?> onboardingDoneAt,
  required DateTime createdAt,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<int> id,
  Value<String> installId,
  Value<String> userName,
  Value<String> wakeTime,
  Value<String> bedTime,
  Value<int> dayStartHour,
  Value<String> moodCheckInMode,
  Value<bool> paused,
  Value<bool> reduceMotion,
  Value<bool> sound,
  Value<bool> haptics,
  Value<bool> notifyMorning,
  Value<bool> notifyAdventure,
  Value<bool> notifyEvening,
  Value<String?> onboardingStep,
  Value<DateTime?> onboardingDoneAt,
  Value<DateTime> createdAt,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get installId => $composableBuilder(
    column: $table.installId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayStartHour => $composableBuilder(
    column: $table.dayStartHour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get moodCheckInMode => $composableBuilder(
    column: $table.moodCheckInMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get haptics => $composableBuilder(
    column: $table.haptics,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyMorning => $composableBuilder(
    column: $table.notifyMorning,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyAdventure => $composableBuilder(
    column: $table.notifyAdventure,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get notifyEvening => $composableBuilder(
    column: $table.notifyEvening,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get onboardingDoneAt => $composableBuilder(
    column: $table.onboardingDoneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get installId => $composableBuilder(
    column: $table.installId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userName => $composableBuilder(
    column: $table.userName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wakeTime => $composableBuilder(
    column: $table.wakeTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bedTime => $composableBuilder(
    column: $table.bedTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayStartHour => $composableBuilder(
    column: $table.dayStartHour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get moodCheckInMode => $composableBuilder(
    column: $table.moodCheckInMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sound => $composableBuilder(
    column: $table.sound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get haptics => $composableBuilder(
    column: $table.haptics,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyMorning => $composableBuilder(
    column: $table.notifyMorning,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyAdventure => $composableBuilder(
    column: $table.notifyAdventure,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get notifyEvening => $composableBuilder(
    column: $table.notifyEvening,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get onboardingDoneAt => $composableBuilder(
    column: $table.onboardingDoneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get installId =>
      $composableBuilder(column: $table.installId, builder: (column) => column);

  GeneratedColumn<String> get userName =>
      $composableBuilder(column: $table.userName, builder: (column) => column);

  GeneratedColumn<String> get wakeTime =>
      $composableBuilder(column: $table.wakeTime, builder: (column) => column);

  GeneratedColumn<String> get bedTime =>
      $composableBuilder(column: $table.bedTime, builder: (column) => column);

  GeneratedColumn<int> get dayStartHour => $composableBuilder(
    column: $table.dayStartHour,
    builder: (column) => column,
  );

  GeneratedColumn<String> get moodCheckInMode => $composableBuilder(
    column: $table.moodCheckInMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<bool> get reduceMotion => $composableBuilder(
    column: $table.reduceMotion,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sound =>
      $composableBuilder(column: $table.sound, builder: (column) => column);

  GeneratedColumn<bool> get haptics =>
      $composableBuilder(column: $table.haptics, builder: (column) => column);

  GeneratedColumn<bool> get notifyMorning => $composableBuilder(
    column: $table.notifyMorning,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyAdventure => $composableBuilder(
    column: $table.notifyAdventure,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get notifyEvening => $composableBuilder(
    column: $table.notifyEvening,
    builder: (column) => column,
  );

  GeneratedColumn<String> get onboardingStep => $composableBuilder(
    column: $table.onboardingStep,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get onboardingDoneAt => $composableBuilder(
    column: $table.onboardingDoneAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> installId = const Value.absent(),
                Value<String> userName = const Value.absent(),
                Value<String> wakeTime = const Value.absent(),
                Value<String> bedTime = const Value.absent(),
                Value<int> dayStartHour = const Value.absent(),
                Value<String> moodCheckInMode = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> sound = const Value.absent(),
                Value<bool> haptics = const Value.absent(),
                Value<bool> notifyMorning = const Value.absent(),
                Value<bool> notifyAdventure = const Value.absent(),
                Value<bool> notifyEvening = const Value.absent(),
                Value<String?> onboardingStep = const Value.absent(),
                Value<DateTime?> onboardingDoneAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                installId: installId,
                userName: userName,
                wakeTime: wakeTime,
                bedTime: bedTime,
                dayStartHour: dayStartHour,
                moodCheckInMode: moodCheckInMode,
                paused: paused,
                reduceMotion: reduceMotion,
                sound: sound,
                haptics: haptics,
                notifyMorning: notifyMorning,
                notifyAdventure: notifyAdventure,
                notifyEvening: notifyEvening,
                onboardingStep: onboardingStep,
                onboardingDoneAt: onboardingDoneAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String installId,
                Value<String> userName = const Value.absent(),
                Value<String> wakeTime = const Value.absent(),
                Value<String> bedTime = const Value.absent(),
                Value<int> dayStartHour = const Value.absent(),
                Value<String> moodCheckInMode = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<bool> reduceMotion = const Value.absent(),
                Value<bool> sound = const Value.absent(),
                Value<bool> haptics = const Value.absent(),
                Value<bool> notifyMorning = const Value.absent(),
                Value<bool> notifyAdventure = const Value.absent(),
                Value<bool> notifyEvening = const Value.absent(),
                Value<String?> onboardingStep = const Value.absent(),
                Value<DateTime?> onboardingDoneAt = const Value.absent(),
                required DateTime createdAt,
              }) => ProfilesCompanion.insert(
                id: id,
                installId: installId,
                userName: userName,
                wakeTime: wakeTime,
                bedTime: bedTime,
                dayStartHour: dayStartHour,
                moodCheckInMode: moodCheckInMode,
                paused: paused,
                reduceMotion: reduceMotion,
                sound: sound,
                haptics: haptics,
                notifyMorning: notifyMorning,
                notifyAdventure: notifyAdventure,
                notifyEvening: notifyEvening,
                onboardingStep: onboardingStep,
                onboardingDoneAt: onboardingDoneAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$PetsTableCreateCompanionBuilder = PetsCompanion Function({
  Value<int> id,
  required String name,
  required String pronouns,
  required String eggColor,
  required String trait,
  Value<String> traitStats,
  required DateTime hatchedAt,
});
typedef $$PetsTableUpdateCompanionBuilder = PetsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<String> pronouns,
  Value<String> eggColor,
  Value<String> trait,
  Value<String> traitStats,
  Value<DateTime> hatchedAt,
});

class $$PetsTableFilterComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pronouns => $composableBuilder(
    column: $table.pronouns,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eggColor => $composableBuilder(
    column: $table.eggColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get trait => $composableBuilder(
    column: $table.trait,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get traitStats => $composableBuilder(
    column: $table.traitStats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get hatchedAt => $composableBuilder(
    column: $table.hatchedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PetsTableOrderingComposer extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pronouns => $composableBuilder(
    column: $table.pronouns,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eggColor => $composableBuilder(
    column: $table.eggColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get trait => $composableBuilder(
    column: $table.trait,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get traitStats => $composableBuilder(
    column: $table.traitStats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get hatchedAt => $composableBuilder(
    column: $table.hatchedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PetsTable> {
  $$PetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get pronouns =>
      $composableBuilder(column: $table.pronouns, builder: (column) => column);

  GeneratedColumn<String> get eggColor =>
      $composableBuilder(column: $table.eggColor, builder: (column) => column);

  GeneratedColumn<String> get trait =>
      $composableBuilder(column: $table.trait, builder: (column) => column);

  GeneratedColumn<String> get traitStats => $composableBuilder(
    column: $table.traitStats,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get hatchedAt =>
      $composableBuilder(column: $table.hatchedAt, builder: (column) => column);
}

class $$PetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PetsTable,
          Pet,
          $$PetsTableFilterComposer,
          $$PetsTableOrderingComposer,
          $$PetsTableAnnotationComposer,
          $$PetsTableCreateCompanionBuilder,
          $$PetsTableUpdateCompanionBuilder,
          (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
          Pet,
          PrefetchHooks Function()
        > {
  $$PetsTableTableManager(_$AppDatabase db, $PetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> pronouns = const Value.absent(),
                Value<String> eggColor = const Value.absent(),
                Value<String> trait = const Value.absent(),
                Value<String> traitStats = const Value.absent(),
                Value<DateTime> hatchedAt = const Value.absent(),
              }) => PetsCompanion(
                id: id,
                name: name,
                pronouns: pronouns,
                eggColor: eggColor,
                trait: trait,
                traitStats: traitStats,
                hatchedAt: hatchedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String pronouns,
                required String eggColor,
                required String trait,
                Value<String> traitStats = const Value.absent(),
                required DateTime hatchedAt,
              }) => PetsCompanion.insert(
                id: id,
                name: name,
                pronouns: pronouns,
                eggColor: eggColor,
                trait: trait,
                traitStats: traitStats,
                hatchedAt: hatchedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PetsTable, Pet>(table),
                  BaseReferences<_$AppDatabase, $PetsTable, Pet>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PetsTable,
      Pet,
      $$PetsTableFilterComposer,
      $$PetsTableOrderingComposer,
      $$PetsTableAnnotationComposer,
      $$PetsTableCreateCompanionBuilder,
      $$PetsTableUpdateCompanionBuilder,
      (Pet, BaseReferences<_$AppDatabase, $PetsTable, Pet>),
      Pet,
      PrefetchHooks Function()
    >;
typedef $$OnboardingAnswersTableCreateCompanionBuilder =
    OnboardingAnswersCompanion Function({
      required String questionId,
      required String value,
      required DateTime answeredAt,
      Value<int> rowid,
    });
typedef $$OnboardingAnswersTableUpdateCompanionBuilder =
    OnboardingAnswersCompanion Function({
      Value<String> questionId,
      Value<String> value,
      Value<DateTime> answeredAt,
      Value<int> rowid,
    });

class $$OnboardingAnswersTableFilterComposer
    extends Composer<_$AppDatabase, $OnboardingAnswersTable> {
  $$OnboardingAnswersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OnboardingAnswersTableOrderingComposer
    extends Composer<_$AppDatabase, $OnboardingAnswersTable> {
  $$OnboardingAnswersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OnboardingAnswersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OnboardingAnswersTable> {
  $$OnboardingAnswersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get questionId => $composableBuilder(
    column: $table.questionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get answeredAt => $composableBuilder(
    column: $table.answeredAt,
    builder: (column) => column,
  );
}

class $$OnboardingAnswersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OnboardingAnswersTable,
          OnboardingAnswer,
          $$OnboardingAnswersTableFilterComposer,
          $$OnboardingAnswersTableOrderingComposer,
          $$OnboardingAnswersTableAnnotationComposer,
          $$OnboardingAnswersTableCreateCompanionBuilder,
          $$OnboardingAnswersTableUpdateCompanionBuilder,
          (
            OnboardingAnswer,
            BaseReferences<
              _$AppDatabase,
              $OnboardingAnswersTable,
              OnboardingAnswer
            >,
          ),
          OnboardingAnswer,
          PrefetchHooks Function()
        > {
  $$OnboardingAnswersTableTableManager(
    _$AppDatabase db,
    $OnboardingAnswersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OnboardingAnswersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OnboardingAnswersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OnboardingAnswersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> questionId = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> answeredAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OnboardingAnswersCompanion(
                questionId: questionId,
                value: value,
                answeredAt: answeredAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String questionId,
                required String value,
                required DateTime answeredAt,
                Value<int> rowid = const Value.absent(),
              }) => OnboardingAnswersCompanion.insert(
                questionId: questionId,
                value: value,
                answeredAt: answeredAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$OnboardingAnswersTable, OnboardingAnswer>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $OnboardingAnswersTable,
                    OnboardingAnswer
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OnboardingAnswersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OnboardingAnswersTable,
      OnboardingAnswer,
      $$OnboardingAnswersTableFilterComposer,
      $$OnboardingAnswersTableOrderingComposer,
      $$OnboardingAnswersTableAnnotationComposer,
      $$OnboardingAnswersTableCreateCompanionBuilder,
      $$OnboardingAnswersTableUpdateCompanionBuilder,
      (
        OnboardingAnswer,
        BaseReferences<
          _$AppDatabase,
          $OnboardingAnswersTable,
          OnboardingAnswer
        >,
      ),
      OnboardingAnswer,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  required String title,
  required String icon,
  required String area,
  required String section,
  Value<int> weekdaysMask,
  Value<int> timesPerDay,
  Value<bool> essential,
  Value<String?> reminderTime,
  required int sortOrder,
  Value<String?> libraryId,
  Value<DateTime?> archivedAt,
  required DateTime createdAt,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> icon,
  Value<String> area,
  Value<String> section,
  Value<int> weekdaysMask,
  Value<int> timesPerDay,
  Value<bool> essential,
  Value<String?> reminderTime,
  Value<int> sortOrder,
  Value<String?> libraryId,
  Value<DateTime?> archivedAt,
  Value<DateTime> createdAt,
});

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get essential => $composableBuilder(
    column: $table.essential,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get area => $composableBuilder(
    column: $table.area,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get section => $composableBuilder(
    column: $table.section,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get essential => $composableBuilder(
    column: $table.essential,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get libraryId => $composableBuilder(
    column: $table.libraryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get area =>
      $composableBuilder(column: $table.area, builder: (column) => column);

  GeneratedColumn<String> get section =>
      $composableBuilder(column: $table.section, builder: (column) => column);

  GeneratedColumn<int> get weekdaysMask => $composableBuilder(
    column: $table.weekdaysMask,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timesPerDay => $composableBuilder(
    column: $table.timesPerDay,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get essential =>
      $composableBuilder(column: $table.essential, builder: (column) => column);

  GeneratedColumn<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get libraryId =>
      $composableBuilder(column: $table.libraryId, builder: (column) => column);

  GeneratedColumn<DateTime> get archivedAt => $composableBuilder(
    column: $table.archivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> area = const Value.absent(),
                Value<String> section = const Value.absent(),
                Value<int> weekdaysMask = const Value.absent(),
                Value<int> timesPerDay = const Value.absent(),
                Value<bool> essential = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String?> libraryId = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                title: title,
                icon: icon,
                area: area,
                section: section,
                weekdaysMask: weekdaysMask,
                timesPerDay: timesPerDay,
                essential: essential,
                reminderTime: reminderTime,
                sortOrder: sortOrder,
                libraryId: libraryId,
                archivedAt: archivedAt,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                required String icon,
                required String area,
                required String section,
                Value<int> weekdaysMask = const Value.absent(),
                Value<int> timesPerDay = const Value.absent(),
                Value<bool> essential = const Value.absent(),
                Value<String?> reminderTime = const Value.absent(),
                required int sortOrder,
                Value<String?> libraryId = const Value.absent(),
                Value<DateTime?> archivedAt = const Value.absent(),
                required DateTime createdAt,
              }) => GoalsCompanion.insert(
                id: id,
                title: title,
                icon: icon,
                area: area,
                section: section,
                weekdaysMask: weekdaysMask,
                timesPerDay: timesPerDay,
                essential: essential,
                reminderTime: reminderTime,
                sortOrder: sortOrder,
                libraryId: libraryId,
                archivedAt: archivedAt,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$GoalsTable, Goal>(table),
                  BaseReferences<_$AppDatabase, $GoalsTable, Goal>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $$CompletionsTableCreateCompanionBuilder =
    CompletionsCompanion Function({
      Value<int> id,
      required int goalId,
      required String appDay,
      required DateTime completedAt,
    });
typedef $$CompletionsTableUpdateCompanionBuilder =
    CompletionsCompanion Function({
      Value<int> id,
      Value<int> goalId,
      Value<String> appDay,
      Value<DateTime> completedAt,
    });

class $$CompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appDay => $composableBuilder(
    column: $table.appDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appDay => $composableBuilder(
    column: $table.appDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CompletionsTable> {
  $$CompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get appDay =>
      $composableBuilder(column: $table.appDay, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );
}

class $$CompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CompletionsTable,
          Completion,
          $$CompletionsTableFilterComposer,
          $$CompletionsTableOrderingComposer,
          $$CompletionsTableAnnotationComposer,
          $$CompletionsTableCreateCompanionBuilder,
          $$CompletionsTableUpdateCompanionBuilder,
          (
            Completion,
            BaseReferences<_$AppDatabase, $CompletionsTable, Completion>,
          ),
          Completion,
          PrefetchHooks Function()
        > {
  $$CompletionsTableTableManager(_$AppDatabase db, $CompletionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> goalId = const Value.absent(),
                Value<String> appDay = const Value.absent(),
                Value<DateTime> completedAt = const Value.absent(),
              }) => CompletionsCompanion(
                id: id,
                goalId: goalId,
                appDay: appDay,
                completedAt: completedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int goalId,
                required String appDay,
                required DateTime completedAt,
              }) => CompletionsCompanion.insert(
                id: id,
                goalId: goalId,
                appDay: appDay,
                completedAt: completedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CompletionsTable, Completion>(table),
                  BaseReferences<_$AppDatabase, $CompletionsTable, Completion>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CompletionsTable,
      Completion,
      $$CompletionsTableFilterComposer,
      $$CompletionsTableOrderingComposer,
      $$CompletionsTableAnnotationComposer,
      $$CompletionsTableCreateCompanionBuilder,
      $$CompletionsTableUpdateCompanionBuilder,
      (
        Completion,
        BaseReferences<_$AppDatabase, $CompletionsTable, Completion>,
      ),
      Completion,
      PrefetchHooks Function()
    >;
typedef $$SkipsTableCreateCompanionBuilder = SkipsCompanion Function({
  required int goalId,
  required String appDay,
  Value<int> rowid,
});
typedef $$SkipsTableUpdateCompanionBuilder = SkipsCompanion Function({
  Value<int> goalId,
  Value<String> appDay,
  Value<int> rowid,
});

class $$SkipsTableFilterComposer extends Composer<_$AppDatabase, $SkipsTable> {
  $$SkipsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appDay => $composableBuilder(
    column: $table.appDay,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SkipsTableOrderingComposer
    extends Composer<_$AppDatabase, $SkipsTable> {
  $$SkipsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appDay => $composableBuilder(
    column: $table.appDay,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SkipsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SkipsTable> {
  $$SkipsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<String> get appDay =>
      $composableBuilder(column: $table.appDay, builder: (column) => column);
}

class $$SkipsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SkipsTable,
          Skip,
          $$SkipsTableFilterComposer,
          $$SkipsTableOrderingComposer,
          $$SkipsTableAnnotationComposer,
          $$SkipsTableCreateCompanionBuilder,
          $$SkipsTableUpdateCompanionBuilder,
          (Skip, BaseReferences<_$AppDatabase, $SkipsTable, Skip>),
          Skip,
          PrefetchHooks Function()
        > {
  $$SkipsTableTableManager(_$AppDatabase db, $SkipsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SkipsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SkipsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SkipsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> goalId = const Value.absent(),
            Value<String> appDay = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SkipsCompanion(goalId: goalId, appDay: appDay, rowid: rowid),
          createCompanionCallback:
              ({
                required int goalId,
                required String appDay,
                Value<int> rowid = const Value.absent(),
              }) => SkipsCompanion.insert(
                goalId: goalId,
                appDay: appDay,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SkipsTable, Skip>(table),
                  BaseReferences<_$AppDatabase, $SkipsTable, Skip>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SkipsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SkipsTable,
      Skip,
      $$SkipsTableFilterComposer,
      $$SkipsTableOrderingComposer,
      $$SkipsTableAnnotationComposer,
      $$SkipsTableCreateCompanionBuilder,
      $$SkipsTableUpdateCompanionBuilder,
      (Skip, BaseReferences<_$AppDatabase, $SkipsTable, Skip>),
      Skip,
      PrefetchHooks Function()
    >;
typedef $$DaysTableCreateCompanionBuilder = DaysCompanion Function({
  required String appDay,
  Value<bool> lowEnergy,
  Value<DateTime?> adventureStartedAt,
  Value<DateTime?> adventureEndsAt,
  Value<String?> storyId,
  Value<bool> adventureClaimed,
  Value<bool> surpriseGiven,
  Value<int> rowid,
});
typedef $$DaysTableUpdateCompanionBuilder = DaysCompanion Function({
  Value<String> appDay,
  Value<bool> lowEnergy,
  Value<DateTime?> adventureStartedAt,
  Value<DateTime?> adventureEndsAt,
  Value<String?> storyId,
  Value<bool> adventureClaimed,
  Value<bool> surpriseGiven,
  Value<int> rowid,
});

class $$DaysTableFilterComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get appDay => $composableBuilder(
    column: $table.appDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get lowEnergy => $composableBuilder(
    column: $table.lowEnergy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get adventureStartedAt => $composableBuilder(
    column: $table.adventureStartedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get adventureEndsAt => $composableBuilder(
    column: $table.adventureEndsAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storyId => $composableBuilder(
    column: $table.storyId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get adventureClaimed => $composableBuilder(
    column: $table.adventureClaimed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get surpriseGiven => $composableBuilder(
    column: $table.surpriseGiven,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DaysTableOrderingComposer extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get appDay => $composableBuilder(
    column: $table.appDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get lowEnergy => $composableBuilder(
    column: $table.lowEnergy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get adventureStartedAt => $composableBuilder(
    column: $table.adventureStartedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get adventureEndsAt => $composableBuilder(
    column: $table.adventureEndsAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storyId => $composableBuilder(
    column: $table.storyId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get adventureClaimed => $composableBuilder(
    column: $table.adventureClaimed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get surpriseGiven => $composableBuilder(
    column: $table.surpriseGiven,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $DaysTable> {
  $$DaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get appDay =>
      $composableBuilder(column: $table.appDay, builder: (column) => column);

  GeneratedColumn<bool> get lowEnergy =>
      $composableBuilder(column: $table.lowEnergy, builder: (column) => column);

  GeneratedColumn<DateTime> get adventureStartedAt => $composableBuilder(
    column: $table.adventureStartedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get adventureEndsAt => $composableBuilder(
    column: $table.adventureEndsAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storyId =>
      $composableBuilder(column: $table.storyId, builder: (column) => column);

  GeneratedColumn<bool> get adventureClaimed => $composableBuilder(
    column: $table.adventureClaimed,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get surpriseGiven => $composableBuilder(
    column: $table.surpriseGiven,
    builder: (column) => column,
  );
}

class $$DaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DaysTable,
          Day,
          $$DaysTableFilterComposer,
          $$DaysTableOrderingComposer,
          $$DaysTableAnnotationComposer,
          $$DaysTableCreateCompanionBuilder,
          $$DaysTableUpdateCompanionBuilder,
          (Day, BaseReferences<_$AppDatabase, $DaysTable, Day>),
          Day,
          PrefetchHooks Function()
        > {
  $$DaysTableTableManager(_$AppDatabase db, $DaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> appDay = const Value.absent(),
                Value<bool> lowEnergy = const Value.absent(),
                Value<DateTime?> adventureStartedAt = const Value.absent(),
                Value<DateTime?> adventureEndsAt = const Value.absent(),
                Value<String?> storyId = const Value.absent(),
                Value<bool> adventureClaimed = const Value.absent(),
                Value<bool> surpriseGiven = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DaysCompanion(
                appDay: appDay,
                lowEnergy: lowEnergy,
                adventureStartedAt: adventureStartedAt,
                adventureEndsAt: adventureEndsAt,
                storyId: storyId,
                adventureClaimed: adventureClaimed,
                surpriseGiven: surpriseGiven,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String appDay,
                Value<bool> lowEnergy = const Value.absent(),
                Value<DateTime?> adventureStartedAt = const Value.absent(),
                Value<DateTime?> adventureEndsAt = const Value.absent(),
                Value<String?> storyId = const Value.absent(),
                Value<bool> adventureClaimed = const Value.absent(),
                Value<bool> surpriseGiven = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DaysCompanion.insert(
                appDay: appDay,
                lowEnergy: lowEnergy,
                adventureStartedAt: adventureStartedAt,
                adventureEndsAt: adventureEndsAt,
                storyId: storyId,
                adventureClaimed: adventureClaimed,
                surpriseGiven: surpriseGiven,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DaysTable, Day>(table),
                  BaseReferences<_$AppDatabase, $DaysTable, Day>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DaysTable,
      Day,
      $$DaysTableFilterComposer,
      $$DaysTableOrderingComposer,
      $$DaysTableAnnotationComposer,
      $$DaysTableCreateCompanionBuilder,
      $$DaysTableUpdateCompanionBuilder,
      (Day, BaseReferences<_$AppDatabase, $DaysTable, Day>),
      Day,
      PrefetchHooks Function()
    >;
typedef $$WalletLedgerTableCreateCompanionBuilder =
    WalletLedgerCompanion Function({
      Value<int> id,
      required int amount,
      required String reason,
      Value<String?> refId,
      required DateTime createdAt,
    });
typedef $$WalletLedgerTableUpdateCompanionBuilder =
    WalletLedgerCompanion Function({
      Value<int> id,
      Value<int> amount,
      Value<String> reason,
      Value<String?> refId,
      Value<DateTime> createdAt,
    });

class $$WalletLedgerTableFilterComposer
    extends Composer<_$AppDatabase, $WalletLedgerTable> {
  $$WalletLedgerTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletLedgerTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletLedgerTable> {
  $$WalletLedgerTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get refId => $composableBuilder(
    column: $table.refId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletLedgerTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletLedgerTable> {
  $$WalletLedgerTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<String> get refId =>
      $composableBuilder(column: $table.refId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletLedgerTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletLedgerTable,
          WalletLedgerData,
          $$WalletLedgerTableFilterComposer,
          $$WalletLedgerTableOrderingComposer,
          $$WalletLedgerTableAnnotationComposer,
          $$WalletLedgerTableCreateCompanionBuilder,
          $$WalletLedgerTableUpdateCompanionBuilder,
          (
            WalletLedgerData,
            BaseReferences<_$AppDatabase, $WalletLedgerTable, WalletLedgerData>,
          ),
          WalletLedgerData,
          PrefetchHooks Function()
        > {
  $$WalletLedgerTableTableManager(_$AppDatabase db, $WalletLedgerTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletLedgerTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletLedgerTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletLedgerTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<String?> refId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletLedgerCompanion(
                id: id,
                amount: amount,
                reason: reason,
                refId: refId,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int amount,
                required String reason,
                Value<String?> refId = const Value.absent(),
                required DateTime createdAt,
              }) => WalletLedgerCompanion.insert(
                id: id,
                amount: amount,
                reason: reason,
                refId: refId,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletLedgerTable, WalletLedgerData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WalletLedgerTable,
                    WalletLedgerData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletLedgerTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletLedgerTable,
      WalletLedgerData,
      $$WalletLedgerTableFilterComposer,
      $$WalletLedgerTableOrderingComposer,
      $$WalletLedgerTableAnnotationComposer,
      $$WalletLedgerTableCreateCompanionBuilder,
      $$WalletLedgerTableUpdateCompanionBuilder,
      (
        WalletLedgerData,
        BaseReferences<_$AppDatabase, $WalletLedgerTable, WalletLedgerData>,
      ),
      WalletLedgerData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
  $$OnboardingAnswersTableTableManager get onboardingAnswers =>
      $$OnboardingAnswersTableTableManager(_db, _db.onboardingAnswers);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$CompletionsTableTableManager get completions =>
      $$CompletionsTableTableManager(_db, _db.completions);
  $$SkipsTableTableManager get skips =>
      $$SkipsTableTableManager(_db, _db.skips);
  $$DaysTableTableManager get days => $$DaysTableTableManager(_db, _db.days);
  $$WalletLedgerTableTableManager get walletLedger =>
      $$WalletLedgerTableTableManager(_db, _db.walletLedger);
}
