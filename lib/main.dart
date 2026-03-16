import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'domain/services/camera_service.dart';
import 'domain/services/text_to_speech_service.dart';
import 'domain/services/tflite_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  await _initServices();

  runApp(const MyApp());
}

/// Initialize all required services
Future<void> _initServices() async {
  print('🚀 Initializing services...');

  try {
    // Initialize Camera Service
    await Get.putAsync(() => CameraService().init());

    // Initialize TFLite Service
    await Get.putAsync(() => TFLiteService().init());

    // Initialize Text-to-Speech Service
    await Get.putAsync(() => TextToSpeechService().init());

    print('✅ All services initialized successfully');
  } catch (e) {
    print('❌ Error initializing services: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Object Learning',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
    );
  }
}
