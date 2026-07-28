sealed class AppException implements Exception {
  const AppException(this.userMessage, {this.debugMessage});

  final String userMessage;
  final String? debugMessage;

  bool get isRecoverable => true;
}

class LocationException extends AppException {
  const LocationException(super.userMessage, {super.debugMessage});
}

class PermissionException extends AppException {
  const PermissionException(super.userMessage, {super.debugMessage});
}

class NetworkException extends AppException {
  const NetworkException(super.userMessage, {super.debugMessage});
}

class StorageException extends AppException {
  const StorageException(super.userMessage, {super.debugMessage});
}

class AlarmException extends AppException {
  const AlarmException(super.userMessage, {super.debugMessage});
}
