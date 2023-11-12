import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../extension/Codable.dart';
import '../../domain/manager/LocalStorageManger.dart';

class SharedPreferencesLocalStorageManger implements LocalStorageManger {
  final Future<SharedPreferences> _sharedPreferences;

  SharedPreferencesLocalStorageManger(this._sharedPreferences);

  @override
  void store<T extends Encodable>(String key, T data) async {
    String encodedData = jsonEncode(data);
    final SharedPreferences sharedPreferences = await _sharedPreferences;
    sharedPreferences.setString(key, encodedData);
  }

  @override
  Future<T?> retrieve<T extends Codable>(String key, T Function(Map<String, dynamic>) fromJson) async {
    SharedPreferences sharedPreferences = await _sharedPreferences;
    final String? data = sharedPreferences.getString(key);
    if (data == null) {
      return null;
    }
    return fromJson(jsonDecode(data));
  }

  @override
  void remove(String key) async {
    (await _sharedPreferences).remove(key);
  }
}