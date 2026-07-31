// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAlarmCollection on Isar {
  IsarCollection<Alarm> get alarms => this.collection();
}

const AlarmSchema = CollectionSchema(
  name: r'Alarm',
  id: -6172094888861729789,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'completedAt': PropertySchema(
      id: 1,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'createdBy': PropertySchema(
      id: 3,
      name: r'createdBy',
      type: IsarType.byte,
      enumMap: _AlarmcreatedByEnumValueMap,
    ),
    r'destLatitude': PropertySchema(
      id: 4,
      name: r'destLatitude',
      type: IsarType.double,
    ),
    r'destLongitude': PropertySchema(
      id: 5,
      name: r'destLongitude',
      type: IsarType.double,
    ),
    r'flashlightEnabled': PropertySchema(
      id: 6,
      name: r'flashlightEnabled',
      type: IsarType.bool,
    ),
    r'name': PropertySchema(
      id: 7,
      name: r'name',
      type: IsarType.string,
    ),
    r'placeId': PropertySchema(
      id: 8,
      name: r'placeId',
      type: IsarType.string,
    ),
    r'radiusMeters': PropertySchema(
      id: 9,
      name: r'radiusMeters',
      type: IsarType.double,
    ),
    r'repeat': PropertySchema(
      id: 10,
      name: r'repeat',
      type: IsarType.bool,
    ),
    r'ringtoneUri': PropertySchema(
      id: 11,
      name: r'ringtoneUri',
      type: IsarType.string,
    ),
    r'scheduledAt': PropertySchema(
      id: 12,
      name: r'scheduledAt',
      type: IsarType.dateTime,
    ),
    r'sourcePlaceId': PropertySchema(
      id: 13,
      name: r'sourcePlaceId',
      type: IsarType.long,
    ),
    r'speedThresholdKmh': PropertySchema(
      id: 14,
      name: r'speedThresholdKmh',
      type: IsarType.double,
    ),
    r'startedAt': PropertySchema(
      id: 15,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'status': PropertySchema(
      id: 16,
      name: r'status',
      type: IsarType.byte,
      enumMap: _AlarmstatusEnumValueMap,
    ),
    r'travelMode': PropertySchema(
      id: 17,
      name: r'travelMode',
      type: IsarType.byte,
      enumMap: _AlarmtravelModeEnumValueMap,
    ),
    r'triggerDistanceMeters': PropertySchema(
      id: 18,
      name: r'triggerDistanceMeters',
      type: IsarType.double,
    ),
    r'triggeredAt': PropertySchema(
      id: 19,
      name: r'triggeredAt',
      type: IsarType.dateTime,
    ),
    r'type': PropertySchema(
      id: 20,
      name: r'type',
      type: IsarType.byte,
      enumMap: _AlarmtypeEnumValueMap,
    ),
    r'updatedAt': PropertySchema(
      id: 21,
      name: r'updatedAt',
      type: IsarType.dateTime,
    ),
    r'vibrationEnabled': PropertySchema(
      id: 22,
      name: r'vibrationEnabled',
      type: IsarType.bool,
    ),
    r'voiceEnabled': PropertySchema(
      id: 23,
      name: r'voiceEnabled',
      type: IsarType.bool,
    ),
    r'voiceMessage': PropertySchema(
      id: 24,
      name: r'voiceMessage',
      type: IsarType.string,
    )
  },
  estimateSize: _alarmEstimateSize,
  serialize: _alarmSerialize,
  deserialize: _alarmDeserialize,
  deserializeProp: _alarmDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _alarmGetId,
  getLinks: _alarmGetLinks,
  attach: _alarmAttach,
  version: '3.1.0+1',
);

int _alarmEstimateSize(
  Alarm object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.address;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.placeId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ringtoneUri;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.voiceMessage;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _alarmSerialize(
  Alarm object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeDateTime(offsets[1], object.completedAt);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeByte(offsets[3], object.createdBy.index);
  writer.writeDouble(offsets[4], object.destLatitude);
  writer.writeDouble(offsets[5], object.destLongitude);
  writer.writeBool(offsets[6], object.flashlightEnabled);
  writer.writeString(offsets[7], object.name);
  writer.writeString(offsets[8], object.placeId);
  writer.writeDouble(offsets[9], object.radiusMeters);
  writer.writeBool(offsets[10], object.repeat);
  writer.writeString(offsets[11], object.ringtoneUri);
  writer.writeDateTime(offsets[12], object.scheduledAt);
  writer.writeLong(offsets[13], object.sourcePlaceId);
  writer.writeDouble(offsets[14], object.speedThresholdKmh);
  writer.writeDateTime(offsets[15], object.startedAt);
  writer.writeByte(offsets[16], object.status.index);
  writer.writeByte(offsets[17], object.travelMode.index);
  writer.writeDouble(offsets[18], object.triggerDistanceMeters);
  writer.writeDateTime(offsets[19], object.triggeredAt);
  writer.writeByte(offsets[20], object.type.index);
  writer.writeDateTime(offsets[21], object.updatedAt);
  writer.writeBool(offsets[22], object.vibrationEnabled);
  writer.writeBool(offsets[23], object.voiceEnabled);
  writer.writeString(offsets[24], object.voiceMessage);
}

Alarm _alarmDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Alarm();
  object.address = reader.readStringOrNull(offsets[0]);
  object.completedAt = reader.readDateTimeOrNull(offsets[1]);
  object.createdAt = reader.readDateTime(offsets[2]);
  object.createdBy =
      _AlarmcreatedByValueEnumMap[reader.readByteOrNull(offsets[3])] ??
          AlarmCreatedBy.manual;
  object.destLatitude = reader.readDouble(offsets[4]);
  object.destLongitude = reader.readDouble(offsets[5]);
  object.flashlightEnabled = reader.readBool(offsets[6]);
  object.id = id;
  object.name = reader.readString(offsets[7]);
  object.placeId = reader.readStringOrNull(offsets[8]);
  object.radiusMeters = reader.readDoubleOrNull(offsets[9]);
  object.repeat = reader.readBool(offsets[10]);
  object.ringtoneUri = reader.readStringOrNull(offsets[11]);
  object.scheduledAt = reader.readDateTimeOrNull(offsets[12]);
  object.sourcePlaceId = reader.readLongOrNull(offsets[13]);
  object.speedThresholdKmh = reader.readDoubleOrNull(offsets[14]);
  object.startedAt = reader.readDateTimeOrNull(offsets[15]);
  object.status =
      _AlarmstatusValueEnumMap[reader.readByteOrNull(offsets[16])] ??
          AlarmStatus.draft;
  object.travelMode =
      _AlarmtravelModeValueEnumMap[reader.readByteOrNull(offsets[17])] ??
          TravelMode.train;
  object.triggerDistanceMeters = reader.readDouble(offsets[18]);
  object.triggeredAt = reader.readDateTimeOrNull(offsets[19]);
  object.type = _AlarmtypeValueEnumMap[reader.readByteOrNull(offsets[20])] ??
      AlarmType.distance;
  object.updatedAt = reader.readDateTime(offsets[21]);
  object.vibrationEnabled = reader.readBool(offsets[22]);
  object.voiceEnabled = reader.readBool(offsets[23]);
  object.voiceMessage = reader.readStringOrNull(offsets[24]);
  return object;
}

P _alarmDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (_AlarmcreatedByValueEnumMap[reader.readByteOrNull(offset)] ??
          AlarmCreatedBy.manual) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 13:
      return (reader.readLongOrNull(offset)) as P;
    case 14:
      return (reader.readDoubleOrNull(offset)) as P;
    case 15:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 16:
      return (_AlarmstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          AlarmStatus.draft) as P;
    case 17:
      return (_AlarmtravelModeValueEnumMap[reader.readByteOrNull(offset)] ??
          TravelMode.train) as P;
    case 18:
      return (reader.readDouble(offset)) as P;
    case 19:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 20:
      return (_AlarmtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          AlarmType.distance) as P;
    case 21:
      return (reader.readDateTime(offset)) as P;
    case 22:
      return (reader.readBool(offset)) as P;
    case 23:
      return (reader.readBool(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AlarmcreatedByEnumValueMap = {
  'manual': 0,
  'smart': 1,
  'imported': 2,
};
const _AlarmcreatedByValueEnumMap = {
  0: AlarmCreatedBy.manual,
  1: AlarmCreatedBy.smart,
  2: AlarmCreatedBy.imported,
};
const _AlarmstatusEnumValueMap = {
  'draft': 0,
  'active': 1,
  'paused': 2,
  'triggered': 3,
  'completed': 4,
  'cancelled': 5,
  'missed': 6,
};
const _AlarmstatusValueEnumMap = {
  0: AlarmStatus.draft,
  1: AlarmStatus.active,
  2: AlarmStatus.paused,
  3: AlarmStatus.triggered,
  4: AlarmStatus.completed,
  5: AlarmStatus.cancelled,
  6: AlarmStatus.missed,
};
const _AlarmtravelModeEnumValueMap = {
  'train': 0,
  'bus': 1,
  'metro': 2,
  'car': 3,
  'walking': 4,
  'cycling': 5,
  'autoDetect': 6,
};
const _AlarmtravelModeValueEnumMap = {
  0: TravelMode.train,
  1: TravelMode.bus,
  2: TravelMode.metro,
  3: TravelMode.car,
  4: TravelMode.walking,
  5: TravelMode.cycling,
  6: TravelMode.autoDetect,
};
const _AlarmtypeEnumValueMap = {
  'distance': 0,
  'arrival': 1,
  'departure': 2,
  'radius': 3,
  'eta': 4,
  'speed': 5,
  'geofence': 6,
};
const _AlarmtypeValueEnumMap = {
  0: AlarmType.distance,
  1: AlarmType.arrival,
  2: AlarmType.departure,
  3: AlarmType.radius,
  4: AlarmType.eta,
  5: AlarmType.speed,
  6: AlarmType.geofence,
};

Id _alarmGetId(Alarm object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _alarmGetLinks(Alarm object) {
  return [];
}

void _alarmAttach(IsarCollection<dynamic> col, Id id, Alarm object) {
  object.id = id;
}

extension AlarmQueryWhereSort on QueryBuilder<Alarm, Alarm, QWhere> {
  QueryBuilder<Alarm, Alarm, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AlarmQueryWhere on QueryBuilder<Alarm, Alarm, QWhereClause> {
  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension AlarmQueryFilter on QueryBuilder<Alarm, Alarm, QFilterCondition> {
  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'address',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'address',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'address',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> completedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdByEqualTo(
      AlarmCreatedBy value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdBy',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdByGreaterThan(
    AlarmCreatedBy value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdBy',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdByLessThan(
    AlarmCreatedBy value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdBy',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> createdByBetween(
    AlarmCreatedBy lower,
    AlarmCreatedBy upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLatitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLatitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'destLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLatitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'destLatitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLatitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'destLatitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLongitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLongitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'destLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLongitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'destLongitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> destLongitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'destLongitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> flashlightEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flashlightEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'placeId',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'placeId',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'placeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'placeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'placeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'placeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'placeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'placeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'placeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'placeId',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> placeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'placeId',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> radiusMetersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'radiusMeters',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> radiusMetersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'radiusMeters',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> radiusMetersEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'radiusMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> radiusMetersGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'radiusMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> radiusMetersLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'radiusMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> radiusMetersBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'radiusMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> repeatEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'repeat',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ringtoneUri',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ringtoneUri',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtoneUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ringtoneUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ringtoneUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ringtoneUri',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ringtoneUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ringtoneUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ringtoneUri',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ringtoneUri',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ringtoneUri',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> ringtoneUriIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ringtoneUri',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> scheduledAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'scheduledAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> scheduledAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'scheduledAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> scheduledAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> scheduledAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> scheduledAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> scheduledAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> sourcePlaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourcePlaceId',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> sourcePlaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourcePlaceId',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> sourcePlaceIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourcePlaceId',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> sourcePlaceIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourcePlaceId',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> sourcePlaceIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourcePlaceId',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> sourcePlaceIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourcePlaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> speedThresholdKmhIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'speedThresholdKmh',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition>
      speedThresholdKmhIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'speedThresholdKmh',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> speedThresholdKmhEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'speedThresholdKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition>
      speedThresholdKmhGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'speedThresholdKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> speedThresholdKmhLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'speedThresholdKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> speedThresholdKmhBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'speedThresholdKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> startedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> startedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startedAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> startedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> startedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> startedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> startedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> statusEqualTo(
      AlarmStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> statusGreaterThan(
    AlarmStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> statusLessThan(
    AlarmStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> statusBetween(
    AlarmStatus lower,
    AlarmStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> travelModeEqualTo(
      TravelMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'travelMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> travelModeGreaterThan(
    TravelMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'travelMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> travelModeLessThan(
    TravelMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'travelMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> travelModeBetween(
    TravelMode lower,
    TravelMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'travelMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition>
      triggerDistanceMetersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggerDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition>
      triggerDistanceMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggerDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition>
      triggerDistanceMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggerDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition>
      triggerDistanceMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggerDistanceMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> triggeredAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggeredAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> triggeredAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggeredAt',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> triggeredAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> triggeredAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> triggeredAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> triggeredAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggeredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> typeEqualTo(
      AlarmType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> typeGreaterThan(
    AlarmType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> typeLessThan(
    AlarmType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> typeBetween(
    AlarmType lower,
    AlarmType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> updatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> vibrationEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vibrationEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceEnabledEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voiceEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'voiceMessage',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'voiceMessage',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voiceMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'voiceMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'voiceMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'voiceMessage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'voiceMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'voiceMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'voiceMessage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'voiceMessage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'voiceMessage',
        value: '',
      ));
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterFilterCondition> voiceMessageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'voiceMessage',
        value: '',
      ));
    });
  }
}

extension AlarmQueryObject on QueryBuilder<Alarm, Alarm, QFilterCondition> {}

extension AlarmQueryLinks on QueryBuilder<Alarm, Alarm, QFilterCondition> {}

extension AlarmQuerySortBy on QueryBuilder<Alarm, Alarm, QSortBy> {
  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByDestLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByDestLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByFlashlightEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flashlightEnabled', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByFlashlightEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flashlightEnabled', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByPlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeId', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByPlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeId', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRadiusMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRadiusMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRingtoneUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneUri', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByRingtoneUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneUri', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortBySourcePlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePlaceId', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortBySourcePlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePlaceId', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortBySpeedThresholdKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedThresholdKmh', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortBySpeedThresholdKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedThresholdKmh', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByTravelMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelMode', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByTravelModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelMode', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByTriggeredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByVibrationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByVoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByVoiceMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceMessage', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> sortByVoiceMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceMessage', Sort.desc);
    });
  }
}

extension AlarmQuerySortThenBy on QueryBuilder<Alarm, Alarm, QSortThenBy> {
  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByCreatedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdBy', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByDestLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByDestLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByFlashlightEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flashlightEnabled', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByFlashlightEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flashlightEnabled', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByPlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeId', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByPlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'placeId', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRadiusMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRadiusMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'radiusMeters', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRepeatDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'repeat', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRingtoneUri() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneUri', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByRingtoneUriDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ringtoneUri', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByScheduledAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenBySourcePlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePlaceId', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenBySourcePlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePlaceId', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenBySpeedThresholdKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedThresholdKmh', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenBySpeedThresholdKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'speedThresholdKmh', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByTravelMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelMode', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByTravelModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'travelMode', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByTriggeredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByVibrationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vibrationEnabled', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByVoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByVoiceMessage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceMessage', Sort.asc);
    });
  }

  QueryBuilder<Alarm, Alarm, QAfterSortBy> thenByVoiceMessageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'voiceMessage', Sort.desc);
    });
  }
}

extension AlarmQueryWhereDistinct on QueryBuilder<Alarm, Alarm, QDistinct> {
  QueryBuilder<Alarm, Alarm, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByCreatedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdBy');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destLatitude');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destLongitude');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByFlashlightEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flashlightEnabled');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByPlaceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'placeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByRadiusMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'radiusMeters');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByRepeat() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'repeat');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByRingtoneUri(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ringtoneUri', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByScheduledAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAt');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctBySourcePlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourcePlaceId');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctBySpeedThresholdKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'speedThresholdKmh');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByTravelMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'travelMode');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerDistanceMeters');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggeredAt');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vibrationEnabled');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voiceEnabled');
    });
  }

  QueryBuilder<Alarm, Alarm, QDistinct> distinctByVoiceMessage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'voiceMessage', caseSensitive: caseSensitive);
    });
  }
}

extension AlarmQueryProperty on QueryBuilder<Alarm, Alarm, QQueryProperty> {
  QueryBuilder<Alarm, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Alarm, String?, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<Alarm, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<Alarm, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Alarm, AlarmCreatedBy, QQueryOperations> createdByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdBy');
    });
  }

  QueryBuilder<Alarm, double, QQueryOperations> destLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destLatitude');
    });
  }

  QueryBuilder<Alarm, double, QQueryOperations> destLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destLongitude');
    });
  }

  QueryBuilder<Alarm, bool, QQueryOperations> flashlightEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flashlightEnabled');
    });
  }

  QueryBuilder<Alarm, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Alarm, String?, QQueryOperations> placeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'placeId');
    });
  }

  QueryBuilder<Alarm, double?, QQueryOperations> radiusMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'radiusMeters');
    });
  }

  QueryBuilder<Alarm, bool, QQueryOperations> repeatProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'repeat');
    });
  }

  QueryBuilder<Alarm, String?, QQueryOperations> ringtoneUriProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ringtoneUri');
    });
  }

  QueryBuilder<Alarm, DateTime?, QQueryOperations> scheduledAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAt');
    });
  }

  QueryBuilder<Alarm, int?, QQueryOperations> sourcePlaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourcePlaceId');
    });
  }

  QueryBuilder<Alarm, double?, QQueryOperations> speedThresholdKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'speedThresholdKmh');
    });
  }

  QueryBuilder<Alarm, DateTime?, QQueryOperations> startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<Alarm, AlarmStatus, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Alarm, TravelMode, QQueryOperations> travelModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'travelMode');
    });
  }

  QueryBuilder<Alarm, double, QQueryOperations>
      triggerDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerDistanceMeters');
    });
  }

  QueryBuilder<Alarm, DateTime?, QQueryOperations> triggeredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggeredAt');
    });
  }

  QueryBuilder<Alarm, AlarmType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<Alarm, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }

  QueryBuilder<Alarm, bool, QQueryOperations> vibrationEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vibrationEnabled');
    });
  }

  QueryBuilder<Alarm, bool, QQueryOperations> voiceEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voiceEnabled');
    });
  }

  QueryBuilder<Alarm, String?, QQueryOperations> voiceMessageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'voiceMessage');
    });
  }
}
