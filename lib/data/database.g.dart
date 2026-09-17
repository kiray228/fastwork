// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ShiftRowsTable extends ShiftRows
    with TableInfo<$ShiftRowsTable, ShiftRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShiftRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _workDateMeta = const VerificationMeta(
    'workDate',
  );
  @override
  late final GeneratedColumn<DateTime> workDate = GeneratedColumn<DateTime>(
    'work_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
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
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startMinutesMeta = const VerificationMeta(
    'startMinutes',
  );
  @override
  late final GeneratedColumn<int> startMinutes = GeneratedColumn<int>(
    'start_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endMinutesMeta = const VerificationMeta(
    'endMinutes',
  );
  @override
  late final GeneratedColumn<int> endMinutes = GeneratedColumn<int>(
    'end_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _breakMinutesMeta = const VerificationMeta(
    'breakMinutes',
  );
  @override
  late final GeneratedColumn<int> breakMinutes = GeneratedColumn<int>(
    'break_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(60),
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<int> hourlyRate = GeneratedColumn<int>(
    'hourly_rate',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workersNeededMeta = const VerificationMeta(
    'workersNeeded',
  );
  @override
  late final GeneratedColumn<int> workersNeeded = GeneratedColumn<int>(
    'workers_needed',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dutiesMeta = const VerificationMeta('duties');
  @override
  late final GeneratedColumn<String> duties = GeneratedColumn<String>(
    'duties',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _dressCodeMeta = const VerificationMeta(
    'dressCode',
  );
  @override
  late final GeneratedColumn<String> dressCode = GeneratedColumn<String>(
    'dress_code',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _employerCommentMeta = const VerificationMeta(
    'employerComment',
  );
  @override
  late final GeneratedColumn<String> employerComment = GeneratedColumn<String>(
    'employer_comment',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payoutDelayDaysMeta = const VerificationMeta(
    'payoutDelayDays',
  );
  @override
  late final GeneratedColumn<int> payoutDelayDays = GeneratedColumn<int>(
    'payout_delay_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _cancelDeadlineHoursMeta =
      const VerificationMeta('cancelDeadlineHours');
  @override
  late final GeneratedColumn<int> cancelDeadlineHours = GeneratedColumn<int>(
    'cancel_deadline_hours',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _minRatingMeta = const VerificationMeta(
    'minRating',
  );
  @override
  late final GeneratedColumn<double> minRating = GeneratedColumn<double>(
    'min_rating',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workDate,
    title,
    company,
    address,
    startMinutes,
    endMinutes,
    breakMinutes,
    hourlyRate,
    workersNeeded,
    duties,
    dressCode,
    employerComment,
    payoutDelayDays,
    cancelDeadlineHours,
    minRating,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shift_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShiftRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('work_date')) {
      context.handle(
        _workDateMeta,
        workDate.isAcceptableOrUnknown(data['work_date']!, _workDateMeta),
      );
    } else if (isInserting) {
      context.missing(_workDateMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    } else if (isInserting) {
      context.missing(_companyMeta);
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('start_minutes')) {
      context.handle(
        _startMinutesMeta,
        startMinutes.isAcceptableOrUnknown(
          data['start_minutes']!,
          _startMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startMinutesMeta);
    }
    if (data.containsKey('end_minutes')) {
      context.handle(
        _endMinutesMeta,
        endMinutes.isAcceptableOrUnknown(data['end_minutes']!, _endMinutesMeta),
      );
    } else if (isInserting) {
      context.missing(_endMinutesMeta);
    }
    if (data.containsKey('break_minutes')) {
      context.handle(
        _breakMinutesMeta,
        breakMinutes.isAcceptableOrUnknown(
          data['break_minutes']!,
          _breakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    } else if (isInserting) {
      context.missing(_hourlyRateMeta);
    }
    if (data.containsKey('workers_needed')) {
      context.handle(
        _workersNeededMeta,
        workersNeeded.isAcceptableOrUnknown(
          data['workers_needed']!,
          _workersNeededMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workersNeededMeta);
    }
    if (data.containsKey('duties')) {
      context.handle(
        _dutiesMeta,
        duties.isAcceptableOrUnknown(data['duties']!, _dutiesMeta),
      );
    }
    if (data.containsKey('dress_code')) {
      context.handle(
        _dressCodeMeta,
        dressCode.isAcceptableOrUnknown(data['dress_code']!, _dressCodeMeta),
      );
    }
    if (data.containsKey('employer_comment')) {
      context.handle(
        _employerCommentMeta,
        employerComment.isAcceptableOrUnknown(
          data['employer_comment']!,
          _employerCommentMeta,
        ),
      );
    }
    if (data.containsKey('payout_delay_days')) {
      context.handle(
        _payoutDelayDaysMeta,
        payoutDelayDays.isAcceptableOrUnknown(
          data['payout_delay_days']!,
          _payoutDelayDaysMeta,
        ),
      );
    }
    if (data.containsKey('cancel_deadline_hours')) {
      context.handle(
        _cancelDeadlineHoursMeta,
        cancelDeadlineHours.isAcceptableOrUnknown(
          data['cancel_deadline_hours']!,
          _cancelDeadlineHoursMeta,
        ),
      );
    }
    if (data.containsKey('min_rating')) {
      context.handle(
        _minRatingMeta,
        minRating.isAcceptableOrUnknown(data['min_rating']!, _minRatingMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShiftRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShiftRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      workDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}work_date'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      )!,
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      )!,
      startMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}start_minutes'],
      )!,
      endMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}end_minutes'],
      )!,
      breakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}break_minutes'],
      )!,
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hourly_rate'],
      )!,
      workersNeeded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}workers_needed'],
      )!,
      duties: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}duties'],
      )!,
      dressCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dress_code'],
      ),
      employerComment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}employer_comment'],
      ),
      payoutDelayDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payout_delay_days'],
      )!,
      cancelDeadlineHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cancel_deadline_hours'],
      )!,
      minRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_rating'],
      ),
    );
  }

  @override
  $ShiftRowsTable createAlias(String alias) {
    return $ShiftRowsTable(attachedDatabase, alias);
  }
}

class ShiftRow extends DataClass implements Insertable<ShiftRow> {
  final int id;
  final DateTime workDate;
  final String title;
  final String company;
  final String address;
  final int startMinutes;
  final int endMinutes;
  final int breakMinutes;
  final int hourlyRate;
  final int workersNeeded;
  final String duties;
  final String? dressCode;
  final String? employerComment;
  final int payoutDelayDays;

  /// За сколько часов до начала смены ещё можно отменить запись.
  /// Добавлена во второй версии схемы — см. миграцию ниже.
  final int cancelDeadlineHours;

  /// Минимальный рейтинг для допуска к смене. null — ограничений нет.
  /// Добавлена в третьей версии схемы.
  final double? minRating;
  const ShiftRow({
    required this.id,
    required this.workDate,
    required this.title,
    required this.company,
    required this.address,
    required this.startMinutes,
    required this.endMinutes,
    required this.breakMinutes,
    required this.hourlyRate,
    required this.workersNeeded,
    required this.duties,
    this.dressCode,
    this.employerComment,
    required this.payoutDelayDays,
    required this.cancelDeadlineHours,
    this.minRating,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_date'] = Variable<DateTime>(workDate);
    map['title'] = Variable<String>(title);
    map['company'] = Variable<String>(company);
    map['address'] = Variable<String>(address);
    map['start_minutes'] = Variable<int>(startMinutes);
    map['end_minutes'] = Variable<int>(endMinutes);
    map['break_minutes'] = Variable<int>(breakMinutes);
    map['hourly_rate'] = Variable<int>(hourlyRate);
    map['workers_needed'] = Variable<int>(workersNeeded);
    map['duties'] = Variable<String>(duties);
    if (!nullToAbsent || dressCode != null) {
      map['dress_code'] = Variable<String>(dressCode);
    }
    if (!nullToAbsent || employerComment != null) {
      map['employer_comment'] = Variable<String>(employerComment);
    }
    map['payout_delay_days'] = Variable<int>(payoutDelayDays);
    map['cancel_deadline_hours'] = Variable<int>(cancelDeadlineHours);
    if (!nullToAbsent || minRating != null) {
      map['min_rating'] = Variable<double>(minRating);
    }
    return map;
  }

  ShiftRowsCompanion toCompanion(bool nullToAbsent) {
    return ShiftRowsCompanion(
      id: Value(id),
      workDate: Value(workDate),
      title: Value(title),
      company: Value(company),
      address: Value(address),
      startMinutes: Value(startMinutes),
      endMinutes: Value(endMinutes),
      breakMinutes: Value(breakMinutes),
      hourlyRate: Value(hourlyRate),
      workersNeeded: Value(workersNeeded),
      duties: Value(duties),
      dressCode: dressCode == null && nullToAbsent
          ? const Value.absent()
          : Value(dressCode),
      employerComment: employerComment == null && nullToAbsent
          ? const Value.absent()
          : Value(employerComment),
      payoutDelayDays: Value(payoutDelayDays),
      cancelDeadlineHours: Value(cancelDeadlineHours),
      minRating: minRating == null && nullToAbsent
          ? const Value.absent()
          : Value(minRating),
    );
  }

  factory ShiftRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShiftRow(
      id: serializer.fromJson<int>(json['id']),
      workDate: serializer.fromJson<DateTime>(json['workDate']),
      title: serializer.fromJson<String>(json['title']),
      company: serializer.fromJson<String>(json['company']),
      address: serializer.fromJson<String>(json['address']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      hourlyRate: serializer.fromJson<int>(json['hourlyRate']),
      workersNeeded: serializer.fromJson<int>(json['workersNeeded']),
      duties: serializer.fromJson<String>(json['duties']),
      dressCode: serializer.fromJson<String?>(json['dressCode']),
      employerComment: serializer.fromJson<String?>(json['employerComment']),
      payoutDelayDays: serializer.fromJson<int>(json['payoutDelayDays']),
      cancelDeadlineHours: serializer.fromJson<int>(
        json['cancelDeadlineHours'],
      ),
      minRating: serializer.fromJson<double?>(json['minRating']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'workDate': serializer.toJson<DateTime>(workDate),
      'title': serializer.toJson<String>(title),
      'company': serializer.toJson<String>(company),
      'address': serializer.toJson<String>(address),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'hourlyRate': serializer.toJson<int>(hourlyRate),
      'workersNeeded': serializer.toJson<int>(workersNeeded),
      'duties': serializer.toJson<String>(duties),
      'dressCode': serializer.toJson<String?>(dressCode),
      'employerComment': serializer.toJson<String?>(employerComment),
      'payoutDelayDays': serializer.toJson<int>(payoutDelayDays),
      'cancelDeadlineHours': serializer.toJson<int>(cancelDeadlineHours),
      'minRating': serializer.toJson<double?>(minRating),
    };
  }

  ShiftRow copyWith({
    int? id,
    DateTime? workDate,
    String? title,
    String? company,
    String? address,
    int? startMinutes,
    int? endMinutes,
    int? breakMinutes,
    int? hourlyRate,
    int? workersNeeded,
    String? duties,
    Value<String?> dressCode = const Value.absent(),
    Value<String?> employerComment = const Value.absent(),
    int? payoutDelayDays,
    int? cancelDeadlineHours,
    Value<double?> minRating = const Value.absent(),
  }) => ShiftRow(
    id: id ?? this.id,
    workDate: workDate ?? this.workDate,
    title: title ?? this.title,
    company: company ?? this.company,
    address: address ?? this.address,
    startMinutes: startMinutes ?? this.startMinutes,
    endMinutes: endMinutes ?? this.endMinutes,
    breakMinutes: breakMinutes ?? this.breakMinutes,
    hourlyRate: hourlyRate ?? this.hourlyRate,
    workersNeeded: workersNeeded ?? this.workersNeeded,
    duties: duties ?? this.duties,
    dressCode: dressCode.present ? dressCode.value : this.dressCode,
    employerComment: employerComment.present
        ? employerComment.value
        : this.employerComment,
    payoutDelayDays: payoutDelayDays ?? this.payoutDelayDays,
    cancelDeadlineHours: cancelDeadlineHours ?? this.cancelDeadlineHours,
    minRating: minRating.present ? minRating.value : this.minRating,
  );
  ShiftRow copyWithCompanion(ShiftRowsCompanion data) {
    return ShiftRow(
      id: data.id.present ? data.id.value : this.id,
      workDate: data.workDate.present ? data.workDate.value : this.workDate,
      title: data.title.present ? data.title.value : this.title,
      company: data.company.present ? data.company.value : this.company,
      address: data.address.present ? data.address.value : this.address,
      startMinutes: data.startMinutes.present
          ? data.startMinutes.value
          : this.startMinutes,
      endMinutes: data.endMinutes.present
          ? data.endMinutes.value
          : this.endMinutes,
      breakMinutes: data.breakMinutes.present
          ? data.breakMinutes.value
          : this.breakMinutes,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      workersNeeded: data.workersNeeded.present
          ? data.workersNeeded.value
          : this.workersNeeded,
      duties: data.duties.present ? data.duties.value : this.duties,
      dressCode: data.dressCode.present ? data.dressCode.value : this.dressCode,
      employerComment: data.employerComment.present
          ? data.employerComment.value
          : this.employerComment,
      payoutDelayDays: data.payoutDelayDays.present
          ? data.payoutDelayDays.value
          : this.payoutDelayDays,
      cancelDeadlineHours: data.cancelDeadlineHours.present
          ? data.cancelDeadlineHours.value
          : this.cancelDeadlineHours,
      minRating: data.minRating.present ? data.minRating.value : this.minRating,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShiftRow(')
          ..write('id: $id, ')
          ..write('workDate: $workDate, ')
          ..write('title: $title, ')
          ..write('company: $company, ')
          ..write('address: $address, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('workersNeeded: $workersNeeded, ')
          ..write('duties: $duties, ')
          ..write('dressCode: $dressCode, ')
          ..write('employerComment: $employerComment, ')
          ..write('payoutDelayDays: $payoutDelayDays, ')
          ..write('cancelDeadlineHours: $cancelDeadlineHours, ')
          ..write('minRating: $minRating')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    workDate,
    title,
    company,
    address,
    startMinutes,
    endMinutes,
    breakMinutes,
    hourlyRate,
    workersNeeded,
    duties,
    dressCode,
    employerComment,
    payoutDelayDays,
    cancelDeadlineHours,
    minRating,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShiftRow &&
          other.id == this.id &&
          other.workDate == this.workDate &&
          other.title == this.title &&
          other.company == this.company &&
          other.address == this.address &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.breakMinutes == this.breakMinutes &&
          other.hourlyRate == this.hourlyRate &&
          other.workersNeeded == this.workersNeeded &&
          other.duties == this.duties &&
          other.dressCode == this.dressCode &&
          other.employerComment == this.employerComment &&
          other.payoutDelayDays == this.payoutDelayDays &&
          other.cancelDeadlineHours == this.cancelDeadlineHours &&
          other.minRating == this.minRating);
}

class ShiftRowsCompanion extends UpdateCompanion<ShiftRow> {
  final Value<int> id;
  final Value<DateTime> workDate;
  final Value<String> title;
  final Value<String> company;
  final Value<String> address;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<int> breakMinutes;
  final Value<int> hourlyRate;
  final Value<int> workersNeeded;
  final Value<String> duties;
  final Value<String?> dressCode;
  final Value<String?> employerComment;
  final Value<int> payoutDelayDays;
  final Value<int> cancelDeadlineHours;
  final Value<double?> minRating;
  const ShiftRowsCompanion({
    this.id = const Value.absent(),
    this.workDate = const Value.absent(),
    this.title = const Value.absent(),
    this.company = const Value.absent(),
    this.address = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.workersNeeded = const Value.absent(),
    this.duties = const Value.absent(),
    this.dressCode = const Value.absent(),
    this.employerComment = const Value.absent(),
    this.payoutDelayDays = const Value.absent(),
    this.cancelDeadlineHours = const Value.absent(),
    this.minRating = const Value.absent(),
  });
  ShiftRowsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime workDate,
    required String title,
    required String company,
    required String address,
    required int startMinutes,
    required int endMinutes,
    this.breakMinutes = const Value.absent(),
    required int hourlyRate,
    required int workersNeeded,
    this.duties = const Value.absent(),
    this.dressCode = const Value.absent(),
    this.employerComment = const Value.absent(),
    this.payoutDelayDays = const Value.absent(),
    this.cancelDeadlineHours = const Value.absent(),
    this.minRating = const Value.absent(),
  }) : workDate = Value(workDate),
       title = Value(title),
       company = Value(company),
       address = Value(address),
       startMinutes = Value(startMinutes),
       endMinutes = Value(endMinutes),
       hourlyRate = Value(hourlyRate),
       workersNeeded = Value(workersNeeded);
  static Insertable<ShiftRow> custom({
    Expression<int>? id,
    Expression<DateTime>? workDate,
    Expression<String>? title,
    Expression<String>? company,
    Expression<String>? address,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? breakMinutes,
    Expression<int>? hourlyRate,
    Expression<int>? workersNeeded,
    Expression<String>? duties,
    Expression<String>? dressCode,
    Expression<String>? employerComment,
    Expression<int>? payoutDelayDays,
    Expression<int>? cancelDeadlineHours,
    Expression<double>? minRating,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workDate != null) 'work_date': workDate,
      if (title != null) 'title': title,
      if (company != null) 'company': company,
      if (address != null) 'address': address,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (workersNeeded != null) 'workers_needed': workersNeeded,
      if (duties != null) 'duties': duties,
      if (dressCode != null) 'dress_code': dressCode,
      if (employerComment != null) 'employer_comment': employerComment,
      if (payoutDelayDays != null) 'payout_delay_days': payoutDelayDays,
      if (cancelDeadlineHours != null)
        'cancel_deadline_hours': cancelDeadlineHours,
      if (minRating != null) 'min_rating': minRating,
    });
  }

  ShiftRowsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? workDate,
    Value<String>? title,
    Value<String>? company,
    Value<String>? address,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<int>? breakMinutes,
    Value<int>? hourlyRate,
    Value<int>? workersNeeded,
    Value<String>? duties,
    Value<String?>? dressCode,
    Value<String?>? employerComment,
    Value<int>? payoutDelayDays,
    Value<int>? cancelDeadlineHours,
    Value<double?>? minRating,
  }) {
    return ShiftRowsCompanion(
      id: id ?? this.id,
      workDate: workDate ?? this.workDate,
      title: title ?? this.title,
      company: company ?? this.company,
      address: address ?? this.address,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      workersNeeded: workersNeeded ?? this.workersNeeded,
      duties: duties ?? this.duties,
      dressCode: dressCode ?? this.dressCode,
      employerComment: employerComment ?? this.employerComment,
      payoutDelayDays: payoutDelayDays ?? this.payoutDelayDays,
      cancelDeadlineHours: cancelDeadlineHours ?? this.cancelDeadlineHours,
      minRating: minRating ?? this.minRating,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (workDate.present) {
      map['work_date'] = Variable<DateTime>(workDate.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (startMinutes.present) {
      map['start_minutes'] = Variable<int>(startMinutes.value);
    }
    if (endMinutes.present) {
      map['end_minutes'] = Variable<int>(endMinutes.value);
    }
    if (breakMinutes.present) {
      map['break_minutes'] = Variable<int>(breakMinutes.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<int>(hourlyRate.value);
    }
    if (workersNeeded.present) {
      map['workers_needed'] = Variable<int>(workersNeeded.value);
    }
    if (duties.present) {
      map['duties'] = Variable<String>(duties.value);
    }
    if (dressCode.present) {
      map['dress_code'] = Variable<String>(dressCode.value);
    }
    if (employerComment.present) {
      map['employer_comment'] = Variable<String>(employerComment.value);
    }
    if (payoutDelayDays.present) {
      map['payout_delay_days'] = Variable<int>(payoutDelayDays.value);
    }
    if (cancelDeadlineHours.present) {
      map['cancel_deadline_hours'] = Variable<int>(cancelDeadlineHours.value);
    }
    if (minRating.present) {
      map['min_rating'] = Variable<double>(minRating.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShiftRowsCompanion(')
          ..write('id: $id, ')
          ..write('workDate: $workDate, ')
          ..write('title: $title, ')
          ..write('company: $company, ')
          ..write('address: $address, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('workersNeeded: $workersNeeded, ')
          ..write('duties: $duties, ')
          ..write('dressCode: $dressCode, ')
          ..write('employerComment: $employerComment, ')
          ..write('payoutDelayDays: $payoutDelayDays, ')
          ..write('cancelDeadlineHours: $cancelDeadlineHours, ')
          ..write('minRating: $minRating')
          ..write(')'))
        .toString();
  }
}

class $ApplicationRowsTable extends ApplicationRows
    with TableInfo<$ApplicationRowsTable, ApplicationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ApplicationRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _workerIdMeta = const VerificationMeta(
    'workerId',
  );
  @override
  late final GeneratedColumn<int> workerId = GeneratedColumn<int>(
    'worker_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
    shiftId,
    workerId,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'application_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ApplicationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('worker_id')) {
      context.handle(
        _workerIdMeta,
        workerId.isAcceptableOrUnknown(data['worker_id']!, _workerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_workerIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {shiftId, workerId},
  ];
  @override
  ApplicationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ApplicationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      )!,
      workerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}worker_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ApplicationRowsTable createAlias(String alias) {
    return $ApplicationRowsTable(attachedDatabase, alias);
  }
}

class ApplicationRow extends DataClass implements Insertable<ApplicationRow> {
  final int id;

  /// Внешний ключ: ссылка на строку в таблице смен.
  /// База не позволит создать отклик на несуществующую смену.
  final int shiftId;
  final int workerId;
  final String status;
  final DateTime createdAt;
  const ApplicationRow({
    required this.id,
    required this.shiftId,
    required this.workerId,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shift_id'] = Variable<int>(shiftId);
    map['worker_id'] = Variable<int>(workerId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ApplicationRowsCompanion toCompanion(bool nullToAbsent) {
    return ApplicationRowsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      workerId: Value(workerId),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory ApplicationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ApplicationRow(
      id: serializer.fromJson<int>(json['id']),
      shiftId: serializer.fromJson<int>(json['shiftId']),
      workerId: serializer.fromJson<int>(json['workerId']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shiftId': serializer.toJson<int>(shiftId),
      'workerId': serializer.toJson<int>(workerId),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ApplicationRow copyWith({
    int? id,
    int? shiftId,
    int? workerId,
    String? status,
    DateTime? createdAt,
  }) => ApplicationRow(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    workerId: workerId ?? this.workerId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  ApplicationRow copyWithCompanion(ApplicationRowsCompanion data) {
    return ApplicationRow(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApplicationRow(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('workerId: $workerId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, shiftId, workerId, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApplicationRow &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.workerId == this.workerId &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class ApplicationRowsCompanion extends UpdateCompanion<ApplicationRow> {
  final Value<int> id;
  final Value<int> shiftId;
  final Value<int> workerId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const ApplicationRowsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.workerId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ApplicationRowsCompanion.insert({
    this.id = const Value.absent(),
    required int shiftId,
    required int workerId,
    required String status,
    required DateTime createdAt,
  }) : shiftId = Value(shiftId),
       workerId = Value(workerId),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<ApplicationRow> custom({
    Expression<int>? id,
    Expression<int>? shiftId,
    Expression<int>? workerId,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (workerId != null) 'worker_id': workerId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ApplicationRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? shiftId,
    Value<int>? workerId,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return ApplicationRowsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      workerId: workerId ?? this.workerId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (workerId.present) {
      map['worker_id'] = Variable<int>(workerId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ApplicationRowsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('workerId: $workerId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $UserRowsTable extends UserRows with TableInfo<$UserRowsTable, UserRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fullNameMeta = const VerificationMeta(
    'fullName',
  );
  @override
  late final GeneratedColumn<String> fullName = GeneratedColumn<String>(
    'full_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<double> rating = GeneratedColumn<double>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(4.0),
  );
  static const VerificationMeta _isVerifiedMeta = const VerificationMeta(
    'isVerified',
  );
  @override
  late final GeneratedColumn<bool> isVerified = GeneratedColumn<bool>(
    'is_verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
    phone,
    fullName,
    city,
    rating,
    isVerified,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    } else if (isInserting) {
      context.missing(_phoneMeta);
    }
    if (data.containsKey('full_name')) {
      context.handle(
        _fullNameMeta,
        fullName.isAcceptableOrUnknown(data['full_name']!, _fullNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fullNameMeta);
    }
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
    } else if (isInserting) {
      context.missing(_cityMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_verified')) {
      context.handle(
        _isVerifiedMeta,
        isVerified.isAcceptableOrUnknown(data['is_verified']!, _isVerifiedMeta),
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
  UserRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      )!,
      fullName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}full_name'],
      )!,
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating'],
      )!,
      isVerified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_verified'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserRowsTable createAlias(String alias) {
    return $UserRowsTable(attachedDatabase, alias);
  }
}

class UserRow extends DataClass implements Insertable<UserRow> {
  final int id;

  /// Телефон — логин. UNIQUE: два аккаунта на один номер невозможны,
  /// и это проверяет сама база, а не код.
  final String phone;
  final String fullName;
  final String city;

  /// Рейтинг. У новичка он не пустой, а стартовый — иначе он не прошёл бы
  /// ни один фильтр по рейтингу и не смог бы начать работать вообще.
  final double rating;
  final bool isVerified;
  final DateTime createdAt;
  const UserRow({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.city,
    required this.rating,
    required this.isVerified,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phone'] = Variable<String>(phone);
    map['full_name'] = Variable<String>(fullName);
    map['city'] = Variable<String>(city);
    map['rating'] = Variable<double>(rating);
    map['is_verified'] = Variable<bool>(isVerified);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserRowsCompanion toCompanion(bool nullToAbsent) {
    return UserRowsCompanion(
      id: Value(id),
      phone: Value(phone),
      fullName: Value(fullName),
      city: Value(city),
      rating: Value(rating),
      isVerified: Value(isVerified),
      createdAt: Value(createdAt),
    );
  }

  factory UserRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserRow(
      id: serializer.fromJson<int>(json['id']),
      phone: serializer.fromJson<String>(json['phone']),
      fullName: serializer.fromJson<String>(json['fullName']),
      city: serializer.fromJson<String>(json['city']),
      rating: serializer.fromJson<double>(json['rating']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phone': serializer.toJson<String>(phone),
      'fullName': serializer.toJson<String>(fullName),
      'city': serializer.toJson<String>(city),
      'rating': serializer.toJson<double>(rating),
      'isVerified': serializer.toJson<bool>(isVerified),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserRow copyWith({
    int? id,
    String? phone,
    String? fullName,
    String? city,
    double? rating,
    bool? isVerified,
    DateTime? createdAt,
  }) => UserRow(
    id: id ?? this.id,
    phone: phone ?? this.phone,
    fullName: fullName ?? this.fullName,
    city: city ?? this.city,
    rating: rating ?? this.rating,
    isVerified: isVerified ?? this.isVerified,
    createdAt: createdAt ?? this.createdAt,
  );
  UserRow copyWithCompanion(UserRowsCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      city: data.city.present ? data.city.value : this.city,
      rating: data.rating.present ? data.rating.value : this.rating,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('fullName: $fullName, ')
          ..write('city: $city, ')
          ..write('rating: $rating, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, phone, fullName, city, rating, isVerified, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.fullName == this.fullName &&
          other.city == this.city &&
          other.rating == this.rating &&
          other.isVerified == this.isVerified &&
          other.createdAt == this.createdAt);
}

class UserRowsCompanion extends UpdateCompanion<UserRow> {
  final Value<int> id;
  final Value<String> phone;
  final Value<String> fullName;
  final Value<String> city;
  final Value<double> rating;
  final Value<bool> isVerified;
  final Value<DateTime> createdAt;
  const UserRowsCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.fullName = const Value.absent(),
    this.city = const Value.absent(),
    this.rating = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserRowsCompanion.insert({
    this.id = const Value.absent(),
    required String phone,
    required String fullName,
    required String city,
    this.rating = const Value.absent(),
    this.isVerified = const Value.absent(),
    required DateTime createdAt,
  }) : phone = Value(phone),
       fullName = Value(fullName),
       city = Value(city),
       createdAt = Value(createdAt);
  static Insertable<UserRow> custom({
    Expression<int>? id,
    Expression<String>? phone,
    Expression<String>? fullName,
    Expression<String>? city,
    Expression<double>? rating,
    Expression<bool>? isVerified,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (fullName != null) 'full_name': fullName,
      if (city != null) 'city': city,
      if (rating != null) 'rating': rating,
      if (isVerified != null) 'is_verified': isVerified,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? phone,
    Value<String>? fullName,
    Value<String>? city,
    Value<double>? rating,
    Value<bool>? isVerified,
    Value<DateTime>? createdAt,
  }) {
    return UserRowsCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (fullName.present) {
      map['full_name'] = Variable<String>(fullName.value);
    }
    if (city.present) {
      map['city'] = Variable<String>(city.value);
    }
    if (rating.present) {
      map['rating'] = Variable<double>(rating.value);
    }
    if (isVerified.present) {
      map['is_verified'] = Variable<bool>(isVerified.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserRowsCompanion(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('fullName: $fullName, ')
          ..write('city: $city, ')
          ..write('rating: $rating, ')
          ..write('isVerified: $isVerified, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, AppSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
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
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSetting> instance, {
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
  AppSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class AppSetting extends DataClass implements Insertable<AppSetting> {
  final String key;
  final String value;
  const AppSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory AppSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSetting(
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

  AppSetting copyWith({String? key, String? value}) =>
      AppSetting(key: key ?? this.key, value: value ?? this.value);
  AppSetting copyWithCompanion(AppSettingsCompanion data) {
    return AppSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSetting(')
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
      (other is AppSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<AppSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<AppSetting> custom({
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

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
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
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewRowsTable extends ReviewRows
    with TableInfo<$ReviewRowsTable, ReviewRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
    'shift_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES shift_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _authorIdMeta = const VerificationMeta(
    'authorId',
  );
  @override
  late final GeneratedColumn<int> authorId = GeneratedColumn<int>(
    'author_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _commentMeta = const VerificationMeta(
    'comment',
  );
  @override
  late final GeneratedColumn<String> comment = GeneratedColumn<String>(
    'comment',
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
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    authorId,
    rating,
    comment,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    } else if (isInserting) {
      context.missing(_shiftIdMeta);
    }
    if (data.containsKey('author_id')) {
      context.handle(
        _authorIdMeta,
        authorId.isAcceptableOrUnknown(data['author_id']!, _authorIdMeta),
      );
    } else if (isInserting) {
      context.missing(_authorIdMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('comment')) {
      context.handle(
        _commentMeta,
        comment.isAcceptableOrUnknown(data['comment']!, _commentMeta),
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
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {shiftId, authorId},
  ];
  @override
  ReviewRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      )!,
      authorId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}author_id'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      comment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}comment'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ReviewRowsTable createAlias(String alias) {
    return $ReviewRowsTable(attachedDatabase, alias);
  }
}

class ReviewRow extends DataClass implements Insertable<ReviewRow> {
  final int id;
  final int shiftId;
  final int authorId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  const ReviewRow({
    required this.id,
    required this.shiftId,
    required this.authorId,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shift_id'] = Variable<int>(shiftId);
    map['author_id'] = Variable<int>(authorId);
    map['rating'] = Variable<int>(rating);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReviewRowsCompanion toCompanion(bool nullToAbsent) {
    return ReviewRowsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      authorId: Value(authorId),
      rating: Value(rating),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAt: Value(createdAt),
    );
  }

  factory ReviewRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewRow(
      id: serializer.fromJson<int>(json['id']),
      shiftId: serializer.fromJson<int>(json['shiftId']),
      authorId: serializer.fromJson<int>(json['authorId']),
      rating: serializer.fromJson<int>(json['rating']),
      comment: serializer.fromJson<String?>(json['comment']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shiftId': serializer.toJson<int>(shiftId),
      'authorId': serializer.toJson<int>(authorId),
      'rating': serializer.toJson<int>(rating),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ReviewRow copyWith({
    int? id,
    int? shiftId,
    int? authorId,
    int? rating,
    Value<String?> comment = const Value.absent(),
    DateTime? createdAt,
  }) => ReviewRow(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    authorId: authorId ?? this.authorId,
    rating: rating ?? this.rating,
    comment: comment.present ? comment.value : this.comment,
    createdAt: createdAt ?? this.createdAt,
  );
  ReviewRow copyWithCompanion(ReviewRowsCompanion data) {
    return ReviewRow(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      rating: data.rating.present ? data.rating.value : this.rating,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewRow(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('authorId: $authorId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, shiftId, authorId, rating, comment, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewRow &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.authorId == this.authorId &&
          other.rating == this.rating &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt);
}

class ReviewRowsCompanion extends UpdateCompanion<ReviewRow> {
  final Value<int> id;
  final Value<int> shiftId;
  final Value<int> authorId;
  final Value<int> rating;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  const ReviewRowsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.rating = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReviewRowsCompanion.insert({
    this.id = const Value.absent(),
    required int shiftId,
    required int authorId,
    required int rating,
    this.comment = const Value.absent(),
    required DateTime createdAt,
  }) : shiftId = Value(shiftId),
       authorId = Value(authorId),
       rating = Value(rating),
       createdAt = Value(createdAt);
  static Insertable<ReviewRow> custom({
    Expression<int>? id,
    Expression<int>? shiftId,
    Expression<int>? authorId,
    Expression<int>? rating,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (authorId != null) 'author_id': authorId,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReviewRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? shiftId,
    Value<int>? authorId,
    Value<int>? rating,
    Value<String?>? comment,
    Value<DateTime>? createdAt,
  }) {
    return ReviewRowsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      authorId: authorId ?? this.authorId,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (authorId.present) {
      map['author_id'] = Variable<int>(authorId.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (comment.present) {
      map['comment'] = Variable<String>(comment.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewRowsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('authorId: $authorId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShiftRowsTable shiftRows = $ShiftRowsTable(this);
  late final $ApplicationRowsTable applicationRows = $ApplicationRowsTable(
    this,
  );
  late final $UserRowsTable userRows = $UserRowsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $ReviewRowsTable reviewRows = $ReviewRowsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shiftRows,
    applicationRows,
    userRows,
    appSettings,
    reviewRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shift_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('application_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shift_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ShiftRowsTableCreateCompanionBuilder = ShiftRowsCompanion Function({
  Value<int> id,
  required DateTime workDate,
  required String title,
  required String company,
  required String address,
  required int startMinutes,
  required int endMinutes,
  Value<int> breakMinutes,
  required int hourlyRate,
  required int workersNeeded,
  Value<String> duties,
  Value<String?> dressCode,
  Value<String?> employerComment,
  Value<int> payoutDelayDays,
  Value<int> cancelDeadlineHours,
  Value<double?> minRating,
});
typedef $$ShiftRowsTableUpdateCompanionBuilder = ShiftRowsCompanion Function({
  Value<int> id,
  Value<DateTime> workDate,
  Value<String> title,
  Value<String> company,
  Value<String> address,
  Value<int> startMinutes,
  Value<int> endMinutes,
  Value<int> breakMinutes,
  Value<int> hourlyRate,
  Value<int> workersNeeded,
  Value<String> duties,
  Value<String?> dressCode,
  Value<String?> employerComment,
  Value<int> payoutDelayDays,
  Value<int> cancelDeadlineHours,
  Value<double?> minRating,
});

final class $$ShiftRowsTableReferences
    extends BaseReferences<_$AppDatabase, $ShiftRowsTable, ShiftRow> {
  $$ShiftRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ApplicationRowsTable, List<ApplicationRow>>
  _applicationRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.applicationRows,
    aliasName: 'shift_rows__id__application_rows__shift_id',
  );

  $$ApplicationRowsTableProcessedTableManager get applicationRowsRefs {
    final manager = $$ApplicationRowsTableTableManager(
      $_db,
      $_db.applicationRows,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _applicationRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewRowsTable, List<ReviewRow>>
  _reviewRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewRows,
    aliasName: 'shift_rows__id__review_rows__shift_id',
  );

  $$ReviewRowsTableProcessedTableManager get reviewRowsRefs {
    final manager = $$ReviewRowsTableTableManager(
      $_db,
      $_db.reviewRows,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_reviewRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ShiftRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ShiftRowsTable> {
  $$ShiftRowsTableFilterComposer({
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

  ColumnFilters<DateTime> get workDate => $composableBuilder(
    column: $table.workDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get workersNeeded => $composableBuilder(
    column: $table.workersNeeded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get duties => $composableBuilder(
    column: $table.duties,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dressCode => $composableBuilder(
    column: $table.dressCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get employerComment => $composableBuilder(
    column: $table.employerComment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get payoutDelayDays => $composableBuilder(
    column: $table.payoutDelayDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cancelDeadlineHours => $composableBuilder(
    column: $table.cancelDeadlineHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get minRating => $composableBuilder(
    column: $table.minRating,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> applicationRowsRefs(
    Expression<bool> Function($$ApplicationRowsTableFilterComposer f) f,
  ) {
    final $$ApplicationRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.applicationRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationRowsTableFilterComposer(
            $db: $db,
            $table: $db.applicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewRowsRefs(
    Expression<bool> Function($$ReviewRowsTableFilterComposer f) f,
  ) {
    final $$ReviewRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewRowsTableFilterComposer(
            $db: $db,
            $table: $db.reviewRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShiftRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShiftRowsTable> {
  $$ShiftRowsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get workDate => $composableBuilder(
    column: $table.workDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get workersNeeded => $composableBuilder(
    column: $table.workersNeeded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get duties => $composableBuilder(
    column: $table.duties,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dressCode => $composableBuilder(
    column: $table.dressCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get employerComment => $composableBuilder(
    column: $table.employerComment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get payoutDelayDays => $composableBuilder(
    column: $table.payoutDelayDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cancelDeadlineHours => $composableBuilder(
    column: $table.cancelDeadlineHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get minRating => $composableBuilder(
    column: $table.minRating,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShiftRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShiftRowsTable> {
  $$ShiftRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get workDate =>
      $composableBuilder(column: $table.workDate, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<int> get startMinutes => $composableBuilder(
    column: $table.startMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get endMinutes => $composableBuilder(
    column: $table.endMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get breakMinutes => $composableBuilder(
    column: $table.breakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get workersNeeded => $composableBuilder(
    column: $table.workersNeeded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get duties =>
      $composableBuilder(column: $table.duties, builder: (column) => column);

  GeneratedColumn<String> get dressCode =>
      $composableBuilder(column: $table.dressCode, builder: (column) => column);

  GeneratedColumn<String> get employerComment => $composableBuilder(
    column: $table.employerComment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get payoutDelayDays => $composableBuilder(
    column: $table.payoutDelayDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cancelDeadlineHours => $composableBuilder(
    column: $table.cancelDeadlineHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minRating =>
      $composableBuilder(column: $table.minRating, builder: (column) => column);

  Expression<T> applicationRowsRefs<T extends Object>(
    Expression<T> Function($$ApplicationRowsTableAnnotationComposer a) f,
  ) {
    final $$ApplicationRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.applicationRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ApplicationRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.applicationRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewRowsRefs<T extends Object>(
    Expression<T> Function($$ReviewRowsTableAnnotationComposer a) f,
  ) {
    final $$ReviewRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ShiftRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShiftRowsTable,
          ShiftRow,
          $$ShiftRowsTableFilterComposer,
          $$ShiftRowsTableOrderingComposer,
          $$ShiftRowsTableAnnotationComposer,
          $$ShiftRowsTableCreateCompanionBuilder,
          $$ShiftRowsTableUpdateCompanionBuilder,
          (ShiftRow, $$ShiftRowsTableReferences),
          ShiftRow,
          PrefetchHooks Function({
            bool applicationRowsRefs,
            bool reviewRowsRefs,
          })
        > {
  $$ShiftRowsTableTableManager(_$AppDatabase db, $ShiftRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShiftRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShiftRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShiftRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> workDate = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> company = const Value.absent(),
                Value<String> address = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<int> hourlyRate = const Value.absent(),
                Value<int> workersNeeded = const Value.absent(),
                Value<String> duties = const Value.absent(),
                Value<String?> dressCode = const Value.absent(),
                Value<String?> employerComment = const Value.absent(),
                Value<int> payoutDelayDays = const Value.absent(),
                Value<int> cancelDeadlineHours = const Value.absent(),
                Value<double?> minRating = const Value.absent(),
              }) => ShiftRowsCompanion(
                id: id,
                workDate: workDate,
                title: title,
                company: company,
                address: address,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                breakMinutes: breakMinutes,
                hourlyRate: hourlyRate,
                workersNeeded: workersNeeded,
                duties: duties,
                dressCode: dressCode,
                employerComment: employerComment,
                payoutDelayDays: payoutDelayDays,
                cancelDeadlineHours: cancelDeadlineHours,
                minRating: minRating,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime workDate,
                required String title,
                required String company,
                required String address,
                required int startMinutes,
                required int endMinutes,
                Value<int> breakMinutes = const Value.absent(),
                required int hourlyRate,
                required int workersNeeded,
                Value<String> duties = const Value.absent(),
                Value<String?> dressCode = const Value.absent(),
                Value<String?> employerComment = const Value.absent(),
                Value<int> payoutDelayDays = const Value.absent(),
                Value<int> cancelDeadlineHours = const Value.absent(),
                Value<double?> minRating = const Value.absent(),
              }) => ShiftRowsCompanion.insert(
                id: id,
                workDate: workDate,
                title: title,
                company: company,
                address: address,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                breakMinutes: breakMinutes,
                hourlyRate: hourlyRate,
                workersNeeded: workersNeeded,
                duties: duties,
                dressCode: dressCode,
                employerComment: employerComment,
                payoutDelayDays: payoutDelayDays,
                cancelDeadlineHours: cancelDeadlineHours,
                minRating: minRating,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShiftRowsTable, ShiftRow>(table),
                  $$ShiftRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({applicationRowsRefs = false, reviewRowsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (applicationRowsRefs) db.applicationRows,
                    if (reviewRowsRefs) db.reviewRows,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (applicationRowsRefs)
                        await $_getPrefetchedData<
                          ShiftRow,
                          $ShiftRowsTable,
                          ApplicationRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftRowsTableReferences
                              ._applicationRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).applicationRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewRowsRefs)
                        await $_getPrefetchedData<
                          ShiftRow,
                          $ShiftRowsTable,
                          ReviewRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftRowsTableReferences
                              ._reviewRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ShiftRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShiftRowsTable,
      ShiftRow,
      $$ShiftRowsTableFilterComposer,
      $$ShiftRowsTableOrderingComposer,
      $$ShiftRowsTableAnnotationComposer,
      $$ShiftRowsTableCreateCompanionBuilder,
      $$ShiftRowsTableUpdateCompanionBuilder,
      (ShiftRow, $$ShiftRowsTableReferences),
      ShiftRow,
      PrefetchHooks Function({bool applicationRowsRefs, bool reviewRowsRefs})
    >;
typedef $$ApplicationRowsTableCreateCompanionBuilder =
    ApplicationRowsCompanion Function({
      Value<int> id,
      required int shiftId,
      required int workerId,
      required String status,
      required DateTime createdAt,
    });
typedef $$ApplicationRowsTableUpdateCompanionBuilder =
    ApplicationRowsCompanion Function({
      Value<int> id,
      Value<int> shiftId,
      Value<int> workerId,
      Value<String> status,
      Value<DateTime> createdAt,
    });

final class $$ApplicationRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ApplicationRowsTable, ApplicationRow> {
  $$ApplicationRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftRowsTable _shiftIdTable(_$AppDatabase db) =>
      db.shiftRows.createAlias('application_rows__shift_id__shift_rows__id');

  $$ShiftRowsTableProcessedTableManager get shiftId {
    final $_column = $_itemColumn<int>('shift_id')!;

    final manager = $$ShiftRowsTableTableManager(
      $_db,
      $_db.shiftRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ApplicationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ApplicationRowsTable> {
  $$ApplicationRowsTableFilterComposer({
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

  ColumnFilters<int> get workerId => $composableBuilder(
    column: $table.workerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftRowsTableFilterComposer get shiftId {
    final $$ShiftRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shiftRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftRowsTableFilterComposer(
            $db: $db,
            $table: $db.shiftRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApplicationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ApplicationRowsTable> {
  $$ApplicationRowsTableOrderingComposer({
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

  ColumnOrderings<int> get workerId => $composableBuilder(
    column: $table.workerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftRowsTableOrderingComposer get shiftId {
    final $$ShiftRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shiftRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftRowsTableOrderingComposer(
            $db: $db,
            $table: $db.shiftRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApplicationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ApplicationRowsTable> {
  $$ApplicationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get workerId =>
      $composableBuilder(column: $table.workerId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShiftRowsTableAnnotationComposer get shiftId {
    final $$ShiftRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shiftRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.shiftRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ApplicationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ApplicationRowsTable,
          ApplicationRow,
          $$ApplicationRowsTableFilterComposer,
          $$ApplicationRowsTableOrderingComposer,
          $$ApplicationRowsTableAnnotationComposer,
          $$ApplicationRowsTableCreateCompanionBuilder,
          $$ApplicationRowsTableUpdateCompanionBuilder,
          (ApplicationRow, $$ApplicationRowsTableReferences),
          ApplicationRow,
          PrefetchHooks Function({bool shiftId})
        > {
  $$ApplicationRowsTableTableManager(
    _$AppDatabase db,
    $ApplicationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ApplicationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ApplicationRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ApplicationRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shiftId = const Value.absent(),
                Value<int> workerId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ApplicationRowsCompanion(
                id: id,
                shiftId: shiftId,
                workerId: workerId,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shiftId,
                required int workerId,
                required String status,
                required DateTime createdAt,
              }) => ApplicationRowsCompanion.insert(
                id: id,
                shiftId: shiftId,
                workerId: workerId,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ApplicationRowsTable, ApplicationRow>(table),
                  $$ApplicationRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shiftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shiftId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.shiftId,
                        referencedTable: $$ApplicationRowsTableReferences
                            ._shiftIdTable(db),
                        referencedColumn: $$ApplicationRowsTableReferences
                            ._shiftIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ApplicationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ApplicationRowsTable,
      ApplicationRow,
      $$ApplicationRowsTableFilterComposer,
      $$ApplicationRowsTableOrderingComposer,
      $$ApplicationRowsTableAnnotationComposer,
      $$ApplicationRowsTableCreateCompanionBuilder,
      $$ApplicationRowsTableUpdateCompanionBuilder,
      (ApplicationRow, $$ApplicationRowsTableReferences),
      ApplicationRow,
      PrefetchHooks Function({bool shiftId})
    >;
typedef $$UserRowsTableCreateCompanionBuilder = UserRowsCompanion Function({
  Value<int> id,
  required String phone,
  required String fullName,
  required String city,
  Value<double> rating,
  Value<bool> isVerified,
  required DateTime createdAt,
});
typedef $$UserRowsTableUpdateCompanionBuilder = UserRowsCompanion Function({
  Value<int> id,
  Value<String> phone,
  Value<String> fullName,
  Value<String> city,
  Value<double> rating,
  Value<bool> isVerified,
  Value<DateTime> createdAt,
});

class $$UserRowsTableFilterComposer
    extends Composer<_$AppDatabase, $UserRowsTable> {
  $$UserRowsTableFilterComposer({
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

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $UserRowsTable> {
  $$UserRowsTableOrderingComposer({
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

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fullName => $composableBuilder(
    column: $table.fullName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserRowsTable> {
  $$UserRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get fullName =>
      $composableBuilder(column: $table.fullName, builder: (column) => column);

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

  GeneratedColumn<double> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isVerified => $composableBuilder(
    column: $table.isVerified,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserRowsTable,
          UserRow,
          $$UserRowsTableFilterComposer,
          $$UserRowsTableOrderingComposer,
          $$UserRowsTableAnnotationComposer,
          $$UserRowsTableCreateCompanionBuilder,
          $$UserRowsTableUpdateCompanionBuilder,
          (UserRow, BaseReferences<_$AppDatabase, $UserRowsTable, UserRow>),
          UserRow,
          PrefetchHooks Function()
        > {
  $$UserRowsTableTableManager(_$AppDatabase db, $UserRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> phone = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserRowsCompanion(
                id: id,
                phone: phone,
                fullName: fullName,
                city: city,
                rating: rating,
                isVerified: isVerified,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String phone,
                required String fullName,
                required String city,
                Value<double> rating = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                required DateTime createdAt,
              }) => UserRowsCompanion.insert(
                id: id,
                phone: phone,
                fullName: fullName,
                city: city,
                rating: rating,
                isVerified: isVerified,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserRowsTable, UserRow>(table),
                  BaseReferences<_$AppDatabase, $UserRowsTable, UserRow>(
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

typedef $$UserRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserRowsTable,
      UserRow,
      $$UserRowsTableFilterComposer,
      $$UserRowsTableOrderingComposer,
      $$UserRowsTableAnnotationComposer,
      $$UserRowsTableCreateCompanionBuilder,
      $$UserRowsTableUpdateCompanionBuilder,
      (UserRow, BaseReferences<_$AppDatabase, $UserRowsTable, UserRow>),
      UserRow,
      PrefetchHooks Function()
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
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

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
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

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
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

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          AppSetting,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            AppSetting,
            BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
          ),
          AppSetting,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTable, AppSetting>(table),
                  BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>(
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

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      AppSetting,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        AppSetting,
        BaseReferences<_$AppDatabase, $AppSettingsTable, AppSetting>,
      ),
      AppSetting,
      PrefetchHooks Function()
    >;
typedef $$ReviewRowsTableCreateCompanionBuilder = ReviewRowsCompanion Function({
  Value<int> id,
  required int shiftId,
  required int authorId,
  required int rating,
  Value<String?> comment,
  required DateTime createdAt,
});
typedef $$ReviewRowsTableUpdateCompanionBuilder = ReviewRowsCompanion Function({
  Value<int> id,
  Value<int> shiftId,
  Value<int> authorId,
  Value<int> rating,
  Value<String?> comment,
  Value<DateTime> createdAt,
});

final class $$ReviewRowsTableReferences
    extends BaseReferences<_$AppDatabase, $ReviewRowsTable, ReviewRow> {
  $$ReviewRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftRowsTable _shiftIdTable(_$AppDatabase db) =>
      db.shiftRows.createAlias('review_rows__shift_id__shift_rows__id');

  $$ShiftRowsTableProcessedTableManager get shiftId {
    final $_column = $_itemColumn<int>('shift_id')!;

    final manager = $$ShiftRowsTableTableManager(
      $_db,
      $_db.shiftRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_shiftIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewRowsTable> {
  $$ReviewRowsTableFilterComposer({
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

  ColumnFilters<int> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ShiftRowsTableFilterComposer get shiftId {
    final $$ShiftRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shiftRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftRowsTableFilterComposer(
            $db: $db,
            $table: $db.shiftRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewRowsTable> {
  $$ReviewRowsTableOrderingComposer({
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

  ColumnOrderings<int> get authorId => $composableBuilder(
    column: $table.authorId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get comment => $composableBuilder(
    column: $table.comment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ShiftRowsTableOrderingComposer get shiftId {
    final $$ShiftRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shiftRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftRowsTableOrderingComposer(
            $db: $db,
            $table: $db.shiftRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewRowsTable> {
  $$ReviewRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get authorId =>
      $composableBuilder(column: $table.authorId, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<String> get comment =>
      $composableBuilder(column: $table.comment, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ShiftRowsTableAnnotationComposer get shiftId {
    final $$ShiftRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.shiftId,
      referencedTable: $db.shiftRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShiftRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.shiftRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewRowsTable,
          ReviewRow,
          $$ReviewRowsTableFilterComposer,
          $$ReviewRowsTableOrderingComposer,
          $$ReviewRowsTableAnnotationComposer,
          $$ReviewRowsTableCreateCompanionBuilder,
          $$ReviewRowsTableUpdateCompanionBuilder,
          (ReviewRow, $$ReviewRowsTableReferences),
          ReviewRow,
          PrefetchHooks Function({bool shiftId})
        > {
  $$ReviewRowsTableTableManager(_$AppDatabase db, $ReviewRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shiftId = const Value.absent(),
                Value<int> authorId = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => ReviewRowsCompanion(
                id: id,
                shiftId: shiftId,
                authorId: authorId,
                rating: rating,
                comment: comment,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shiftId,
                required int authorId,
                required int rating,
                Value<String?> comment = const Value.absent(),
                required DateTime createdAt,
              }) => ReviewRowsCompanion.insert(
                id: id,
                shiftId: shiftId,
                authorId: authorId,
                rating: rating,
                comment: comment,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReviewRowsTable, ReviewRow>(table),
                  $$ReviewRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({shiftId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (shiftId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.shiftId,
                        referencedTable: $$ReviewRowsTableReferences
                            ._shiftIdTable(db),
                        referencedColumn: $$ReviewRowsTableReferences
                            ._shiftIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewRowsTable,
      ReviewRow,
      $$ReviewRowsTableFilterComposer,
      $$ReviewRowsTableOrderingComposer,
      $$ReviewRowsTableAnnotationComposer,
      $$ReviewRowsTableCreateCompanionBuilder,
      $$ReviewRowsTableUpdateCompanionBuilder,
      (ReviewRow, $$ReviewRowsTableReferences),
      ReviewRow,
      PrefetchHooks Function({bool shiftId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShiftRowsTableTableManager get shiftRows =>
      $$ShiftRowsTableTableManager(_db, _db.shiftRows);
  $$ApplicationRowsTableTableManager get applicationRows =>
      $$ApplicationRowsTableTableManager(_db, _db.applicationRows);
  $$UserRowsTableTableManager get userRows =>
      $$UserRowsTableTableManager(_db, _db.userRows);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$ReviewRowsTableTableManager get reviewRows =>
      $$ReviewRowsTableTableManager(_db, _db.reviewRows);
}
