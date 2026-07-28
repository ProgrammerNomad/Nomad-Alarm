import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/features/about/presentation/about_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/active_alarm_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/alarm_config_screen.dart';
import 'package:nomad_alarm/features/alarm/presentation/alarm_ring_screen.dart';
import 'package:nomad_alarm/features/debug/presentation/debug_screen.dart';
import 'package:nomad_alarm/features/history/presentation/history_screen.dart';
import 'package:nomad_alarm/features/home/presentation/home_screen.dart';
import 'package:nomad_alarm/features/map/presentation/map_screen.dart';
import 'package:nomad_alarm/features/permission/presentation/permissions_screen.dart';
import 'package:nomad_alarm/features/privacy/presentation/privacy_screen.dart';
import 'package:nomad_alarm/features/search/presentation/search_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/permission_center_screen.dart';
import 'package:nomad_alarm/features/settings/presentation/settings_screen.dart';
import 'package:nomad_alarm/features/splash/presentation/splash_screen.dart';
import 'package:nomad_alarm/features/trip/presentation/trips_screen.dart';
import 'package:nomad_alarm/features/welcome/presentation/welcome_screen.dart';
import 'package:nomad_alarm/shared/widgets/main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
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
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/trips',
                builder: (context, state) => const TripsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryScreen(),
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
        builder: (context, state) => const SearchScreen(),
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
        path: '/alarm/ring/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AlarmRingScreen(alarmId: id);
        },
      ),
    ],
  );
});
