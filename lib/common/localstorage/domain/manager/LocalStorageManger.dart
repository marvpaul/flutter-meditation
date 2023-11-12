import '../../../../extension/Codable.dart';

abstract class LocalStorageManger {
  void store<T extends Encodable>(String key, T data);
  Future<T?> retrieve<T extends Codable>(String key, T Function(Map<String, dynamic>) fromJson);
  void remove(String key);
}
