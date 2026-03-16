import 'dart:async';

import 'package:camera/camera.dart';
import 'package:get/get.dart';

import '../../data/models/detection_result.dart';
import '../../data/repositories/object_detection_repository.dart';
import '../../domain/services/camera_service.dart';

/// ViewModel for Camera screen
class CameraViewModel extends GetxController {
  final CameraService _cameraService = Get.find<CameraService>();
  final ObjectDetectionRepository _repository = ObjectDetectionRepository();

  // Observable states
  final Rx<DetectionResult?> currentDetection = Rx<DetectionResult?>(null);
  final RxBool isDetecting = false.obs;
  final RxBool isCameraReady = false.obs;
  final RxBool isProcessing = false.obs;
  final RxString lastSpokenObject = ''.obs;

  // Camera controller
  CameraController? get cameraController => _cameraService.controller;

  // Detection throttling
  bool _isProcessingFrame = false;
  Timer? _detectionTimer;
  String? _lastDetectedLabel;
  DateTime? _lastSpeakTime;

  @override
  void onInit() {
    super.onInit();
    _initializeCamera();
  }

  /// Initialize camera
  Future<void> _initializeCamera() async {
    try {
      final initialized = await _cameraService.initializeCamera();
      isCameraReady.value = initialized;

      if (initialized) {
        // Wait a bit for camera to stabilize, then auto-start detection
        await Future.delayed(const Duration(milliseconds: 800));
        if (isCameraReady.value && !isDetecting.value) {
          startDetection();
        }
      }
    } catch (e) {
      print('Error initializing camera: $e');
      Get.snackbar(
        'Error',
        'Failed to initialize camera',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Start real-time object detection
  void startDetection() {
    if (!isCameraReady.value || isDetecting.value) return;

    isDetecting.value = true;
    _cameraService.startImageStream(_onCameraImage);
  }

  /// Stop real-time object detection
  Future<void> stopDetection() async {
    if (!isDetecting.value) return;

    isDetecting.value = false;
    await _cameraService.stopImageStream();
    _detectionTimer?.cancel();
  }

  /// Handle camera image for detection
  void _onCameraImage(CameraImage image) {
    if (_isProcessingFrame || !isDetecting.value) return;

    _isProcessingFrame = true;
    isProcessing.value = true;

    _processImage(image).then((_) {
      _isProcessingFrame = false;
      isProcessing.value = false;
    });
  }

  /// Process camera image
  Future<void> _processImage(CameraImage image) async {
    try {
      final result = await _repository.detectFromCameraImage(image);

      if (result != null && result.isValid) {
        currentDetection.value = result;

        // Only speak if it's a new object and enough time has passed
        final now = DateTime.now();
        final shouldSpeak =
            _lastDetectedLabel != result.label &&
            (_lastSpeakTime == null ||
                now.difference(_lastSpeakTime!).inSeconds >= 3);

        if (shouldSpeak) {
          _announceDetection(result.label);
          _lastDetectedLabel = result.label;
          _lastSpeakTime = now;
        }
      }
    } catch (e) {
      print('Error processing image: $e');
    }
  }

  /// Announce detected object
  Future<void> _announceDetection(String objectName) async {
    lastSpokenObject.value = objectName;
    await _repository.announceObject(objectName);
  }

  /// Take a snapshot and detect
  Future<void> captureAndDetect() async {
    if (!isCameraReady.value) return;

    try {
      // Temporarily stop stream if running
      final wasDetecting = isDetecting.value;
      if (wasDetecting) {
        await stopDetection();
      }

      final picture = await _cameraService.takePicture();
      if (picture != null) {
        // Process the captured image
        Get.snackbar(
          'Captured',
          'Image captured successfully!',
          snackPosition: SnackPosition.BOTTOM,
        );
      }

      // Resume stream if it was running
      if (wasDetecting) {
        startDetection();
      }
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  /// Repeat last detected object name
  void repeatLastDetection() {
    if (currentDetection.value != null && currentDetection.value!.isValid) {
      _announceDetection(currentDetection.value!.label);
    }
  }

  @override
  void onClose() {
    stopDetection();
    _detectionTimer?.cancel();
    super.onClose();
  }
}
