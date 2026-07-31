import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/router/alarm_config_args.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/features/about/presentation/about_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/active_alarm_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/alarm_config_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/alarm_ring_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/import_alarm_preview_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/import_qr_scan_screen.dart';
import 'package:nomad_alarm/models/shared_alarm_payload.dart';
import 'package:nomad_alarm/features/debug/presentation/debug_screen.dart';
import 'package:nomad_alarm/features/history/presentation/history_screen.dart';
import 'package:nomad_alarm/providers/history_trip_providers.dart';
import 'package:nomad_alarm/features/home/presentation/alarms_screen.dart';
import 'package:nomad_alarm/features/map/presentation/map_screen.dart';
import 'package:nomad_alarm/features/permission/presentation/permissions_screen.dart';
import 'package:nomad_alarm/features/privacy/presentation/privacy_screen.dart';
import 'package:nomad_alarm/features/search/presentation/search_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/map_settings_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/permission_center_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/settings_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/transfer_data_screen.dart';
import 'package:nomad_alarm/features/saved_places/presentation/saved_place_form_screen.dart';
import 'package:nomad_alarm/features/saved_places/presentation/saved_places_list_screen.dart';
import 'package:nomad_alarm/features/splash/presentation/splash_screen.dart';
import 'package:nomad_alarm/features/welcome/presentation/welcome_screen.dart';
import 'package:nomad_alarm/shared/widgets/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      if (state.uri.path == '/home') {
        return '/alarms';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: '/permissions',
        builder: (context, state) => const PermissionsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/alarms',
                builder: (context, state) => const AlarmsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => HistoryScreen(
                  initialFilter: HistoryFilterQuery.fromQueryParameter(
                    state.uri.queryParameters['filter'],
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings/permissions',
        builder: (context, state) => const PermissionCenterScreen(),
      ),
      GoRoute(
        path: '/settings/map',
        builder: (context, state) => const MapSettingsScreen(),
      ),
      GoRoute(
        path: '/settings/transfer-data',
        builder: (context, state) => const TransferDataScreen(),
      ),
      GoRoute(
        path: '/saved-places',
        builder: (context, state) => const SavedPlacesListScreen(),
      ),
      GoRoute(
        path: '/saved-places/new',
        builder: (context, state) => const SavedPlaceFormScreen(),
      ),
      GoRoute(
        path: '/saved-places/:id/edit',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return SavedPlaceFormScreen(placeId: id);
        },
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),
      GoRoute(
        path: '/debug',
        builder: (context, state) => const DebugScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => SearchScreen(
          pickForPlace: state.uri.queryParameters['pick'] == 'place',
        ),
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) {
          final lat = double.tryParse(state.uri.queryParameters['lat'] ?? '');
          final lng = double.tryParse(state.uri.queryParameters['lng'] ?? '');
          final zoom = double.tryParse(state.uri.queryParameters['zoom'] ?? '');
          return MapScreen(
            initialLatitude: lat,
            initialLongitude: lng,
            initialZoom: zoom,
          );
        },
      ),
      GoRoute(
        path: '/alarm/new',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is AlarmConfigArgs) {
            return AlarmConfigScreen(
              destination: extra.destination,
              importedDraft: extra.importedDraft,
            );
          }
          return AlarmConfigScreen(
            destination: extra is DestinationArgs ? extra : null,
          );
        },
      ),
      GoRoute(
        path: '/alarm/active/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ActiveAlarmScreen(alarmId: id);
        },
      ),
      GoRoute(
        path: '/alarm/import/preview',
        builder: (context, state) {
          final extra = state.extra;
          if (extra is List<SharedAlarmPayload>) {
            return ImportAlarmPreviewScreen(payloads: extra);
          }
          return ImportAlarmPreviewScreen(
            payloads: [extra as SharedAlarmPayload],
          );
        },
      ),
      GoRoute(
        path: '/alarm/import/qr',
        builder: (context, state) => const ImportQrScanScreen(),
      ),
      GoRoute(
        path: '/alarm/ring/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AlarmRingScreen(alarmId: id);
        },
      ),
    ],
  );
});
