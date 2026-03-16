# Object Learning App

A Flutter application that helps children learn object names through AI-powered object recognition.

## Features

✨ **Real-time Object Detection**

- Point camera at any object
- Get instant recognition results
- Visual confidence indicators

🔊 **Audio Pronunciation**

- Automatically speaks object names
- Child-friendly voice settings
- Repeat functionality

📷 **Flexible Input**

- Real-time camera detection
- Photo capture
- Gallery image selection

🎨 **Child-Friendly UI**

- Colorful, engaging interface
- Large buttons and text
- Simple navigation

## Architecture

This project follows **Clean MVVM Architecture** with **GetX** state management:

```
lib/
├── main.dart                      # App entry point
├── app/
│   ├── routes/                    # Navigation routes
│   └── theme/                     # App theming
├── data/
│   ├── models/                    # Data models
│   └── repositories/              # Data repositories
├── domain/
│   └── services/                  # Business logic services
├── presentation/
│   ├── viewmodels/                # View models (Controllers)
│   └── views/                     # UI screens
└── utils/                         # Constants and utilities
```

## Technologies Used

- **Flutter**: Cross-platform framework
- **GetX**: State management & dependency injection
- **TFLite**: TensorFlow Lite for object detection
- **Camera**: Camera access and image streaming
- **Flutter TTS**: Text-to-speech functionality
- **Image**: Image processing

## Setup Instructions

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. **Clone the repository**

   ```bash
   git clone <your-repo-url>
   cd fyp_flutter_project
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Add TFLite Model & Labels**

   Download a pre-trained model and labels:

   ```bash
   # Follow instructions in assets/README.md
   ```

   Or manually:
   - Download SSD MobileNet from TensorFlow Hub
   - Place `.tflite` file in `assets/models/`
   - Place `labels.txt` in `assets/labels/`

4. **Configure Permissions**

   **Android** (`android/app/src/main/AndroidManifest.xml`):

   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.INTERNET" />
   ```

   **iOS** (`ios/Runner/Info.plist`):

   ```xml
   <key>NSCameraUsageDescription</key>
   <string>Camera is required for object detection</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>Microphone for audio features</string>
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Usage

1. **Launch the App**
   - Open the app
   - Wait for services to initialize

2. **Start Detection**
   - Tap "Start Camera"
   - Grant camera permissions
   - Point camera at objects

3. **Learn Objects**
   - Detected object name appears on screen
   - App automatically speaks the name
   - Tap "Repeat" to hear again

4. **Controls**
   - ▶️ Play button: Start/stop detection
   - 📷 Camera button: Capture snapshot
   - 🔊 Repeat button: Repeat last object name

## MVVM Architecture Details

### Services Layer (`domain/services/`)

- **TFLiteService**: Handles ML model loading and inference
- **CameraService**: Manages camera operations
- **TextToSpeechService**: Controls audio output

### Repository Layer (`data/repositories/`)

- **ObjectDetectionRepository**: Coordinates detection workflow

### ViewModel Layer (`presentation/viewmodels/`)

- **HomeViewModel**: Home screen logic
- **CameraViewModel**: Camera and detection logic

### View Layer (`presentation/views/`)

- **HomeView**: Landing screen
- **CameraView**: Real-time detection screen

## Customization

### Change Detection Threshold

Edit `lib/utils/constants.dart`:

```dart
static const double minimumConfidence = 0.5; // Adjust from 0.0 to 1.0
```

### Change Speech Settings

Edit `lib/utils/constants.dart`:

```dart
static const double speechRate = 0.5;  // Speed (0.0 - 1.0)
static const double speechPitch = 1.0; // Pitch (0.5 - 2.0)
```

### Use Different Model

1. Place new model in `assets/models/`
2. Update path in `lib/utils/constants.dart`
3. Update labels file accordingly

## Troubleshooting

### Model Not Loading

- Verify model file is in `assets/models/`
- Check `pubspec.yaml` has assets declared
- Run `flutter clean` and `flutter pub get`

### Camera Not Working

- Check permissions are granted
- Verify AndroidManifest.xml / Info.plist configuration
- Test on physical device (not simulator)

### Detection Inaccurate

- Try different lighting conditions
- Adjust `minimumConfidence` threshold
- Use a more accurate (but slower) model

## Performance Tips

- Use `ResolutionPreset.medium` for balanced performance
- Implement frame skipping for slower devices
- Consider quantized models for better speed

## Future Enhancements

- [ ] Gallery image selection
- [ ] Multiple language support
- [ ] Learning progress tracking
- [ ] Object database and flashcards
- [ ] Drawing/coloring activities
- [ ] Parent/teacher dashboard

## Contributing

Contributions are welcome! Please follow:

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## License

This project is for educational purposes.

## Credits

- TensorFlow Lite for ML capabilities
- Flutter team for the framework
- GetX for state management
- Community contributors

## Contact

For questions or support, please open an issue on GitHub.

---

**Made with ❤️ for helping children learn**
