import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../viewmodels/camera_viewmodel.dart';

/// Camera screen view for real-time object detection
class CameraView extends GetView<CameraViewModel> {
  const CameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(AppConstants.cameraViewTitle),
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
      ),
      body: Obx(() {
        if (!controller.isCameraReady.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }

        return Stack(
          fit: StackFit.expand,
          children: [
            // Camera Preview
            _buildCameraPreview(),

            // Detection Overlay
            _buildDetectionOverlay(context),

            // Controls
            _buildControls(context),
          ],
        );
      }),
    );
  }

  /// Build camera preview widget
  Widget _buildCameraPreview() {
    return controller.cameraController != null
        ? CameraPreview(controller.cameraController!)
        : const SizedBox.shrink();
  }

  /// Build detection result overlay
  Widget _buildDetectionOverlay(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      right: 20,
      child: Obx(() {
        final detection = controller.currentDetection.value;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: detection != null && detection.isValid
                ? Theme.of(context).colorScheme.primary.withOpacity(0.9)
                : Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    detection != null && detection.isValid
                        ? Icons.check_circle
                        : Icons.camera_alt,
                    color: Colors.white,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      detection != null && detection.isValid
                          ? detection.label
                          : 'Looking for objects...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              if (detection != null && detection.isValid) ...[
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: detection.confidence,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confidence: ${(detection.confidence * 100).toStringAsFixed(1)}%',
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  /// Build control buttons
  Widget _buildControls(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Column(
        children: [
          // Repeat button
          Obx(() {
            final hasDetection =
                controller.currentDetection.value != null &&
                controller.currentDetection.value!.isValid;

            return AnimatedOpacity(
              opacity: hasDetection ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300),
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: ElevatedButton.icon(
                  onPressed: hasDetection
                      ? controller.repeatLastDetection
                      : null,
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Repeat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            );
          }),

          // Main action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Start/Stop Detection Button
              Obx(
                () => FloatingActionButton.large(
                  heroTag: 'detection',
                  onPressed: controller.isDetecting.value
                      ? controller.stopDetection
                      : controller.startDetection,
                  backgroundColor: controller.isDetecting.value
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                  child: Icon(
                    controller.isDetecting.value
                        ? Icons.stop
                        : Icons.play_arrow,
                    size: 40,
                  ),
                ),
              ),

              // Capture Button
              FloatingActionButton(
                heroTag: 'capture',
                onPressed: controller.captureAndDetect,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.camera,
                  color: Theme.of(context).colorScheme.primary,
                  size: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
