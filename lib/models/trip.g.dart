// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetTripCollection on Isar {
  IsarCollection<Trip> get trips => this.collection();
}

const TripSchema = CollectionSchema(
  name: r'Trip',
  id: 2639069002795865543,
  properties: {
    r'alarmId': PropertySchema(
      id: 0,
      name: r'alarmId',
      type: IsarType.long,
    ),
    r'avgSpeedKmh': PropertySchema(
      id: 1,
      name: r'avgSpeedKmh',
      type: IsarType.double,
    ),
    r'destLatitude': PropertySchema(
      id: 2,
      name: r'destLatitude',
      type: IsarType.double,
    ),
    r'destLongitude': PropertySchema(
      id: 3,
      name: r'destLongitude',
      type: IsarType.double,
    ),
    r'destinationName': PropertySchema(
      id: 4,
      name: r'destinationName',
      type: IsarType.string,
    ),
    r'durationSeconds': PropertySchema(
      id: 5,
      name: r'durationSeconds',
      type: IsarType.long,
    ),
    r'endedAt': PropertySchema(
      id: 6,
      name: r'endedAt',
      type: IsarType.dateTime,
    ),
    r'maxSpeedKmh': PropertySchema(
      id: 7,
      name: r'maxSpeedKmh',
      type: IsarType.double,
    ),
    r'outcome': PropertySchema(
      id: 8,
      name: r'outcome',
      type: IsarType.byte,
      enumMap: _TripoutcomeEnumValueMap,
    ),
    r'routePolyline': PropertySchema(
      id: 9,
      name: r'routePolyline',
      type: IsarType.string,
    ),
    r'startedAt': PropertySchema(
      id: 10,
      name: r'startedAt',
      type: IsarType.dateTime,
    ),
    r'totalDistanceMeters': PropertySchema(
      id: 11,
      name: r'totalDistanceMeters',
      type: IsarType.double,
    )
  },
  estimateSize: _tripEstimateSize,
  serialize: _tripSerialize,
  deserialize: _tripDeserialize,
  deserializeProp: _tripDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _tripGetId,
  getLinks: _tripGetLinks,
  attach: _tripAttach,
  version: '3.1.0+1',
);

int _tripEstimateSize(
  Trip object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.destinationName.length * 3;
  {
    final value = object.routePolyline;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _tripSerialize(
  Trip object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.alarmId);
  writer.writeDouble(offsets[1], object.avgSpeedKmh);
  writer.writeDouble(offsets[2], object.destLatitude);
  writer.writeDouble(offsets[3], object.destLongitude);
  writer.writeString(offsets[4], object.destinationName);
  writer.writeLong(offsets[5], object.durationSeconds);
  writer.writeDateTime(offsets[6], object.endedAt);
  writer.writeDouble(offsets[7], object.maxSpeedKmh);
  writer.writeByte(offsets[8], object.outcome.index);
  writer.writeString(offsets[9], object.routePolyline);
  writer.writeDateTime(offsets[10], object.startedAt);
  writer.writeDouble(offsets[11], object.totalDistanceMeters);
}

Trip _tripDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Trip();
  object.alarmId = reader.readLong(offsets[0]);
  object.avgSpeedKmh = reader.readDoubleOrNull(offsets[1]);
  object.destLatitude = reader.readDouble(offsets[2]);
  object.destLongitude = reader.readDouble(offsets[3]);
  object.destinationName = reader.readString(offsets[4]);
  object.durationSeconds = reader.readLongOrNull(offsets[5]);
  object.endedAt = reader.readDateTimeOrNull(offsets[6]);
  object.id = id;
  object.maxSpeedKmh = reader.readDoubleOrNull(offsets[7]);
  object.outcome =
      _TripoutcomeValueEnumMap[reader.readByteOrNull(offsets[8])] ??
          TripOutcome.completed;
  object.routePolyline = reader.readStringOrNull(offsets[9]);
  object.startedAt = reader.readDateTime(offsets[10]);
  object.totalDistanceMeters = reader.readDoubleOrNull(offsets[11]);
  return object;
}

P _tripDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDoubleOrNull(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (_TripoutcomeValueEnumMap[reader.readByteOrNull(offset)] ??
          TripOutcome.completed) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _TripoutcomeEnumValueMap = {
  'completed': 0,
  'cancelled': 1,
  'missed': 2,
  'passed': 3,
};
const _TripoutcomeValueEnumMap = {
  0: TripOutcome.completed,
  1: TripOutcome.cancelled,
  2: TripOutcome.missed,
  3: TripOutcome.passed,
};

Id _tripGetId(Trip object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _tripGetLinks(Trip object) {
  return [];
}

void _tripAttach(IsarCollection<dynamic> col, Id id, Trip object) {
  object.id = id;
}

extension TripQueryWhereSort on QueryBuilder<Trip, Trip, QWhere> {
  QueryBuilder<Trip, Trip, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension TripQueryWhere on QueryBuilder<Trip, Trip, QWhereClause> {
  QueryBuilder<Trip, Trip, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Trip, Trip, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Trip, Trip, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Trip, Trip, QAfterWhereClause> idBetween(
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

extension TripQueryFilter on QueryBuilder<Trip, Trip, QFilterCondition> {
  QueryBuilder<Trip, Trip, QAfterFilterCondition> alarmIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmId',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> alarmIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'alarmId',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> alarmIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'alarmId',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> alarmIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'alarmId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> avgSpeedKmhIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avgSpeedKmh',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> avgSpeedKmhIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avgSpeedKmh',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> avgSpeedKmhEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avgSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> avgSpeedKmhGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avgSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> avgSpeedKmhLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avgSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> avgSpeedKmhBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avgSpeedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLatitudeEqualTo(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLatitudeGreaterThan(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLatitudeLessThan(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLatitudeBetween(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLongitudeEqualTo(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLongitudeGreaterThan(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLongitudeLessThan(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destLongitudeBetween(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'destinationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'destinationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'destinationName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'destinationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'destinationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'destinationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'destinationName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinationName',
        value: '',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> destinationNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'destinationName',
        value: '',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> durationSecondsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationSeconds',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> durationSecondsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationSeconds',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> durationSecondsEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> durationSecondsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> durationSecondsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationSeconds',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> durationSecondsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationSeconds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> endedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endedAt',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> endedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endedAt',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> endedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> endedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> endedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> endedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> maxSpeedKmhIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'maxSpeedKmh',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> maxSpeedKmhIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'maxSpeedKmh',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> maxSpeedKmhEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> maxSpeedKmhGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> maxSpeedKmhLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'maxSpeedKmh',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> maxSpeedKmhBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'maxSpeedKmh',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> outcomeEqualTo(
      TripOutcome value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'outcome',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> outcomeGreaterThan(
    TripOutcome value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'outcome',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> outcomeLessThan(
    TripOutcome value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'outcome',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> outcomeBetween(
    TripOutcome lower,
    TripOutcome upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'outcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'routePolyline',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'routePolyline',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routePolyline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'routePolyline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'routePolyline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'routePolyline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'routePolyline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'routePolyline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'routePolyline',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'routePolyline',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routePolyline',
        value: '',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> routePolylineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'routePolyline',
        value: '',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> startedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> startedAtGreaterThan(
    DateTime value, {
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> startedAtLessThan(
    DateTime value, {
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> startedAtBetween(
    DateTime lower,
    DateTime upper, {
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

  QueryBuilder<Trip, Trip, QAfterFilterCondition> totalDistanceMetersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalDistanceMeters',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition>
      totalDistanceMetersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalDistanceMeters',
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> totalDistanceMetersEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition>
      totalDistanceMetersGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> totalDistanceMetersLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Trip, Trip, QAfterFilterCondition> totalDistanceMetersBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalDistanceMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension TripQueryObject on QueryBuilder<Trip, Trip, QFilterCondition> {}

extension TripQueryLinks on QueryBuilder<Trip, Trip, QFilterCondition> {}

extension TripQuerySortBy on QueryBuilder<Trip, Trip, QSortBy> {
  QueryBuilder<Trip, Trip, QAfterSortBy> sortByAlarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByAlarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByAvgSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByAvgSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDestLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDestLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDestinationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDestinationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByRoutePolyline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByRoutePolylineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> sortByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }
}

extension TripQuerySortThenBy on QueryBuilder<Trip, Trip, QSortThenBy> {
  QueryBuilder<Trip, Trip, QAfterSortBy> thenByAlarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByAlarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByAvgSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByAvgSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avgSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDestLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDestLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDestinationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDestinationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByDurationSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationSeconds', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByEndedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endedAt', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByMaxSpeedKmhDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'maxSpeedKmh', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'outcome', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByRoutePolyline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByRoutePolylineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByStartedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'startedAt', Sort.desc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<Trip, Trip, QAfterSortBy> thenByTotalDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalDistanceMeters', Sort.desc);
    });
  }
}

extension TripQueryWhereDistinct on QueryBuilder<Trip, Trip, QDistinct> {
  QueryBuilder<Trip, Trip, QDistinct> distinctByAlarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmId');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByAvgSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avgSpeedKmh');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destLatitude');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destLongitude');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByDestinationName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destinationName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByDurationSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationSeconds');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByEndedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endedAt');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByMaxSpeedKmh() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'maxSpeedKmh');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'outcome');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByRoutePolyline(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routePolyline',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByStartedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startedAt');
    });
  }

  QueryBuilder<Trip, Trip, QDistinct> distinctByTotalDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalDistanceMeters');
    });
  }
}

extension TripQueryProperty on QueryBuilder<Trip, Trip, QQueryProperty> {
  QueryBuilder<Trip, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Trip, int, QQueryOperations> alarmIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmId');
    });
  }

  QueryBuilder<Trip, double?, QQueryOperations> avgSpeedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avgSpeedKmh');
    });
  }

  QueryBuilder<Trip, double, QQueryOperations> destLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destLatitude');
    });
  }

  QueryBuilder<Trip, double, QQueryOperations> destLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destLongitude');
    });
  }

  QueryBuilder<Trip, String, QQueryOperations> destinationNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destinationName');
    });
  }

  QueryBuilder<Trip, int?, QQueryOperations> durationSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationSeconds');
    });
  }

  QueryBuilder<Trip, DateTime?, QQueryOperations> endedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endedAt');
    });
  }

  QueryBuilder<Trip, double?, QQueryOperations> maxSpeedKmhProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'maxSpeedKmh');
    });
  }

  QueryBuilder<Trip, TripOutcome, QQueryOperations> outcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'outcome');
    });
  }

  QueryBuilder<Trip, String?, QQueryOperations> routePolylineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routePolyline');
    });
  }

  QueryBuilder<Trip, DateTime, QQueryOperations> startedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startedAt');
    });
  }

  QueryBuilder<Trip, double?, QQueryOperations> totalDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalDistanceMeters');
    });
  }
}
