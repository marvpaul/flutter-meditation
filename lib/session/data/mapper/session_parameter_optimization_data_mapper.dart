import 'package:flutter_meditation/session/data/dto/session_parameter_optimization_response_dto.dart';

import '../model/session_parameter_optimization.dart';

extension SessionParameterOptimizationDTOMapper on SessionParameterOptimizationDTO {
  SessionParameterOptimization toDomain() {
    return SessionParameterOptimization(
      visualization: visualization,
      beatFrequency: beatFrequency,
      breathingPatternMultiplier: breathingPatternMultiplier,
    );
  }
}