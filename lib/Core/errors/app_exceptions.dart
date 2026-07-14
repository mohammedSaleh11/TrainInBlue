/// Application-level failures with messages that are safe to show users.
///
/// Low-level storage and parsing exceptions are converted into these types at
/// the repository boundary; raw exception text never reaches the UI.
sealed class AppException implements Exception {
  const AppException();
}

/// Reading from local storage failed.
class StorageReadException extends AppException {
  const StorageReadException();
}

/// Writing to local storage failed; the latest change may not be persisted.
class StorageWriteException extends AppException {
  const StorageWriteException();
}

/// A saved workout exists but cannot be parsed. The damaged payload is left
/// untouched so the user decides how to recover.
class CorruptSavedWorkoutException extends AppException {
  const CorruptSavedWorkoutException();
}

/// The bundled starter exercises are missing, empty, or malformed.
class StarterDataException extends AppException {
  const StarterDataException();
}
