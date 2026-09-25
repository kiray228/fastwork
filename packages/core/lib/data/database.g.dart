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
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(kOtherCategory),
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
    category,
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
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
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
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
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

  /// Категория работ — ключ из `kShiftCategories`. Добавлена в
  /// одиннадцатой версии; у смен, созданных раньше, будет «Другое».
  final String category;
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
    required this.category,
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
    map['category'] = Variable<String>(category);
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
      category: Value(category),
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
      category: serializer.fromJson<String>(json['category']),
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
      'category': serializer.toJson<String>(category),
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
    String? category,
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
    category: category ?? this.category,
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
      category: data.category.present ? data.category.value : this.category,
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
          ..write('category: $category, ')
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
    category,
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
          other.category == this.category &&
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
  final Value<String> category;
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
    this.category = const Value.absent(),
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
    this.category = const Value.absent(),
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
    Expression<String>? category,
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
      if (category != null) 'category': category,
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
    Value<String>? category,
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
      category: category ?? this.category,
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
    if (category.present) {
      map['category'] = Variable<String>(category.value);
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
          ..write('category: $category, ')
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
  static const VerificationMeta _termsVersionMeta = const VerificationMeta(
    'termsVersion',
  );
  @override
  late final GeneratedColumn<int> termsVersion = GeneratedColumn<int>(
    'terms_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _termsAcceptedAtMeta = const VerificationMeta(
    'termsAcceptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> termsAcceptedAt =
      GeneratedColumn<DateTime>(
        'terms_accepted_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
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
    termsVersion,
    termsAcceptedAt,
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
    if (data.containsKey('terms_version')) {
      context.handle(
        _termsVersionMeta,
        termsVersion.isAcceptableOrUnknown(
          data['terms_version']!,
          _termsVersionMeta,
        ),
      );
    }
    if (data.containsKey('terms_accepted_at')) {
      context.handle(
        _termsAcceptedAtMeta,
        termsAcceptedAt.isAcceptableOrUnknown(
          data['terms_accepted_at']!,
          _termsAcceptedAtMeta,
        ),
      );
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
      termsVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}terms_version'],
      )!,
      termsAcceptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}terms_accepted_at'],
      ),
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

  /// Какую версию правил человек принял. 0 — никакую: так у аккаунтов,
  /// заведённых до появления правил. Добавлена в двенадцатой версии.
  final int termsVersion;

  /// Когда принял. Хранить момент, а не галочку, — то же правило, что и
  /// с отметкой о выходе: из времени галочку получить можно, наоборот нет.
  /// А при споре «я ни с чем не соглашался» время — единственный довод.
  final DateTime? termsAcceptedAt;
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
    required this.termsVersion,
    this.termsAcceptedAt,
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
    map['terms_version'] = Variable<int>(termsVersion);
    if (!nullToAbsent || termsAcceptedAt != null) {
      map['terms_accepted_at'] = Variable<DateTime>(termsAcceptedAt);
    }
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
      termsVersion: Value(termsVersion),
      termsAcceptedAt: termsAcceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(termsAcceptedAt),
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
      termsVersion: serializer.fromJson<int>(json['termsVersion']),
      termsAcceptedAt: serializer.fromJson<DateTime?>(json['termsAcceptedAt']),
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
      'termsVersion': serializer.toJson<int>(termsVersion),
      'termsAcceptedAt': serializer.toJson<DateTime?>(termsAcceptedAt),
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
    int? termsVersion,
    Value<DateTime?> termsAcceptedAt = const Value.absent(),
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
    termsVersion: termsVersion ?? this.termsVersion,
    termsAcceptedAt: termsAcceptedAt.present
        ? termsAcceptedAt.value
        : this.termsAcceptedAt,
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
      termsVersion: data.termsVersion.present
          ? data.termsVersion.value
          : this.termsVersion,
      termsAcceptedAt: data.termsAcceptedAt.present
          ? data.termsAcceptedAt.value
          : this.termsAcceptedAt,
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
          ..write('createdAt: $createdAt, ')
          ..write('termsVersion: $termsVersion, ')
          ..write('termsAcceptedAt: $termsAcceptedAt')
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
    termsVersion,
    termsAcceptedAt,
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
          other.createdAt == this.createdAt &&
          other.termsVersion == this.termsVersion &&
          other.termsAcceptedAt == this.termsAcceptedAt);
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
  final Value<int> termsVersion;
  final Value<DateTime?> termsAcceptedAt;
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
    this.termsVersion = const Value.absent(),
    this.termsAcceptedAt = const Value.absent(),
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
    this.termsVersion = const Value.absent(),
    this.termsAcceptedAt = const Value.absent(),
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
    Expression<int>? termsVersion,
    Expression<DateTime>? termsAcceptedAt,
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
      if (termsVersion != null) 'terms_version': termsVersion,
      if (termsAcceptedAt != null) 'terms_accepted_at': termsAcceptedAt,
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
    Value<int>? termsVersion,
    Value<DateTime?>? termsAcceptedAt,
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
      termsVersion: termsVersion ?? this.termsVersion,
      termsAcceptedAt: termsAcceptedAt ?? this.termsAcceptedAt,
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
    if (termsVersion.present) {
      map['terms_version'] = Variable<int>(termsVersion.value);
    }
    if (termsAcceptedAt.present) {
      map['terms_accepted_at'] = Variable<DateTime>(termsAcceptedAt.value);
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
          ..write('createdAt: $createdAt, ')
          ..write('termsVersion: $termsVersion, ')
          ..write('termsAcceptedAt: $termsAcceptedAt')
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

class $MrpRateRowsTable extends MrpRateRows
    with TableInfo<$MrpRateRowsTable, MrpRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MrpRateRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<DateTime> validFrom = GeneratedColumn<DateTime>(
    'valid_from',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
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
  List<GeneratedColumn> get $columns => [id, validFrom, amount, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mrp_rate_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<MrpRateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    } else if (isInserting) {
      context.missing(_validFromMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
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
  MrpRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MrpRateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}valid_from'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MrpRateRowsTable createAlias(String alias) {
    return $MrpRateRowsTable(attachedDatabase, alias);
  }
}

class MrpRateRow extends DataClass implements Insertable<MrpRateRow> {
  final int id;

  /// С какого дня действует.
  final DateTime validFrom;

  /// Один МРП в тиынах.
  final int amount;
  final DateTime createdAt;
  const MrpRateRow({
    required this.id,
    required this.validFrom,
    required this.amount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['valid_from'] = Variable<DateTime>(validFrom);
    map['amount'] = Variable<int>(amount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MrpRateRowsCompanion toCompanion(bool nullToAbsent) {
    return MrpRateRowsCompanion(
      id: Value(id),
      validFrom: Value(validFrom),
      amount: Value(amount),
      createdAt: Value(createdAt),
    );
  }

  factory MrpRateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MrpRateRow(
      id: serializer.fromJson<int>(json['id']),
      validFrom: serializer.fromJson<DateTime>(json['validFrom']),
      amount: serializer.fromJson<int>(json['amount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'validFrom': serializer.toJson<DateTime>(validFrom),
      'amount': serializer.toJson<int>(amount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MrpRateRow copyWith({
    int? id,
    DateTime? validFrom,
    int? amount,
    DateTime? createdAt,
  }) => MrpRateRow(
    id: id ?? this.id,
    validFrom: validFrom ?? this.validFrom,
    amount: amount ?? this.amount,
    createdAt: createdAt ?? this.createdAt,
  );
  MrpRateRow copyWithCompanion(MrpRateRowsCompanion data) {
    return MrpRateRow(
      id: data.id.present ? data.id.value : this.id,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      amount: data.amount.present ? data.amount.value : this.amount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MrpRateRow(')
          ..write('id: $id, ')
          ..write('validFrom: $validFrom, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, validFrom, amount, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MrpRateRow &&
          other.id == this.id &&
          other.validFrom == this.validFrom &&
          other.amount == this.amount &&
          other.createdAt == this.createdAt);
}

class MrpRateRowsCompanion extends UpdateCompanion<MrpRateRow> {
  final Value<int> id;
  final Value<DateTime> validFrom;
  final Value<int> amount;
  final Value<DateTime> createdAt;
  const MrpRateRowsCompanion({
    this.id = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.amount = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  MrpRateRowsCompanion.insert({
    this.id = const Value.absent(),
    required DateTime validFrom,
    required int amount,
    required DateTime createdAt,
  }) : validFrom = Value(validFrom),
       amount = Value(amount),
       createdAt = Value(createdAt);
  static Insertable<MrpRateRow> custom({
    Expression<int>? id,
    Expression<DateTime>? validFrom,
    Expression<int>? amount,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (validFrom != null) 'valid_from': validFrom,
      if (amount != null) 'amount': amount,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  MrpRateRowsCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? validFrom,
    Value<int>? amount,
    Value<DateTime>? createdAt,
  }) {
    return MrpRateRowsCompanion(
      id: id ?? this.id,
      validFrom: validFrom ?? this.validFrom,
      amount: amount ?? this.amount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<DateTime>(validFrom.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MrpRateRowsCompanion(')
          ..write('id: $id, ')
          ..write('validFrom: $validFrom, ')
          ..write('amount: $amount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $PaymentRowsTable extends PaymentRows
    with TableInfo<$PaymentRowsTable, PaymentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentRowsTable(this.attachedDatabase, [this._alias]);
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
      'UNIQUE REFERENCES shift_rows (id)',
    ),
  );
  static const VerificationMeta _payerIdMeta = const VerificationMeta(
    'payerId',
  );
  @override
  late final GeneratedColumn<int> payerId = GeneratedColumn<int>(
    'payer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
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
  static const VerificationMeta _feeMeta = const VerificationMeta('fee');
  @override
  late final GeneratedColumn<int> fee = GeneratedColumn<int>(
    'fee',
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
  static const VerificationMeta _cardLast4Meta = const VerificationMeta(
    'cardLast4',
  );
  @override
  late final GeneratedColumn<String> cardLast4 = GeneratedColumn<String>(
    'card_last4',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardBrandMeta = const VerificationMeta(
    'cardBrand',
  );
  @override
  late final GeneratedColumn<String> cardBrand = GeneratedColumn<String>(
    'card_brand',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('card'),
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
    payerId,
    amount,
    fee,
    status,
    cardLast4,
    cardBrand,
    operation,
    method,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentRow> instance, {
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
    if (data.containsKey('payer_id')) {
      context.handle(
        _payerIdMeta,
        payerId.isAcceptableOrUnknown(data['payer_id']!, _payerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_payerIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('fee')) {
      context.handle(
        _feeMeta,
        fee.isAcceptableOrUnknown(data['fee']!, _feeMeta),
      );
    } else if (isInserting) {
      context.missing(_feeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('card_last4')) {
      context.handle(
        _cardLast4Meta,
        cardLast4.isAcceptableOrUnknown(data['card_last4']!, _cardLast4Meta),
      );
    } else if (isInserting) {
      context.missing(_cardLast4Meta);
    }
    if (data.containsKey('card_brand')) {
      context.handle(
        _cardBrandMeta,
        cardBrand.isAcceptableOrUnknown(data['card_brand']!, _cardBrandMeta),
      );
    } else if (isInserting) {
      context.missing(_cardBrandMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
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
  PaymentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      )!,
      payerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payer_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      fee: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fee'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      cardLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_last4'],
      )!,
      cardBrand: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_brand'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $PaymentRowsTable createAlias(String alias) {
    return $PaymentRowsTable(attachedDatabase, alias);
  }
}

class PaymentRow extends DataClass implements Insertable<PaymentRow> {
  final int id;

  /// Смена. Одна оплата на смену — доплаты и возвраты при правке
  /// пишутся движениями, а эта строка лишь обновляет итоговые суммы.
  final int shiftId;

  /// Кто платил. 0 — учебные смены, их «оплатил» сам сервис.
  final int payerId;

  /// Удержано на вознаграждение всем местам, в тиынах.
  final int amount;

  /// Комиссия сервиса, в тиынах.
  final int fee;

  /// `pending` — смена ждёт оплаты и в ленте её нет, `held` — деньги у
  /// сервиса, `refunded` — остаток вернули заказчику.
  final String status;

  /// Чем платили: «Visa •• 4242», «Kaspi.kz». Пусто, пока не заплатили.
  final String cardLast4;
  final String cardBrand;

  /// Номер первой операции у провайдера. Возвраты идут по операциям из
  /// `charge_rows` — их у смены может быть несколько, если доплачивали.
  final String operation;

  /// Способ: `card` или `kaspi`. Добавлен в четырнадцатой версии.
  final String method;
  final DateTime createdAt;
  const PaymentRow({
    required this.id,
    required this.shiftId,
    required this.payerId,
    required this.amount,
    required this.fee,
    required this.status,
    required this.cardLast4,
    required this.cardBrand,
    required this.operation,
    required this.method,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shift_id'] = Variable<int>(shiftId);
    map['payer_id'] = Variable<int>(payerId);
    map['amount'] = Variable<int>(amount);
    map['fee'] = Variable<int>(fee);
    map['status'] = Variable<String>(status);
    map['card_last4'] = Variable<String>(cardLast4);
    map['card_brand'] = Variable<String>(cardBrand);
    map['operation'] = Variable<String>(operation);
    map['method'] = Variable<String>(method);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  PaymentRowsCompanion toCompanion(bool nullToAbsent) {
    return PaymentRowsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      payerId: Value(payerId),
      amount: Value(amount),
      fee: Value(fee),
      status: Value(status),
      cardLast4: Value(cardLast4),
      cardBrand: Value(cardBrand),
      operation: Value(operation),
      method: Value(method),
      createdAt: Value(createdAt),
    );
  }

  factory PaymentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentRow(
      id: serializer.fromJson<int>(json['id']),
      shiftId: serializer.fromJson<int>(json['shiftId']),
      payerId: serializer.fromJson<int>(json['payerId']),
      amount: serializer.fromJson<int>(json['amount']),
      fee: serializer.fromJson<int>(json['fee']),
      status: serializer.fromJson<String>(json['status']),
      cardLast4: serializer.fromJson<String>(json['cardLast4']),
      cardBrand: serializer.fromJson<String>(json['cardBrand']),
      operation: serializer.fromJson<String>(json['operation']),
      method: serializer.fromJson<String>(json['method']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shiftId': serializer.toJson<int>(shiftId),
      'payerId': serializer.toJson<int>(payerId),
      'amount': serializer.toJson<int>(amount),
      'fee': serializer.toJson<int>(fee),
      'status': serializer.toJson<String>(status),
      'cardLast4': serializer.toJson<String>(cardLast4),
      'cardBrand': serializer.toJson<String>(cardBrand),
      'operation': serializer.toJson<String>(operation),
      'method': serializer.toJson<String>(method),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  PaymentRow copyWith({
    int? id,
    int? shiftId,
    int? payerId,
    int? amount,
    int? fee,
    String? status,
    String? cardLast4,
    String? cardBrand,
    String? operation,
    String? method,
    DateTime? createdAt,
  }) => PaymentRow(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    payerId: payerId ?? this.payerId,
    amount: amount ?? this.amount,
    fee: fee ?? this.fee,
    status: status ?? this.status,
    cardLast4: cardLast4 ?? this.cardLast4,
    cardBrand: cardBrand ?? this.cardBrand,
    operation: operation ?? this.operation,
    method: method ?? this.method,
    createdAt: createdAt ?? this.createdAt,
  );
  PaymentRow copyWithCompanion(PaymentRowsCompanion data) {
    return PaymentRow(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      payerId: data.payerId.present ? data.payerId.value : this.payerId,
      amount: data.amount.present ? data.amount.value : this.amount,
      fee: data.fee.present ? data.fee.value : this.fee,
      status: data.status.present ? data.status.value : this.status,
      cardLast4: data.cardLast4.present ? data.cardLast4.value : this.cardLast4,
      cardBrand: data.cardBrand.present ? data.cardBrand.value : this.cardBrand,
      operation: data.operation.present ? data.operation.value : this.operation,
      method: data.method.present ? data.method.value : this.method,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentRow(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('payerId: $payerId, ')
          ..write('amount: $amount, ')
          ..write('fee: $fee, ')
          ..write('status: $status, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('cardBrand: $cardBrand, ')
          ..write('operation: $operation, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shiftId,
    payerId,
    amount,
    fee,
    status,
    cardLast4,
    cardBrand,
    operation,
    method,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentRow &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.payerId == this.payerId &&
          other.amount == this.amount &&
          other.fee == this.fee &&
          other.status == this.status &&
          other.cardLast4 == this.cardLast4 &&
          other.cardBrand == this.cardBrand &&
          other.operation == this.operation &&
          other.method == this.method &&
          other.createdAt == this.createdAt);
}

class PaymentRowsCompanion extends UpdateCompanion<PaymentRow> {
  final Value<int> id;
  final Value<int> shiftId;
  final Value<int> payerId;
  final Value<int> amount;
  final Value<int> fee;
  final Value<String> status;
  final Value<String> cardLast4;
  final Value<String> cardBrand;
  final Value<String> operation;
  final Value<String> method;
  final Value<DateTime> createdAt;
  const PaymentRowsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.payerId = const Value.absent(),
    this.amount = const Value.absent(),
    this.fee = const Value.absent(),
    this.status = const Value.absent(),
    this.cardLast4 = const Value.absent(),
    this.cardBrand = const Value.absent(),
    this.operation = const Value.absent(),
    this.method = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  PaymentRowsCompanion.insert({
    this.id = const Value.absent(),
    required int shiftId,
    required int payerId,
    required int amount,
    required int fee,
    required String status,
    required String cardLast4,
    required String cardBrand,
    required String operation,
    this.method = const Value.absent(),
    required DateTime createdAt,
  }) : shiftId = Value(shiftId),
       payerId = Value(payerId),
       amount = Value(amount),
       fee = Value(fee),
       status = Value(status),
       cardLast4 = Value(cardLast4),
       cardBrand = Value(cardBrand),
       operation = Value(operation),
       createdAt = Value(createdAt);
  static Insertable<PaymentRow> custom({
    Expression<int>? id,
    Expression<int>? shiftId,
    Expression<int>? payerId,
    Expression<int>? amount,
    Expression<int>? fee,
    Expression<String>? status,
    Expression<String>? cardLast4,
    Expression<String>? cardBrand,
    Expression<String>? operation,
    Expression<String>? method,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (payerId != null) 'payer_id': payerId,
      if (amount != null) 'amount': amount,
      if (fee != null) 'fee': fee,
      if (status != null) 'status': status,
      if (cardLast4 != null) 'card_last4': cardLast4,
      if (cardBrand != null) 'card_brand': cardBrand,
      if (operation != null) 'operation': operation,
      if (method != null) 'method': method,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  PaymentRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? shiftId,
    Value<int>? payerId,
    Value<int>? amount,
    Value<int>? fee,
    Value<String>? status,
    Value<String>? cardLast4,
    Value<String>? cardBrand,
    Value<String>? operation,
    Value<String>? method,
    Value<DateTime>? createdAt,
  }) {
    return PaymentRowsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      payerId: payerId ?? this.payerId,
      amount: amount ?? this.amount,
      fee: fee ?? this.fee,
      status: status ?? this.status,
      cardLast4: cardLast4 ?? this.cardLast4,
      cardBrand: cardBrand ?? this.cardBrand,
      operation: operation ?? this.operation,
      method: method ?? this.method,
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
    if (payerId.present) {
      map['payer_id'] = Variable<int>(payerId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (fee.present) {
      map['fee'] = Variable<int>(fee.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (cardLast4.present) {
      map['card_last4'] = Variable<String>(cardLast4.value);
    }
    if (cardBrand.present) {
      map['card_brand'] = Variable<String>(cardBrand.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentRowsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('payerId: $payerId, ')
          ..write('amount: $amount, ')
          ..write('fee: $fee, ')
          ..write('status: $status, ')
          ..write('cardLast4: $cardLast4, ')
          ..write('cardBrand: $cardBrand, ')
          ..write('operation: $operation, ')
          ..write('method: $method, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WalletEntryRowsTable extends WalletEntryRows
    with TableInfo<$WalletEntryRowsTable, WalletEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WalletEntryRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
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
    shiftId,
    kind,
    amount,
    title,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'wallet_entry_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<WalletEntryRow> instance, {
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
    if (data.containsKey('shift_id')) {
      context.handle(
        _shiftIdMeta,
        shiftId.isAcceptableOrUnknown(data['shift_id']!, _shiftIdMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
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
  WalletEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WalletEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WalletEntryRowsTable createAlias(String alias) {
    return $WalletEntryRowsTable(attachedDatabase, alias);
  }
}

class WalletEntryRow extends DataClass implements Insertable<WalletEntryRow> {
  final int id;
  final int userId;

  /// Смена, к которой относится движение. У вывода на карту её нет.
  final int? shiftId;

  /// Вид: earning, withdrawal, charge, refund — см. `WalletEntryKind`.
  final String kind;

  /// Сумма со знаком, в тиынах.
  final int amount;

  /// Готовая подпись для истории — как у уведомлений: верна на момент
  /// события, даже если смену потом переименуют.
  final String title;
  final DateTime createdAt;
  const WalletEntryRow({
    required this.id,
    required this.userId,
    this.shiftId,
    required this.kind,
    required this.amount,
    required this.title,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    if (!nullToAbsent || shiftId != null) {
      map['shift_id'] = Variable<int>(shiftId);
    }
    map['kind'] = Variable<String>(kind);
    map['amount'] = Variable<int>(amount);
    map['title'] = Variable<String>(title);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WalletEntryRowsCompanion toCompanion(bool nullToAbsent) {
    return WalletEntryRowsCompanion(
      id: Value(id),
      userId: Value(userId),
      shiftId: shiftId == null && nullToAbsent
          ? const Value.absent()
          : Value(shiftId),
      kind: Value(kind),
      amount: Value(amount),
      title: Value(title),
      createdAt: Value(createdAt),
    );
  }

  factory WalletEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WalletEntryRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      shiftId: serializer.fromJson<int?>(json['shiftId']),
      kind: serializer.fromJson<String>(json['kind']),
      amount: serializer.fromJson<int>(json['amount']),
      title: serializer.fromJson<String>(json['title']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'shiftId': serializer.toJson<int?>(shiftId),
      'kind': serializer.toJson<String>(kind),
      'amount': serializer.toJson<int>(amount),
      'title': serializer.toJson<String>(title),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WalletEntryRow copyWith({
    int? id,
    int? userId,
    Value<int?> shiftId = const Value.absent(),
    String? kind,
    int? amount,
    String? title,
    DateTime? createdAt,
  }) => WalletEntryRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    shiftId: shiftId.present ? shiftId.value : this.shiftId,
    kind: kind ?? this.kind,
    amount: amount ?? this.amount,
    title: title ?? this.title,
    createdAt: createdAt ?? this.createdAt,
  );
  WalletEntryRow copyWithCompanion(WalletEntryRowsCompanion data) {
    return WalletEntryRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      kind: data.kind.present ? data.kind.value : this.kind,
      amount: data.amount.present ? data.amount.value : this.amount,
      title: data.title.present ? data.title.value : this.title,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WalletEntryRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, shiftId, kind, amount, title, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WalletEntryRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.shiftId == this.shiftId &&
          other.kind == this.kind &&
          other.amount == this.amount &&
          other.title == this.title &&
          other.createdAt == this.createdAt);
}

class WalletEntryRowsCompanion extends UpdateCompanion<WalletEntryRow> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int?> shiftId;
  final Value<String> kind;
  final Value<int> amount;
  final Value<String> title;
  final Value<DateTime> createdAt;
  const WalletEntryRowsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.kind = const Value.absent(),
    this.amount = const Value.absent(),
    this.title = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WalletEntryRowsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    this.shiftId = const Value.absent(),
    required String kind,
    required int amount,
    required String title,
    required DateTime createdAt,
  }) : userId = Value(userId),
       kind = Value(kind),
       amount = Value(amount),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<WalletEntryRow> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? shiftId,
    Expression<String>? kind,
    Expression<int>? amount,
    Expression<String>? title,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (shiftId != null) 'shift_id': shiftId,
      if (kind != null) 'kind': kind,
      if (amount != null) 'amount': amount,
      if (title != null) 'title': title,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WalletEntryRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int?>? shiftId,
    Value<String>? kind,
    Value<int>? amount,
    Value<String>? title,
    Value<DateTime>? createdAt,
  }) {
    return WalletEntryRowsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      shiftId: shiftId ?? this.shiftId,
      kind: kind ?? this.kind,
      amount: amount ?? this.amount,
      title: title ?? this.title,
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
    if (shiftId.present) {
      map['shift_id'] = Variable<int>(shiftId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WalletEntryRowsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('shiftId: $shiftId, ')
          ..write('kind: $kind, ')
          ..write('amount: $amount, ')
          ..write('title: $title, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ChargeRowsTable extends ChargeRows
    with TableInfo<$ChargeRowsTable, ChargeRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChargeRowsTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES shift_rows (id)',
    ),
  );
  static const VerificationMeta _payerIdMeta = const VerificationMeta(
    'payerId',
  );
  @override
  late final GeneratedColumn<int> payerId = GeneratedColumn<int>(
    'payer_id',
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
  static const VerificationMeta _methodMeta = const VerificationMeta('method');
  @override
  late final GeneratedColumn<String> method = GeneratedColumn<String>(
    'method',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
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
  static const VerificationMeta _refundedMeta = const VerificationMeta(
    'refunded',
  );
  @override
  late final GeneratedColumn<int> refunded = GeneratedColumn<int>(
    'refunded',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
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
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _checkoutUrlMeta = const VerificationMeta(
    'checkoutUrl',
  );
  @override
  late final GeneratedColumn<String> checkoutUrl = GeneratedColumn<String>(
    'checkout_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
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
  static const VerificationMeta _paidAtMeta = const VerificationMeta('paidAt');
  @override
  late final GeneratedColumn<DateTime> paidAt = GeneratedColumn<DateTime>(
    'paid_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    shiftId,
    payerId,
    kind,
    method,
    amount,
    refunded,
    status,
    provider,
    operation,
    checkoutUrl,
    phone,
    payload,
    message,
    createdAt,
    paidAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'charge_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChargeRow> instance, {
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
    if (data.containsKey('payer_id')) {
      context.handle(
        _payerIdMeta,
        payerId.isAcceptableOrUnknown(data['payer_id']!, _payerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_payerIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('method')) {
      context.handle(
        _methodMeta,
        method.isAcceptableOrUnknown(data['method']!, _methodMeta),
      );
    } else if (isInserting) {
      context.missing(_methodMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('refunded')) {
      context.handle(
        _refundedMeta,
        refunded.isAcceptableOrUnknown(data['refunded']!, _refundedMeta),
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
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    }
    if (data.containsKey('checkout_url')) {
      context.handle(
        _checkoutUrlMeta,
        checkoutUrl.isAcceptableOrUnknown(
          data['checkout_url']!,
          _checkoutUrlMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
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
    if (data.containsKey('paid_at')) {
      context.handle(
        _paidAtMeta,
        paidAt.isAcceptableOrUnknown(data['paid_at']!, _paidAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChargeRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChargeRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      shiftId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shift_id'],
      )!,
      payerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payer_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      method: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}method'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      refunded: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}refunded'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      checkoutUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkout_url'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      paidAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}paid_at'],
      ),
    );
  }

  @override
  $ChargeRowsTable createAlias(String alias) {
    return $ChargeRowsTable(attachedDatabase, alias);
  }
}

class ChargeRow extends DataClass implements Insertable<ChargeRow> {
  final int id;
  final int shiftId;
  final int payerId;

  /// `shift` — оплата смены, `topup` — доплата после правки.
  final String kind;

  /// `card` или `kaspi`.
  final String method;

  /// Сколько списываем вместе с комиссией, в тиынах.
  final int amount;

  /// Сколько по этой операции уже вернули.
  final int refunded;

  /// `pending`, `paid`, `failed` — см. `CheckoutStatus`.
  final String status;

  /// Кто принимает: `sandbox`, `ioka`, `apipay`.
  final String provider;

  /// Номер операции у провайдера. Пусто — провайдер ещё не ответил.
  final String operation;

  /// Куда отправить человека платить. null — никуда: счёт в Kaspi.kz.
  final String? checkoutUrl;

  /// Телефон, на который выставлен счёт Kaspi.
  final String? phone;

  /// Для доплаты — новые условия смены. Они вступят в силу, только когда
  /// доплата пройдёт: иначе смена подорожала бы в ленте за чужой счёт.
  final String? payload;

  /// Почему не прошло.
  final String? message;
  final DateTime createdAt;
  final DateTime? paidAt;
  const ChargeRow({
    required this.id,
    required this.shiftId,
    required this.payerId,
    required this.kind,
    required this.method,
    required this.amount,
    required this.refunded,
    required this.status,
    required this.provider,
    required this.operation,
    this.checkoutUrl,
    this.phone,
    this.payload,
    this.message,
    required this.createdAt,
    this.paidAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['shift_id'] = Variable<int>(shiftId);
    map['payer_id'] = Variable<int>(payerId);
    map['kind'] = Variable<String>(kind);
    map['method'] = Variable<String>(method);
    map['amount'] = Variable<int>(amount);
    map['refunded'] = Variable<int>(refunded);
    map['status'] = Variable<String>(status);
    map['provider'] = Variable<String>(provider);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || checkoutUrl != null) {
      map['checkout_url'] = Variable<String>(checkoutUrl);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || paidAt != null) {
      map['paid_at'] = Variable<DateTime>(paidAt);
    }
    return map;
  }

  ChargeRowsCompanion toCompanion(bool nullToAbsent) {
    return ChargeRowsCompanion(
      id: Value(id),
      shiftId: Value(shiftId),
      payerId: Value(payerId),
      kind: Value(kind),
      method: Value(method),
      amount: Value(amount),
      refunded: Value(refunded),
      status: Value(status),
      provider: Value(provider),
      operation: Value(operation),
      checkoutUrl: checkoutUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(checkoutUrl),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      createdAt: Value(createdAt),
      paidAt: paidAt == null && nullToAbsent
          ? const Value.absent()
          : Value(paidAt),
    );
  }

  factory ChargeRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChargeRow(
      id: serializer.fromJson<int>(json['id']),
      shiftId: serializer.fromJson<int>(json['shiftId']),
      payerId: serializer.fromJson<int>(json['payerId']),
      kind: serializer.fromJson<String>(json['kind']),
      method: serializer.fromJson<String>(json['method']),
      amount: serializer.fromJson<int>(json['amount']),
      refunded: serializer.fromJson<int>(json['refunded']),
      status: serializer.fromJson<String>(json['status']),
      provider: serializer.fromJson<String>(json['provider']),
      operation: serializer.fromJson<String>(json['operation']),
      checkoutUrl: serializer.fromJson<String?>(json['checkoutUrl']),
      phone: serializer.fromJson<String?>(json['phone']),
      payload: serializer.fromJson<String?>(json['payload']),
      message: serializer.fromJson<String?>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      paidAt: serializer.fromJson<DateTime?>(json['paidAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'shiftId': serializer.toJson<int>(shiftId),
      'payerId': serializer.toJson<int>(payerId),
      'kind': serializer.toJson<String>(kind),
      'method': serializer.toJson<String>(method),
      'amount': serializer.toJson<int>(amount),
      'refunded': serializer.toJson<int>(refunded),
      'status': serializer.toJson<String>(status),
      'provider': serializer.toJson<String>(provider),
      'operation': serializer.toJson<String>(operation),
      'checkoutUrl': serializer.toJson<String?>(checkoutUrl),
      'phone': serializer.toJson<String?>(phone),
      'payload': serializer.toJson<String?>(payload),
      'message': serializer.toJson<String?>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'paidAt': serializer.toJson<DateTime?>(paidAt),
    };
  }

  ChargeRow copyWith({
    int? id,
    int? shiftId,
    int? payerId,
    String? kind,
    String? method,
    int? amount,
    int? refunded,
    String? status,
    String? provider,
    String? operation,
    Value<String?> checkoutUrl = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> payload = const Value.absent(),
    Value<String?> message = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> paidAt = const Value.absent(),
  }) => ChargeRow(
    id: id ?? this.id,
    shiftId: shiftId ?? this.shiftId,
    payerId: payerId ?? this.payerId,
    kind: kind ?? this.kind,
    method: method ?? this.method,
    amount: amount ?? this.amount,
    refunded: refunded ?? this.refunded,
    status: status ?? this.status,
    provider: provider ?? this.provider,
    operation: operation ?? this.operation,
    checkoutUrl: checkoutUrl.present ? checkoutUrl.value : this.checkoutUrl,
    phone: phone.present ? phone.value : this.phone,
    payload: payload.present ? payload.value : this.payload,
    message: message.present ? message.value : this.message,
    createdAt: createdAt ?? this.createdAt,
    paidAt: paidAt.present ? paidAt.value : this.paidAt,
  );
  ChargeRow copyWithCompanion(ChargeRowsCompanion data) {
    return ChargeRow(
      id: data.id.present ? data.id.value : this.id,
      shiftId: data.shiftId.present ? data.shiftId.value : this.shiftId,
      payerId: data.payerId.present ? data.payerId.value : this.payerId,
      kind: data.kind.present ? data.kind.value : this.kind,
      method: data.method.present ? data.method.value : this.method,
      amount: data.amount.present ? data.amount.value : this.amount,
      refunded: data.refunded.present ? data.refunded.value : this.refunded,
      status: data.status.present ? data.status.value : this.status,
      provider: data.provider.present ? data.provider.value : this.provider,
      operation: data.operation.present ? data.operation.value : this.operation,
      checkoutUrl: data.checkoutUrl.present
          ? data.checkoutUrl.value
          : this.checkoutUrl,
      phone: data.phone.present ? data.phone.value : this.phone,
      payload: data.payload.present ? data.payload.value : this.payload,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      paidAt: data.paidAt.present ? data.paidAt.value : this.paidAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChargeRow(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('payerId: $payerId, ')
          ..write('kind: $kind, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('refunded: $refunded, ')
          ..write('status: $status, ')
          ..write('provider: $provider, ')
          ..write('operation: $operation, ')
          ..write('checkoutUrl: $checkoutUrl, ')
          ..write('phone: $phone, ')
          ..write('payload: $payload, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    shiftId,
    payerId,
    kind,
    method,
    amount,
    refunded,
    status,
    provider,
    operation,
    checkoutUrl,
    phone,
    payload,
    message,
    createdAt,
    paidAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChargeRow &&
          other.id == this.id &&
          other.shiftId == this.shiftId &&
          other.payerId == this.payerId &&
          other.kind == this.kind &&
          other.method == this.method &&
          other.amount == this.amount &&
          other.refunded == this.refunded &&
          other.status == this.status &&
          other.provider == this.provider &&
          other.operation == this.operation &&
          other.checkoutUrl == this.checkoutUrl &&
          other.phone == this.phone &&
          other.payload == this.payload &&
          other.message == this.message &&
          other.createdAt == this.createdAt &&
          other.paidAt == this.paidAt);
}

class ChargeRowsCompanion extends UpdateCompanion<ChargeRow> {
  final Value<int> id;
  final Value<int> shiftId;
  final Value<int> payerId;
  final Value<String> kind;
  final Value<String> method;
  final Value<int> amount;
  final Value<int> refunded;
  final Value<String> status;
  final Value<String> provider;
  final Value<String> operation;
  final Value<String?> checkoutUrl;
  final Value<String?> phone;
  final Value<String?> payload;
  final Value<String?> message;
  final Value<DateTime> createdAt;
  final Value<DateTime?> paidAt;
  const ChargeRowsCompanion({
    this.id = const Value.absent(),
    this.shiftId = const Value.absent(),
    this.payerId = const Value.absent(),
    this.kind = const Value.absent(),
    this.method = const Value.absent(),
    this.amount = const Value.absent(),
    this.refunded = const Value.absent(),
    this.status = const Value.absent(),
    this.provider = const Value.absent(),
    this.operation = const Value.absent(),
    this.checkoutUrl = const Value.absent(),
    this.phone = const Value.absent(),
    this.payload = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.paidAt = const Value.absent(),
  });
  ChargeRowsCompanion.insert({
    this.id = const Value.absent(),
    required int shiftId,
    required int payerId,
    required String kind,
    required String method,
    required int amount,
    this.refunded = const Value.absent(),
    required String status,
    required String provider,
    this.operation = const Value.absent(),
    this.checkoutUrl = const Value.absent(),
    this.phone = const Value.absent(),
    this.payload = const Value.absent(),
    this.message = const Value.absent(),
    required DateTime createdAt,
    this.paidAt = const Value.absent(),
  }) : shiftId = Value(shiftId),
       payerId = Value(payerId),
       kind = Value(kind),
       method = Value(method),
       amount = Value(amount),
       status = Value(status),
       provider = Value(provider),
       createdAt = Value(createdAt);
  static Insertable<ChargeRow> custom({
    Expression<int>? id,
    Expression<int>? shiftId,
    Expression<int>? payerId,
    Expression<String>? kind,
    Expression<String>? method,
    Expression<int>? amount,
    Expression<int>? refunded,
    Expression<String>? status,
    Expression<String>? provider,
    Expression<String>? operation,
    Expression<String>? checkoutUrl,
    Expression<String>? phone,
    Expression<String>? payload,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? paidAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (shiftId != null) 'shift_id': shiftId,
      if (payerId != null) 'payer_id': payerId,
      if (kind != null) 'kind': kind,
      if (method != null) 'method': method,
      if (amount != null) 'amount': amount,
      if (refunded != null) 'refunded': refunded,
      if (status != null) 'status': status,
      if (provider != null) 'provider': provider,
      if (operation != null) 'operation': operation,
      if (checkoutUrl != null) 'checkout_url': checkoutUrl,
      if (phone != null) 'phone': phone,
      if (payload != null) 'payload': payload,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
      if (paidAt != null) 'paid_at': paidAt,
    });
  }

  ChargeRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? shiftId,
    Value<int>? payerId,
    Value<String>? kind,
    Value<String>? method,
    Value<int>? amount,
    Value<int>? refunded,
    Value<String>? status,
    Value<String>? provider,
    Value<String>? operation,
    Value<String?>? checkoutUrl,
    Value<String?>? phone,
    Value<String?>? payload,
    Value<String?>? message,
    Value<DateTime>? createdAt,
    Value<DateTime?>? paidAt,
  }) {
    return ChargeRowsCompanion(
      id: id ?? this.id,
      shiftId: shiftId ?? this.shiftId,
      payerId: payerId ?? this.payerId,
      kind: kind ?? this.kind,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      refunded: refunded ?? this.refunded,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      operation: operation ?? this.operation,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      phone: phone ?? this.phone,
      payload: payload ?? this.payload,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      paidAt: paidAt ?? this.paidAt,
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
    if (payerId.present) {
      map['payer_id'] = Variable<int>(payerId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (method.present) {
      map['method'] = Variable<String>(method.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (refunded.present) {
      map['refunded'] = Variable<int>(refunded.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (checkoutUrl.present) {
      map['checkout_url'] = Variable<String>(checkoutUrl.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (paidAt.present) {
      map['paid_at'] = Variable<DateTime>(paidAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChargeRowsCompanion(')
          ..write('id: $id, ')
          ..write('shiftId: $shiftId, ')
          ..write('payerId: $payerId, ')
          ..write('kind: $kind, ')
          ..write('method: $method, ')
          ..write('amount: $amount, ')
          ..write('refunded: $refunded, ')
          ..write('status: $status, ')
          ..write('provider: $provider, ')
          ..write('operation: $operation, ')
          ..write('checkoutUrl: $checkoutUrl, ')
          ..write('phone: $phone, ')
          ..write('payload: $payload, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('paidAt: $paidAt')
          ..write(')'))
        .toString();
  }
}

class $PayoutRowsTable extends PayoutRows
    with TableInfo<$PayoutRowsTable, PayoutRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayoutRowsTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
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
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _checkoutUrlMeta = const VerificationMeta(
    'checkoutUrl',
  );
  @override
  late final GeneratedColumn<String> checkoutUrl = GeneratedColumn<String>(
    'checkout_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
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
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<DateTime> doneAt = GeneratedColumn<DateTime>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    amount,
    status,
    provider,
    operation,
    checkoutUrl,
    message,
    createdAt,
    doneAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payout_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayoutRow> instance, {
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
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    }
    if (data.containsKey('checkout_url')) {
      context.handle(
        _checkoutUrlMeta,
        checkoutUrl.isAcceptableOrUnknown(
          data['checkout_url']!,
          _checkoutUrlMeta,
        ),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
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
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayoutRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayoutRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}user_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      checkoutUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checkout_url'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}done_at'],
      ),
    );
  }

  @override
  $PayoutRowsTable createAlias(String alias) {
    return $PayoutRowsTable(attachedDatabase, alias);
  }
}

class PayoutRow extends DataClass implements Insertable<PayoutRow> {
  final int id;
  final int userId;
  final int amount;

  /// `pending`, `paid`, `failed`.
  final String status;
  final String provider;
  final String operation;
  final String? checkoutUrl;
  final String? message;
  final DateTime createdAt;
  final DateTime? doneAt;
  const PayoutRow({
    required this.id,
    required this.userId,
    required this.amount,
    required this.status,
    required this.provider,
    required this.operation,
    this.checkoutUrl,
    this.message,
    required this.createdAt,
    this.doneAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_id'] = Variable<int>(userId);
    map['amount'] = Variable<int>(amount);
    map['status'] = Variable<String>(status);
    map['provider'] = Variable<String>(provider);
    map['operation'] = Variable<String>(operation);
    if (!nullToAbsent || checkoutUrl != null) {
      map['checkout_url'] = Variable<String>(checkoutUrl);
    }
    if (!nullToAbsent || message != null) {
      map['message'] = Variable<String>(message);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<DateTime>(doneAt);
    }
    return map;
  }

  PayoutRowsCompanion toCompanion(bool nullToAbsent) {
    return PayoutRowsCompanion(
      id: Value(id),
      userId: Value(userId),
      amount: Value(amount),
      status: Value(status),
      provider: Value(provider),
      operation: Value(operation),
      checkoutUrl: checkoutUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(checkoutUrl),
      message: message == null && nullToAbsent
          ? const Value.absent()
          : Value(message),
      createdAt: Value(createdAt),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
    );
  }

  factory PayoutRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayoutRow(
      id: serializer.fromJson<int>(json['id']),
      userId: serializer.fromJson<int>(json['userId']),
      amount: serializer.fromJson<int>(json['amount']),
      status: serializer.fromJson<String>(json['status']),
      provider: serializer.fromJson<String>(json['provider']),
      operation: serializer.fromJson<String>(json['operation']),
      checkoutUrl: serializer.fromJson<String?>(json['checkoutUrl']),
      message: serializer.fromJson<String?>(json['message']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      doneAt: serializer.fromJson<DateTime?>(json['doneAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userId': serializer.toJson<int>(userId),
      'amount': serializer.toJson<int>(amount),
      'status': serializer.toJson<String>(status),
      'provider': serializer.toJson<String>(provider),
      'operation': serializer.toJson<String>(operation),
      'checkoutUrl': serializer.toJson<String?>(checkoutUrl),
      'message': serializer.toJson<String?>(message),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'doneAt': serializer.toJson<DateTime?>(doneAt),
    };
  }

  PayoutRow copyWith({
    int? id,
    int? userId,
    int? amount,
    String? status,
    String? provider,
    String? operation,
    Value<String?> checkoutUrl = const Value.absent(),
    Value<String?> message = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> doneAt = const Value.absent(),
  }) => PayoutRow(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    amount: amount ?? this.amount,
    status: status ?? this.status,
    provider: provider ?? this.provider,
    operation: operation ?? this.operation,
    checkoutUrl: checkoutUrl.present ? checkoutUrl.value : this.checkoutUrl,
    message: message.present ? message.value : this.message,
    createdAt: createdAt ?? this.createdAt,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
  );
  PayoutRow copyWithCompanion(PayoutRowsCompanion data) {
    return PayoutRow(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      amount: data.amount.present ? data.amount.value : this.amount,
      status: data.status.present ? data.status.value : this.status,
      provider: data.provider.present ? data.provider.value : this.provider,
      operation: data.operation.present ? data.operation.value : this.operation,
      checkoutUrl: data.checkoutUrl.present
          ? data.checkoutUrl.value
          : this.checkoutUrl,
      message: data.message.present ? data.message.value : this.message,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayoutRow(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('provider: $provider, ')
          ..write('operation: $operation, ')
          ..write('checkoutUrl: $checkoutUrl, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userId,
    amount,
    status,
    provider,
    operation,
    checkoutUrl,
    message,
    createdAt,
    doneAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayoutRow &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.amount == this.amount &&
          other.status == this.status &&
          other.provider == this.provider &&
          other.operation == this.operation &&
          other.checkoutUrl == this.checkoutUrl &&
          other.message == this.message &&
          other.createdAt == this.createdAt &&
          other.doneAt == this.doneAt);
}

class PayoutRowsCompanion extends UpdateCompanion<PayoutRow> {
  final Value<int> id;
  final Value<int> userId;
  final Value<int> amount;
  final Value<String> status;
  final Value<String> provider;
  final Value<String> operation;
  final Value<String?> checkoutUrl;
  final Value<String?> message;
  final Value<DateTime> createdAt;
  final Value<DateTime?> doneAt;
  const PayoutRowsCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.amount = const Value.absent(),
    this.status = const Value.absent(),
    this.provider = const Value.absent(),
    this.operation = const Value.absent(),
    this.checkoutUrl = const Value.absent(),
    this.message = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.doneAt = const Value.absent(),
  });
  PayoutRowsCompanion.insert({
    this.id = const Value.absent(),
    required int userId,
    required int amount,
    required String status,
    required String provider,
    this.operation = const Value.absent(),
    this.checkoutUrl = const Value.absent(),
    this.message = const Value.absent(),
    required DateTime createdAt,
    this.doneAt = const Value.absent(),
  }) : userId = Value(userId),
       amount = Value(amount),
       status = Value(status),
       provider = Value(provider),
       createdAt = Value(createdAt);
  static Insertable<PayoutRow> custom({
    Expression<int>? id,
    Expression<int>? userId,
    Expression<int>? amount,
    Expression<String>? status,
    Expression<String>? provider,
    Expression<String>? operation,
    Expression<String>? checkoutUrl,
    Expression<String>? message,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? doneAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (amount != null) 'amount': amount,
      if (status != null) 'status': status,
      if (provider != null) 'provider': provider,
      if (operation != null) 'operation': operation,
      if (checkoutUrl != null) 'checkout_url': checkoutUrl,
      if (message != null) 'message': message,
      if (createdAt != null) 'created_at': createdAt,
      if (doneAt != null) 'done_at': doneAt,
    });
  }

  PayoutRowsCompanion copyWith({
    Value<int>? id,
    Value<int>? userId,
    Value<int>? amount,
    Value<String>? status,
    Value<String>? provider,
    Value<String>? operation,
    Value<String?>? checkoutUrl,
    Value<String?>? message,
    Value<DateTime>? createdAt,
    Value<DateTime?>? doneAt,
  }) {
    return PayoutRowsCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      provider: provider ?? this.provider,
      operation: operation ?? this.operation,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      doneAt: doneAt ?? this.doneAt,
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
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (checkoutUrl.present) {
      map['checkout_url'] = Variable<String>(checkoutUrl.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<DateTime>(doneAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayoutRowsCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('amount: $amount, ')
          ..write('status: $status, ')
          ..write('provider: $provider, ')
          ..write('operation: $operation, ')
          ..write('checkoutUrl: $checkoutUrl, ')
          ..write('message: $message, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt')
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
  late final $MrpRateRowsTable mrpRateRows = $MrpRateRowsTable(this);
  late final $PaymentRowsTable paymentRows = $PaymentRowsTable(this);
  late final $WalletEntryRowsTable walletEntryRows = $WalletEntryRowsTable(
    this,
  );
  late final $ChargeRowsTable chargeRows = $ChargeRowsTable(this);
  late final $PayoutRowsTable payoutRows = $PayoutRowsTable(this);
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
    mrpRateRows,
    paymentRows,
    walletEntryRows,
    chargeRows,
    payoutRows,
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
  Value<String> category,
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
  Value<String> category,
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

  static MultiTypedResultKey<$PaymentRowsTable, List<PaymentRow>>
  _paymentRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.paymentRows,
    aliasName: 'shift_rows__id__payment_rows__shift_id',
  );

  $$PaymentRowsTableProcessedTableManager get paymentRowsRefs {
    final manager = $$PaymentRowsTableTableManager(
      $_db,
      $_db.paymentRows,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_paymentRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ChargeRowsTable, List<ChargeRow>>
  _chargeRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.chargeRows,
    aliasName: 'shift_rows__id__charge_rows__shift_id',
  );

  $$ChargeRowsTableProcessedTableManager get chargeRowsRefs {
    final manager = $$ChargeRowsTableTableManager(
      $_db,
      $_db.chargeRows,
    ).filter((f) => f.shiftId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chargeRowsRefsTable($_db));
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

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
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

  Expression<bool> paymentRowsRefs(
    Expression<bool> Function($$PaymentRowsTableFilterComposer f) f,
  ) {
    final $$PaymentRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentRowsTableFilterComposer(
            $db: $db,
            $table: $db.paymentRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> chargeRowsRefs(
    Expression<bool> Function($$ChargeRowsTableFilterComposer f) f,
  ) {
    final $$ChargeRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chargeRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChargeRowsTableFilterComposer(
            $db: $db,
            $table: $db.chargeRows,
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

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
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

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

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

  Expression<T> paymentRowsRefs<T extends Object>(
    Expression<T> Function($$PaymentRowsTableAnnotationComposer a) f,
  ) {
    final $$PaymentRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.paymentRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.paymentRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> chargeRowsRefs<T extends Object>(
    Expression<T> Function($$ChargeRowsTableAnnotationComposer a) f,
  ) {
    final $$ChargeRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.chargeRows,
      getReferencedColumn: (t) => t.shiftId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ChargeRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.chargeRows,
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
            bool paymentRowsRefs,
            bool chargeRowsRefs,
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
                Value<String> category = const Value.absent(),
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
                category: category,
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
                Value<String> category = const Value.absent(),
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
                category: category,
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
                paymentRowsRefs = false,
                chargeRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (applicationRowsRefs) db.applicationRows,
                    if (reviewRowsRefs) db.reviewRows,
                    if (workerReviewRowsRefs) db.workerReviewRows,
                    if (paymentRowsRefs) db.paymentRows,
                    if (chargeRowsRefs) db.chargeRows,
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
                      if (paymentRowsRefs)
                        await $_getPrefetchedData<
                          ShiftRow,
                          $ShiftRowsTable,
                          PaymentRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftRowsTableReferences
                              ._paymentRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).paymentRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.shiftId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (chargeRowsRefs)
                        await $_getPrefetchedData<
                          ShiftRow,
                          $ShiftRowsTable,
                          ChargeRow
                        >(
                          currentTable: table,
                          referencedTable: $$ShiftRowsTableReferences
                              ._chargeRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ShiftRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).chargeRowsRefs,
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
        bool paymentRowsRefs,
        bool chargeRowsRefs,
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
  Value<int> termsVersion,
  Value<DateTime?> termsAcceptedAt,
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
  Value<int> termsVersion,
  Value<DateTime?> termsAcceptedAt,
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

  ColumnFilters<int> get termsVersion => $composableBuilder(
    column: $table.termsVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get termsAcceptedAt => $composableBuilder(
    column: $table.termsAcceptedAt,
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

  ColumnOrderings<int> get termsVersion => $composableBuilder(
    column: $table.termsVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get termsAcceptedAt => $composableBuilder(
    column: $table.termsAcceptedAt,
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

  GeneratedColumn<int> get termsVersion => $composableBuilder(
    column: $table.termsVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get termsAcceptedAt => $composableBuilder(
    column: $table.termsAcceptedAt,
    builder: (column) => column,
  );
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
                Value<int> termsVersion = const Value.absent(),
                Value<DateTime?> termsAcceptedAt = const Value.absent(),
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
                termsVersion: termsVersion,
                termsAcceptedAt: termsAcceptedAt,
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
                Value<int> termsVersion = const Value.absent(),
                Value<DateTime?> termsAcceptedAt = const Value.absent(),
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
                termsVersion: termsVersion,
                termsAcceptedAt: termsAcceptedAt,
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
typedef $$MrpRateRowsTableCreateCompanionBuilder =
    MrpRateRowsCompanion Function({
      Value<int> id,
      required DateTime validFrom,
      required int amount,
      required DateTime createdAt,
    });
typedef $$MrpRateRowsTableUpdateCompanionBuilder =
    MrpRateRowsCompanion Function({
      Value<int> id,
      Value<DateTime> validFrom,
      Value<int> amount,
      Value<DateTime> createdAt,
    });

class $$MrpRateRowsTableFilterComposer
    extends Composer<_$AppDatabase, $MrpRateRowsTable> {
  $$MrpRateRowsTableFilterComposer({
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

  ColumnFilters<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MrpRateRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $MrpRateRowsTable> {
  $$MrpRateRowsTableOrderingComposer({
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

  ColumnOrderings<DateTime> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MrpRateRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MrpRateRowsTable> {
  $$MrpRateRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MrpRateRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MrpRateRowsTable,
          MrpRateRow,
          $$MrpRateRowsTableFilterComposer,
          $$MrpRateRowsTableOrderingComposer,
          $$MrpRateRowsTableAnnotationComposer,
          $$MrpRateRowsTableCreateCompanionBuilder,
          $$MrpRateRowsTableUpdateCompanionBuilder,
          (
            MrpRateRow,
            BaseReferences<_$AppDatabase, $MrpRateRowsTable, MrpRateRow>,
          ),
          MrpRateRow,
          PrefetchHooks Function()
        > {
  $$MrpRateRowsTableTableManager(_$AppDatabase db, $MrpRateRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MrpRateRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MrpRateRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MrpRateRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> validFrom = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => MrpRateRowsCompanion(
                id: id,
                validFrom: validFrom,
                amount: amount,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime validFrom,
                required int amount,
                required DateTime createdAt,
              }) => MrpRateRowsCompanion.insert(
                id: id,
                validFrom: validFrom,
                amount: amount,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MrpRateRowsTable, MrpRateRow>(table),
                  BaseReferences<_$AppDatabase, $MrpRateRowsTable, MrpRateRow>(
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

typedef $$MrpRateRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MrpRateRowsTable,
      MrpRateRow,
      $$MrpRateRowsTableFilterComposer,
      $$MrpRateRowsTableOrderingComposer,
      $$MrpRateRowsTableAnnotationComposer,
      $$MrpRateRowsTableCreateCompanionBuilder,
      $$MrpRateRowsTableUpdateCompanionBuilder,
      (
        MrpRateRow,
        BaseReferences<_$AppDatabase, $MrpRateRowsTable, MrpRateRow>,
      ),
      MrpRateRow,
      PrefetchHooks Function()
    >;
typedef $$PaymentRowsTableCreateCompanionBuilder =
    PaymentRowsCompanion Function({
      Value<int> id,
      required int shiftId,
      required int payerId,
      required int amount,
      required int fee,
      required String status,
      required String cardLast4,
      required String cardBrand,
      required String operation,
      Value<String> method,
      required DateTime createdAt,
    });
typedef $$PaymentRowsTableUpdateCompanionBuilder =
    PaymentRowsCompanion Function({
      Value<int> id,
      Value<int> shiftId,
      Value<int> payerId,
      Value<int> amount,
      Value<int> fee,
      Value<String> status,
      Value<String> cardLast4,
      Value<String> cardBrand,
      Value<String> operation,
      Value<String> method,
      Value<DateTime> createdAt,
    });

final class $$PaymentRowsTableReferences
    extends BaseReferences<_$AppDatabase, $PaymentRowsTable, PaymentRow> {
  $$PaymentRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftRowsTable _shiftIdTable(_$AppDatabase db) =>
      db.shiftRows.createAlias('payment_rows__shift_id__shift_rows__id');

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

class $$PaymentRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentRowsTable> {
  $$PaymentRowsTableFilterComposer({
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

  ColumnFilters<int> get payerId => $composableBuilder(
    column: $table.payerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fee => $composableBuilder(
    column: $table.fee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cardBrand => $composableBuilder(
    column: $table.cardBrand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
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

class $$PaymentRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentRowsTable> {
  $$PaymentRowsTableOrderingComposer({
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

  ColumnOrderings<int> get payerId => $composableBuilder(
    column: $table.payerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fee => $composableBuilder(
    column: $table.fee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardLast4 => $composableBuilder(
    column: $table.cardLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cardBrand => $composableBuilder(
    column: $table.cardBrand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
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

class $$PaymentRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentRowsTable> {
  $$PaymentRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get payerId =>
      $composableBuilder(column: $table.payerId, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get fee =>
      $composableBuilder(column: $table.fee, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get cardLast4 =>
      $composableBuilder(column: $table.cardLast4, builder: (column) => column);

  GeneratedColumn<String> get cardBrand =>
      $composableBuilder(column: $table.cardBrand, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

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

class $$PaymentRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentRowsTable,
          PaymentRow,
          $$PaymentRowsTableFilterComposer,
          $$PaymentRowsTableOrderingComposer,
          $$PaymentRowsTableAnnotationComposer,
          $$PaymentRowsTableCreateCompanionBuilder,
          $$PaymentRowsTableUpdateCompanionBuilder,
          (PaymentRow, $$PaymentRowsTableReferences),
          PaymentRow,
          PrefetchHooks Function({bool shiftId})
        > {
  $$PaymentRowsTableTableManager(_$AppDatabase db, $PaymentRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shiftId = const Value.absent(),
                Value<int> payerId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> fee = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> cardLast4 = const Value.absent(),
                Value<String> cardBrand = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => PaymentRowsCompanion(
                id: id,
                shiftId: shiftId,
                payerId: payerId,
                amount: amount,
                fee: fee,
                status: status,
                cardLast4: cardLast4,
                cardBrand: cardBrand,
                operation: operation,
                method: method,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shiftId,
                required int payerId,
                required int amount,
                required int fee,
                required String status,
                required String cardLast4,
                required String cardBrand,
                required String operation,
                Value<String> method = const Value.absent(),
                required DateTime createdAt,
              }) => PaymentRowsCompanion.insert(
                id: id,
                shiftId: shiftId,
                payerId: payerId,
                amount: amount,
                fee: fee,
                status: status,
                cardLast4: cardLast4,
                cardBrand: cardBrand,
                operation: operation,
                method: method,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PaymentRowsTable, PaymentRow>(table),
                  $$PaymentRowsTableReferences(db, table, e),
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
                        referencedTable: $$PaymentRowsTableReferences
                            ._shiftIdTable(db),
                        referencedColumn: $$PaymentRowsTableReferences
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

typedef $$PaymentRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentRowsTable,
      PaymentRow,
      $$PaymentRowsTableFilterComposer,
      $$PaymentRowsTableOrderingComposer,
      $$PaymentRowsTableAnnotationComposer,
      $$PaymentRowsTableCreateCompanionBuilder,
      $$PaymentRowsTableUpdateCompanionBuilder,
      (PaymentRow, $$PaymentRowsTableReferences),
      PaymentRow,
      PrefetchHooks Function({bool shiftId})
    >;
typedef $$WalletEntryRowsTableCreateCompanionBuilder =
    WalletEntryRowsCompanion Function({
      Value<int> id,
      required int userId,
      Value<int?> shiftId,
      required String kind,
      required int amount,
      required String title,
      required DateTime createdAt,
    });
typedef $$WalletEntryRowsTableUpdateCompanionBuilder =
    WalletEntryRowsCompanion Function({
      Value<int> id,
      Value<int> userId,
      Value<int?> shiftId,
      Value<String> kind,
      Value<int> amount,
      Value<String> title,
      Value<DateTime> createdAt,
    });

class $$WalletEntryRowsTableFilterComposer
    extends Composer<_$AppDatabase, $WalletEntryRowsTable> {
  $$WalletEntryRowsTableFilterComposer({
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

  ColumnFilters<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WalletEntryRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $WalletEntryRowsTable> {
  $$WalletEntryRowsTableOrderingComposer({
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

  ColumnOrderings<int> get shiftId => $composableBuilder(
    column: $table.shiftId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WalletEntryRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WalletEntryRowsTable> {
  $$WalletEntryRowsTableAnnotationComposer({
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

  GeneratedColumn<int> get shiftId =>
      $composableBuilder(column: $table.shiftId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WalletEntryRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WalletEntryRowsTable,
          WalletEntryRow,
          $$WalletEntryRowsTableFilterComposer,
          $$WalletEntryRowsTableOrderingComposer,
          $$WalletEntryRowsTableAnnotationComposer,
          $$WalletEntryRowsTableCreateCompanionBuilder,
          $$WalletEntryRowsTableUpdateCompanionBuilder,
          (
            WalletEntryRow,
            BaseReferences<
              _$AppDatabase,
              $WalletEntryRowsTable,
              WalletEntryRow
            >,
          ),
          WalletEntryRow,
          PrefetchHooks Function()
        > {
  $$WalletEntryRowsTableTableManager(
    _$AppDatabase db,
    $WalletEntryRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WalletEntryRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WalletEntryRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WalletEntryRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int?> shiftId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WalletEntryRowsCompanion(
                id: id,
                userId: userId,
                shiftId: shiftId,
                kind: kind,
                amount: amount,
                title: title,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                Value<int?> shiftId = const Value.absent(),
                required String kind,
                required int amount,
                required String title,
                required DateTime createdAt,
              }) => WalletEntryRowsCompanion.insert(
                id: id,
                userId: userId,
                shiftId: shiftId,
                kind: kind,
                amount: amount,
                title: title,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WalletEntryRowsTable, WalletEntryRow>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WalletEntryRowsTable,
                    WalletEntryRow
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WalletEntryRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WalletEntryRowsTable,
      WalletEntryRow,
      $$WalletEntryRowsTableFilterComposer,
      $$WalletEntryRowsTableOrderingComposer,
      $$WalletEntryRowsTableAnnotationComposer,
      $$WalletEntryRowsTableCreateCompanionBuilder,
      $$WalletEntryRowsTableUpdateCompanionBuilder,
      (
        WalletEntryRow,
        BaseReferences<_$AppDatabase, $WalletEntryRowsTable, WalletEntryRow>,
      ),
      WalletEntryRow,
      PrefetchHooks Function()
    >;
typedef $$ChargeRowsTableCreateCompanionBuilder = ChargeRowsCompanion Function({
  Value<int> id,
  required int shiftId,
  required int payerId,
  required String kind,
  required String method,
  required int amount,
  Value<int> refunded,
  required String status,
  required String provider,
  Value<String> operation,
  Value<String?> checkoutUrl,
  Value<String?> phone,
  Value<String?> payload,
  Value<String?> message,
  required DateTime createdAt,
  Value<DateTime?> paidAt,
});
typedef $$ChargeRowsTableUpdateCompanionBuilder = ChargeRowsCompanion Function({
  Value<int> id,
  Value<int> shiftId,
  Value<int> payerId,
  Value<String> kind,
  Value<String> method,
  Value<int> amount,
  Value<int> refunded,
  Value<String> status,
  Value<String> provider,
  Value<String> operation,
  Value<String?> checkoutUrl,
  Value<String?> phone,
  Value<String?> payload,
  Value<String?> message,
  Value<DateTime> createdAt,
  Value<DateTime?> paidAt,
});

final class $$ChargeRowsTableReferences
    extends BaseReferences<_$AppDatabase, $ChargeRowsTable, ChargeRow> {
  $$ChargeRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ShiftRowsTable _shiftIdTable(_$AppDatabase db) =>
      db.shiftRows.createAlias('charge_rows__shift_id__shift_rows__id');

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

class $$ChargeRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ChargeRowsTable> {
  $$ChargeRowsTableFilterComposer({
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

  ColumnFilters<int> get payerId => $composableBuilder(
    column: $table.payerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get refunded => $composableBuilder(
    column: $table.refunded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkoutUrl => $composableBuilder(
    column: $table.checkoutUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
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

class $$ChargeRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChargeRowsTable> {
  $$ChargeRowsTableOrderingComposer({
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

  ColumnOrderings<int> get payerId => $composableBuilder(
    column: $table.payerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get method => $composableBuilder(
    column: $table.method,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get refunded => $composableBuilder(
    column: $table.refunded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkoutUrl => $composableBuilder(
    column: $table.checkoutUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get paidAt => $composableBuilder(
    column: $table.paidAt,
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

class $$ChargeRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChargeRowsTable> {
  $$ChargeRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get payerId =>
      $composableBuilder(column: $table.payerId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get method =>
      $composableBuilder(column: $table.method, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<int> get refunded =>
      $composableBuilder(column: $table.refunded, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get checkoutUrl => $composableBuilder(
    column: $table.checkoutUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get paidAt =>
      $composableBuilder(column: $table.paidAt, builder: (column) => column);

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

class $$ChargeRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChargeRowsTable,
          ChargeRow,
          $$ChargeRowsTableFilterComposer,
          $$ChargeRowsTableOrderingComposer,
          $$ChargeRowsTableAnnotationComposer,
          $$ChargeRowsTableCreateCompanionBuilder,
          $$ChargeRowsTableUpdateCompanionBuilder,
          (ChargeRow, $$ChargeRowsTableReferences),
          ChargeRow,
          PrefetchHooks Function({bool shiftId})
        > {
  $$ChargeRowsTableTableManager(_$AppDatabase db, $ChargeRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChargeRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChargeRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChargeRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> shiftId = const Value.absent(),
                Value<int> payerId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> method = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<int> refunded = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> checkoutUrl = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> paidAt = const Value.absent(),
              }) => ChargeRowsCompanion(
                id: id,
                shiftId: shiftId,
                payerId: payerId,
                kind: kind,
                method: method,
                amount: amount,
                refunded: refunded,
                status: status,
                provider: provider,
                operation: operation,
                checkoutUrl: checkoutUrl,
                phone: phone,
                payload: payload,
                message: message,
                createdAt: createdAt,
                paidAt: paidAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int shiftId,
                required int payerId,
                required String kind,
                required String method,
                required int amount,
                Value<int> refunded = const Value.absent(),
                required String status,
                required String provider,
                Value<String> operation = const Value.absent(),
                Value<String?> checkoutUrl = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<String?> message = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> paidAt = const Value.absent(),
              }) => ChargeRowsCompanion.insert(
                id: id,
                shiftId: shiftId,
                payerId: payerId,
                kind: kind,
                method: method,
                amount: amount,
                refunded: refunded,
                status: status,
                provider: provider,
                operation: operation,
                checkoutUrl: checkoutUrl,
                phone: phone,
                payload: payload,
                message: message,
                createdAt: createdAt,
                paidAt: paidAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChargeRowsTable, ChargeRow>(table),
                  $$ChargeRowsTableReferences(db, table, e),
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
                        referencedTable: $$ChargeRowsTableReferences
                            ._shiftIdTable(db),
                        referencedColumn: $$ChargeRowsTableReferences
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

typedef $$ChargeRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChargeRowsTable,
      ChargeRow,
      $$ChargeRowsTableFilterComposer,
      $$ChargeRowsTableOrderingComposer,
      $$ChargeRowsTableAnnotationComposer,
      $$ChargeRowsTableCreateCompanionBuilder,
      $$ChargeRowsTableUpdateCompanionBuilder,
      (ChargeRow, $$ChargeRowsTableReferences),
      ChargeRow,
      PrefetchHooks Function({bool shiftId})
    >;
typedef $$PayoutRowsTableCreateCompanionBuilder = PayoutRowsCompanion Function({
  Value<int> id,
  required int userId,
  required int amount,
  required String status,
  required String provider,
  Value<String> operation,
  Value<String?> checkoutUrl,
  Value<String?> message,
  required DateTime createdAt,
  Value<DateTime?> doneAt,
});
typedef $$PayoutRowsTableUpdateCompanionBuilder = PayoutRowsCompanion Function({
  Value<int> id,
  Value<int> userId,
  Value<int> amount,
  Value<String> status,
  Value<String> provider,
  Value<String> operation,
  Value<String?> checkoutUrl,
  Value<String?> message,
  Value<DateTime> createdAt,
  Value<DateTime?> doneAt,
});

class $$PayoutRowsTableFilterComposer
    extends Composer<_$AppDatabase, $PayoutRowsTable> {
  $$PayoutRowsTableFilterComposer({
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

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get checkoutUrl => $composableBuilder(
    column: $table.checkoutUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PayoutRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $PayoutRowsTable> {
  $$PayoutRowsTableOrderingComposer({
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

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get checkoutUrl => $composableBuilder(
    column: $table.checkoutUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayoutRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayoutRowsTable> {
  $$PayoutRowsTableAnnotationComposer({
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

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get checkoutUrl => $composableBuilder(
    column: $table.checkoutUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get message =>
      $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);
}

class $$PayoutRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayoutRowsTable,
          PayoutRow,
          $$PayoutRowsTableFilterComposer,
          $$PayoutRowsTableOrderingComposer,
          $$PayoutRowsTableAnnotationComposer,
          $$PayoutRowsTableCreateCompanionBuilder,
          $$PayoutRowsTableUpdateCompanionBuilder,
          (
            PayoutRow,
            BaseReferences<_$AppDatabase, $PayoutRowsTable, PayoutRow>,
          ),
          PayoutRow,
          PrefetchHooks Function()
        > {
  $$PayoutRowsTableTableManager(_$AppDatabase db, $PayoutRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayoutRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayoutRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayoutRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> userId = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String?> checkoutUrl = const Value.absent(),
                Value<String?> message = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> doneAt = const Value.absent(),
              }) => PayoutRowsCompanion(
                id: id,
                userId: userId,
                amount: amount,
                status: status,
                provider: provider,
                operation: operation,
                checkoutUrl: checkoutUrl,
                message: message,
                createdAt: createdAt,
                doneAt: doneAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int userId,
                required int amount,
                required String status,
                required String provider,
                Value<String> operation = const Value.absent(),
                Value<String?> checkoutUrl = const Value.absent(),
                Value<String?> message = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> doneAt = const Value.absent(),
              }) => PayoutRowsCompanion.insert(
                id: id,
                userId: userId,
                amount: amount,
                status: status,
                provider: provider,
                operation: operation,
                checkoutUrl: checkoutUrl,
                message: message,
                createdAt: createdAt,
                doneAt: doneAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PayoutRowsTable, PayoutRow>(table),
                  BaseReferences<_$AppDatabase, $PayoutRowsTable, PayoutRow>(
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

typedef $$PayoutRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayoutRowsTable,
      PayoutRow,
      $$PayoutRowsTableFilterComposer,
      $$PayoutRowsTableOrderingComposer,
      $$PayoutRowsTableAnnotationComposer,
      $$PayoutRowsTableCreateCompanionBuilder,
      $$PayoutRowsTableUpdateCompanionBuilder,
      (PayoutRow, BaseReferences<_$AppDatabase, $PayoutRowsTable, PayoutRow>),
      PayoutRow,
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
  $$MrpRateRowsTableTableManager get mrpRateRows =>
      $$MrpRateRowsTableTableManager(_db, _db.mrpRateRows);
  $$PaymentRowsTableTableManager get paymentRows =>
      $$PaymentRowsTableTableManager(_db, _db.paymentRows);
  $$WalletEntryRowsTableTableManager get walletEntryRows =>
      $$WalletEntryRowsTableTableManager(_db, _db.walletEntryRows);
  $$ChargeRowsTableTableManager get chargeRows =>
      $$ChargeRowsTableTableManager(_db, _db.chargeRows);
  $$PayoutRowsTableTableManager get payoutRows =>
      $$PayoutRowsTableTableManager(_db, _db.payoutRows);
}
