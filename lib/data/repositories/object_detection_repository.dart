import 'dart:io';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';

import '../../domain/services/text_to_speech_service.dart';
import '../../domain/services/tflite_service.dart';
import '../models/detection_result.dart';

/// Repository for object detection operations
class ObjectDetectionRepository {
  final TFLiteService _tfliteService = Get.find<TFLiteService>();
  final TextToSpeechService _ttsService = Get.find<TextToSpeechService>();
  final ImagePicker _imagePicker = ImagePicker();

  /// Detect object from camera image
  Future<DetectionResult?> detectFromCameraImage(
    CameraImage cameraImage,
  ) async {
    try {
      // Convert CameraImage to img.Image
      final image = _convertCameraImage(cameraImage);
      if (image == null) return null;

      // Run detection
      return await _tfliteService.detectObject(image);
    } catch (e) {
      print('Error detecting from camera: $e');
      return null;
    }
  }

  /// Detect object from file
  Future<DetectionResult?> detectFromFile(File imageFile) async {
    try {
      final bytes = await imageFile.readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) return null;

      return await _tfliteService.detectObject(image);
    } catch (e) {
      print('Error detecting from file: $e');
      return null;
    }
  }

  /// Pick image from gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  /// Announce the detected object
  Future<void> announceObject(String objectName) async {
    await _ttsService.speak(objectName);
  }

  /// Convert CameraImage to img.Image
  img.Image? _convertCameraImage(CameraImage cameraImage) {
    try {
      if (cameraImage.format.group == ImageFormatGroup.yuv420) {
        return _convertYUV420ToImage(cameraImage);
      } else if (cameraImage.format.group == ImageFormatGroup.bgra8888) {
        return _convertBGRA8888ToImage(cameraImage);
      }
      return null;
    } catch (e) {
      print('Error converting camera image: $e');
      return null;
    }
  }

  /// Convert YUV420 format to img.Image
  img.Image? _convertYUV420ToImage(CameraImage cameraImage) {
    final int width = cameraImage.width;
    final int height = cameraImage.height;

    final int uvRowStride = cameraImage.planes[1].bytesPerRow;
    final int uvPixelStride = cameraImage.planes[1].bytesPerPixel ?? 1;

    final image = img.Image(width: width, height: height);

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final int uvIndex =
            uvPixelStride * (x / 2).floor() + uvRowStride * (y / 2).floor();
        final int index = y * width + x;

        final yValue = cameraImage.planes[0].bytes[index];
        final uValue = cameraImage.planes[1].bytes[uvIndex];
        final vValue = cameraImage.planes[2].bytes[uvIndex];

        final r = (yValue + vValue * 1436 / 1024 - 179).round().clamp(0, 255);
        final g =
            (yValue -
                    uValue * 46549 / 131072 +
                    44 -
                    vValue * 93604 / 131072 +
                    91)
                .round()
                .clamp(0, 255);
        final b = (yValue + uValue * 1814 / 1024 - 227).round().clamp(0, 255);

        image.setPixelRgb(x, y, r, g, b);
      }
    }

    return image;
  }

  /// Convert BGRA8888 format to img.Image
  img.Image _convertBGRA8888ToImage(CameraImage cameraImage) {
    return img.Image.fromBytes(
      width: cameraImage.width,
      height: cameraImage.height,
      bytes: cameraImage.planes[0].bytes.buffer,
      order: img.ChannelOrder.bgra,
    );
  }
}
