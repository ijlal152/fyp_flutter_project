import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../../data/models/detection_result.dart';
import '../../utils/constants.dart';

/// Service for TensorFlow Lite object detection
class TFLiteService extends GetxService {
  Interpreter? _interpreter;
  List<String> _labels = [];
  bool _isModelLoaded = false;

  bool get isModelLoaded => _isModelLoaded;

  /// Initialize the TFLite model
  Future<TFLiteService> init() async {
    try {
      await _loadModel();
      await _loadLabels();
      _isModelLoaded = true;
      print('✅ TFLite model loaded successfully');
    } catch (e) {
      print('❌ Error loading TFLite model: $e');
      _isModelLoaded = false;
    }
    return this;
  }

  /// Load the TFLite model
  Future<void> _loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        AppConstants.modelPath,
        options: InterpreterOptions()..threads = 4,
      );
    } catch (e) {
      throw Exception('Failed to load model: $e');
    }
  }

  /// Load labels from text file
  Future<void> _loadLabels() async {
    try {
      final labelsData = await rootBundle.loadString(AppConstants.labelsPath);
      _labels = labelsData
          .split('\n')
          .where((label) => label.isNotEmpty)
          .toList();
    } catch (e) {
      throw Exception('Failed to load labels: $e');
    }
  }

  /// Run object detection on image
  Future<DetectionResult?> detectObject(img.Image image) async {
    if (!_isModelLoaded || _interpreter == null) {
      print('Model not loaded');
      return null;
    }

    try {
      // Preprocess image
      final input = _preprocessImage(image);

      // Prepare output buffers for SSD MobileNet
      // Output format: [locations, classes, scores, numDetections]
      var outputLocations = List.filled(1 * 10 * 4, 0.0).reshape([1, 10, 4]);
      var outputClasses = List.filled(1 * 10, 0.0).reshape([1, 10]);
      var outputScores = List.filled(1 * 10, 0.0).reshape([1, 10]);
      var numDetections = List.filled(1, 0.0).reshape([1]);

      final outputs = {
        0: outputLocations,
        1: outputClasses,
        2: outputScores,
        3: numDetections,
      };

      // Run inference
      _interpreter!.runForMultipleInputs([input], outputs);

      // Process results
      return _processOutput(outputScores, outputClasses);
    } catch (e) {
      print('Error during detection: $e');
      return null;
    }
  }

  /// Preprocess image for model input
  List<List<List<List<double>>>> _preprocessImage(img.Image image) {
    // Resize image to model input size
    final resizedImage = img.copyResize(
      image,
      width: AppConstants.targetImageWidth,
      height: AppConstants.targetImageHeight,
    );

    // Convert to input tensor format
    final input = List.generate(
      1,
      (b) => List.generate(
        AppConstants.targetImageHeight,
        (y) => List.generate(AppConstants.targetImageWidth, (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        }),
      ),
    );

    return input;
  }

  /// Process model output and extract best detection
  DetectionResult _processOutput(
    List<dynamic> outputScores,
    List<dynamic> outputClasses,
  ) {
    final scores = outputScores[0] as List<double>;
    final classes = outputClasses[0] as List<double>;

    // Find the detection with highest confidence
    double maxConfidence = 0.0;
    int maxIndex = 0;

    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > maxConfidence) {
        maxConfidence = scores[i];
        maxIndex = i;
      }
    }

    // Only return if confidence is above minimum threshold
    if (maxConfidence >= AppConstants.minimumConfidence) {
      final classIndex = classes[maxIndex].toInt();
      final label = classIndex < _labels.length
          ? _labels[classIndex]
          : 'Unknown object';

      return DetectionResult(
        label: label,
        confidence: maxConfidence,
        timestamp: DateTime.now(),
      );
    }

    return DetectionResult.empty();
  }

  /// Clean up resources
  @override
  void onClose() {
    _interpreter?.close();
    super.onClose();
  }
}
