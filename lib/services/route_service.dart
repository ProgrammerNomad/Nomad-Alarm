import 'package:latlong2/latlong.dart';
import 'package:nomad_alarm/models/app_settings.dart';
import 'package:nomad_alarm/models/enums.dart';
import 'package:nomad_alarm/providers/route/route_provider.dart';
import 'package:nomad_alarm/services/provider_factory.dart';

class RouteService {
  RouteService({
    required ProviderFactory factory,
    required AppSettings settings,
  })  : _factory = factory,
        _settings = settings;

  final ProviderFactory _factory;
  AppSettings _settings;
  RouteProvider? _cachedProvider;

  void updateSettings(AppSettings settings) {
    if (_settings.routeProvider != settings.routeProvider) {
      _cachedProvider?.dispose();
      _cachedProvider = null;
    }
    _settings = settings;
  }

  Future<RouteProvider> _provider() async {
    _cachedProvider ??= await _factory.createRouteProvider(_settings);
    return _cachedProvider!;
  }

  Future<RouteResult?> route({
    required LatLng from,
    required LatLng to,
    TravelMode travelMode = TravelMode.autoDetect,
  }) async {
    final provider = await _provider();
    return provider.route(from: from, to: to, travelMode: travelMode);
  }

  void dispose() {
    _cachedProvider?.dispose();
    _cachedProvider = null;
  }
}
