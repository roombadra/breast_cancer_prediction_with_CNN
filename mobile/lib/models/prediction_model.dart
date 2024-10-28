class PredictionModel {
  final String prediction;
  final double confidence;
  final double confidenceMargin;
  final double uncertainty;
  final double processingTime;

  PredictionModel({
    required this.prediction,
    required this.confidence,
    required this.confidenceMargin,
    required this.uncertainty,
    required this.processingTime,
  });

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      prediction: json['prediction'],
      confidence: json['confidence'],
      confidenceMargin: json['confidence_margin'],
      uncertainty: json['uncertainty'],
      processingTime: json['processing_time'],
    );
  }
}
