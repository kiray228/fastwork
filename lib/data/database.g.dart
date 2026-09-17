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
          ..write('payoutDelayDays: $payoutDelayDays')
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
          other.payoutDelayDays == this.payoutDelayDays);
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
          ..write('payoutDelayDays: $payoutDelayDays')
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ShiftRowsTable shiftRows = $ShiftRowsTable(this);
  late final $ApplicationRowsTable applicationRows = $ApplicationRowsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    shiftRows,
    applicationRows,
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
          PrefetchHooks Function({bool applicationRowsRefs})
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
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShiftRowsTable, ShiftRow>(table),
                  $$ShiftRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({applicationRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (applicationRowsRefs) db.applicationRows,
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
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.shiftId == item.id),
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
      PrefetchHooks Function({bool applicationRowsRefs})
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

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ShiftRowsTableTableManager get shiftRows =>
      $$ShiftRowsTableTableManager(_db, _db.shiftRows);
  $$ApplicationRowsTableTableManager get applicationRows =>
      $$ApplicationRowsTableTableManager(_db, _db.applicationRows);
}
