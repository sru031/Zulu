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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $PetsTable pets = $PetsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [profiles, pets];
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$PetsTableTableManager get pets => $$PetsTableTableManager(_db, _db.pets);
}
