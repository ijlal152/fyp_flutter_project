import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants.dart';
import '../../viewmodels/home_viewmodel.dart';

/// Home screen view
class HomeView extends GetView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appTitle), elevation: 0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // App Logo/Icon
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(height: 40),

              // Welcome Text
              Text(
                'Learn Object Names!',
                style: Theme.of(context).textTheme.displayMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                'Point your camera at objects and I\'ll tell you what they are!',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Status Message
              Obx(
                () => Text(
                  controller.statusMessage.value,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 40),

              // Start Camera Button
              Obx(
                () => ElevatedButton.icon(
                  onPressed: controller.servicesReady.value
                      ? controller.openCamera
                      : null,
                  icon: const Icon(Icons.camera_alt, size: 28),
                  label: const Text('Start Camera'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Pick from Gallery Button
              OutlinedButton.icon(
                onPressed: controller.openGallery,
                icon: const Icon(Icons.photo_library),
                label: const Text('Pick from Gallery'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
              ),

              const SizedBox(height: 40),

              // Test TTS Button
              if (Get.isRegistered<HomeViewModel>())
                TextButton(
                  onPressed: controller.testTTS,
                  child: const Text('Test Voice'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
