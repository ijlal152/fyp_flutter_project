# Quick Setup Guide

## 📋 Prerequisites Checklist

- [x] Flutter SDK installed
- [x] Android Studio / Xcode installed
- [x] Physical device or emulator ready
- [ ] TFLite model downloaded

## 🚀 Quick Start (5 minutes)

### Step 1: Download Pre-trained Model

Run this command in your terminal:

```bash
cd /Users/ijlal/Documents/GitHub/fyp_flutter_project/assets/models

# Download the model
curl -L -o model.zip "https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_1.0_quant_2018_06_29.zip"

# Extract
unzip model.zip

# Rename model file
mv detect.tflite ssd_mobilenet.tflite

# Copy labels to labels folder
cp labelmap.txt ../labels/labels.txt

# Clean up
rm model.zip
```

### Step 2: Verify Installation

Check that files exist:

```bash
ls assets/models/ssd_mobilenet.tflite
ls assets/labels/labels.txt
```

You should see both files listed.

### Step 3: Run the App

```bash
# Make sure you're in the project root
cd /Users/ijlal/Documents/GitHub/fyp_flutter_project

# Run on connected device
flutter run
```

## 📱 Testing the App

1. **Grant Permissions**: When prompted, allow camera access
2. **Start Detection**: Tap "Start Camera" button
3. **Point at Objects**: Aim camera at common objects (cup, phone, laptop, etc.)
4. **Listen**: The app will speak the object name
5. **Repeat**: Tap the "Repeat" button to hear the name again

## 🔧 Troubleshooting

### Issue: "Model not loading"

**Solution 1**: Verify model exists

```bash
ls -la assets/models/ssd_mobilenet.tflite
```

**Solution 2**: Rebuild the app

```bash
flutter clean
flutter pub get
flutter run
```

### Issue: "Camera not working"

- Make sure you're using a **physical device** (camera doesn't work well in simulators)
- Check that camera permissions are granted
- Restart the app

### Issue: "No sound / Not speaking"

- Check device volume
- Test TTS by tapping "Test Voice" on home screen
- Ensure device is not in silent mode

### Issue: "Low accuracy / Wrong detections"

- Ensure good lighting
- Hold camera steady
- Try different distances from object
- Some objects work better than others

## 📊 What Objects Can It Detect?

The pre-trained COCO model can detect 80 common objects including:

**Common Items:**

- person, chair, couch, bed, table
- laptop, mouse, keyboard, cell phone
- cup, bottle, wine glass, fork, knife, spoon, bowl

**Household:**

- tv, microwave, oven, toaster, sink, refrigerator
- book, clock, vase, scissors

**Animals:**

- cat, dog, bird, horse, sheep, cow, elephant, bear

**Vehicles:**

- bicycle, car, motorcycle, airplane, bus, train, truck, boat

**Food:**

- banana, apple, sandwich, orange, broccoli, carrot, pizza, cake, donut

For the complete list, see: `assets/labels/labels.txt`

## 🎯 Next Steps

1. **Test with Different Objects**: Try various items around you
2. **Adjust Settings**: Modify confidence threshold in `lib/utils/constants.dart`
3. **Customize Voice**: Change speech rate and pitch for different preferences
4. **Add More Features**: Extend the app with new capabilities

## 🏗️ Project Structure

```
lib/
├── main.dart                          # Entry point with service initialization
├── app/
│   ├── routes/                        # GetX navigation
│   │   ├── app_pages.dart            # Route definitions
│   │   └── app_routes.dart           # Route constants
│   └── theme/
│       └── app_theme.dart            # Child-friendly color theme
├── data/
│   ├── models/
│   │   └── detection_result.dart     # Detection result model
│   └── repositories/
│       └── object_detection_repository.dart  # Detection operations
├── domain/
│   └── services/
│       ├── camera_service.dart       # Camera management
│       ├── tflite_service.dart       # ML model inference
│       └── text_to_speech_service.dart  # Voice output
├── presentation/
│   ├── viewmodels/
│   │   ├── home_viewmodel.dart       # Home screen logic
│   │   └── camera_viewmodel.dart     # Detection logic
│   └── views/
│       ├── home/
│       │   ├── home_view.dart        # Home UI
│       │   └── home_binding.dart     # Dependency injection
│       └── camera/
│           ├── camera_view.dart      # Camera UI
│           └── camera_binding.dart   # Dependency injection
└── utils/
    └── constants.dart                # App-wide constants
```

## 🎨 MVVM Architecture Flow

```
User Interaction
    ↓
View (UI Layer)
    ↓
ViewModel (Presentation Logic)
    ↓
Repository (Data Coordination)
    ↓
Services (Business Logic)
    ↓
External APIs (Camera, TFLite, TTS)
```

## 📝 Key Features Implemented

✅ **Clean Architecture**: Separation of concerns with MVVM
✅ **Dependency Injection**: GetX for service management
✅ **State Management**: Reactive programming with GetX
✅ **Real-time Detection**: Live camera feed processing
✅ **Text-to-Speech**: Automatic pronunciation
✅ **Child-Friendly UI**: Large, colorful, simple interface
✅ **Error Handling**: Graceful degradation
✅ **Permissions**: Proper runtime permission handling

## 🔄 Development Workflow

```bash
# Start development
flutter run

# Hot reload (after code changes)
# Press 'r' in terminal or save file

# Hot restart (for major changes)
# Press 'R' in terminal

# Check for issues
flutter analyze

# Run tests (when available)
flutter test
```

## 📚 Learning Resources

- **Flutter Docs**: https://flutter.dev/docs
- **GetX Guide**: https://pub.dev/packages/get
- **TFLite Flutter**: https://pub.dev/packages/tflite_flutter
- **MVVM Pattern**: https://en.wikipedia.org/wiki/Model–view–viewmodel

## 🎓 Educational Value

This project teaches children:

- **Object Recognition**: Learning names of everyday items
- **Visual Learning**: Associating images with words
- **Audio Reinforcement**: Hearing pronunciation
- **Interactive Learning**: Hands-on exploration
- **Technology Literacy**: Understanding AI capabilities

Perfect for:

- Early childhood education (ages 3-8)
- Language learning
- Children with learning differences
- Home schooling activities

---

**Need Help?** Check the main README.md or create an issue on GitHub.
