import 'package:app_links/app_links.dart';
import 'package:nomad_alarm/core/constants/feature_flags.dart';
import 'package:nomad_alarm/core/router/destination_args.dart';
import 'package:nomad_alarm/core/utils/deep_link_parser.dart';

/// Handles incoming geo / Maps URIs and clipboard import.
class DeepLinkService {
  DeepLinkService._();

  static final _appLinks = AppLinks();
  static String? _pendingUri;

  static Future<void> initialize() async {
    if (!FeatureFlags.deepLinkImport) {
      return;
    }
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      _pendingUri = initial.toString();
    }
    _appLinks.uriLinkStream.listen((uri) {
      _pendingUri = uri.toString();
    });
  }

  static String? consumePendingUri() {
    final uri = _pendingUri;
    _pendingUri = null;
    return uri;
  }

  static DestinationArgs? parse(String input) {
    if (!FeatureFlags.deepLinkImport) {
      return null;
    }
    final location = DeepLinkParser.parse(input);
    return location?.toDestinationArgs();
  }

  static DestinationArgs? consumePendingDestination() {
    final uri = consumePendingUri();
    if (uri == null) {
      return null;
    }
    return parse(uri);
  }
}
