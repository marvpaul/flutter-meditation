class PredictionParametersModel {
  List<int> heartRates;
  List<int> binauralBeats;
  List<int> visualizations;
  List<double> breathingMultipliers;

  PredictionParametersModel({
    required this.heartRates,
    required this.binauralBeats,
    required this.visualizations,
    required this.breathingMultipliers,
  });

  factory PredictionParametersModel.fromJson(Map<String, dynamic> json) {
    return PredictionParametersModel(
      heartRates: (json['heartRates'] as List<dynamic>).cast<int>(),
      binauralBeats: (json['binauralBeats'] as List<dynamic>).cast<int>(),
      visualizations: (json['visualizations'] as List<dynamic>).cast<int>(),
      breathingMultipliers:
          (json['breathingMultipliers'] as List<dynamic>).cast<double>(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'heartRates': heartRates,
      'binauralBeats': binauralBeats,
      'visualizations': visualizations,
      'breathingMultipliers': breathingMultipliers,
    };
  }

  @override
  String toString() {
    return 'PredictionParametersModel {'
        ' heartRates: $heartRates,'
        ' binauralBeats: $binauralBeats,'
        ' visualizations: $visualizations,'
        ' breathingMultipliers: $breathingMultipliers'
        ' }';
  }
}
