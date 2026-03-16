import 'dart:io';

import 'package:get/get.dart';

import '../../data/models/detection_result.dart';
import '../../data/repositories/object_detection_repository.dart';

/// ViewModel for Gallery screen
class GalleryViewModel extends GetxController {
  final ObjectDetectionRepository _repository = ObjectDetectionRepository();

  // Observable states
  final Rx<DetectionResult?> currentDetection = Rx<DetectionResult?>(null);
  final RxBool isProcessing = false.obs;
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxString lastSpokenObject = ''.obs;

  /// Pick image from gallery
  Future<void> pickImage() async {
    try {
      isProcessing.value = true;
      final file = await _repository.pickImageFromGallery();

      if (file != null) {
        selectedImage.value = file;
        await _detectFromImage(file);
      } else {
        Get.snackbar(
          'No Image',
          'No image was selected',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar(
        'Error',
        'Failed to pick image',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Detect object from selected image
  Future<void> _detectFromImage(File imageFile) async {
    try {
      isProcessing.value = true;
      final result = await _repository.detectFromFile(imageFile);

      if (result != null && result.isValid) {
        currentDetection.value = result;
        lastSpokenObject.value = result.label;
        await _repository.announceObject(result.label);
      } else {
        currentDetection.value = DetectionResult.empty();
        Get.snackbar(
          'No Object Detected',
          'Could not identify any object in this image',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('Error detecting from image: $e');
      Get.snackbar(
        'Error',
        'Failed to detect object',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isProcessing.value = false;
    }
  }

  /// Repeat last detected object name
  void repeatLastDetection() {
    if (currentDetection.value != null && currentDetection.value!.isValid) {
      _repository.announceObject(currentDetection.value!.label);
    }
  }

  /// Clear current selection
  void clearSelection() {
    selectedImage.value = null;
    currentDetection.value = null;
    lastSpokenObject.value = '';
  }
}
