// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_entry.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHistoryEntryCollection on Isar {
  IsarCollection<HistoryEntry> get historyEntrys => this.collection();
}

const HistoryEntrySchema = CollectionSchema(
  name: r'HistoryEntry',
  id: 2196274019059455532,
  properties: {
    r'alarmId': PropertySchema(
      id: 0,
      name: r'alarmId',
      type: IsarType.long,
    ),
    r'destLatitude': PropertySchema(
      id: 1,
      name: r'destLatitude',
      type: IsarType.double,
    ),
    r'destLongitude': PropertySchema(
      id: 2,
      name: r'destLongitude',
      type: IsarType.double,
    ),
    r'destinationName': PropertySchema(
      id: 3,
      name: r'destinationName',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 4,
      name: r'notes',
      type: IsarType.string,
    ),
    r'occurredAt': PropertySchema(
      id: 5,
      name: r'occurredAt',
      type: IsarType.dateTime,
    ),
    r'snoozeCount': PropertySchema(
      id: 6,
      name: r'snoozeCount',
      type: IsarType.long,
    ),
    r'triggerDistanceMeters': PropertySchema(
      id: 7,
      name: r'triggerDistanceMeters',
      type: IsarType.double,
    ),
    r'tripId': PropertySchema(
      id: 8,
      name: r'tripId',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 9,
      name: r'type',
      type: IsarType.byte,
      enumMap: _HistoryEntrytypeEnumValueMap,
    )
  },
  estimateSize: _historyEntryEstimateSize,
  serialize: _historyEntrySerialize,
  deserialize: _historyEntryDeserialize,
  deserializeProp: _historyEntryDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _historyEntryGetId,
  getLinks: _historyEntryGetLinks,
  attach: _historyEntryAttach,
  version: '3.1.0+1',
);

int _historyEntryEstimateSize(
  HistoryEntry object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.destinationName.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _historyEntrySerialize(
  HistoryEntry object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.alarmId);
  writer.writeDouble(offsets[1], object.destLatitude);
  writer.writeDouble(offsets[2], object.destLongitude);
  writer.writeString(offsets[3], object.destinationName);
  writer.writeString(offsets[4], object.notes);
  writer.writeDateTime(offsets[5], object.occurredAt);
  writer.writeLong(offsets[6], object.snoozeCount);
  writer.writeDouble(offsets[7], object.triggerDistanceMeters);
  writer.writeLong(offsets[8], object.tripId);
  writer.writeByte(offsets[9], object.type.index);
}

HistoryEntry _historyEntryDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HistoryEntry();
  object.alarmId = reader.readLongOrNull(offsets[0]);
  object.destLatitude = reader.readDouble(offsets[1]);
  object.destLongitude = reader.readDouble(offsets[2]);
  object.destinationName = reader.readString(offsets[3]);
  object.id = id;
  object.notes = reader.readStringOrNull(offsets[4]);
  object.occurredAt = reader.readDateTime(offsets[5]);
  object.snoozeCount = reader.readLongOrNull(offsets[6]);
  object.triggerDistanceMeters = reader.readDoubleOrNull(offsets[7]);
  object.tripId = reader.readLongOrNull(offsets[8]);
  object.type =
      _HistoryEntrytypeValueEnumMap[reader.readByteOrNull(offsets[9])] ??
          HistoryType.completed;
  return object;
}

P _historyEntryDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (_HistoryEntrytypeValueEnumMap[reader.readByteOrNull(offset)] ??
          HistoryType.completed) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _HistoryEntrytypeEnumValueMap = {
  'completed': 0,
  'missed': 1,
  'dismissed': 2,
  'snoozed': 3,
};
const _HistoryEntrytypeValueEnumMap = {
  0: HistoryType.completed,
  1: HistoryType.missed,
  2: HistoryType.dismissed,
  3: HistoryType.snoozed,
};

Id _historyEntryGetId(HistoryEntry object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _historyEntryGetLinks(HistoryEntry object) {
  return [];
}

void _historyEntryAttach(
    IsarCollection<dynamic> col, Id id, HistoryEntry object) {
  object.id = id;
}

extension HistoryEntryQueryWhereSort
    on QueryBuilder<HistoryEntry, HistoryEntry, QWhere> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HistoryEntryQueryWhere
    on QueryBuilder<HistoryEntry, HistoryEntry, QWhereClause> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterWhereClause> idBetween(
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

extension HistoryEntryQueryFilter
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      alarmIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'alarmId',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      alarmIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'alarmId',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      alarmIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'alarmId',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      alarmIdGreaterThan(
    int? value, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      alarmIdLessThan(
    int? value, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      alarmIdBetween(
    int? lower,
    int? upper, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLatitudeEqualTo(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLatitudeGreaterThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLatitudeLessThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLatitudeBetween(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLongitudeEqualTo(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLongitudeGreaterThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLongitudeLessThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destLongitudeBetween(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameEqualTo(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameGreaterThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameLessThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameBetween(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameStartsWith(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameEndsWith(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'destinationName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'destinationName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'destinationName',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      destinationNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'destinationName',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      occurredAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      occurredAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occurredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      occurredAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occurredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      occurredAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occurredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      snoozeCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snoozeCount',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      snoozeCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snoozeCount',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      snoozeCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snoozeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      snoozeCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snoozeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      snoozeCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snoozeCount',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      snoozeCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snoozeCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      triggerDistanceMetersIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggerDistanceMeters',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      triggerDistanceMetersIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggerDistanceMeters',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      triggerDistanceMetersEqualTo(
    double? value, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      triggerDistanceMetersGreaterThan(
    double? value, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      triggerDistanceMetersLessThan(
    double? value, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      triggerDistanceMetersBetween(
    double? lower,
    double? upper, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      tripIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'tripId',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      tripIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'tripId',
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> tripIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'tripId',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      tripIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'tripId',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      tripIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'tripId',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> tripIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'tripId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> typeEqualTo(
      HistoryType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition>
      typeGreaterThan(
    HistoryType value, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> typeLessThan(
    HistoryType value, {
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

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterFilterCondition> typeBetween(
    HistoryType lower,
    HistoryType upper, {
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
}

extension HistoryEntryQueryObject
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {}

extension HistoryEntryQueryLinks
    on QueryBuilder<HistoryEntry, HistoryEntry, QFilterCondition> {}

extension HistoryEntryQuerySortBy
    on QueryBuilder<HistoryEntry, HistoryEntry, QSortBy> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByAlarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByAlarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDestLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDestLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDestinationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByDestinationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortBySnoozeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeCount', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortBySnoozeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeCount', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      sortByTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension HistoryEntryQuerySortThenBy
    on QueryBuilder<HistoryEntry, HistoryEntry, QSortThenBy> {
  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByAlarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByAlarmIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'alarmId', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDestLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLatitude', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDestLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destLongitude', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDestinationName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByDestinationNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'destinationName', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByOccurredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurredAt', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenBySnoozeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeCount', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenBySnoozeCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozeCount', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy>
      thenByTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'tripId', Sort.desc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension HistoryEntryQueryWhereDistinct
    on QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> {
  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByAlarmId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'alarmId');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByDestLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destLatitude');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct>
      distinctByDestLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destLongitude');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByDestinationName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'destinationName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByOccurredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurredAt');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctBySnoozeCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoozeCount');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct>
      distinctByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerDistanceMeters');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'tripId');
    });
  }

  QueryBuilder<HistoryEntry, HistoryEntry, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension HistoryEntryQueryProperty
    on QueryBuilder<HistoryEntry, HistoryEntry, QQueryProperty> {
  QueryBuilder<HistoryEntry, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HistoryEntry, int?, QQueryOperations> alarmIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'alarmId');
    });
  }

  QueryBuilder<HistoryEntry, double, QQueryOperations> destLatitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destLatitude');
    });
  }

  QueryBuilder<HistoryEntry, double, QQueryOperations> destLongitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destLongitude');
    });
  }

  QueryBuilder<HistoryEntry, String, QQueryOperations>
      destinationNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'destinationName');
    });
  }

  QueryBuilder<HistoryEntry, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<HistoryEntry, DateTime, QQueryOperations> occurredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurredAt');
    });
  }

  QueryBuilder<HistoryEntry, int?, QQueryOperations> snoozeCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoozeCount');
    });
  }

  QueryBuilder<HistoryEntry, double?, QQueryOperations>
      triggerDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerDistanceMeters');
    });
  }

  QueryBuilder<HistoryEntry, int?, QQueryOperations> tripIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'tripId');
    });
  }

  QueryBuilder<HistoryEntry, HistoryType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
