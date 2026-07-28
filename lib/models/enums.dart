enum AlarmType {
  distance,
  arrival,
  departure,
  radius,
  eta,
  speed,
  geofence,
}

enum AlarmStatus {
  draft,
  active,
  paused,
  triggered,
  completed,
  cancelled,
  missed,
}

enum TravelMode {
  train,
  bus,
  metro,
  car,
  walking,
  cycling,
  autoDetect,
}

enum TripOutcome {
  completed,
  cancelled,
  missed,
  passed,
}

enum FavoriteCategory {
  home,
  office,
  college,
  gym,
  airport,
  hotel,
  custom,
}

enum HistoryType {
  completed,
  missed,
  dismissed,
  snoozed,
}

enum AppThemeMode {
  system,
  light,
  dark,
}

enum MapProviderType {
  osm,
  google,
  mapbox,
  here,
}

enum SearchProviderType {
  nominatim,
  googlePlaces,
  photon,
  pelias,
  here,
}

enum RouteProviderType {
  osrm,
  googleDirections,
  graphHopper,
  valhalla,
}

enum BatteryProfile {
  balanced,
  aggressive,
  saver,
}

enum LogLevel {
  debug,
  info,
  warning,
  error,
}
