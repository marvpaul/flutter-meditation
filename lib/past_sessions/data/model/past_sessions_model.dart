/// {@category Model}
/// Represents a model for past sessions.
import 'package:freezed_annotation/freezed_annotation.dart';
part 'past_sessions_model.freezed.dart';
part 'past_sessions_model.g.dart';

@unfreezed
class PastSessions with _$PastSessions {
  factory PastSessions() = _PastSessions;

  factory PastSessions.fromJson(Map<String, dynamic> json) =>
      _$PastSessionsFromJson(json);
}
