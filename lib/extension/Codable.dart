abstract class Encodable {
  Map<String, dynamic> toJson();
}

abstract class Decodable {
  factory Decodable.fromJson(Map<String, dynamic> json) { throw UnimplementedError(); }
}

abstract class Codable implements Encodable, Decodable {
  @override
  Map<String, dynamic> toJson();

  @override
  factory Codable.fromJson(Map<String, dynamic> json) { throw UnimplementedError(); }
}