import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_parameter_optimization_response_dto.freezed.dart';
part 'session_parameter_optimization_response_dto.g.dart';

@freezed
class SessionParameterOptimizationResponseDTO with _$SessionParameterOptimizationResponseDTO {
  factory SessionParameterOptimizationResponseDTO({
    String? message,
    SessionParameterOptimizationDTO? bestCombination,
  }) = _SessionParameterOptimizationResponseDTO;

  factory SessionParameterOptimizationResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$SessionParameterOptimizationResponseDTOFromJson(json);
}

@freezed
class SessionParameterOptimizationDTO with _$SessionParameterOptimizationDTO {
  factory SessionParameterOptimizationDTO({
    required String visualization,
    required double beatFrequency,
    required double breathingPatternMultiplier,
  }) = _SessionParameterOptimizationDTO;

  factory SessionParameterOptimizationDTO.fromJson(Map<String, dynamic> json) =>
      _$SessionParameterOptimizationDTOFromJson(json);
}