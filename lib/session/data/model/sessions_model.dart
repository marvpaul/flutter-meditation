import 'package:flutter_meditation/session/data/model/session_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'sessions_model.freezed.dart';
part 'sessions_model.g.dart';

@unfreezed
class SessionsModel with _$SessionsModel {
  factory SessionsModel({
    @Default([]) List<SessionModel> sessions
  }) = _SessionsModel;

  factory SessionsModel.fromJson(Map<String, dynamic> json) =>
      _$SessionsModelFromJson(json);
}
