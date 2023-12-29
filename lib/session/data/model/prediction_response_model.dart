class PredictionResponseModel {
  late double binauralBeatsInHz;
  late double breathFrequency;
  late int visualization;

  PredictionResponseModel({
    required this.binauralBeatsInHz,
    required this.breathFrequency,
    required this.visualization,
  });

  PredictionResponseModel.fromJson(Map<String, dynamic> json) {
    final bestCombination = json['best_combination'];
    binauralBeatsInHz = bestCombination['binauralBeatsInHz'];
    breathFrequency = bestCombination['breathFrequency'];
    visualization = bestCombination['visualization'];
  }

}
