import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../viewmodels/gallery_viewmodel.dart';

/// Gallery screen view for image-based object detection
class GalleryView extends GetView<GalleryViewModel> {
  const GalleryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery Detection'),
        actions: [
          Obx(() {
            if (controller.selectedImage.value != null) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: controller.clearSelection,
                tooltip: 'Clear',
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: SafeArea(
        child: Obx(() {
          if (controller.isProcessing.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.selectedImage.value == null) {
            return _buildEmptyState(context);
          }

          return _buildImageView(context);
        }),
      ),
      floatingActionButton: Obx(() {
        if (controller.selectedImage.value == null) {
          return FloatingActionButton.extended(
            onPressed: controller.pickImage,
            icon: const Icon(Icons.photo_library),
            label: const Text('Pick Image'),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }

  /// Build empty state when no image is selected
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 120,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'Select an Image',
            style: Theme.of(context).textTheme.displayMedium,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Pick a photo from your gallery to identify objects',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  /// Build image view with detection results
  Widget _buildImageView(BuildContext context) {
    return Column(
      children: [
        // Image display
        Expanded(
          child: Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(controller.selectedImage.value!.path),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Detection results
        Obx(() {
          final detection = controller.currentDetection.value;

          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: detection != null && detection.isValid
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      detection != null && detection.isValid
                          ? Icons.check_circle
                          : Icons.image_search,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        detection != null && detection.isValid
                            ? detection.label
                            : 'Analyzing...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                if (detection != null && detection.isValid) ...[
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: detection.confidence,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Confidence: ${(detection.confidence * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: controller.repeatLastDetection,
                        icon: const Icon(Icons.volume_up, size: 20),
                        label: const Text('Repeat'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: controller.pickImage,
                    icon: const Icon(Icons.photo_library),
                    label: const Text('Pick Another Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }
}
