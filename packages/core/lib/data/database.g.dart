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
  static const VerificationMeta _cityMeta = const VerificationMeta('city');
  @override
  late final GeneratedColumn<String> city = GeneratedColumn<String>(
    'city',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Алматы'),
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
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<int> createdBy = GeneratedColumn<int>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
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
  static const VerificationMeta _cancelledAtMeta = const VerificationMeta(
    'cancelledAt',
  );
  @override
  late final GeneratedColumn<DateTime> cancelledAt = GeneratedColumn<DateTime>(
    'cancelled_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workDate,
    title,
    company,
    address,
    city,
    startMinutes,
    endMinutes,
    breakMinutes,
    hourlyRate,
    workersNeeded,
    duties,
    dressCode,
    employerComment,
    payoutDelayDays,
    createdBy,
    cancelDeadlineHours,
    minRating,
    cancelledAt,
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
    if (data.containsKey('city')) {
      context.handle(
        _cityMeta,
        city.isAcceptableOrUnknown(data['city']!, _cityMeta),
      );
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
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
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
    if (data.containsKey('cancelled_at')) {
      context.handle(
        _cancelledAtMeta,
        cancelledAt.isAcceptableOrUnknown(
          data['cancelled_at']!,
          _cancelledAtMeta,
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
      city: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}city'],
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
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_by'],
      ),
      cancelDeadlineHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cancel_deadline_hours'],
      )!,
      minRating: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}min_rating'],
      ),
      cancelledAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}cancelled_at'],
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

  /// Город. Лента показывает смены только того города, который выбрал
  /// человек: подработка в другом городе ему не нужна.
  final String city;
  final int startMinutes;
  final int endMinutes;
  final int breakMinutes;
  final int hourlyRate;
  final int workersNeeded;
  final String duties;
  final String? dressCode;
  final String? employerComment;
  final int payoutDelayDays;

  /// Кто создал смену. null — учебные данные, созданные приложением.
  final int? createdBy;

  /// За сколько часов до начала смены ещё можно отменить запись.
  /// Добавлена во второй версии схемы — см. миграцию ниже.
  final int cancelDeadlineHours;

  /// Минимальный рейтинг для допуска к смене. null — ограничений нет.
  /// Добавлена в третьей версии схемы.
  final double? minRating;

  /// Когда заказчик отменил смену. null — смена в силе.
  ///
  /// Строку не удаляем, а помечаем. Удали мы её — вместе со сменой по
  /// каскаду исчезли бы все отклики, и человек, который на неё
  /// рассчитывал, не нашёл бы в архиве даже следа. А так смена остаётся:
  /// её видно в «Моих сменах» с пометкой «отменена».
  final DateTime? cancelledAt;
  const ShiftRow({
    required this.id,
    required this.workDate,
    required this.title,
    required this.company,
    required this.address,
    required this.city,
    required this.startMinutes,
    required this.endMinutes,
    required this.breakMinutes,
    required this.hourlyRate,
    required this.workersNeeded,
    required this.duties,
    this.dressCode,
    this.employerComment,
    required this.payoutDelayDays,
    this.createdBy,
    required this.cancelDeadlineHours,
    this.minRating,
    this.cancelledAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['work_date'] = Variable<DateTime>(workDate);
    map['title'] = Variable<String>(title);
    map['company'] = Variable<String>(company);
    map['address'] = Variable<String>(address);
    map['city'] = Variable<String>(city);
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
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<int>(createdBy);
    }
    map['cancel_deadline_hours'] = Variable<int>(cancelDeadlineHours);
    if (!nullToAbsent || minRating != null) {
      map['min_rating'] = Variable<double>(minRating);
    }
    if (!nullToAbsent || cancelledAt != null) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt);
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
      city: Value(city),
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
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      cancelDeadlineHours: Value(cancelDeadlineHours),
      minRating: minRating == null && nullToAbsent
          ? const Value.absent()
          : Value(minRating),
      cancelledAt: cancelledAt == null && nullToAbsent
          ? const Value.absent()
          : Value(cancelledAt),
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
      city: serializer.fromJson<String>(json['city']),
      startMinutes: serializer.fromJson<int>(json['startMinutes']),
      endMinutes: serializer.fromJson<int>(json['endMinutes']),
      breakMinutes: serializer.fromJson<int>(json['breakMinutes']),
      hourlyRate: serializer.fromJson<int>(json['hourlyRate']),
      workersNeeded: serializer.fromJson<int>(json['workersNeeded']),
      duties: serializer.fromJson<String>(json['duties']),
      dressCode: serializer.fromJson<String?>(json['dressCode']),
      employerComment: serializer.fromJson<String?>(json['employerComment']),
      payoutDelayDays: serializer.fromJson<int>(json['payoutDelayDays']),
      createdBy: serializer.fromJson<int?>(json['createdBy']),
      cancelDeadlineHours: serializer.fromJson<int>(
        json['cancelDeadlineHours'],
      ),
      minRating: serializer.fromJson<double?>(json['minRating']),
      cancelledAt: serializer.fromJson<DateTime?>(json['cancelledAt']),
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
      'city': serializer.toJson<String>(city),
      'startMinutes': serializer.toJson<int>(startMinutes),
      'endMinutes': serializer.toJson<int>(endMinutes),
      'breakMinutes': serializer.toJson<int>(breakMinutes),
      'hourlyRate': serializer.toJson<int>(hourlyRate),
      'workersNeeded': serializer.toJson<int>(workersNeeded),
      'duties': serializer.toJson<String>(duties),
      'dressCode': serializer.toJson<String?>(dressCode),
      'employerComment': serializer.toJson<String?>(employerComment),
      'payoutDelayDays': serializer.toJson<int>(payoutDelayDays),
      'createdBy': serializer.toJson<int?>(createdBy),
      'cancelDeadlineHours': serializer.toJson<int>(cancelDeadlineHours),
      'minRating': serializer.toJson<double?>(minRating),
      'cancelledAt': serializer.toJson<DateTime?>(cancelledAt),
    };
  }

  ShiftRow copyWith({
    int? id,
    DateTime? workDate,
    String? title,
    String? company,
    String? address,
    String? city,
    int? startMinutes,
    int? endMinutes,
    int? breakMinutes,
    int? hourlyRate,
    int? workersNeeded,
    String? duties,
    Value<String?> dressCode = const Value.absent(),
    Value<String?> employerComment = const Value.absent(),
    int? payoutDelayDays,
    Value<int?> createdBy = const Value.absent(),
    int? cancelDeadlineHours,
    Value<double?> minRating = const Value.absent(),
    Value<DateTime?> cancelledAt = const Value.absent(),
  }) => ShiftRow(
    id: id ?? this.id,
    workDate: workDate ?? this.workDate,
    title: title ?? this.title,
    company: company ?? this.company,
    address: address ?? this.address,
    city: city ?? this.city,
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
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    cancelDeadlineHours: cancelDeadlineHours ?? this.cancelDeadlineHours,
    minRating: minRating.present ? minRating.value : this.minRating,
    cancelledAt: cancelledAt.present ? cancelledAt.value : this.cancelledAt,
  );
  ShiftRow copyWithCompanion(ShiftRowsCompanion data) {
    return ShiftRow(
      id: data.id.present ? data.id.value : this.id,
      workDate: data.workDate.present ? data.workDate.value : this.workDate,
      title: data.title.present ? data.title.value : this.title,
      company: data.company.present ? data.company.value : this.company,
      address: data.address.present ? data.address.value : this.address,
      city: data.city.present ? data.city.value : this.city,
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
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      cancelDeadlineHours: data.cancelDeadlineHours.present
          ? data.cancelDeadlineHours.value
          : this.cancelDeadlineHours,
      minRating: data.minRating.present ? data.minRating.value : this.minRating,
      cancelledAt: data.cancelledAt.present
          ? data.cancelledAt.value
          : this.cancelledAt,
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
          ..write('city: $city, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('workersNeeded: $workersNeeded, ')
          ..write('duties: $duties, ')
          ..write('dressCode: $dressCode, ')
          ..write('employerComment: $employerComment, ')
          ..write('payoutDelayDays: $payoutDelayDays, ')
          ..write('createdBy: $createdBy, ')
          ..write('cancelDeadlineHours: $cancelDeadlineHours, ')
          ..write('minRating: $minRating, ')
          ..write('cancelledAt: $cancelledAt')
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
    city,
    startMinutes,
    endMinutes,
    breakMinutes,
    hourlyRate,
    workersNeeded,
    duties,
    dressCode,
    employerComment,
    payoutDelayDays,
    createdBy,
    cancelDeadlineHours,
    minRating,
    cancelledAt,
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
          other.city == this.city &&
          other.startMinutes == this.startMinutes &&
          other.endMinutes == this.endMinutes &&
          other.breakMinutes == this.breakMinutes &&
          other.hourlyRate == this.hourlyRate &&
          other.workersNeeded == this.workersNeeded &&
          other.duties == this.duties &&
          other.dressCode == this.dressCode &&
          other.employerComment == this.employerComment &&
          other.payoutDelayDays == this.payoutDelayDays &&
          other.createdBy == this.createdBy &&
          other.cancelDeadlineHours == this.cancelDeadlineHours &&
          other.minRating == this.minRating &&
          other.cancelledAt == this.cancelledAt);
}

class ShiftRowsCompanion extends UpdateCompanion<ShiftRow> {
  final Value<int> id;
  final Value<DateTime> workDate;
  final Value<String> title;
  final Value<String> company;
  final Value<String> address;
  final Value<String> city;
  final Value<int> startMinutes;
  final Value<int> endMinutes;
  final Value<int> breakMinutes;
  final Value<int> hourlyRate;
  final Value<int> workersNeeded;
  final Value<String> duties;
  final Value<String?> dressCode;
  final Value<String?> employerComment;
  final Value<int> payoutDelayDays;
  final Value<int?> createdBy;
  final Value<int> cancelDeadlineHours;
  final Value<double?> minRating;
  final Value<DateTime?> cancelledAt;
  const ShiftRowsCompanion({
    this.id = const Value.absent(),
    this.workDate = const Value.absent(),
    this.title = const Value.absent(),
    this.company = const Value.absent(),
    this.address = const Value.absent(),
    this.city = const Value.absent(),
    this.startMinutes = const Value.absent(),
    this.endMinutes = const Value.absent(),
    this.breakMinutes = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.workersNeeded = const Value.absent(),
    this.duties = const Value.absent(),
    this.dressCode = const Value.absent(),
    this.employerComment = const Value.absent(),
    this.payoutDelayDays = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.cancelDeadlineHours = const Value.absent(),
    this.minRating = const Value.absent(),
    this.cancelledAt = const Value.absent(),
  });
  ShiftRowsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime workDate,
    required String title,
    required String company,
    required String address,
    this.city = const Value.absent(),
    required int startMinutes,
    required int endMinutes,
    this.breakMinutes = const Value.absent(),
    required int hourlyRate,
    required int workersNeeded,
    this.duties = const Value.absent(),
    this.dressCode = const Value.absent(),
    this.employerComment = const Value.absent(),
    this.payoutDelayDays = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.cancelDeadlineHours = const Value.absent(),
    this.minRating = const Value.absent(),
    this.cancelledAt = const Value.absent(),
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
    Expression<String>? city,
    Expression<int>? startMinutes,
    Expression<int>? endMinutes,
    Expression<int>? breakMinutes,
    Expression<int>? hourlyRate,
    Expression<int>? workersNeeded,
    Expression<String>? duties,
    Expression<String>? dressCode,
    Expression<String>? employerComment,
    Expression<int>? payoutDelayDays,
    Expression<int>? createdBy,
    Expression<int>? cancelDeadlineHours,
    Expression<double>? minRating,
    Expression<DateTime>? cancelledAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workDate != null) 'work_date': workDate,
      if (title != null) 'title': title,
      if (company != null) 'company': company,
      if (address != null) 'address': address,
      if (city != null) 'city': city,
      if (startMinutes != null) 'start_minutes': startMinutes,
      if (endMinutes != null) 'end_minutes': endMinutes,
      if (breakMinutes != null) 'break_minutes': breakMinutes,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (workersNeeded != null) 'workers_needed': workersNeeded,
      if (duties != null) 'duties': duties,
      if (dressCode != null) 'dress_code': dressCode,
      if (employerComment != null) 'employer_comment': employerComment,
      if (payoutDelayDays != null) 'payout_delay_days': payoutDelayDays,
      if (createdBy != null) 'created_by': createdBy,
      if (cancelDeadlineHours != null)
        'cancel_deadline_hours': cancelDeadlineHours,
      if (minRating != null) 'min_rating': minRating,
      if (cancelledAt != null) 'cancelled_at': cancelledAt,
    });
  }

  ShiftRowsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? workDate,
    Value<String>? title,
    Value<String>? company,
    Value<String>? address,
    Value<String>? city,
    Value<int>? startMinutes,
    Value<int>? endMinutes,
    Value<int>? breakMinutes,
    Value<int>? hourlyRate,
    Value<int>? workersNeeded,
    Value<String>? duties,
    Value<String?>? dressCode,
    Value<String?>? employerComment,
    Value<int>? payoutDelayDays,
    Value<int?>? createdBy,
    Value<int>? cancelDeadlineHours,
    Value<double?>? minRating,
    Value<DateTime?>? cancelledAt,
  }) {
    return ShiftRowsCompanion(
      id: id ?? this.id,
      workDate: workDate ?? this.workDate,
      title: title ?? this.title,
      company: company ?? this.company,
      address: address ?? this.address,
      city: city ?? this.city,
      startMinutes: startMinutes ?? this.startMinutes,
      endMinutes: endMinutes ?? this.endMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      workersNeeded: workersNeeded ?? this.workersNeeded,
      duties: duties ?? this.duties,
      dressCode: dressCode ?? this.dressCode,
      employerComment: employerComment ?? this.employerComment,
      payoutDelayDays: payoutDelayDays ?? this.payoutDelayDays,
      createdBy: createdBy ?? this.createdBy,
      cancelDeadlineHours: cancelDeadlineHours ?? this.cancelDeadlineHours,
      minRating: minRating ?? this.minRating,
      cancelledAt: cancelledAt ?? this.cancelledAt,
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
    if (city.present) {
      map['city'] = Variable<String>(city.value);
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
    if (createdBy.present) {
      map['created_by'] = Variable<int>(createdBy.value);
    }
    if (cancelDeadlineHours.present) {
      map['cancel_deadline_hours'] = Variable<int>(cancelDeadlineHours.value);
    }
    if (minRating.present) {
      map['min_rating'] = Variable<double>(minRating.value);
    }
    if (cancelledAt.present) {
      map['cancelled_at'] = Variable<DateTime>(cancelledAt.value);
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
          ..write('city: $city, ')
          ..write('startMinutes: $startMinutes, ')
          ..write('endMinutes: $endMinutes, ')
          ..write('breakMinutes: $breakMinutes, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('workersNeeded: $workersNeeded, ')
          ..write('duties: $duties, ')
          ..write('dressCode: $dressCode, ')
          ..write('employerComment: $employerComment, ')
          ..write('payoutDelayDays: $payoutDelayDays, ')
          ..write('createdBy: $createdBy, ')
          ..write('cancelDeadlineHours: $cancelDeadlineHours, ')
          ..write('minRating: $minRating, ')
          ..write('cancelledAt: $cancelledAt')
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
  static const VerificationMeta _checkedInAtMeta = const VerificationMeta(
    'checkedInAt',
  );
  @override
  late final GeneratedColumn<DateTime> checkedInAt = GeneratedColumn<DateTime>(
    'checked_in_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    workerId,
    status,
    createdAt,
    checkedInAt,
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
    if (data.containsKey('checked_in_at')) {
      context.handle(
        _checkedInAtMeta,
        checkedInAt.isAcceptableOrUnknown(
          data['checked_in_at']!,
          _checkedInAtMeta,
        ),
      );
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
      checkedInAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}checked_in_at'],
      ),
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

  /// Когда исполнитель отметился на месте. null — ещё не отмечался.
  ///
  /// Хранить именно **время**, а не галочку «отметился», выгоднее:
  /// из времени всегда можно получить галочку (`!= null`), а из галочки
  /// время уже не вернёшь. Общее правило: храни самое подробное.
  final DateTime? checkedInAt;
  const ApplicationRow({
    required this.id,
    required this.shiftId,
    required this.workerId,
    required this.status,
    required this.createdAt,
    this.checkedInAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shift_id'] = Variable<int>(shiftId);
    map['worker_id'] = Variable<int>(workerId);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || checkedInAt != null) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt);
    }
    return map;
  }

  ApplicationRowsCompanion toCompanion(bool nullToAbsent) {
    return ApplicationRowsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      workerId: Value(workerId),
      status: Value(status),
      createdAt: Value(createdAt),
      checkedInAt: checkedInAt == null && nullToAbsent
          ? const Value.absent()
          : Value(checkedInAt),
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
      checkedInAt: serializer.fromJson<DateTime?>(json['checkedInAt']),
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
      'checkedInAt': serializer.toJson<DateTime?>(checkedInAt),
    };
  }

  ApplicationRow copyWith({
    int? id,
    int? shiftId,
    int? workerId,
    String? status,
    DateTime? createdAt,
    Value<DateTime?> checkedInAt = const Value.absent(),
  }) => ApplicationRow(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    workerId: workerId ?? this.workerId,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    checkedInAt: checkedInAt.present ? checkedInAt.value : this.checkedInAt,
  );
  ApplicationRow copyWithCompanion(ApplicationRowsCompanion data) {
    return ApplicationRow(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      checkedInAt: data.checkedInAt.present
          ? data.checkedInAt.value
          : this.checkedInAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ApplicationRow(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('workerId: $workerId, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('checkedInAt: $checkedInAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, shiftId, workerId, status, createdAt, checkedInAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ApplicationRow &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.workerId == this.workerId &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.checkedInAt == this.checkedInAt);
}

class ApplicationRowsCompanion extends UpdateCompanion<ApplicationRow> {
  final Value<int> id;
  final Value<int> shiftId;
  final Value<int> workerId;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime?> checkedInAt;
  const ApplicationRowsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.workerId = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.checkedInAt = const Value.absent(),
  });
  ApplicationRowsCompanion.insert({
    this.id = const Value.absent(),
    required int shiftId,
    required int workerId,
    required String status,
    required DateTime createdAt,
    this.checkedInAt = const Value.absent(),
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
    Expression<DateTime>? checkedInAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (workerId != null) 'worker_id': workerId,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (checkedInAt != null) 'checked_in_at': checkedInAt,
    });
  }

  ApplicationRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? shiftId,
    Value<int>? workerId,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime?>? checkedInAt,
  }) {
    return ApplicationRowsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      workerId: workerId ?? this.workerId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      checkedInAt: checkedInAt ?? this.checkedInAt,
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
    if (checkedInAt.present) {
      map['checked_in_at'] = Variable<DateTime>(checkedInAt.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('checkedInAt: $checkedInAt')
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
      SqlDialect.sqlite: 'CHECK ("is_verified" IN (0, 1))',
      SqlDialect.postgres: '',
    }),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(UserRole.worker),
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
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
    phone,
    email,
    fullName,
    city,
    rating,
    isVerified,
    role,
    company,
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
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
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
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
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
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
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
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
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

  /// Почта — на неё приходит код для входа, по ней же человека узнают.
  /// Может быть пустой у тех, кто регистрировался до появления кодов.
  final String? email;
  final String fullName;
  final String city;

  /// Рейтинг. У новичка он не пустой, а стартовый — иначе он не прошёл бы
  /// ни один фильтр по рейтингу и не смог бы начать работать вообще.
  final double rating;
  final bool isVerified;

  /// Роль: `worker` — исполнитель, `manager` — сотрудник компании.
  /// Роль это **свойство** пользователя, а не отдельная таблица: поля у них
  /// одинаковые, различается только поведение.
  final String role;

  /// Название компании для менеджера. У исполнителя пусто.
  final String? company;
  final DateTime createdAt;
  const UserRow({
    required this.id,
    required this.phone,
    this.email,
    required this.fullName,
    required this.city,
    required this.rating,
    required this.isVerified,
    required this.role,
    this.company,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['phone'] = Variable<String>(phone);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['full_name'] = Variable<String>(fullName);
    map['city'] = Variable<String>(city);
    map['rating'] = Variable<double>(rating);
    map['is_verified'] = Variable<bool>(isVerified);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  UserRowsCompanion toCompanion(bool nullToAbsent) {
    return UserRowsCompanion(
      id: Value(id),
      phone: Value(phone),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      fullName: Value(fullName),
      city: Value(city),
      rating: Value(rating),
      isVerified: Value(isVerified),
      role: Value(role),
      company: company == null && nullToAbsent
          ? const Value.absent()
          : Value(company),
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
      email: serializer.fromJson<String?>(json['email']),
      fullName: serializer.fromJson<String>(json['fullName']),
      city: serializer.fromJson<String>(json['city']),
      rating: serializer.fromJson<double>(json['rating']),
      isVerified: serializer.fromJson<bool>(json['isVerified']),
      role: serializer.fromJson<String>(json['role']),
      company: serializer.fromJson<String?>(json['company']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'phone': serializer.toJson<String>(phone),
      'email': serializer.toJson<String?>(email),
      'fullName': serializer.toJson<String>(fullName),
      'city': serializer.toJson<String>(city),
      'rating': serializer.toJson<double>(rating),
      'isVerified': serializer.toJson<bool>(isVerified),
      'role': serializer.toJson<String>(role),
      'company': serializer.toJson<String?>(company),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  UserRow copyWith({
    int? id,
    String? phone,
    Value<String?> email = const Value.absent(),
    String? fullName,
    String? city,
    double? rating,
    bool? isVerified,
    String? role,
    Value<String?> company = const Value.absent(),
    DateTime? createdAt,
  }) => UserRow(
    id: id ?? this.id,
    phone: phone ?? this.phone,
    email: email.present ? email.value : this.email,
    fullName: fullName ?? this.fullName,
    city: city ?? this.city,
    rating: rating ?? this.rating,
    isVerified: isVerified ?? this.isVerified,
    role: role ?? this.role,
    company: company.present ? company.value : this.company,
    createdAt: createdAt ?? this.createdAt,
  );
  UserRow copyWithCompanion(UserRowsCompanion data) {
    return UserRow(
      id: data.id.present ? data.id.value : this.id,
      phone: data.phone.present ? data.phone.value : this.phone,
      email: data.email.present ? data.email.value : this.email,
      fullName: data.fullName.present ? data.fullName.value : this.fullName,
      city: data.city.present ? data.city.value : this.city,
      rating: data.rating.present ? data.rating.value : this.rating,
      isVerified: data.isVerified.present
          ? data.isVerified.value
          : this.isVerified,
      role: data.role.present ? data.role.value : this.role,
      company: data.company.present ? data.company.value : this.company,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserRow(')
          ..write('id: $id, ')
          ..write('phone: $phone, ')
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('city: $city, ')
          ..write('rating: $rating, ')
          ..write('isVerified: $isVerified, ')
          ..write('role: $role, ')
          ..write('company: $company, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phone,
    email,
    fullName,
    city,
    rating,
    isVerified,
    role,
    company,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserRow &&
          other.id == this.id &&
          other.phone == this.phone &&
          other.email == this.email &&
          other.fullName == this.fullName &&
          other.city == this.city &&
          other.rating == this.rating &&
          other.isVerified == this.isVerified &&
          other.role == this.role &&
          other.company == this.company &&
          other.createdAt == this.createdAt);
}

class UserRowsCompanion extends UpdateCompanion<UserRow> {
  final Value<int> id;
  final Value<String> phone;
  final Value<String?> email;
  final Value<String> fullName;
  final Value<String> city;
  final Value<double> rating;
  final Value<bool> isVerified;
  final Value<String> role;
  final Value<String?> company;
  final Value<DateTime> createdAt;
  const UserRowsCompanion({
    this.id = const Value.absent(),
    this.phone = const Value.absent(),
    this.email = const Value.absent(),
    this.fullName = const Value.absent(),
    this.city = const Value.absent(),
    this.rating = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.role = const Value.absent(),
    this.company = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserRowsCompanion.insert({
    this.id = const Value.absent(),
    required String phone,
    this.email = const Value.absent(),
    required String fullName,
    required String city,
    this.rating = const Value.absent(),
    this.isVerified = const Value.absent(),
    this.role = const Value.absent(),
    this.company = const Value.absent(),
    required DateTime createdAt,
  }) : phone = Value(phone),
       fullName = Value(fullName),
       city = Value(city),
       createdAt = Value(createdAt);
  static Insertable<UserRow> custom({
    Expression<int>? id,
    Expression<String>? phone,
    Expression<String>? email,
    Expression<String>? fullName,
    Expression<String>? city,
    Expression<double>? rating,
    Expression<bool>? isVerified,
    Expression<String>? role,
    Expression<String>? company,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (fullName != null) 'full_name': fullName,
      if (city != null) 'city': city,
      if (rating != null) 'rating': rating,
      if (isVerified != null) 'is_verified': isVerified,
      if (role != null) 'role': role,
      if (company != null) 'company': company,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? phone,
    Value<String?>? email,
    Value<String>? fullName,
    Value<String>? city,
    Value<double>? rating,
    Value<bool>? isVerified,
    Value<String>? role,
    Value<String?>? company,
    Value<DateTime>? createdAt,
  }) {
    return UserRowsCompanion(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      role: role ?? this.role,
      company: company ?? this.company,
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
    if (email.present) {
      map['email'] = Variable<String>(email.value);
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
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
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
          ..write('email: $email, ')
          ..write('fullName: $fullName, ')
          ..write('city: $city, ')
          ..write('rating: $rating, ')
          ..write('isVerified: $isVerified, ')
          ..write('role: $role, ')
          ..write('company: $company, ')
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

class $DocumentRowsTable extends DocumentRows
    with TableInfo<$DocumentRowsTable, DocumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<String> number = GeneratedColumn<String>(
    'number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
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
    userId,
    type,
    number,
    expiresAt,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'document_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DocumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('number')) {
      context.handle(
        _numberMeta,
        number.isAcceptableOrUnknown(data['number']!, _numberMeta),
      );
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
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
    {userId, type},
  ];
  @override
  DocumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DocumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      number: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}number'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      ),
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
  $DocumentRowsTable createAlias(String alias) {
    return $DocumentRowsTable(attachedDatabase, alias);
  }
}

class DocumentRow extends DataClass implements Insertable<DocumentRow> {
  final int id;
  final int userId;
  final String type;
  final String number;
  final DateTime? expiresAt;

  /// Состояние проверки: pending → approved или rejected.
  final String status;
  final DateTime createdAt;
  const DocumentRow({
    required this.id,
    required this.userId,
    required this.type,
    required this.number,
    this.expiresAt,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['type'] = Variable<String>(type);
    map['number'] = Variable<String>(number);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<DateTime>(expiresAt);
    }
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DocumentRowsCompanion toCompanion(bool nullToAbsent) {
    return DocumentRowsCompanion(
      id: Value(id),
      userId: Value(userId),
      type: Value(type),
      number: Value(number),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory DocumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DocumentRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      type: serializer.fromJson<String>(json['type']),
      number: serializer.fromJson<String>(json['number']),
      expiresAt: serializer.fromJson<DateTime?>(json['expiresAt']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'type': serializer.toJson<String>(type),
      'number': serializer.toJson<String>(number),
      'expiresAt': serializer.toJson<DateTime?>(expiresAt),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DocumentRow copyWith({
    int? id,
    int? userId,
    String? type,
    String? number,
    Value<DateTime?> expiresAt = const Value.absent(),
    String? status,
    DateTime? createdAt,
  }) => DocumentRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    type: type ?? this.type,
    number: number ?? this.number,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  DocumentRow copyWithCompanion(DocumentRowsCompanion data) {
    return DocumentRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      type: data.type.present ? data.type.value : this.type,
      number: data.number.present ? data.number.value : this.number,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DocumentRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('number: $number, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, type, number, expiresAt, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DocumentRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.type == this.type &&
          other.number == this.number &&
          other.expiresAt == this.expiresAt &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class DocumentRowsCompanion extends UpdateCompanion<DocumentRow> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> type;
  final Value<String> number;
  final Value<DateTime?> expiresAt;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const DocumentRowsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.type = const Value.absent(),
    this.number = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DocumentRowsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String type,
    required String number,
    this.expiresAt = const Value.absent(),
    required String status,
    required DateTime createdAt,
  }) : userId = Value(userId),
       type = Value(type),
       number = Value(number),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<DocumentRow> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? type,
    Expression<String>? number,
    Expression<DateTime>? expiresAt,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (type != null) 'type': type,
      if (number != null) 'number': number,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DocumentRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? type,
    Value<String>? number,
    Value<DateTime?>? expiresAt,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return DocumentRowsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      number: number ?? this.number,
      expiresAt: expiresAt ?? this.expiresAt,
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
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (number.present) {
      map['number'] = Variable<String>(number.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
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
    return (StringBuffer('DocumentRowsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('type: $type, ')
          ..write('number: $number, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SupportTicketRowsTable extends SupportTicketRows
    with TableInfo<$SupportTicketRowsTable, SupportTicketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupportTicketRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
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
    userId,
    subject,
    status,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'support_ticket_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupportTicketRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
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
  SupportTicketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupportTicketRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
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
  $SupportTicketRowsTable createAlias(String alias) {
    return $SupportTicketRowsTable(attachedDatabase, alias);
  }
}

class SupportTicketRow extends DataClass
    implements Insertable<SupportTicketRow> {
  final int id;
  final int userId;
  final String subject;
  final String status;
  final DateTime createdAt;
  const SupportTicketRow({
    required this.id,
    required this.userId,
    required this.subject,
    required this.status,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['subject'] = Variable<String>(subject);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SupportTicketRowsCompanion toCompanion(bool nullToAbsent) {
    return SupportTicketRowsCompanion(
      id: Value(id),
      userId: Value(userId),
      subject: Value(subject),
      status: Value(status),
      createdAt: Value(createdAt),
    );
  }

  factory SupportTicketRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupportTicketRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      subject: serializer.fromJson<String>(json['subject']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'subject': serializer.toJson<String>(subject),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupportTicketRow copyWith({
    int? id,
    int? userId,
    String? subject,
    String? status,
    DateTime? createdAt,
  }) => SupportTicketRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    subject: subject ?? this.subject,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
  );
  SupportTicketRow copyWithCompanion(SupportTicketRowsCompanion data) {
    return SupportTicketRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      subject: data.subject.present ? data.subject.value : this.subject,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupportTicketRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('subject: $subject, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, userId, subject, status, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupportTicketRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.subject == this.subject &&
          other.status == this.status &&
          other.createdAt == this.createdAt);
}

class SupportTicketRowsCompanion extends UpdateCompanion<SupportTicketRow> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> subject;
  final Value<String> status;
  final Value<DateTime> createdAt;
  const SupportTicketRowsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.subject = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SupportTicketRowsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String subject,
    required String status,
    required DateTime createdAt,
  }) : userId = Value(userId),
       subject = Value(subject),
       status = Value(status),
       createdAt = Value(createdAt);
  static Insertable<SupportTicketRow> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? subject,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (subject != null) 'subject': subject,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SupportTicketRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? subject,
    Value<String>? status,
    Value<DateTime>? createdAt,
  }) {
    return SupportTicketRowsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      subject: subject ?? this.subject,
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
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
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
    return (StringBuffer('SupportTicketRowsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('subject: $subject, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SupportMessageRowsTable extends SupportMessageRows
    with TableInfo<$SupportMessageRowsTable, SupportMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SupportMessageRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _ticketIdMeta = const VerificationMeta(
    'ticketId',
  );
  @override
  late final GeneratedColumn<int> ticketId = GeneratedColumn<int>(
    'ticket_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES support_ticket_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromSupportMeta = const VerificationMeta(
    'fromSupport',
  );
  @override
  late final GeneratedColumn<bool> fromSupport = GeneratedColumn<bool>(
    'from_support',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintsDependsOnDialect({
      SqlDialect.sqlite: 'CHECK ("from_support" IN (0, 1))',
      SqlDialect.postgres: '',
    }),
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
    ticketId,
    body,
    fromSupport,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'support_message_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SupportMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('ticket_id')) {
      context.handle(
        _ticketIdMeta,
        ticketId.isAcceptableOrUnknown(data['ticket_id']!, _ticketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ticketIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('from_support')) {
      context.handle(
        _fromSupportMeta,
        fromSupport.isAcceptableOrUnknown(
          data['from_support']!,
          _fromSupportMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_fromSupportMeta);
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
  SupportMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SupportMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      ticketId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ticket_id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      fromSupport: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}from_support'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SupportMessageRowsTable createAlias(String alias) {
    return $SupportMessageRowsTable(attachedDatabase, alias);
  }
}

class SupportMessageRow extends DataClass
    implements Insertable<SupportMessageRow> {
  final int id;
  final int ticketId;

  /// Колонку нельзя назвать `text`: так называется метод drift, которым
  /// объявляют текстовые колонки, и получилось бы обращение к самому себе.
  final String body;
  final bool fromSupport;
  final DateTime createdAt;
  const SupportMessageRow({
    required this.id,
    required this.ticketId,
    required this.body,
    required this.fromSupport,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['ticket_id'] = Variable<int>(ticketId);
    map['body'] = Variable<String>(body);
    map['from_support'] = Variable<bool>(fromSupport);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SupportMessageRowsCompanion toCompanion(bool nullToAbsent) {
    return SupportMessageRowsCompanion(
      id: Value(id),
      ticketId: Value(ticketId),
      body: Value(body),
      fromSupport: Value(fromSupport),
      createdAt: Value(createdAt),
    );
  }

  factory SupportMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SupportMessageRow(
      id: serializer.fromJson<int>(json['id']),
      ticketId: serializer.fromJson<int>(json['ticketId']),
      body: serializer.fromJson<String>(json['body']),
      fromSupport: serializer.fromJson<bool>(json['fromSupport']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'ticketId': serializer.toJson<int>(ticketId),
      'body': serializer.toJson<String>(body),
      'fromSupport': serializer.toJson<bool>(fromSupport),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SupportMessageRow copyWith({
    int? id,
    int? ticketId,
    String? body,
    bool? fromSupport,
    DateTime? createdAt,
  }) => SupportMessageRow(
    id: id ?? this.id,
    ticketId: ticketId ?? this.ticketId,
    body: body ?? this.body,
    fromSupport: fromSupport ?? this.fromSupport,
    createdAt: createdAt ?? this.createdAt,
  );
  SupportMessageRow copyWithCompanion(SupportMessageRowsCompanion data) {
    return SupportMessageRow(
      id: data.id.present ? data.id.value : this.id,
      ticketId: data.ticketId.present ? data.ticketId.value : this.ticketId,
      body: data.body.present ? data.body.value : this.body,
      fromSupport: data.fromSupport.present
          ? data.fromSupport.value
          : this.fromSupport,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SupportMessageRow(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('body: $body, ')
          ..write('fromSupport: $fromSupport, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, ticketId, body, fromSupport, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SupportMessageRow &&
          other.id == this.id &&
          other.ticketId == this.ticketId &&
          other.body == this.body &&
          other.fromSupport == this.fromSupport &&
          other.createdAt == this.createdAt);
}

class SupportMessageRowsCompanion extends UpdateCompanion<SupportMessageRow> {
  final Value<int> id;
  final Value<int> ticketId;
  final Value<String> body;
  final Value<bool> fromSupport;
  final Value<DateTime> createdAt;
  const SupportMessageRowsCompanion({
    this.id = const Value.absent(),
    this.ticketId = const Value.absent(),
    this.body = const Value.absent(),
    this.fromSupport = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SupportMessageRowsCompanion.insert({
    this.id = const Value.absent(),
    required int ticketId,
    required String body,
    required bool fromSupport,
    required DateTime createdAt,
  }) : ticketId = Value(ticketId),
       body = Value(body),
       fromSupport = Value(fromSupport),
       createdAt = Value(createdAt);
  static Insertable<SupportMessageRow> custom({
    Expression<int>? id,
    Expression<int>? ticketId,
    Expression<String>? body,
    Expression<bool>? fromSupport,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ticketId != null) 'ticket_id': ticketId,
      if (body != null) 'body': body,
      if (fromSupport != null) 'from_support': fromSupport,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SupportMessageRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? ticketId,
    Value<String>? body,
    Value<bool>? fromSupport,
    Value<DateTime>? createdAt,
  }) {
    return SupportMessageRowsCompanion(
      id: id ?? this.id,
      ticketId: ticketId ?? this.ticketId,
      body: body ?? this.body,
      fromSupport: fromSupport ?? this.fromSupport,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (ticketId.present) {
      map['ticket_id'] = Variable<int>(ticketId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (fromSupport.present) {
      map['from_support'] = Variable<bool>(fromSupport.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SupportMessageRowsCompanion(')
          ..write('id: $id, ')
          ..write('ticketId: $ticketId, ')
          ..write('body: $body, ')
          ..write('fromSupport: $fromSupport, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WorkerReviewRowsTable extends WorkerReviewRows
    with TableInfo<$WorkerReviewRowsTable, WorkerReviewRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkerReviewRowsTable(this.attachedDatabase, [this._alias]);
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
    workerId,
    authorId,
    rating,
    comment,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'worker_review_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkerReviewRow> instance, {
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
    {shiftId, workerId, authorId},
  ];
  @override
  WorkerReviewRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkerReviewRow(
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
  $WorkerReviewRowsTable createAlias(String alias) {
    return $WorkerReviewRowsTable(attachedDatabase, alias);
  }
}

class WorkerReviewRow extends DataClass implements Insertable<WorkerReviewRow> {
  final int id;

  /// Смена, после которой поставлена оценка. Как и в отзывах о компании,
  /// привязка к смене — доказательство, что человек действительно работал.
  final int shiftId;

  /// Кого оценивают.
  final int workerId;

  /// Кто оценивает — заказчик.
  final int authorId;
  final int rating;
  final String? comment;
  final DateTime createdAt;
  const WorkerReviewRow({
    required this.id,
    required this.shiftId,
    required this.workerId,
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
    map['worker_id'] = Variable<int>(workerId);
    map['author_id'] = Variable<int>(authorId);
    map['rating'] = Variable<int>(rating);
    if (!nullToAbsent || comment != null) {
      map['comment'] = Variable<String>(comment);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WorkerReviewRowsCompanion toCompanion(bool nullToAbsent) {
    return WorkerReviewRowsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      workerId: Value(workerId),
      authorId: Value(authorId),
      rating: Value(rating),
      comment: comment == null && nullToAbsent
          ? const Value.absent()
          : Value(comment),
      createdAt: Value(createdAt),
    );
  }

  factory WorkerReviewRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkerReviewRow(
      id: serializer.fromJson<int>(json['id']),
      shiftId: serializer.fromJson<int>(json['shiftId']),
      workerId: serializer.fromJson<int>(json['workerId']),
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
      'workerId': serializer.toJson<int>(workerId),
      'authorId': serializer.toJson<int>(authorId),
      'rating': serializer.toJson<int>(rating),
      'comment': serializer.toJson<String?>(comment),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WorkerReviewRow copyWith({
    int? id,
    int? shiftId,
    int? workerId,
    int? authorId,
    int? rating,
    Value<String?> comment = const Value.absent(),
    DateTime? createdAt,
  }) => WorkerReviewRow(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    workerId: workerId ?? this.workerId,
    authorId: authorId ?? this.authorId,
    rating: rating ?? this.rating,
    comment: comment.present ? comment.value : this.comment,
    createdAt: createdAt ?? this.createdAt,
  );
  WorkerReviewRow copyWithCompanion(WorkerReviewRowsCompanion data) {
    return WorkerReviewRow(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      workerId: data.workerId.present ? data.workerId.value : this.workerId,
      authorId: data.authorId.present ? data.authorId.value : this.authorId,
      rating: data.rating.present ? data.rating.value : this.rating,
      comment: data.comment.present ? data.comment.value : this.comment,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkerReviewRow(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('workerId: $workerId, ')
          ..write('authorId: $authorId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, shiftId, workerId, authorId, rating, comment, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkerReviewRow &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.workerId == this.workerId &&
          other.authorId == this.authorId &&
          other.rating == this.rating &&
          other.comment == this.comment &&
          other.createdAt == this.createdAt);
}

class WorkerReviewRowsCompanion extends UpdateCompanion<WorkerReviewRow> {
  final Value<int> id;
  final Value<int> shiftId;
  final Value<int> workerId;
  final Value<int> authorId;
  final Value<int> rating;
  final Value<String?> comment;
  final Value<DateTime> createdAt;
  const WorkerReviewRowsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.workerId = const Value.absent(),
    this.authorId = const Value.absent(),
    this.rating = const Value.absent(),
    this.comment = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WorkerReviewRowsCompanion.insert({
    this.id = const Value.absent(),
    required int shiftId,
    required int workerId,
    required int authorId,
    required int rating,
    this.comment = const Value.absent(),
    required DateTime createdAt,
  }) : shiftId = Value(shiftId),
       workerId = Value(workerId),
       authorId = Value(authorId),
       rating = Value(rating),
       createdAt = Value(createdAt);
  static Insertable<WorkerReviewRow> custom({
    Expression<int>? id,
    Expression<int>? shiftId,
    Expression<int>? workerId,
    Expression<int>? authorId,
    Expression<int>? rating,
    Expression<String>? comment,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (workerId != null) 'worker_id': workerId,
      if (authorId != null) 'author_id': authorId,
      if (rating != null) 'rating': rating,
      if (comment != null) 'comment': comment,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WorkerReviewRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? shiftId,
    Value<int>? workerId,
    Value<int>? authorId,
    Value<int>? rating,
    Value<String?>? comment,
    Value<DateTime>? createdAt,
  }) {
    return WorkerReviewRowsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      workerId: workerId ?? this.workerId,
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
    if (workerId.present) {
      map['worker_id'] = Variable<int>(workerId.value);
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
    return (StringBuffer('WorkerReviewRowsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('workerId: $workerId, ')
          ..write('authorId: $authorId, ')
          ..write('rating: $rating, ')
          ..write('comment: $comment, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AuthCodeRowsTable extends AuthCodeRows
    with TableInfo<$AuthCodeRowsTable, AuthCodeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthCodeRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _codeHashMeta = const VerificationMeta(
    'codeHash',
  );
  @override
  late final GeneratedColumn<String> codeHash = GeneratedColumn<String>(
    'code_hash',
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
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  @override
  late final GeneratedColumn<DateTime> expiresAt = GeneratedColumn<DateTime>(
    'expires_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    codeHash,
    createdAt,
    expiresAt,
    attempts,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_code_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthCodeRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('code_hash')) {
      context.handle(
        _codeHashMeta,
        codeHash.isAcceptableOrUnknown(data['code_hash']!, _codeHashMeta),
      );
    } else if (isInserting) {
      context.missing(_codeHashMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    } else if (isInserting) {
      context.missing(_expiresAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AuthCodeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthCodeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      codeHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code_hash'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
    );
  }

  @override
  $AuthCodeRowsTable createAlias(String alias) {
    return $AuthCodeRowsTable(attachedDatabase, alias);
  }
}

class AuthCodeRow extends DataClass implements Insertable<AuthCodeRow> {
  final int id;
  final String email;

  /// Отпечаток кода, а не сам код.
  final String codeHash;
  final DateTime createdAt;

  /// Когда код перестаёт действовать. Без срока подобранный однажды код
  /// работал бы вечно.
  final DateTime expiresAt;

  /// Сколько раз пытались ввести. После трёх неудач код сгорает —
  /// иначе шестизначный код можно перебрать за вечер.
  final int attempts;
  const AuthCodeRow({
    required this.id,
    required this.email,
    required this.codeHash,
    required this.createdAt,
    required this.expiresAt,
    required this.attempts,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['email'] = Variable<String>(email);
    map['code_hash'] = Variable<String>(codeHash);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['expires_at'] = Variable<DateTime>(expiresAt);
    map['attempts'] = Variable<int>(attempts);
    return map;
  }

  AuthCodeRowsCompanion toCompanion(bool nullToAbsent) {
    return AuthCodeRowsCompanion(
      id: Value(id),
      email: Value(email),
      codeHash: Value(codeHash),
      createdAt: Value(createdAt),
      expiresAt: Value(expiresAt),
      attempts: Value(attempts),
    );
  }

  factory AuthCodeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthCodeRow(
      id: serializer.fromJson<int>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      codeHash: serializer.fromJson<String>(json['codeHash']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      expiresAt: serializer.fromJson<DateTime>(json['expiresAt']),
      attempts: serializer.fromJson<int>(json['attempts']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'email': serializer.toJson<String>(email),
      'codeHash': serializer.toJson<String>(codeHash),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'expiresAt': serializer.toJson<DateTime>(expiresAt),
      'attempts': serializer.toJson<int>(attempts),
    };
  }

  AuthCodeRow copyWith({
    int? id,
    String? email,
    String? codeHash,
    DateTime? createdAt,
    DateTime? expiresAt,
    int? attempts,
  }) => AuthCodeRow(
    id: id ?? this.id,
    email: email ?? this.email,
    codeHash: codeHash ?? this.codeHash,
    createdAt: createdAt ?? this.createdAt,
    expiresAt: expiresAt ?? this.expiresAt,
    attempts: attempts ?? this.attempts,
  );
  AuthCodeRow copyWithCompanion(AuthCodeRowsCompanion data) {
    return AuthCodeRow(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      codeHash: data.codeHash.present ? data.codeHash.value : this.codeHash,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthCodeRow(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('codeHash: $codeHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, email, codeHash, createdAt, expiresAt, attempts);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthCodeRow &&
          other.id == this.id &&
          other.email == this.email &&
          other.codeHash == this.codeHash &&
          other.createdAt == this.createdAt &&
          other.expiresAt == this.expiresAt &&
          other.attempts == this.attempts);
}

class AuthCodeRowsCompanion extends UpdateCompanion<AuthCodeRow> {
  final Value<int> id;
  final Value<String> email;
  final Value<String> codeHash;
  final Value<DateTime> createdAt;
  final Value<DateTime> expiresAt;
  final Value<int> attempts;
  const AuthCodeRowsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.codeHash = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.attempts = const Value.absent(),
  });
  AuthCodeRowsCompanion.insert({
    this.id = const Value.absent(),
    required String email,
    required String codeHash,
    required DateTime createdAt,
    required DateTime expiresAt,
    this.attempts = const Value.absent(),
  }) : email = Value(email),
       codeHash = Value(codeHash),
       createdAt = Value(createdAt),
       expiresAt = Value(expiresAt);
  static Insertable<AuthCodeRow> custom({
    Expression<int>? id,
    Expression<String>? email,
    Expression<String>? codeHash,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? expiresAt,
    Expression<int>? attempts,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (codeHash != null) 'code_hash': codeHash,
      if (createdAt != null) 'created_at': createdAt,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (attempts != null) 'attempts': attempts,
    });
  }

  AuthCodeRowsCompanion copyWith({
    Value<int>? id,
    Value<String>? email,
    Value<String>? codeHash,
    Value<DateTime>? createdAt,
    Value<DateTime>? expiresAt,
    Value<int>? attempts,
  }) {
    return AuthCodeRowsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      codeHash: codeHash ?? this.codeHash,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      attempts: attempts ?? this.attempts,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (codeHash.present) {
      map['code_hash'] = Variable<String>(codeHash.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<DateTime>(expiresAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthCodeRowsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('codeHash: $codeHash, ')
          ..write('createdAt: $createdAt, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('attempts: $attempts')
          ..write(')'))
        .toString();
  }
}

class $AuthTokenRowsTable extends AuthTokenRows
    with TableInfo<$AuthTokenRowsTable, AuthTokenRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AuthTokenRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
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
  List<GeneratedColumn> get $columns => [token, userId, email, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'auth_token_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<AuthTokenRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
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
  Set<GeneratedColumn> get $primaryKey => {token};
  @override
  AuthTokenRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AuthTokenRow(
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      ),
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AuthTokenRowsTable createAlias(String alias) {
    return $AuthTokenRowsTable(attachedDatabase, alias);
  }
}

class AuthTokenRow extends DataClass implements Insertable<AuthTokenRow> {
  final String token;

  /// Чей токен. null — почта подтверждена, аккаунт ещё не создан.
  final int? userId;

  /// Подтверждённая почта. По ней создаётся аккаунт на следующем шаге.
  final String email;
  final DateTime createdAt;
  const AuthTokenRow({
    required this.token,
    this.userId,
    required this.email,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['token'] = Variable<String>(token);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<int>(userId);
    }
    map['email'] = Variable<String>(email);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AuthTokenRowsCompanion toCompanion(bool nullToAbsent) {
    return AuthTokenRowsCompanion(
      token: Value(token),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      email: Value(email),
      createdAt: Value(createdAt),
    );
  }

  factory AuthTokenRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AuthTokenRow(
      token: serializer.fromJson<String>(json['token']),
      userId: serializer.fromJson<int?>(json['userId']),
      email: serializer.fromJson<String>(json['email']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'token': serializer.toJson<String>(token),
      'userId': serializer.toJson<int?>(userId),
      'email': serializer.toJson<String>(email),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AuthTokenRow copyWith({
    String? token,
    Value<int?> userId = const Value.absent(),
    String? email,
    DateTime? createdAt,
  }) => AuthTokenRow(
    token: token ?? this.token,
    userId: userId.present ? userId.value : this.userId,
    email: email ?? this.email,
    createdAt: createdAt ?? this.createdAt,
  );
  AuthTokenRow copyWithCompanion(AuthTokenRowsCompanion data) {
    return AuthTokenRow(
      token: data.token.present ? data.token.value : this.token,
      userId: data.userId.present ? data.userId.value : this.userId,
      email: data.email.present ? data.email.value : this.email,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AuthTokenRow(')
          ..write('token: $token, ')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(token, userId, email, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthTokenRow &&
          other.token == this.token &&
          other.userId == this.userId &&
          other.email == this.email &&
          other.createdAt == this.createdAt);
}

class AuthTokenRowsCompanion extends UpdateCompanion<AuthTokenRow> {
  final Value<String> token;
  final Value<int?> userId;
  final Value<String> email;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AuthTokenRowsCompanion({
    this.token = const Value.absent(),
    this.userId = const Value.absent(),
    this.email = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AuthTokenRowsCompanion.insert({
    required String token,
    this.userId = const Value.absent(),
    required String email,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : token = Value(token),
       email = Value(email),
       createdAt = Value(createdAt);
  static Insertable<AuthTokenRow> custom({
    Expression<String>? token,
    Expression<int>? userId,
    Expression<String>? email,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (token != null) 'token': token,
      if (userId != null) 'user_id': userId,
      if (email != null) 'email': email,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AuthTokenRowsCompanion copyWith({
    Value<String>? token,
    Value<int?>? userId,
    Value<String>? email,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AuthTokenRowsCompanion(
      token: token ?? this.token,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AuthTokenRowsCompanion(')
          ..write('token: $token, ')
          ..write('userId: $userId, ')
          ..write('email: $email, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationRowsTable extends NotificationRows
    with TableInfo<$NotificationRowsTable, NotificationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<int> userId = GeneratedColumn<int>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
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
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shiftIdMeta = const VerificationMeta(
    'shiftId',
  );
  @override
  late final GeneratedColumn<int> shiftId = GeneratedColumn<int>(
    'shift_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<DateTime> readAt = GeneratedColumn<DateTime>(
    'read_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    kind,
    title,
    body,
    shiftId,
    createdAt,
    readAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
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
    if (data.containsKey('read_at')) {
      context.handle(
        _readAtMeta,
        readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotificationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      readAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}read_at'],
      ),
    );
  }

  @override
  $NotificationRowsTable createAlias(String alias) {
    return $NotificationRowsTable(attachedDatabase, alias);
  }
}

class NotificationRow extends DataClass implements Insertable<NotificationRow> {
  final int id;

  /// Кому адресовано.
  final int userId;

  /// Вид события — имя значения из `NotificationKind`.
  final String kind;
  final String title;
  final String body;

  /// Смена, к которой относится событие.
  ///
  /// Здесь нарочно **нет** внешнего ключа со связью «удалить вместе со
  /// сменой». В остальных таблицах он есть: отклик без смены — мусор.
  /// А уведомление «смену отменили» без смены — как раз то, ради чего
  /// оно и написано. Пусть переживёт саму смену.
  final int? shiftId;
  final DateTime createdAt;

  /// Когда прочитано. null — ещё не прочитано.
  final DateTime? readAt;
  const NotificationRow({
    required this.id,
    required this.userId,
    required this.kind,
    required this.title,
    required this.body,
    this.shiftId,
    required this.createdAt,
    this.readAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || readAt != null) {
      map['read_at'] = Variable<DateTime>(readAt);
    }
    return map;
  }

  NotificationRowsCompanion toCompanion(bool nullToAbsent) {
    return NotificationRowsCompanion(
      id: Value(id),
      userId: Value(userId),
      kind: Value(kind),
      title: Value(title),
      body: Value(body),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      createdAt: Value(createdAt),
      readAt: readAt == null && nullToAbsent
          ? const Value.absent()
          : Value(readAt),
    );
  }

  factory NotificationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      readAt: serializer.fromJson<DateTime?>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'shiftId': serializer.toJson<int?>(shiftId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'readAt': serializer.toJson<DateTime?>(readAt),
    };
  }

  NotificationRow copyWith({
    int? id,
    int? userId,
    String? kind,
    String? title,
    String? body,
    Value<int?> shiftId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> readAt = const Value.absent(),
  }) => NotificationRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    body: body ?? this.body,
    shiftId: shiftId.present ? shiftId.value : this.shiftId,
    createdAt: createdAt ?? this.createdAt,
    readAt: readAt.present ? readAt.value : this.readAt,
  );
  NotificationRow copyWithCompanion(NotificationRowsCompanion data) {
    return NotificationRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('shiftId: $shiftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, kind, title, body, shiftId, createdAt, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.body == this.body &&
          other.shiftId == this.shiftId &&
          other.createdAt == this.createdAt &&
          other.readAt == this.readAt);
}

class NotificationRowsCompanion extends UpdateCompanion<NotificationRow> {
  final Value<int> id;
  final Value<int> userId;
  final Value<String> kind;
  final Value<String> title;
  final Value<String> body;
  final Value<int?> shiftId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> readAt;
  const NotificationRowsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.readAt = const Value.absent(),
  });
  NotificationRowsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required String kind,
    required String title,
    required String body,
    this.shiftId = const Value.absent(),
    required DateTime createdAt,
    this.readAt = const Value.absent(),
  }) : userId = Value(userId),
       kind = Value(kind),
       title = Value(title),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<NotificationRow> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? body,
    Expression<int>? shiftId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? readAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (shiftId != null) 'shift_id': shiftId,
      if (createdAt != null) 'created_at': createdAt,
      if (readAt != null) 'read_at': readAt,
    });
  }

  NotificationRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<String>? kind,
    Value<String>? title,
    Value<String>? body,
    Value<int?>? shiftId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? readAt,
  }) {
    return NotificationRowsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      body: body ?? this.body,
      shiftId: shiftId ?? this.shiftId,
      createdAt: createdAt ?? this.createdAt,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<int>(userId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<DateTime>(readAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationRowsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('shiftId: $shiftId, ')
          ..write('createdAt: $createdAt, ')
          ..write('readAt: $readAt')
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
  late final $DocumentRowsTable documentRows = $DocumentRowsTable(this);
  late final $SupportTicketRowsTable supportTicketRows =
      $SupportTicketRowsTable(this);
  late final $SupportMessageRowsTable supportMessageRows =
      $SupportMessageRowsTable(this);
  late final $WorkerReviewRowsTable workerReviewRows = $WorkerReviewRowsTable(
    this,
  );
  late final $AuthCodeRowsTable authCodeRows = $AuthCodeRowsTable(this);
  late final $AuthTokenRowsTable authTokenRows = $AuthTokenRowsTable(this);
  late final $NotificationRowsTable notificationRows = $NotificationRowsTable(
    this,
  );
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
    documentRows,
    supportTicketRows,
    supportMessageRows,
    workerReviewRows,
    authCodeRows,
    authTokenRows,
    notificationRows,
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
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'support_ticket_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('support_message_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'shift_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('worker_review_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$ShiftRowsTableCreateCompanionBuilder = ShiftRowsCompanion Function({
  Value<int> id,
  required DateTime workDate,
  required String title,
  required String company,
  required String address,
  Value<String> city,
  required int startMinutes,
  required int endMinutes,
  Value<int> breakMinutes,
  required int hourlyRate,
  required int workersNeeded,
  Value<String> duties,
  Value<String?> dressCode,
  Value<String?> employerComment,
  Value<int> payoutDelayDays,
  Value<int?> createdBy,
  Value<int> cancelDeadlineHours,
  Value<double?> minRating,
  Value<DateTime?> cancelledAt,
});
typedef $$ShiftRowsTableUpdateCompanionBuilder = ShiftRowsCompanion Function({
  Value<int> id,
  Value<DateTime> workDate,
  Value<String> title,
  Value<String> company,
  Value<String> address,
  Value<String> city,
  Value<int> startMinutes,
  Value<int> endMinutes,
  Value<int> breakMinutes,
  Value<int> hourlyRate,
  Value<int> workersNeeded,
  Value<String> duties,
  Value<String?> dressCode,
  Value<String?> employerComment,
  Value<int> payoutDelayDays,
  Value<int?> createdBy,
  Value<int> cancelDeadlineHours,
  Value<double?> minRating,
  Value<DateTime?> cancelledAt,
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

  static MultiTypedResultKey<$WorkerReviewRowsTable, List<WorkerReviewRow>>
  _workerReviewRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.workerReviewRows,
    aliasName: 'shift_rows__id__worker_review_rows__shift_id',
  );

  $$WorkerReviewRowsTableProcessedTableManager get workerReviewRowsRefs {
    final manager = $$WorkerReviewRowsTableTableManager(
      $_db,
      $_db.workerReviewRows,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _workerReviewRowsRefsTable($_db),
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

  ColumnFilters<String> get city => $composableBuilder(
    column: $table.city,
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

  ColumnFilters<int> get createdBy => $composableBuilder(
    column: $table.createdBy,
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

  ColumnFilters<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
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

  Expression<bool> workerReviewRowsRefs(
    Expression<bool> Function($$WorkerReviewRowsTableFilterComposer f) f,
  ) {
    final $$WorkerReviewRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerReviewRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerReviewRowsTableFilterComposer(
            $db: $db,
            $table: $db.workerReviewRows,
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

  ColumnOrderings<String> get city => $composableBuilder(
    column: $table.city,
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

  ColumnOrderings<int> get createdBy => $composableBuilder(
    column: $table.createdBy,
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

  ColumnOrderings<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
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

  GeneratedColumn<String> get city =>
      $composableBuilder(column: $table.city, builder: (column) => column);

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

  GeneratedColumn<int> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get cancelDeadlineHours => $composableBuilder(
    column: $table.cancelDeadlineHours,
    builder: (column) => column,
  );

  GeneratedColumn<double> get minRating =>
      $composableBuilder(column: $table.minRating, builder: (column) => column);

  GeneratedColumn<DateTime> get cancelledAt => $composableBuilder(
    column: $table.cancelledAt,
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

  Expression<T> workerReviewRowsRefs<T extends Object>(
    Expression<T> Function($$WorkerReviewRowsTableAnnotationComposer a) f,
  ) {
    final $$WorkerReviewRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.workerReviewRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WorkerReviewRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.workerReviewRows,
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
            bool workerReviewRowsRefs,
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
                Value<String> city = const Value.absent(),
                Value<int> startMinutes = const Value.absent(),
                Value<int> endMinutes = const Value.absent(),
                Value<int> breakMinutes = const Value.absent(),
                Value<int> hourlyRate = const Value.absent(),
                Value<int> workersNeeded = const Value.absent(),
                Value<String> duties = const Value.absent(),
                Value<String?> dressCode = const Value.absent(),
                Value<String?> employerComment = const Value.absent(),
                Value<int> payoutDelayDays = const Value.absent(),
                Value<int?> createdBy = const Value.absent(),
                Value<int> cancelDeadlineHours = const Value.absent(),
                Value<double?> minRating = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
              }) => ShiftRowsCompanion(
                id: id,
                workDate: workDate,
                title: title,
                company: company,
                address: address,
                city: city,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                breakMinutes: breakMinutes,
                hourlyRate: hourlyRate,
                workersNeeded: workersNeeded,
                duties: duties,
                dressCode: dressCode,
                employerComment: employerComment,
                payoutDelayDays: payoutDelayDays,
                createdBy: createdBy,
                cancelDeadlineHours: cancelDeadlineHours,
                minRating: minRating,
                cancelledAt: cancelledAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime workDate,
                required String title,
                required String company,
                required String address,
                Value<String> city = const Value.absent(),
                required int startMinutes,
                required int endMinutes,
                Value<int> breakMinutes = const Value.absent(),
                required int hourlyRate,
                required int workersNeeded,
                Value<String> duties = const Value.absent(),
                Value<String?> dressCode = const Value.absent(),
                Value<String?> employerComment = const Value.absent(),
                Value<int> payoutDelayDays = const Value.absent(),
                Value<int?> createdBy = const Value.absent(),
                Value<int> cancelDeadlineHours = const Value.absent(),
                Value<double?> minRating = const Value.absent(),
                Value<DateTime?> cancelledAt = const Value.absent(),
              }) => ShiftRowsCompanion.insert(
                id: id,
                workDate: workDate,
                title: title,
                company: company,
                address: address,
                city: city,
                startMinutes: startMinutes,
                endMinutes: endMinutes,
                breakMinutes: breakMinutes,
                hourlyRate: hourlyRate,
                workersNeeded: workersNeeded,
                duties: duties,
                dressCode: dressCode,
                employerComment: employerComment,
                payoutDelayDays: payoutDelayDays,
                createdBy: createdBy,
                cancelDeadlineHours: cancelDeadlineHours,
                minRating: minRating,
                cancelledAt: cancelledAt,
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
              ({
                applicationRowsRefs = false,
                reviewRowsRefs = false,
                workerReviewRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (applicationRowsRefs) db.applicationRows,
                    if (reviewRowsRefs) db.reviewRows,
                    if (workerReviewRowsRefs) db.workerReviewRows,
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
                      if (workerReviewRowsRefs)
                        await $_getPrefetchedData<
                          ShiftRow,
                          $ShiftRowsTable,
                          WorkerReviewRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftRowsTableReferences
                              ._workerReviewRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).workerReviewRowsRefs,
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
      PrefetchHooks Function({
        bool applicationRowsRefs,
        bool reviewRowsRefs,
        bool workerReviewRowsRefs,
      })
    >;
typedef $$ApplicationRowsTableCreateCompanionBuilder =
    ApplicationRowsCompanion Function({
      Value<int> id,
      required int shiftId,
      required int workerId,
      required String status,
      required DateTime createdAt,
      Value<DateTime?> checkedInAt,
    });
typedef $$ApplicationRowsTableUpdateCompanionBuilder =
    ApplicationRowsCompanion Function({
      Value<int> id,
      Value<int> shiftId,
      Value<int> workerId,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime?> checkedInAt,
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

  ColumnFilters<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
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

  ColumnOrderings<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
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

  GeneratedColumn<DateTime> get checkedInAt => $composableBuilder(
    column: $table.checkedInAt,
    builder: (column) => column,
  );

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
                Value<DateTime?> checkedInAt = const Value.absent(),
              }) => ApplicationRowsCompanion(
                id: id,
                shiftId: shiftId,
                workerId: workerId,
                status: status,
                createdAt: createdAt,
                checkedInAt: checkedInAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shiftId,
                required int workerId,
                required String status,
                required DateTime createdAt,
                Value<DateTime?> checkedInAt = const Value.absent(),
              }) => ApplicationRowsCompanion.insert(
                id: id,
                shiftId: shiftId,
                workerId: workerId,
                status: status,
                createdAt: createdAt,
                checkedInAt: checkedInAt,
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
  Value<String?> email,
  required String fullName,
  required String city,
  Value<double> rating,
  Value<bool> isVerified,
  Value<String> role,
  Value<String?> company,
  required DateTime createdAt,
});
typedef $$UserRowsTableUpdateCompanionBuilder = UserRowsCompanion Function({
  Value<int> id,
  Value<String> phone,
  Value<String?> email,
  Value<String> fullName,
  Value<String> city,
  Value<double> rating,
  Value<bool> isVerified,
  Value<String> role,
  Value<String?> company,
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
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

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
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

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
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

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

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

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

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
                Value<String?> email = const Value.absent(),
                Value<String> fullName = const Value.absent(),
                Value<String> city = const Value.absent(),
                Value<double> rating = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => UserRowsCompanion(
                id: id,
                phone: phone,
                email: email,
                fullName: fullName,
                city: city,
                rating: rating,
                isVerified: isVerified,
                role: role,
                company: company,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String phone,
                Value<String?> email = const Value.absent(),
                required String fullName,
                required String city,
                Value<double> rating = const Value.absent(),
                Value<bool> isVerified = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> company = const Value.absent(),
                required DateTime createdAt,
              }) => UserRowsCompanion.insert(
                id: id,
                phone: phone,
                email: email,
                fullName: fullName,
                city: city,
                rating: rating,
                isVerified: isVerified,
                role: role,
                company: company,
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
typedef $$DocumentRowsTableCreateCompanionBuilder =
    DocumentRowsCompanion Function({
      Value<int> id,
      required int userId,
      required String type,
      required String number,
      Value<DateTime?> expiresAt,
      required String status,
      required DateTime createdAt,
    });
typedef $$DocumentRowsTableUpdateCompanionBuilder =
    DocumentRowsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> type,
      Value<String> number,
      Value<DateTime?> expiresAt,
      Value<String> status,
      Value<DateTime> createdAt,
    });

class $$DocumentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentRowsTable> {
  $$DocumentRowsTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
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
}

class $$DocumentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentRowsTable> {
  $$DocumentRowsTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get number => $composableBuilder(
    column: $table.number,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
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
}

class $$DocumentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentRowsTable> {
  $$DocumentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DocumentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DocumentRowsTable,
          DocumentRow,
          $$DocumentRowsTableFilterComposer,
          $$DocumentRowsTableOrderingComposer,
          $$DocumentRowsTableAnnotationComposer,
          $$DocumentRowsTableCreateCompanionBuilder,
          $$DocumentRowsTableUpdateCompanionBuilder,
          (
            DocumentRow,
            BaseReferences<_$AppDatabase, $DocumentRowsTable, DocumentRow>,
          ),
          DocumentRow,
          PrefetchHooks Function()
        > {
  $$DocumentRowsTableTableManager(_$AppDatabase db, $DocumentRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> number = const Value.absent(),
                Value<DateTime?> expiresAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DocumentRowsCompanion(
                id: id,
                userId: userId,
                type: type,
                number: number,
                expiresAt: expiresAt,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String type,
                required String number,
                Value<DateTime?> expiresAt = const Value.absent(),
                required String status,
                required DateTime createdAt,
              }) => DocumentRowsCompanion.insert(
                id: id,
                userId: userId,
                type: type,
                number: number,
                expiresAt: expiresAt,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DocumentRowsTable, DocumentRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DocumentRowsTable,
                    DocumentRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DocumentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DocumentRowsTable,
      DocumentRow,
      $$DocumentRowsTableFilterComposer,
      $$DocumentRowsTableOrderingComposer,
      $$DocumentRowsTableAnnotationComposer,
      $$DocumentRowsTableCreateCompanionBuilder,
      $$DocumentRowsTableUpdateCompanionBuilder,
      (
        DocumentRow,
        BaseReferences<_$AppDatabase, $DocumentRowsTable, DocumentRow>,
      ),
      DocumentRow,
      PrefetchHooks Function()
    >;
typedef $$SupportTicketRowsTableCreateCompanionBuilder =
    SupportTicketRowsCompanion Function({
      Value<int> id,
      required int userId,
      required String subject,
      required String status,
      required DateTime createdAt,
    });
typedef $$SupportTicketRowsTableUpdateCompanionBuilder =
    SupportTicketRowsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> subject,
      Value<String> status,
      Value<DateTime> createdAt,
    });

final class $$SupportTicketRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SupportTicketRowsTable,
          SupportTicketRow
        > {
  $$SupportTicketRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$SupportMessageRowsTable, List<SupportMessageRow>>
  _supportMessageRowsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.supportMessageRows,
        aliasName: 'support_ticket_rows__id__support_message_rows__ticket_id',
      );

  $$SupportMessageRowsTableProcessedTableManager get supportMessageRowsRefs {
    final manager = $$SupportMessageRowsTableTableManager(
      $_db,
      $_db.supportMessageRows,
    ).filter((f) => f.ticketId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _supportMessageRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SupportTicketRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SupportTicketRowsTable> {
  $$SupportTicketRowsTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
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

  Expression<bool> supportMessageRowsRefs(
    Expression<bool> Function($$SupportMessageRowsTableFilterComposer f) f,
  ) {
    final $$SupportMessageRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.supportMessageRows,
      getReferencedColumn: (t) => t.ticketId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupportMessageRowsTableFilterComposer(
            $db: $db,
            $table: $db.supportMessageRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SupportTicketRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupportTicketRowsTable> {
  $$SupportTicketRowsTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
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
}

class $$SupportTicketRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupportTicketRowsTable> {
  $$SupportTicketRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> supportMessageRowsRefs<T extends Object>(
    Expression<T> Function($$SupportMessageRowsTableAnnotationComposer a) f,
  ) {
    final $$SupportMessageRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.supportMessageRows,
          getReferencedColumn: (t) => t.ticketId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SupportMessageRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.supportMessageRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SupportTicketRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupportTicketRowsTable,
          SupportTicketRow,
          $$SupportTicketRowsTableFilterComposer,
          $$SupportTicketRowsTableOrderingComposer,
          $$SupportTicketRowsTableAnnotationComposer,
          $$SupportTicketRowsTableCreateCompanionBuilder,
          $$SupportTicketRowsTableUpdateCompanionBuilder,
          (SupportTicketRow, $$SupportTicketRowsTableReferences),
          SupportTicketRow,
          PrefetchHooks Function({bool supportMessageRowsRefs})
        > {
  $$SupportTicketRowsTableTableManager(
    _$AppDatabase db,
    $SupportTicketRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupportTicketRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupportTicketRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupportTicketRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SupportTicketRowsCompanion(
                id: id,
                userId: userId,
                subject: subject,
                status: status,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String subject,
                required String status,
                required DateTime createdAt,
              }) => SupportTicketRowsCompanion.insert(
                id: id,
                userId: userId,
                subject: subject,
                status: status,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupportTicketRowsTable, SupportTicketRow>(table),
                  $$SupportTicketRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({supportMessageRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (supportMessageRowsRefs) db.supportMessageRows,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (supportMessageRowsRefs)
                    await $_getPrefetchedData<
                      SupportTicketRow,
                      $SupportTicketRowsTable,
                      SupportMessageRow
                    >(
                      currentTable: table,
                      referencedTable: $$SupportTicketRowsTableReferences
                          ._supportMessageRowsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$SupportTicketRowsTableReferences(
                            db,
                            table,
                            p0,
                          ).supportMessageRowsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.ticketId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$SupportTicketRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupportTicketRowsTable,
      SupportTicketRow,
      $$SupportTicketRowsTableFilterComposer,
      $$SupportTicketRowsTableOrderingComposer,
      $$SupportTicketRowsTableAnnotationComposer,
      $$SupportTicketRowsTableCreateCompanionBuilder,
      $$SupportTicketRowsTableUpdateCompanionBuilder,
      (SupportTicketRow, $$SupportTicketRowsTableReferences),
      SupportTicketRow,
      PrefetchHooks Function({bool supportMessageRowsRefs})
    >;
typedef $$SupportMessageRowsTableCreateCompanionBuilder =
    SupportMessageRowsCompanion Function({
      Value<int> id,
      required int ticketId,
      required String body,
      required bool fromSupport,
      required DateTime createdAt,
    });
typedef $$SupportMessageRowsTableUpdateCompanionBuilder =
    SupportMessageRowsCompanion Function({
      Value<int> id,
      Value<int> ticketId,
      Value<String> body,
      Value<bool> fromSupport,
      Value<DateTime> createdAt,
    });

final class $$SupportMessageRowsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SupportMessageRowsTable,
          SupportMessageRow
        > {
  $$SupportMessageRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SupportTicketRowsTable _ticketIdTable(_$AppDatabase db) => db
      .supportTicketRows
      .createAlias('support_message_rows__ticket_id__support_ticket_rows__id');

  $$SupportTicketRowsTableProcessedTableManager get ticketId {
    final $_column = $_itemColumn<int>('ticket_id')!;

    final manager = $$SupportTicketRowsTableTableManager(
      $_db,
      $_db.supportTicketRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ticketIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SupportMessageRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SupportMessageRowsTable> {
  $$SupportMessageRowsTableFilterComposer({
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

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get fromSupport => $composableBuilder(
    column: $table.fromSupport,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SupportTicketRowsTableFilterComposer get ticketId {
    final $$SupportTicketRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.supportTicketRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupportTicketRowsTableFilterComposer(
            $db: $db,
            $table: $db.supportTicketRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupportMessageRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SupportMessageRowsTable> {
  $$SupportMessageRowsTableOrderingComposer({
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

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get fromSupport => $composableBuilder(
    column: $table.fromSupport,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SupportTicketRowsTableOrderingComposer get ticketId {
    final $$SupportTicketRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ticketId,
      referencedTable: $db.supportTicketRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SupportTicketRowsTableOrderingComposer(
            $db: $db,
            $table: $db.supportTicketRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SupportMessageRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SupportMessageRowsTable> {
  $$SupportMessageRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get fromSupport => $composableBuilder(
    column: $table.fromSupport,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$SupportTicketRowsTableAnnotationComposer get ticketId {
    final $$SupportTicketRowsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.ticketId,
          referencedTable: $db.supportTicketRows,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SupportTicketRowsTableAnnotationComposer(
                $db: $db,
                $table: $db.supportTicketRows,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$SupportMessageRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SupportMessageRowsTable,
          SupportMessageRow,
          $$SupportMessageRowsTableFilterComposer,
          $$SupportMessageRowsTableOrderingComposer,
          $$SupportMessageRowsTableAnnotationComposer,
          $$SupportMessageRowsTableCreateCompanionBuilder,
          $$SupportMessageRowsTableUpdateCompanionBuilder,
          (SupportMessageRow, $$SupportMessageRowsTableReferences),
          SupportMessageRow,
          PrefetchHooks Function({bool ticketId})
        > {
  $$SupportMessageRowsTableTableManager(
    _$AppDatabase db,
    $SupportMessageRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SupportMessageRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SupportMessageRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SupportMessageRowsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> ticketId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> fromSupport = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SupportMessageRowsCompanion(
                id: id,
                ticketId: ticketId,
                body: body,
                fromSupport: fromSupport,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int ticketId,
                required String body,
                required bool fromSupport,
                required DateTime createdAt,
              }) => SupportMessageRowsCompanion.insert(
                id: id,
                ticketId: ticketId,
                body: body,
                fromSupport: fromSupport,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SupportMessageRowsTable, SupportMessageRow>(
                    table,
                  ),
                  $$SupportMessageRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ticketId = false}) {
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
                    if (ticketId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.ticketId,
                        referencedTable: $$SupportMessageRowsTableReferences
                            ._ticketIdTable(db),
                        referencedColumn: $$SupportMessageRowsTableReferences
                            ._ticketIdTable(db)
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

typedef $$SupportMessageRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SupportMessageRowsTable,
      SupportMessageRow,
      $$SupportMessageRowsTableFilterComposer,
      $$SupportMessageRowsTableOrderingComposer,
      $$SupportMessageRowsTableAnnotationComposer,
      $$SupportMessageRowsTableCreateCompanionBuilder,
      $$SupportMessageRowsTableUpdateCompanionBuilder,
      (SupportMessageRow, $$SupportMessageRowsTableReferences),
      SupportMessageRow,
      PrefetchHooks Function({bool ticketId})
    >;
typedef $$WorkerReviewRowsTableCreateCompanionBuilder =
    WorkerReviewRowsCompanion Function({
      Value<int> id,
      required int shiftId,
      required int workerId,
      required int authorId,
      required int rating,
      Value<String?> comment,
      required DateTime createdAt,
    });
typedef $$WorkerReviewRowsTableUpdateCompanionBuilder =
    WorkerReviewRowsCompanion Function({
      Value<int> id,
      Value<int> shiftId,
      Value<int> workerId,
      Value<int> authorId,
      Value<int> rating,
      Value<String?> comment,
      Value<DateTime> createdAt,
    });

final class $$WorkerReviewRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $WorkerReviewRowsTable, WorkerReviewRow> {
  $$WorkerReviewRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ShiftRowsTable _shiftIdTable(_$AppDatabase db) =>
      db.shiftRows.createAlias('worker_review_rows__shift_id__shift_rows__id');

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

class $$WorkerReviewRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkerReviewRowsTable> {
  $$WorkerReviewRowsTableFilterComposer({
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

class $$WorkerReviewRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkerReviewRowsTable> {
  $$WorkerReviewRowsTableOrderingComposer({
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

class $$WorkerReviewRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkerReviewRowsTable> {
  $$WorkerReviewRowsTableAnnotationComposer({
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

class $$WorkerReviewRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkerReviewRowsTable,
          WorkerReviewRow,
          $$WorkerReviewRowsTableFilterComposer,
          $$WorkerReviewRowsTableOrderingComposer,
          $$WorkerReviewRowsTableAnnotationComposer,
          $$WorkerReviewRowsTableCreateCompanionBuilder,
          $$WorkerReviewRowsTableUpdateCompanionBuilder,
          (WorkerReviewRow, $$WorkerReviewRowsTableReferences),
          WorkerReviewRow,
          PrefetchHooks Function({bool shiftId})
        > {
  $$WorkerReviewRowsTableTableManager(
    _$AppDatabase db,
    $WorkerReviewRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkerReviewRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkerReviewRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkerReviewRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shiftId = const Value.absent(),
                Value<int> workerId = const Value.absent(),
                Value<int> authorId = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<String?> comment = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WorkerReviewRowsCompanion(
                id: id,
                shiftId: shiftId,
                workerId: workerId,
                authorId: authorId,
                rating: rating,
                comment: comment,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shiftId,
                required int workerId,
                required int authorId,
                required int rating,
                Value<String?> comment = const Value.absent(),
                required DateTime createdAt,
              }) => WorkerReviewRowsCompanion.insert(
                id: id,
                shiftId: shiftId,
                workerId: workerId,
                authorId: authorId,
                rating: rating,
                comment: comment,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WorkerReviewRowsTable, WorkerReviewRow>(table),
                  $$WorkerReviewRowsTableReferences(db, table, e),
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
                        referencedTable: $$WorkerReviewRowsTableReferences
                            ._shiftIdTable(db),
                        referencedColumn: $$WorkerReviewRowsTableReferences
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

typedef $$WorkerReviewRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkerReviewRowsTable,
      WorkerReviewRow,
      $$WorkerReviewRowsTableFilterComposer,
      $$WorkerReviewRowsTableOrderingComposer,
      $$WorkerReviewRowsTableAnnotationComposer,
      $$WorkerReviewRowsTableCreateCompanionBuilder,
      $$WorkerReviewRowsTableUpdateCompanionBuilder,
      (WorkerReviewRow, $$WorkerReviewRowsTableReferences),
      WorkerReviewRow,
      PrefetchHooks Function({bool shiftId})
    >;
typedef $$AuthCodeRowsTableCreateCompanionBuilder =
    AuthCodeRowsCompanion Function({
      Value<int> id,
      required String email,
      required String codeHash,
      required DateTime createdAt,
      required DateTime expiresAt,
      Value<int> attempts,
    });
typedef $$AuthCodeRowsTableUpdateCompanionBuilder =
    AuthCodeRowsCompanion Function({
      Value<int> id,
      Value<String> email,
      Value<String> codeHash,
      Value<DateTime> createdAt,
      Value<DateTime> expiresAt,
      Value<int> attempts,
    });

class $$AuthCodeRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AuthCodeRowsTable> {
  $$AuthCodeRowsTableFilterComposer({
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

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get codeHash => $composableBuilder(
    column: $table.codeHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthCodeRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthCodeRowsTable> {
  $$AuthCodeRowsTableOrderingComposer({
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

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get codeHash => $composableBuilder(
    column: $table.codeHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthCodeRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthCodeRowsTable> {
  $$AuthCodeRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get codeHash =>
      $composableBuilder(column: $table.codeHash, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);
}

class $$AuthCodeRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthCodeRowsTable,
          AuthCodeRow,
          $$AuthCodeRowsTableFilterComposer,
          $$AuthCodeRowsTableOrderingComposer,
          $$AuthCodeRowsTableAnnotationComposer,
          $$AuthCodeRowsTableCreateCompanionBuilder,
          $$AuthCodeRowsTableUpdateCompanionBuilder,
          (
            AuthCodeRow,
            BaseReferences<_$AppDatabase, $AuthCodeRowsTable, AuthCodeRow>,
          ),
          AuthCodeRow,
          PrefetchHooks Function()
        > {
  $$AuthCodeRowsTableTableManager(_$AppDatabase db, $AuthCodeRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthCodeRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthCodeRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthCodeRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> codeHash = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> expiresAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
              }) => AuthCodeRowsCompanion(
                id: id,
                email: email,
                codeHash: codeHash,
                createdAt: createdAt,
                expiresAt: expiresAt,
                attempts: attempts,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String email,
                required String codeHash,
                required DateTime createdAt,
                required DateTime expiresAt,
                Value<int> attempts = const Value.absent(),
              }) => AuthCodeRowsCompanion.insert(
                id: id,
                email: email,
                codeHash: codeHash,
                createdAt: createdAt,
                expiresAt: expiresAt,
                attempts: attempts,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuthCodeRowsTable, AuthCodeRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AuthCodeRowsTable,
                    AuthCodeRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthCodeRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthCodeRowsTable,
      AuthCodeRow,
      $$AuthCodeRowsTableFilterComposer,
      $$AuthCodeRowsTableOrderingComposer,
      $$AuthCodeRowsTableAnnotationComposer,
      $$AuthCodeRowsTableCreateCompanionBuilder,
      $$AuthCodeRowsTableUpdateCompanionBuilder,
      (
        AuthCodeRow,
        BaseReferences<_$AppDatabase, $AuthCodeRowsTable, AuthCodeRow>,
      ),
      AuthCodeRow,
      PrefetchHooks Function()
    >;
typedef $$AuthTokenRowsTableCreateCompanionBuilder =
    AuthTokenRowsCompanion Function({
      required String token,
      Value<int?> userId,
      required String email,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AuthTokenRowsTableUpdateCompanionBuilder =
    AuthTokenRowsCompanion Function({
      Value<String> token,
      Value<int?> userId,
      Value<String> email,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AuthTokenRowsTableFilterComposer
    extends Composer<_$AppDatabase, $AuthTokenRowsTable> {
  $$AuthTokenRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AuthTokenRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $AuthTokenRowsTable> {
  $$AuthTokenRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AuthTokenRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AuthTokenRowsTable> {
  $$AuthTokenRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AuthTokenRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AuthTokenRowsTable,
          AuthTokenRow,
          $$AuthTokenRowsTableFilterComposer,
          $$AuthTokenRowsTableOrderingComposer,
          $$AuthTokenRowsTableAnnotationComposer,
          $$AuthTokenRowsTableCreateCompanionBuilder,
          $$AuthTokenRowsTableUpdateCompanionBuilder,
          (
            AuthTokenRow,
            BaseReferences<_$AppDatabase, $AuthTokenRowsTable, AuthTokenRow>,
          ),
          AuthTokenRow,
          PrefetchHooks Function()
        > {
  $$AuthTokenRowsTableTableManager(_$AppDatabase db, $AuthTokenRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AuthTokenRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AuthTokenRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AuthTokenRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> token = const Value.absent(),
                Value<int?> userId = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AuthTokenRowsCompanion(
                token: token,
                userId: userId,
                email: email,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String token,
                Value<int?> userId = const Value.absent(),
                required String email,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AuthTokenRowsCompanion.insert(
                token: token,
                userId: userId,
                email: email,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AuthTokenRowsTable, AuthTokenRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AuthTokenRowsTable,
                    AuthTokenRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AuthTokenRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AuthTokenRowsTable,
      AuthTokenRow,
      $$AuthTokenRowsTableFilterComposer,
      $$AuthTokenRowsTableOrderingComposer,
      $$AuthTokenRowsTableAnnotationComposer,
      $$AuthTokenRowsTableCreateCompanionBuilder,
      $$AuthTokenRowsTableUpdateCompanionBuilder,
      (
        AuthTokenRow,
        BaseReferences<_$AppDatabase, $AuthTokenRowsTable, AuthTokenRow>,
      ),
      AuthTokenRow,
      PrefetchHooks Function()
    >;
typedef $$NotificationRowsTableCreateCompanionBuilder =
    NotificationRowsCompanion Function({
      Value<int> id,
      required int userId,
      required String kind,
      required String title,
      required String body,
      Value<int?> shiftId,
      required DateTime createdAt,
      Value<DateTime?> readAt,
    });
typedef $$NotificationRowsTableUpdateCompanionBuilder =
    NotificationRowsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<String> kind,
      Value<String> title,
      Value<String> body,
      Value<int?> shiftId,
      Value<DateTime> createdAt,
      Value<DateTime?> readAt,
    });

class $$NotificationRowsTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationRowsTable> {
  $$NotificationRowsTableFilterComposer({
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

  ColumnFilters<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationRowsTable> {
  $$NotificationRowsTableOrderingComposer({
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

  ColumnOrderings<int> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get readAt => $composableBuilder(
    column: $table.readAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationRowsTable> {
  $$NotificationRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<int> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$NotificationRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationRowsTable,
          NotificationRow,
          $$NotificationRowsTableFilterComposer,
          $$NotificationRowsTableOrderingComposer,
          $$NotificationRowsTableAnnotationComposer,
          $$NotificationRowsTableCreateCompanionBuilder,
          $$NotificationRowsTableUpdateCompanionBuilder,
          (
            NotificationRow,
            BaseReferences<
              _$AppDatabase,
              $NotificationRowsTable,
              NotificationRow
            >,
          ),
          NotificationRow,
          PrefetchHooks Function()
        > {
  $$NotificationRowsTableTableManager(
    _$AppDatabase db,
    $NotificationRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotificationRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotificationRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<int?> shiftId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> readAt = const Value.absent(),
              }) => NotificationRowsCompanion(
                id: id,
                userId: userId,
                kind: kind,
                title: title,
                body: body,
                shiftId: shiftId,
                createdAt: createdAt,
                readAt: readAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required String kind,
                required String title,
                required String body,
                Value<int?> shiftId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> readAt = const Value.absent(),
              }) => NotificationRowsCompanion.insert(
                id: id,
                userId: userId,
                kind: kind,
                title: title,
                body: body,
                shiftId: shiftId,
                createdAt: createdAt,
                readAt: readAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NotificationRowsTable, NotificationRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $NotificationRowsTable,
                    NotificationRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationRowsTable,
      NotificationRow,
      $$NotificationRowsTableFilterComposer,
      $$NotificationRowsTableOrderingComposer,
      $$NotificationRowsTableAnnotationComposer,
      $$NotificationRowsTableCreateCompanionBuilder,
      $$NotificationRowsTableUpdateCompanionBuilder,
      (
        NotificationRow,
        BaseReferences<_$AppDatabase, $NotificationRowsTable, NotificationRow>,
      ),
      NotificationRow,
      PrefetchHooks Function()
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
  $$DocumentRowsTableTableManager get documentRows =>
      $$DocumentRowsTableTableManager(_db, _db.documentRows);
  $$SupportTicketRowsTableTableManager get supportTicketRows =>
      $$SupportTicketRowsTableTableManager(_db, _db.supportTicketRows);
  $$SupportMessageRowsTableTableManager get supportMessageRows =>
      $$SupportMessageRowsTableTableManager(_db, _db.supportMessageRows);
  $$WorkerReviewRowsTableTableManager get workerReviewRows =>
      $$WorkerReviewRowsTableTableManager(_db, _db.workerReviewRows);
  $$AuthCodeRowsTableTableManager get authCodeRows =>
      $$AuthCodeRowsTableTableManager(_db, _db.authCodeRows);
  $$AuthTokenRowsTableTableManager get authTokenRows =>
      $$AuthTokenRowsTableTableManager(_db, _db.authTokenRows);
  $$NotificationRowsTableTableManager get notificationRows =>
      $$NotificationRowsTableTableManager(_db, _db.notificationRows);
}
