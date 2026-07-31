// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFavoriteCollection on Isar {
  IsarCollection<Favorite> get favorites => this.collection();
}

const FavoriteSchema = CollectionSchema(
  name: r'Favorite',
  id: 5577971995748139032,
  properties: {
    r'address': PropertySchema(
      id: 0,
      name: r'address',
      type: IsarType.string,
    ),
    r'autoStartedCount': PropertySchema(
      id: 1,
      name: r'autoStartedCount',
      type: IsarType.long,
    ),
    r'category': PropertySchema(
      id: 2,
      name: r'category',
      type: IsarType.byte,
      enumMap: _FavoritecategoryEnumValueMap,
    ),
    r'createdAt': PropertySchema(
      id: 3,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'falsePredictionCount': PropertySchema(
      id: 4,
      name: r'falsePredictionCount',
      type: IsarType.long,
    ),
    r'icon': PropertySchema(
      id: 5,
      name: r'icon',
      type: IsarType.string,
    ),
    r'isFavorite': PropertySchema(
      id: 6,
      name: r'isFavorite',
      type: IsarType.bool,
    ),
    r'lastAutoCreatedAt': PropertySchema(
      id: 7,
      name: r'lastAutoCreatedAt',
      type: IsarType.dateTime,
    ),
    r'lastDismissedAt': PropertySchema(
      id: 8,
      name: r'lastDismissedAt',
      type: IsarType.dateTime,
    ),
    r'lastUsedAt': PropertySchema(
      id: 9,
      name: r'lastUsedAt',
      type: IsarType.dateTime,
    ),
    r'latitude': PropertySchema(
      id: 10,
      name: r'latitude',
      type: IsarType.double,
    ),
    r'linkedTripId': PropertySchema(
      id: 11,
      name: r'linkedTripId',
      type: IsarType.long,
    ),
    r'longitude': PropertySchema(
      id: 12,
      name: r'longitude',
      type: IsarType.double,
    ),
    r'name': PropertySchema(
      id: 13,
      name: r'name',
      type: IsarType.string,
    ),
    r'predictionAccuracy': PropertySchema(
      id: 14,
      name: r'predictionAccuracy',
      type: IsarType.double,
    ),
    r'priority': PropertySchema(
      id: 15,
      name: r'priority',
      type: IsarType.long,
    ),
    r'providerPlaceId': PropertySchema(
      id: 16,
      name: r'providerPlaceId',
      type: IsarType.string,
    ),
    r'routePolyline': PropertySchema(
      id: 17,
      name: r'routePolyline',
      type: IsarType.string,
    ),
    r'smartAlarmMode': PropertySchema(
      id: 18,
      name: r'smartAlarmMode',
      type: IsarType.byte,
      enumMap: _FavoritesmartAlarmModeEnumValueMap,
    ),
    r'sortOrder': PropertySchema(
      id: 19,
      name: r'sortOrder',
      type: IsarType.long,
    ),
    r'triggerDistanceMeters': PropertySchema(
      id: 20,
      name: r'triggerDistanceMeters',
      type: IsarType.double,
    )
  },
  estimateSize: _favoriteEstimateSize,
  serialize: _favoriteSerialize,
  deserialize: _favoriteDeserialize,
  deserializeProp: _favoriteDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _favoriteGetId,
  getLinks: _favoriteGetLinks,
  attach: _favoriteAttach,
  version: '3.1.0+1',
);

int _favoriteEstimateSize(
  Favorite object,
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
  {
    final value = object.icon;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.name.length * 3;
  {
    final value = object.providerPlaceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.routePolyline;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _favoriteSerialize(
  Favorite object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.address);
  writer.writeLong(offsets[1], object.autoStartedCount);
  writer.writeByte(offsets[2], object.category.index);
  writer.writeDateTime(offsets[3], object.createdAt);
  writer.writeLong(offsets[4], object.falsePredictionCount);
  writer.writeString(offsets[5], object.icon);
  writer.writeBool(offsets[6], object.isFavorite);
  writer.writeDateTime(offsets[7], object.lastAutoCreatedAt);
  writer.writeDateTime(offsets[8], object.lastDismissedAt);
  writer.writeDateTime(offsets[9], object.lastUsedAt);
  writer.writeDouble(offsets[10], object.latitude);
  writer.writeLong(offsets[11], object.linkedTripId);
  writer.writeDouble(offsets[12], object.longitude);
  writer.writeString(offsets[13], object.name);
  writer.writeDouble(offsets[14], object.predictionAccuracy);
  writer.writeLong(offsets[15], object.priority);
  writer.writeString(offsets[16], object.providerPlaceId);
  writer.writeString(offsets[17], object.routePolyline);
  writer.writeByte(offsets[18], object.smartAlarmMode.index);
  writer.writeLong(offsets[19], object.sortOrder);
  writer.writeDouble(offsets[20], object.triggerDistanceMeters);
}

Favorite _favoriteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Favorite();
  object.address = reader.readStringOrNull(offsets[0]);
  object.autoStartedCount = reader.readLong(offsets[1]);
  object.category =
      _FavoritecategoryValueEnumMap[reader.readByteOrNull(offsets[2])] ??
          FavoriteCategory.home;
  object.createdAt = reader.readDateTime(offsets[3]);
  object.falsePredictionCount = reader.readLong(offsets[4]);
  object.icon = reader.readStringOrNull(offsets[5]);
  object.id = id;
  object.isFavorite = reader.readBool(offsets[6]);
  object.lastAutoCreatedAt = reader.readDateTimeOrNull(offsets[7]);
  object.lastDismissedAt = reader.readDateTimeOrNull(offsets[8]);
  object.lastUsedAt = reader.readDateTimeOrNull(offsets[9]);
  object.latitude = reader.readDouble(offsets[10]);
  object.linkedTripId = reader.readLongOrNull(offsets[11]);
  object.longitude = reader.readDouble(offsets[12]);
  object.name = reader.readString(offsets[13]);
  object.predictionAccuracy = reader.readDouble(offsets[14]);
  object.priority = reader.readLong(offsets[15]);
  object.providerPlaceId = reader.readStringOrNull(offsets[16]);
  object.routePolyline = reader.readStringOrNull(offsets[17]);
  object.smartAlarmMode =
      _FavoritesmartAlarmModeValueEnumMap[reader.readByteOrNull(offsets[18])] ??
          SmartAlarmMode.off;
  object.sortOrder = reader.readLong(offsets[19]);
  object.triggerDistanceMeters = reader.readDouble(offsets[20]);
  return object;
}

P _favoriteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (_FavoritecategoryValueEnumMap[reader.readByteOrNull(offset)] ??
          FavoriteCategory.home) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 8:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 9:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readLong(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readStringOrNull(offset)) as P;
    case 18:
      return (_FavoritesmartAlarmModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SmartAlarmMode.off) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _FavoritecategoryEnumValueMap = {
  'home': 0,
  'office': 1,
  'college': 2,
  'gym': 3,
  'airport': 4,
  'hotel': 5,
  'custom': 6,
  'trip': 7,
  'school': 8,
  'station': 9,
  'busStop': 10,
  'metro': 11,
  'hospital': 12,
};
const _FavoritecategoryValueEnumMap = {
  0: FavoriteCategory.home,
  1: FavoriteCategory.office,
  2: FavoriteCategory.college,
  3: FavoriteCategory.gym,
  4: FavoriteCategory.airport,
  5: FavoriteCategory.hotel,
  6: FavoriteCategory.custom,
  7: FavoriteCategory.trip,
  8: FavoriteCategory.school,
  9: FavoriteCategory.station,
  10: FavoriteCategory.busStop,
  11: FavoriteCategory.metro,
  12: FavoriteCategory.hospital,
};
const _FavoritesmartAlarmModeEnumValueMap = {
  'off': 0,
  'suggest': 1,
  'automatic': 2,
};
const _FavoritesmartAlarmModeValueEnumMap = {
  0: SmartAlarmMode.off,
  1: SmartAlarmMode.suggest,
  2: SmartAlarmMode.automatic,
};

Id _favoriteGetId(Favorite object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _favoriteGetLinks(Favorite object) {
  return [];
}

void _favoriteAttach(IsarCollection<dynamic> col, Id id, Favorite object) {
  object.id = id;
}

extension FavoriteQueryWhereSort on QueryBuilder<Favorite, Favorite, QWhere> {
  QueryBuilder<Favorite, Favorite, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FavoriteQueryWhere on QueryBuilder<Favorite, Favorite, QWhereClause> {
  QueryBuilder<Favorite, Favorite, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Favorite, Favorite, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterWhereClause> idBetween(
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

extension FavoriteQueryFilter
    on QueryBuilder<Favorite, Favorite, QFilterCondition> {
  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'address',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressEqualTo(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressGreaterThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressLessThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressBetween(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressStartsWith(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressEndsWith(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressContains(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressMatches(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> addressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'address',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      autoStartedCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'autoStartedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      autoStartedCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'autoStartedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      autoStartedCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'autoStartedCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      autoStartedCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'autoStartedCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> categoryEqualTo(
      FavoriteCategory value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> categoryGreaterThan(
    FavoriteCategory value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> categoryLessThan(
    FavoriteCategory value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> categoryBetween(
    FavoriteCategory lower,
    FavoriteCategory upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> createdAtGreaterThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      falsePredictionCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'falsePredictionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      falsePredictionCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'falsePredictionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      falsePredictionCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'falsePredictionCount',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      falsePredictionCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'falsePredictionCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'icon',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'icon',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'icon',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'icon',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> iconIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'icon',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> isFavoriteEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isFavorite',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastAutoCreatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastAutoCreatedAt',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastAutoCreatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastAutoCreatedAt',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastAutoCreatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastAutoCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastAutoCreatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastAutoCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastAutoCreatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastAutoCreatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastAutoCreatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastAutoCreatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastDismissedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastDismissedAt',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastDismissedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastDismissedAt',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastDismissedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastDismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastDismissedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastDismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastDismissedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastDismissedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastDismissedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastDismissedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> lastUsedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastUsedAt',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      lastUsedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastUsedAt',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> lastUsedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastUsedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> lastUsedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastUsedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> lastUsedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastUsedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> lastUsedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastUsedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> latitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> latitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> latitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'latitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> latitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'latitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> linkedTripIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'linkedTripId',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      linkedTripIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'linkedTripId',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> linkedTripIdEqualTo(
      int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'linkedTripId',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      linkedTripIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'linkedTripId',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> linkedTripIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'linkedTripId',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> linkedTripIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'linkedTripId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> longitudeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> longitudeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> longitudeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'longitude',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> longitudeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'longitude',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameStartsWith(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      predictionAccuracyEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'predictionAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      predictionAccuracyGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'predictionAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      predictionAccuracyLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'predictionAccuracy',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      predictionAccuracyBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'predictionAccuracy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> priorityEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> priorityGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> priorityLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'priority',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> priorityBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'priority',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'providerPlaceId',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'providerPlaceId',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerPlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'providerPlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'providerPlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'providerPlaceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'providerPlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'providerPlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'providerPlaceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'providerPlaceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'providerPlaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      providerPlaceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'providerPlaceId',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      routePolylineIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'routePolyline',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      routePolylineIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'routePolyline',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> routePolylineEqualTo(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      routePolylineGreaterThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> routePolylineLessThan(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> routePolylineBetween(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      routePolylineStartsWith(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> routePolylineEndsWith(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> routePolylineContains(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> routePolylineMatches(
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      routePolylineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routePolyline',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      routePolylineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'routePolyline',
        value: '',
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> smartAlarmModeEqualTo(
      SmartAlarmMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'smartAlarmMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      smartAlarmModeGreaterThan(
    SmartAlarmMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'smartAlarmMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
      smartAlarmModeLessThan(
    SmartAlarmMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'smartAlarmMode',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> smartAlarmModeBetween(
    SmartAlarmMode lower,
    SmartAlarmMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'smartAlarmMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> sortOrderEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> sortOrderGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> sortOrderLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sortOrder',
        value: value,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition> sortOrderBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sortOrder',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
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

  QueryBuilder<Favorite, Favorite, QAfterFilterCondition>
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
}

extension FavoriteQueryObject
    on QueryBuilder<Favorite, Favorite, QFilterCondition> {}

extension FavoriteQueryLinks
    on QueryBuilder<Favorite, Favorite, QFilterCondition> {}

extension FavoriteQuerySortBy on QueryBuilder<Favorite, Favorite, QSortBy> {
  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByAutoStartedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartedCount', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByAutoStartedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartedCount', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByFalsePredictionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falsePredictionCount', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy>
      sortByFalsePredictionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falsePredictionCount', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLastAutoCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoCreatedAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLastAutoCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoCreatedAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLastDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDismissedAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLastDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDismissedAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLastUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLinkedTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTripId', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLinkedTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTripId', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByPredictionAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionAccuracy', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy>
      sortByPredictionAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionAccuracy', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByProviderPlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPlaceId', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByProviderPlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPlaceId', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByRoutePolyline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByRoutePolylineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortBySmartAlarmMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartAlarmMode', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortBySmartAlarmModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartAlarmMode', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> sortByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy>
      sortByTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.desc);
    });
  }
}

extension FavoriteQuerySortThenBy
    on QueryBuilder<Favorite, Favorite, QSortThenBy> {
  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByAddress() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByAddressDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'address', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByAutoStartedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartedCount', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByAutoStartedCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'autoStartedCount', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByFalsePredictionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falsePredictionCount', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy>
      thenByFalsePredictionCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'falsePredictionCount', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByIcon() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByIconDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'icon', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByIsFavoriteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isFavorite', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLastAutoCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoCreatedAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLastAutoCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastAutoCreatedAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLastDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDismissedAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLastDismissedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastDismissedAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLastUsedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUsedAt', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLatitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'latitude', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLinkedTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTripId', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLinkedTripIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'linkedTripId', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByLongitudeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'longitude', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByPredictionAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionAccuracy', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy>
      thenByPredictionAccuracyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'predictionAccuracy', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByPriorityDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'priority', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByProviderPlaceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPlaceId', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByProviderPlaceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'providerPlaceId', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByRoutePolyline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByRoutePolylineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routePolyline', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenBySmartAlarmMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartAlarmMode', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenBySmartAlarmModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'smartAlarmMode', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenBySortOrderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sortOrder', Sort.desc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy> thenByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<Favorite, Favorite, QAfterSortBy>
      thenByTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggerDistanceMeters', Sort.desc);
    });
  }
}

extension FavoriteQueryWhereDistinct
    on QueryBuilder<Favorite, Favorite, QDistinct> {
  QueryBuilder<Favorite, Favorite, QDistinct> distinctByAddress(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'address', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByAutoStartedCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'autoStartedCount');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByFalsePredictionCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'falsePredictionCount');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByIcon(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'icon', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByIsFavorite() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isFavorite');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByLastAutoCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastAutoCreatedAt');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByLastDismissedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastDismissedAt');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByLastUsedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUsedAt');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByLatitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'latitude');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByLinkedTripId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'linkedTripId');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByLongitude() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'longitude');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByPredictionAccuracy() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'predictionAccuracy');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByPriority() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'priority');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByProviderPlaceId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'providerPlaceId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctByRoutePolyline(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routePolyline',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctBySmartAlarmMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'smartAlarmMode');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct> distinctBySortOrder() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sortOrder');
    });
  }

  QueryBuilder<Favorite, Favorite, QDistinct>
      distinctByTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggerDistanceMeters');
    });
  }
}

extension FavoriteQueryProperty
    on QueryBuilder<Favorite, Favorite, QQueryProperty> {
  QueryBuilder<Favorite, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Favorite, String?, QQueryOperations> addressProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'address');
    });
  }

  QueryBuilder<Favorite, int, QQueryOperations> autoStartedCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'autoStartedCount');
    });
  }

  QueryBuilder<Favorite, FavoriteCategory, QQueryOperations>
      categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<Favorite, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Favorite, int, QQueryOperations> falsePredictionCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'falsePredictionCount');
    });
  }

  QueryBuilder<Favorite, String?, QQueryOperations> iconProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'icon');
    });
  }

  QueryBuilder<Favorite, bool, QQueryOperations> isFavoriteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isFavorite');
    });
  }

  QueryBuilder<Favorite, DateTime?, QQueryOperations>
      lastAutoCreatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastAutoCreatedAt');
    });
  }

  QueryBuilder<Favorite, DateTime?, QQueryOperations>
      lastDismissedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastDismissedAt');
    });
  }

  QueryBuilder<Favorite, DateTime?, QQueryOperations> lastUsedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUsedAt');
    });
  }

  QueryBuilder<Favorite, double, QQueryOperations> latitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'latitude');
    });
  }

  QueryBuilder<Favorite, int?, QQueryOperations> linkedTripIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'linkedTripId');
    });
  }

  QueryBuilder<Favorite, double, QQueryOperations> longitudeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'longitude');
    });
  }

  QueryBuilder<Favorite, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<Favorite, double, QQueryOperations>
      predictionAccuracyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'predictionAccuracy');
    });
  }

  QueryBuilder<Favorite, int, QQueryOperations> priorityProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'priority');
    });
  }

  QueryBuilder<Favorite, String?, QQueryOperations> providerPlaceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'providerPlaceId');
    });
  }

  QueryBuilder<Favorite, String?, QQueryOperations> routePolylineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routePolyline');
    });
  }

  QueryBuilder<Favorite, SmartAlarmMode, QQueryOperations>
      smartAlarmModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'smartAlarmMode');
    });
  }

  QueryBuilder<Favorite, int, QQueryOperations> sortOrderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sortOrder');
    });
  }

  QueryBuilder<Favorite, double, QQueryOperations>
      triggerDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggerDistanceMeters');
    });
  }
}
