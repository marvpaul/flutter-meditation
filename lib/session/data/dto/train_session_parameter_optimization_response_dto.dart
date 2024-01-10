import 'package:freezed_annotation/freezed_annotation.dart';

part 'train_session_parameter_optimization_response_dto.freezed.dart';
part 'train_session_parameter_optimization_response_dto.g.dart';

@freezed
class TrainSessionParameterOptimizationResponseDTO with _$TrainSessionParameterOptimizationResponseDTO {
  factory TrainSessionParameterOptimizationResponseDTO({
    String? message,
  }) = _TrainSessionParameterOptimizationResponseDTO;

  factory TrainSessionParameterOptimizationResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$TrainSessionParameterOptimizationResponseDTOFromJson(json);
}