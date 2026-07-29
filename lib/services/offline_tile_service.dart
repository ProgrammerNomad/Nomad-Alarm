import 'dart:io';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';

/// Manages offline map tile stores via flutter_map_tile_caching.
class OfflineTileService {
  OfflineTileService._();

  static const storeName = 'nomad_offline_tiles';
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    await FMTCObjectBoxBackend().initialise();
    final store = const FMTCStore(storeName);
    if (!await store.manage.ready) {
      await store.manage.create();
    }
    _initialized = true;
  }

  static FMTCStore get store => const FMTCStore(storeName);

  static Future<void> downloadRegion({
    required LatLng southWest,
    required LatLng northEast,
    required String urlTemplate,
    int minZoom = 10,
    int maxZoom = 16,
    void Function(double progress)? onProgress,
  }) async {
    await initialize();
    final region = RectangleRegion(
      LatLngBounds(southWest, northEast),
    ).toDownloadable(
      minZoom: minZoom,
      maxZoom: maxZoom,
      options: TileLayer(
        urlTemplate: urlTemplate,
        userAgentPackageName: 'com.nomad.alarm',
      ),
    );
    await for (final progress in store.download.startForeground(
      region: region,
      parallelThreads: 2,
      maxBufferLength: 64,
      skipExistingTiles: true,
    )) {
      onProgress?.call(progress.percentageProgress / 100);
    }
  }

  static Future<int> cacheSizeBytes() async {
    await initialize();
    final stats = await store.stats.all;
    return (stats.size * 1024).round();
  }

  static Future<void> clearCache() async {
    await initialize();
    await store.manage.delete();
    await store.manage.create();
  }

  static Future<String> formatCacheSize() async {
    final bytes = await cacheSizeBytes();
    if (bytes < 1024) {
      return '$bytes B';
    }
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  static Future<String> cacheDirectoryPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}${Platform.pathSeparator}fmtc';
  }
}
