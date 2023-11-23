import 'package:freezed_annotation/freezed_annotation.dart';
part 'session_model.freezed.dart';
part 'session_model.g.dart';

@unfreezed
class SessionModel with _$SessionModel {
  factory SessionModel({
    @Default(false) bool isHapticFeedbackEnabled,
    @Default(false) bool shouldShowHeartRate,
    @Default('Option 1') String sound,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
}
