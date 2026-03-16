/// Model class for object detection results
class DetectionResult {
  final String label;
  final double confidence;
  final DateTime timestamp;

  DetectionResult({
    required this.label,
    required this.confidence,
    required this.timestamp,
  });

  /// Factory constructor for creating an empty result
  factory DetectionResult.empty() {
    return DetectionResult(
      label: 'No object detected',
      confidence: 0.0,
      timestamp: DateTime.now(),
    );
  }

  /// Convert to map for potential serialization
  Map<String, dynamic> toMap() {
    return {
      'label': label,
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Create from map
  factory DetectionResult.fromMap(Map<String, dynamic> map) {
    return DetectionResult(
      label: map['label'] as String,
      confidence: map['confidence'] as double,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  @override
  String toString() {
    return 'DetectionResult(label: $label, confidence: ${(confidence * 100).toStringAsFixed(2)}%)';
  }

  /// Check if this is a valid detection
  bool get isValid =>
      confidence > 0.0 && label.isNotEmpty && label != 'No object detected';
}
