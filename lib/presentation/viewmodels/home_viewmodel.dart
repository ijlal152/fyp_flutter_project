import 'package:get/get.dart';

import '../../app/routes/app_routes.dart';
import '../../domain/services/camera_service.dart';
import '../../domain/services/text_to_speech_service.dart';
import '../../domain/services/tflite_service.dart';

/// ViewModel for Home screen
class HomeViewModel extends GetxController {
  final CameraService _cameraService = Get.find<CameraService>();
  final TFLiteService _tfliteService = Get.find<TFLiteService>();
  final TextToSpeechService _ttsService = Get.find<TextToSpeechService>();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxString statusMessage = ''.obs;
  final RxBool servicesReady = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkServices();
  }

  /// Check if all services are initialized
  void _checkServices() {
    servicesReady.value =
        _tfliteService.isModelLoaded && _ttsService.isInitialized;

    if (servicesReady.value) {
      statusMessage.value = 'Ready to learn! 🎉';
    } else {
      statusMessage.value = 'Initializing...';
    }
  }

  /// Navigate to camera screen
  void openCamera() async {
    // Check camera permission
    final hasPermission = await _cameraService.checkPermission();

    if (!hasPermission) {
      final granted = await _cameraService.requestPermission();
      if (!granted) {
        Get.snackbar(
          'Permission Required',
          'Camera permission is needed to detect objects',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }
    }

    // Navigate to camera view
    Get.toNamed(AppRoutes.camera);
  }

  /// Open gallery to select image
  void openGallery() async {
    Get.toNamed(AppRoutes.gallery);
  }

  /// Test text-to-speech
  void testTTS() {
    _ttsService.speak('Hello! I am ready to help you learn object names!');
  }
}
