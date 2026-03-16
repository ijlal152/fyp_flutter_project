/// Application constants
class AppConstants {
  // Detection Settings
  static const double minimumConfidence =
      0.3; // Lower threshold for easier detection
  static const int maxDetectionResults = 5;

  // Camera Settings
  static const int targetImageWidth = 300;
  static const int targetImageHeight = 300;

  // TFLite Model Settings
  static const String modelPath = 'assets/models/ssd_mobilenet.tflite';
  static const String labelsPath = 'assets/labels/labels.txt';

  // Text to Speech Settings
  static const double speechRate = 0.5; // Slower for children
  static const double speechPitch = 1.0;
  static const double speechVolume = 1.0;

  // UI Constants
  static const String appTitle = 'Object Learning';
  static const String cameraViewTitle = 'Point to Learn';

  // Error Messages
  static const String cameraPermissionDenied = 'Camera permission is required';
  static const String modelLoadError = 'Failed to load AI model';
  static const String detectionError = 'Detection failed';

  // Success Messages
  static const String speakingObject = 'Speaking object name...';
}
