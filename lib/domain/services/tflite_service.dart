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
      print('📊 Model input shape: ${_interpreter?.getInputTensors()}');
      print('📊 Model output shape: ${_interpreter?.getOutputTensors()}');
      print('📋 Loaded ${_labels.length} labels');
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
      throw (e);
    }
  }

  /// Run object detection on image
  Future<DetectionResult?> detectObject(img.Image image) async {
    if (!_isModelLoaded || _interpreter == null) {
      print('❌ Model not loaded');
      return null;
    }

    try {
      print('🔍 Starting detection...');

      // Preprocess image
      final input = _preprocessImage(image);
      print(
        '✅ Image preprocessed: ${AppConstants.targetImageWidth}x${AppConstants.targetImageHeight}',
      );

      // Get model input/output details
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputTensors = _interpreter!.getOutputTensors();

      print('📊 Input shape: $inputShape');
      print('📊 Output tensors count: ${outputTensors.length}');

      // Prepare output buffers for SSD MobileNet
      // The model typically outputs:
      // 0: detection_boxes [1, num_detections, 4]
      // 1: detection_classes [1, num_detections]
      // 2: detection_scores [1, num_detections]
      // 3: num_detections [1]

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
      print('⚡ Running inference...');
      _interpreter!.runForMultipleInputs([input], outputs);
      print('✅ Inference completed');

      // Process results
      final result = _processOutput(outputScores, outputClasses);

      if (result.isValid) {
        print(
          '✅ Detected: ${result.label} (${(result.confidence * 100).toStringAsFixed(1)}%)',
        );
      } else {
        print('⚠️ No valid detection (max confidence below threshold)');
      }

      return result;
    } catch (e, stackTrace) {
      print('❌ Error during detection: $e');
      print('Stack trace: $stackTrace');
      return null;
    }
  }

  /// Preprocess image for model input
  List<List<List<List<int>>>> _preprocessImage(img.Image image) {
    // Resize image to model input size
    final resizedImage = img.copyResize(
      image,
      width: AppConstants.targetImageWidth,
      height: AppConstants.targetImageHeight,
    );

    // Convert to input tensor format (uint8: 0-255)
    final input = List.generate(
      1,
      (b) => List.generate(
        AppConstants.targetImageHeight,
        (y) => List.generate(AppConstants.targetImageWidth, (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
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

    print('📊 Scores: ${scores.take(5).toList()}');
    print('📊 Classes: ${classes.take(5).toList()}');

    // Find the detection with highest confidence
    double maxConfidence = 0.0;
    int maxIndex = 0;

    for (int i = 0; i < scores.length; i++) {
      if (scores[i] > maxConfidence) {
        maxConfidence = scores[i];
        maxIndex = i;
      }
    }

    print(
      '🎯 Best detection: index=$maxIndex, score=$maxConfidence, threshold=${AppConstants.minimumConfidence}',
    );

    // Only return if confidence is above minimum threshold
    if (maxConfidence >= AppConstants.minimumConfidence) {
      final classIndex = classes[maxIndex].toInt();
      print('🏷️ Class index: $classIndex, Labels count: ${_labels.length}');

      final label = classIndex >= 0 && classIndex < _labels.length
          ? _labels[classIndex]
          : 'Unknown object #$classIndex';

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
