// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppSettingsCollection on Isar {
  IsarCollection<AppSettings> get appSettings => this.collection();
}

const AppSettingsSchema = CollectionSchema(
  name: r'AppSettings',
  id: -5633561779022347008,
  properties: {
    r'accentColor': PropertySchema(
      id: 0,
      name: r'accentColor',
      type: IsarType.string,
    ),
    r'accessibilityHighContrast': PropertySchema(
      id: 1,
      name: r'accessibilityHighContrast',
      type: IsarType.bool,
    ),
    r'batteryProfile': PropertySchema(
      id: 2,
      name: r'batteryProfile',
      type: IsarType.byte,
      enumMap: _AppSettingsbatteryProfileEnumValueMap,
    ),
    r'debugLoggingEnabled': PropertySchema(
      id: 3,
      name: r'debugLoggingEnabled',
      type: IsarType.bool,
    ),
    r'defaultFlashlightEnabled': PropertySchema(
      id: 4,
      name: r'defaultFlashlightEnabled',
      type: IsarType.bool,
    ),
    r'defaultTriggerDistanceMeters': PropertySchema(
      id: 5,
      name: r'defaultTriggerDistanceMeters',
      type: IsarType.double,
    ),
    r'defaultVibrationEnabled': PropertySchema(
      id: 6,
      name: r'defaultVibrationEnabled',
      type: IsarType.bool,
    ),
    r'defaultVoiceEnabled': PropertySchema(
      id: 7,
      name: r'defaultVoiceEnabled',
      type: IsarType.bool,
    ),
    r'fontFamily': PropertySchema(
      id: 8,
      name: r'fontFamily',
      type: IsarType.string,
    ),
    r'hasCompletedPermissions': PropertySchema(
      id: 9,
      name: r'hasCompletedPermissions',
      type: IsarType.bool,
    ),
    r'hasCompletedWelcome': PropertySchema(
      id: 10,
      name: r'hasCompletedWelcome',
      type: IsarType.bool,
    ),
    r'languageCode': PropertySchema(
      id: 11,
      name: r'languageCode',
      type: IsarType.string,
    ),
    r'lockScreenInfoEnabled': PropertySchema(
      id: 12,
      name: r'lockScreenInfoEnabled',
      type: IsarType.bool,
    ),
    r'mapLayer': PropertySchema(
      id: 13,
      name: r'mapLayer',
      type: IsarType.byte,
      enumMap: _AppSettingsmapLayerEnumValueMap,
    ),
    r'mapProvider': PropertySchema(
      id: 14,
      name: r'mapProvider',
      type: IsarType.byte,
      enumMap: _AppSettingsmapProviderEnumValueMap,
    ),
    r'overrideRouteProvider': PropertySchema(
      id: 15,
      name: r'overrideRouteProvider',
      type: IsarType.bool,
    ),
    r'overrideSearchProvider': PropertySchema(
      id: 16,
      name: r'overrideSearchProvider',
      type: IsarType.bool,
    ),
    r'persistentNotificationEnabled': PropertySchema(
      id: 17,
      name: r'persistentNotificationEnabled',
      type: IsarType.bool,
    ),
    r'resumeAlarmAfterBoot': PropertySchema(
      id: 18,
      name: r'resumeAlarmAfterBoot',
      type: IsarType.bool,
    ),
    r'routeProvider': PropertySchema(
      id: 19,
      name: r'routeProvider',
      type: IsarType.byte,
      enumMap: _AppSettingsrouteProviderEnumValueMap,
    ),
    r'searchProvider': PropertySchema(
      id: 20,
      name: r'searchProvider',
      type: IsarType.byte,
      enumMap: _AppSettingssearchProviderEnumValueMap,
    ),
    r'themeMode': PropertySchema(
      id: 21,
      name: r'themeMode',
      type: IsarType.byte,
      enumMap: _AppSettingsthemeModeEnumValueMap,
    ),
    r'useMetric': PropertySchema(
      id: 22,
      name: r'useMetric',
      type: IsarType.bool,
    ),
    r'useRecommendedProviders': PropertySchema(
      id: 23,
      name: r'useRecommendedProviders',
      type: IsarType.bool,
    )
  },
  estimateSize: _appSettingsEstimateSize,
  serialize: _appSettingsSerialize,
  deserialize: _appSettingsDeserialize,
  deserializeProp: _appSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _appSettingsGetId,
  getLinks: _appSettingsGetLinks,
  attach: _appSettingsAttach,
  version: '3.1.0+1',
);

int _appSettingsEstimateSize(
  AppSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accentColor.length * 3;
  bytesCount += 3 + object.fontFamily.length * 3;
  bytesCount += 3 + object.languageCode.length * 3;
  return bytesCount;
}

void _appSettingsSerialize(
  AppSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accentColor);
  writer.writeBool(offsets[1], object.accessibilityHighContrast);
  writer.writeByte(offsets[2], object.batteryProfile.index);
  writer.writeBool(offsets[3], object.debugLoggingEnabled);
  writer.writeBool(offsets[4], object.defaultFlashlightEnabled);
  writer.writeDouble(offsets[5], object.defaultTriggerDistanceMeters);
  writer.writeBool(offsets[6], object.defaultVibrationEnabled);
  writer.writeBool(offsets[7], object.defaultVoiceEnabled);
  writer.writeString(offsets[8], object.fontFamily);
  writer.writeBool(offsets[9], object.hasCompletedPermissions);
  writer.writeBool(offsets[10], object.hasCompletedWelcome);
  writer.writeString(offsets[11], object.languageCode);
  writer.writeBool(offsets[12], object.lockScreenInfoEnabled);
  writer.writeByte(offsets[13], object.mapLayer.index);
  writer.writeByte(offsets[14], object.mapProvider.index);
  writer.writeBool(offsets[15], object.overrideRouteProvider);
  writer.writeBool(offsets[16], object.overrideSearchProvider);
  writer.writeBool(offsets[17], object.persistentNotificationEnabled);
  writer.writeBool(offsets[18], object.resumeAlarmAfterBoot);
  writer.writeByte(offsets[19], object.routeProvider.index);
  writer.writeByte(offsets[20], object.searchProvider.index);
  writer.writeByte(offsets[21], object.themeMode.index);
  writer.writeBool(offsets[22], object.useMetric);
  writer.writeBool(offsets[23], object.useRecommendedProviders);
}

AppSettings _appSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppSettings();
  object.accentColor = reader.readString(offsets[0]);
  object.accessibilityHighContrast = reader.readBool(offsets[1]);
  object.batteryProfile = _AppSettingsbatteryProfileValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      BatteryProfile.balanced;
  object.debugLoggingEnabled = reader.readBool(offsets[3]);
  object.defaultFlashlightEnabled = reader.readBool(offsets[4]);
  object.defaultTriggerDistanceMeters = reader.readDouble(offsets[5]);
  object.defaultVibrationEnabled = reader.readBool(offsets[6]);
  object.defaultVoiceEnabled = reader.readBool(offsets[7]);
  object.fontFamily = reader.readString(offsets[8]);
  object.hasCompletedPermissions = reader.readBool(offsets[9]);
  object.hasCompletedWelcome = reader.readBool(offsets[10]);
  object.id = id;
  object.languageCode = reader.readString(offsets[11]);
  object.lockScreenInfoEnabled = reader.readBool(offsets[12]);
  object.mapLayer =
      _AppSettingsmapLayerValueEnumMap[reader.readByteOrNull(offsets[13])] ??
          MapLayerType.standard;
  object.mapProvider =
      _AppSettingsmapProviderValueEnumMap[reader.readByteOrNull(offsets[14])] ??
          MapProviderType.osm;
  object.overrideRouteProvider = reader.readBool(offsets[15]);
  object.overrideSearchProvider = reader.readBool(offsets[16]);
  object.persistentNotificationEnabled = reader.readBool(offsets[17]);
  object.resumeAlarmAfterBoot = reader.readBool(offsets[18]);
  object.routeProvider = _AppSettingsrouteProviderValueEnumMap[
          reader.readByteOrNull(offsets[19])] ??
      RouteProviderType.osrm;
  object.searchProvider = _AppSettingssearchProviderValueEnumMap[
          reader.readByteOrNull(offsets[20])] ??
      SearchProviderType.nominatim;
  object.themeMode =
      _AppSettingsthemeModeValueEnumMap[reader.readByteOrNull(offsets[21])] ??
          AppThemeMode.system;
  object.useMetric = reader.readBool(offsets[22]);
  object.useRecommendedProviders = reader.readBool(offsets[23]);
  return object;
}

P _appSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (_AppSettingsbatteryProfileValueEnumMap[
              reader.readByteOrNull(offset)] ??
          BatteryProfile.balanced) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (_AppSettingsmapLayerValueEnumMap[reader.readByteOrNull(offset)] ??
          MapLayerType.standard) as P;
    case 14:
      return (_AppSettingsmapProviderValueEnumMap[
              reader.readByteOrNull(offset)] ??
          MapProviderType.osm) as P;
    case 15:
      return (reader.readBool(offset)) as P;
    case 16:
      return (reader.readBool(offset)) as P;
    case 17:
      return (reader.readBool(offset)) as P;
    case 18:
      return (reader.readBool(offset)) as P;
    case 19:
      return (_AppSettingsrouteProviderValueEnumMap[
              reader.readByteOrNull(offset)] ??
          RouteProviderType.osrm) as P;
    case 20:
      return (_AppSettingssearchProviderValueEnumMap[
              reader.readByteOrNull(offset)] ??
          SearchProviderType.nominatim) as P;
    case 21:
      return (_AppSettingsthemeModeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          AppThemeMode.system) as P;
    case 22:
      return (reader.readBool(offset)) as P;
    case 23:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _AppSettingsbatteryProfileEnumValueMap = {
  'balanced': 0,
  'aggressive': 1,
  'saver': 2,
};
const _AppSettingsbatteryProfileValueEnumMap = {
  0: BatteryProfile.balanced,
  1: BatteryProfile.aggressive,
  2: BatteryProfile.saver,
};
const _AppSettingsmapLayerEnumValueMap = {
  'standard': 0,
  'satellite': 1,
  'dark': 2,
  'terrain': 3,
};
const _AppSettingsmapLayerValueEnumMap = {
  0: MapLayerType.standard,
  1: MapLayerType.satellite,
  2: MapLayerType.dark,
  3: MapLayerType.terrain,
};
const _AppSettingsmapProviderEnumValueMap = {
  'osm': 0,
  'google': 1,
  'mapbox': 2,
  'here': 3,
  'apple': 4,
};
const _AppSettingsmapProviderValueEnumMap = {
  0: MapProviderType.osm,
  1: MapProviderType.google,
  2: MapProviderType.mapbox,
  3: MapProviderType.here,
  4: MapProviderType.apple,
};
const _AppSettingsrouteProviderEnumValueMap = {
  'osrm': 0,
  'googleDirections': 1,
  'graphHopper': 2,
  'valhalla': 3,
};
const _AppSettingsrouteProviderValueEnumMap = {
  0: RouteProviderType.osrm,
  1: RouteProviderType.googleDirections,
  2: RouteProviderType.graphHopper,
  3: RouteProviderType.valhalla,
};
const _AppSettingssearchProviderEnumValueMap = {
  'nominatim': 0,
  'googlePlaces': 1,
  'photon': 2,
  'pelias': 3,
  'here': 4,
};
const _AppSettingssearchProviderValueEnumMap = {
  0: SearchProviderType.nominatim,
  1: SearchProviderType.googlePlaces,
  2: SearchProviderType.photon,
  3: SearchProviderType.pelias,
  4: SearchProviderType.here,
};
const _AppSettingsthemeModeEnumValueMap = {
  'system': 0,
  'light': 1,
  'dark': 2,
};
const _AppSettingsthemeModeValueEnumMap = {
  0: AppThemeMode.system,
  1: AppThemeMode.light,
  2: AppThemeMode.dark,
};

Id _appSettingsGetId(AppSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _appSettingsGetLinks(AppSettings object) {
  return [];
}

void _appSettingsAttach(
    IsarCollection<dynamic> col, Id id, AppSettings object) {
  object.id = id;
}

extension AppSettingsQueryWhereSort
    on QueryBuilder<AppSettings, AppSettings, QWhere> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppSettingsQueryWhere
    on QueryBuilder<AppSettings, AppSettings, QWhereClause> {
  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterWhereClause> idBetween(
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

extension AppSettingsQueryFilter
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {
  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accentColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accentColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accentColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accentColor',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accentColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accentColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accentColor',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accentColor',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accentColor',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accentColorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accentColor',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      accessibilityHighContrastEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessibilityHighContrast',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      batteryProfileEqualTo(BatteryProfile value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'batteryProfile',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      batteryProfileGreaterThan(
    BatteryProfile value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'batteryProfile',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      batteryProfileLessThan(
    BatteryProfile value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'batteryProfile',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      batteryProfileBetween(
    BatteryProfile lower,
    BatteryProfile upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'batteryProfile',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      debugLoggingEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'debugLoggingEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      defaultFlashlightEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultFlashlightEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      defaultTriggerDistanceMetersEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultTriggerDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      defaultTriggerDistanceMetersGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'defaultTriggerDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      defaultTriggerDistanceMetersLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'defaultTriggerDistanceMeters',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      defaultTriggerDistanceMetersBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'defaultTriggerDistanceMeters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      defaultVibrationEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultVibrationEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      defaultVoiceEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'defaultVoiceEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontFamily',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fontFamily',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fontFamily',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      fontFamilyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fontFamily',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      hasCompletedPermissionsEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasCompletedPermissions',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      hasCompletedWelcomeEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hasCompletedWelcome',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> idBetween(
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

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'languageCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'languageCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'languageCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      languageCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'languageCode',
        value: '',
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      lockScreenInfoEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lockScreenInfoEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> mapLayerEqualTo(
      MapLayerType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mapLayer',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      mapLayerGreaterThan(
    MapLayerType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mapLayer',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      mapLayerLessThan(
    MapLayerType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mapLayer',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition> mapLayerBetween(
    MapLayerType lower,
    MapLayerType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mapLayer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      mapProviderEqualTo(MapProviderType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mapProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      mapProviderGreaterThan(
    MapProviderType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mapProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      mapProviderLessThan(
    MapProviderType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mapProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      mapProviderBetween(
    MapProviderType lower,
    MapProviderType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mapProvider',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      overrideRouteProviderEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overrideRouteProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      overrideSearchProviderEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'overrideSearchProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      persistentNotificationEnabledEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'persistentNotificationEnabled',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      resumeAlarmAfterBootEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resumeAlarmAfterBoot',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      routeProviderEqualTo(RouteProviderType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'routeProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      routeProviderGreaterThan(
    RouteProviderType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'routeProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      routeProviderLessThan(
    RouteProviderType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'routeProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      routeProviderBetween(
    RouteProviderType lower,
    RouteProviderType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'routeProvider',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      searchProviderEqualTo(SearchProviderType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'searchProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      searchProviderGreaterThan(
    SearchProviderType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'searchProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      searchProviderLessThan(
    SearchProviderType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'searchProvider',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      searchProviderBetween(
    SearchProviderType lower,
    SearchProviderType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'searchProvider',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      themeModeEqualTo(AppThemeMode value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'themeMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      themeModeGreaterThan(
    AppThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'themeMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      themeModeLessThan(
    AppThemeMode value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'themeMode',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      themeModeBetween(
    AppThemeMode lower,
    AppThemeMode upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'themeMode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      useMetricEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useMetric',
        value: value,
      ));
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterFilterCondition>
      useRecommendedProvidersEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'useRecommendedProviders',
        value: value,
      ));
    });
  }
}

extension AppSettingsQueryObject
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQueryLinks
    on QueryBuilder<AppSettings, AppSettings, QFilterCondition> {}

extension AppSettingsQuerySortBy
    on QueryBuilder<AppSettings, AppSettings, QSortBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByAccentColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByAccentColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByAccessibilityHighContrast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessibilityHighContrast', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByAccessibilityHighContrastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessibilityHighContrast', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByBatteryProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryProfile', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByBatteryProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryProfile', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDebugLoggingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugLoggingEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDebugLoggingEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugLoggingEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultFlashlightEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFlashlightEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultFlashlightEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFlashlightEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTriggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTriggerDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVibrationEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultVibrationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVibrationEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVoiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByDefaultVoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVoiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByHasCompletedPermissions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedPermissions', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByHasCompletedPermissionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedPermissions', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByHasCompletedWelcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedWelcome', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByHasCompletedWelcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedWelcome', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLockScreenInfoEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockScreenInfoEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByLockScreenInfoEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockScreenInfoEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByMapLayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapLayer', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByMapLayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapLayer', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByMapProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByMapProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByOverrideRouteProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideRouteProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByOverrideRouteProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideRouteProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByOverrideSearchProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideSearchProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByOverrideSearchProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideSearchProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByPersistentNotificationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistentNotificationEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByPersistentNotificationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistentNotificationEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByResumeAlarmAfterBoot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeAlarmAfterBoot', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByResumeAlarmAfterBootDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeAlarmAfterBoot', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByRouteProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routeProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByRouteProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routeProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortBySearchProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortBySearchProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByUseMetric() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMetric', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> sortByUseMetricDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMetric', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByUseRecommendedProviders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useRecommendedProviders', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      sortByUseRecommendedProvidersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useRecommendedProviders', Sort.desc);
    });
  }
}

extension AppSettingsQuerySortThenBy
    on QueryBuilder<AppSettings, AppSettings, QSortThenBy> {
  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByAccentColor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByAccentColorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accentColor', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByAccessibilityHighContrast() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessibilityHighContrast', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByAccessibilityHighContrastDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessibilityHighContrast', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByBatteryProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryProfile', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByBatteryProfileDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'batteryProfile', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDebugLoggingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugLoggingEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDebugLoggingEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'debugLoggingEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultFlashlightEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFlashlightEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultFlashlightEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultFlashlightEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTriggerDistanceMeters', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultTriggerDistanceMetersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultTriggerDistanceMeters', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVibrationEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultVibrationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVibrationEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVoiceEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByDefaultVoiceEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'defaultVoiceEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByFontFamily() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByFontFamilyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fontFamily', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByHasCompletedPermissions() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedPermissions', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByHasCompletedPermissionsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedPermissions', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByHasCompletedWelcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedWelcome', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByHasCompletedWelcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hasCompletedWelcome', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByLanguageCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLanguageCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'languageCode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLockScreenInfoEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockScreenInfoEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByLockScreenInfoEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lockScreenInfoEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByMapLayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapLayer', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByMapLayerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapLayer', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByMapProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByMapProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mapProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByOverrideRouteProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideRouteProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByOverrideRouteProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideRouteProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByOverrideSearchProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideSearchProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByOverrideSearchProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'overrideSearchProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByPersistentNotificationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistentNotificationEnabled', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByPersistentNotificationEnabledDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'persistentNotificationEnabled', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByResumeAlarmAfterBoot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeAlarmAfterBoot', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByResumeAlarmAfterBootDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resumeAlarmAfterBoot', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByRouteProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routeProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByRouteProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'routeProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenBySearchProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchProvider', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenBySearchProviderDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'searchProvider', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByThemeModeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'themeMode', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByUseMetric() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMetric', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy> thenByUseMetricDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useMetric', Sort.desc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByUseRecommendedProviders() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useRecommendedProviders', Sort.asc);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QAfterSortBy>
      thenByUseRecommendedProvidersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'useRecommendedProviders', Sort.desc);
    });
  }
}

extension AppSettingsQueryWhereDistinct
    on QueryBuilder<AppSettings, AppSettings, QDistinct> {
  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByAccentColor(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accentColor', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByAccessibilityHighContrast() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessibilityHighContrast');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByBatteryProfile() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'batteryProfile');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByDebugLoggingEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'debugLoggingEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByDefaultFlashlightEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultFlashlightEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByDefaultTriggerDistanceMeters() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultTriggerDistanceMeters');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByDefaultVibrationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultVibrationEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByDefaultVoiceEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'defaultVoiceEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByFontFamily(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fontFamily', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByHasCompletedPermissions() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasCompletedPermissions');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByHasCompletedWelcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hasCompletedWelcome');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByLanguageCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'languageCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByLockScreenInfoEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lockScreenInfoEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByMapLayer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mapLayer');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByMapProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mapProvider');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByOverrideRouteProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overrideRouteProvider');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByOverrideSearchProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'overrideSearchProvider');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByPersistentNotificationEnabled() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'persistentNotificationEnabled');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByResumeAlarmAfterBoot() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resumeAlarmAfterBoot');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByRouteProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'routeProvider');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctBySearchProvider() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'searchProvider');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByThemeMode() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'themeMode');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct> distinctByUseMetric() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useMetric');
    });
  }

  QueryBuilder<AppSettings, AppSettings, QDistinct>
      distinctByUseRecommendedProviders() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'useRecommendedProviders');
    });
  }
}

extension AppSettingsQueryProperty
    on QueryBuilder<AppSettings, AppSettings, QQueryProperty> {
  QueryBuilder<AppSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> accentColorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accentColor');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      accessibilityHighContrastProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessibilityHighContrast');
    });
  }

  QueryBuilder<AppSettings, BatteryProfile, QQueryOperations>
      batteryProfileProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'batteryProfile');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      debugLoggingEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'debugLoggingEnabled');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      defaultFlashlightEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultFlashlightEnabled');
    });
  }

  QueryBuilder<AppSettings, double, QQueryOperations>
      defaultTriggerDistanceMetersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultTriggerDistanceMeters');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      defaultVibrationEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultVibrationEnabled');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      defaultVoiceEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'defaultVoiceEnabled');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> fontFamilyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fontFamily');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      hasCompletedPermissionsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasCompletedPermissions');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      hasCompletedWelcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hasCompletedWelcome');
    });
  }

  QueryBuilder<AppSettings, String, QQueryOperations> languageCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'languageCode');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      lockScreenInfoEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lockScreenInfoEnabled');
    });
  }

  QueryBuilder<AppSettings, MapLayerType, QQueryOperations> mapLayerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mapLayer');
    });
  }

  QueryBuilder<AppSettings, MapProviderType, QQueryOperations>
      mapProviderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mapProvider');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      overrideRouteProviderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overrideRouteProvider');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      overrideSearchProviderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'overrideSearchProvider');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      persistentNotificationEnabledProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'persistentNotificationEnabled');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      resumeAlarmAfterBootProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resumeAlarmAfterBoot');
    });
  }

  QueryBuilder<AppSettings, RouteProviderType, QQueryOperations>
      routeProviderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'routeProvider');
    });
  }

  QueryBuilder<AppSettings, SearchProviderType, QQueryOperations>
      searchProviderProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'searchProvider');
    });
  }

  QueryBuilder<AppSettings, AppThemeMode, QQueryOperations>
      themeModeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'themeMode');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations> useMetricProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useMetric');
    });
  }

  QueryBuilder<AppSettings, bool, QQueryOperations>
      useRecommendedProvidersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'useRecommendedProviders');
    });
  }
}
