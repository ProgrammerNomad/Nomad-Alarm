/// Simple rate limiter for HTTP-based providers.
class RequestThrottler {
  RequestThrottler({this.minIntervalMs = 1000});

  final int minIntervalMs;
  DateTime? _lastRequestAt;

  Future<void> throttle() async {
    if (_lastRequestAt == null) {
      return;
    }
    final elapsed = DateTime.now().difference(_lastRequestAt!);
    final remaining = minIntervalMs - elapsed.inMilliseconds;
    if (remaining > 0) {
      await Future<void>.delayed(Duration(milliseconds: remaining));
    }
  }

  void markRequest() {
    _lastRequestAt = DateTime.now();
  }

  Future<void> run(Future<void> Function() action) async {
    await throttle();
    markRequest();
    await action();
  }
}
