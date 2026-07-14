import 'package:shared_preferences/shared_preferences.dart';

import '../errors/app_exceptions.dart';

/// Thin wrapper over [SharedPreferences] that converts platform errors into
/// readable application exceptions. Repositories talk to this service;
/// nothing else touches the storage plugin directly.
class LocalStorageService {
  LocalStorageService(this._preferences);

  final SharedPreferences _preferences;

  String? readString(String key) {
    try {
      return _preferences.getString(key);
    } catch (_) {
      throw const StorageReadException();
    }
  }

  Future<void> writeString(String key, String value) async {
    final bool didWrite;
    try {
      didWrite = await _preferences.setString(key, value);
    } catch (_) {
      throw const StorageWriteException();
    }
    if (!didWrite) {
      throw const StorageWriteException();
    }
  }

  bool? readBool(String key) {
    try {
      return _preferences.getBool(key);
    } catch (_) {
      throw const StorageReadException();
    }
  }

  Future<void> writeBool(String key, bool value) async {
    final bool didWrite;
    try {
      didWrite = await _preferences.setBool(key, value);
    } catch (_) {
      throw const StorageWriteException();
    }
    if (!didWrite) {
      throw const StorageWriteException();
    }
  }
}
