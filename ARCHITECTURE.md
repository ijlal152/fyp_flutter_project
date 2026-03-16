# Project Architecture Overview

## 🏗️ Complete File Structure

```
fyp_flutter_project/
│
├── lib/
│   ├── main.dart                                    # App entry point
│   │
│   ├── app/                                         # Application configuration
│   │   ├── routes/
│   │   │   ├── app_pages.dart                      # GetX page definitions
│   │   │   └── app_routes.dart                     # Route constants
│   │   └── theme/
│   │       └── app_theme.dart                      # Material theme configuration
│   │
│   ├── data/                                        # Data layer
│   │   ├── models/
│   │   │   └── detection_result.dart               # Detection result model
│   │   └── repositories/
│   │       └── object_detection_repository.dart    # Data operations coordinator
│   │
│   ├── domain/                                      # Business logic layer
│   │   └── services/
│   │       ├── camera_service.dart                 # Camera operations
│   │       ├── tflite_service.dart                 # TensorFlow Lite ML
│   │       └── text_to_speech_service.dart         # Audio output
│   │
│   ├── presentation/                                # Presentation layer
│   │   ├── viewmodels/
│   │   │   ├── home_viewmodel.dart                 # Home screen logic
│   │   │   └── camera_viewmodel.dart               # Camera screen logic
│   │   └── views/
│   │       ├── home/
│   │       │   ├── home_view.dart                  # Home screen UI
│   │       │   └── home_binding.dart               # DI bindings
│   │       └── camera/
│   │           ├── camera_view.dart                # Camera screen UI
│   │           └── camera_binding.dart             # DI bindings
│   │
│   └── utils/
│       └── constants.dart                           # App constants
│
├── assets/                                          # Asset files
│   ├── models/
│   │   └── ssd_mobilenet.tflite                    # TFLite model (to be added)
│   └── labels/
│       └── labels.txt                               # Object labels
│
├── android/                                         # Android configuration
│   └── app/src/main/AndroidManifest.xml            # Android permissions
│
├── ios/                                             # iOS configuration
│   └── Runner/Info.plist                           # iOS permissions
│
└── pubspec.yaml                                     # Dependencies
```

## 🔄 Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         USER INTERACTION                         │
│                     (Tap buttons, point camera)                  │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                         VIEW LAYER                               │
│                  (HomeView / CameraView)                         │
│  • Displays UI                                                   │
│  • Handles user input                                            │
│  • Observes ViewModel state                                      │
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─════════════════════════════════════════════════════════════════┐
║                    VIEWMODEL LAYER                               ║
║              (HomeViewModel / CameraViewModel)                   ║
║  • Business logic                                                ║
║  • State management (GetX)                                       ║
║  • Coordinates repositories and services                         ║
└─────────────────────┬───────────────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────────────┐
│                    REPOSITORY LAYER                              │
│              (ObjectDetectionRepository)                         │
│  • Coordinates data operations                                   │
│  • Calls multiple services                                       │
│  • Transforms data                                               │
└───────┬─────────────┬───────────────┬───────────────────────────┘
        │             │               │
        ▼             ▼               ▼
    ┌───────┐   ┌─────────┐   ┌──────────┐
    │TFLite │   │ Camera  │   │   TTS    │
    │Service│   │ Service │   │ Service  │
    └───┬───┘   └────┬────┘   └────┬─────┘
        │            │              │
        ▼            ▼              ▼
    ┌────────────────────────────────────┐
    │      EXTERNAL DEPENDENCIES         │
    │  • TensorFlow Lite                 │
    │  • Camera Plugin                   │
    │  • Flutter TTS                     │
    └────────────────────────────────────┘
```

## 🎯 MVVM Pattern Implementation

### Model Layer

**Location**: `lib/data/models/`

**Purpose**: Data structures and business entities

**Example**: `DetectionResult`

```dart
class DetectionResult {
  final String label;          // Object name
  final double confidence;     // Confidence score (0.0-1.0)
  final DateTime timestamp;    // When detected
}
```

### View Layer

**Location**: `lib/presentation/views/`

**Purpose**: UI components that display data

**Responsibilities**:

- Render UI using Flutter widgets
- Observe ViewModel state changes (GetX reactive)
- Pass user interactions to ViewModel
- No business logic

**Example**: `CameraView`

- Displays camera preview
- Shows detection results
- Provides control buttons
- Observes `CameraViewModel`

### ViewModel Layer

**Location**: `lib/presentation/viewmodels/`

**Purpose**: Presentation logic and state management

**Responsibilities**:

- Manage UI state
- Handle user actions
- Coordinate repositories and services
- Transform data for presentation
- No direct UI code

**Example**: `CameraViewModel`

- Manages camera state
- Processes detections
- Controls TTS announcements
- Throttles detection calls

## 🔌 Dependency Injection Flow

GetX handles all dependency injection:

```dart
// Step 1: Initialize services globally (main.dart)
await Get.putAsync(() => CameraService().init());
await Get.putAsync(() => TFLiteService().init());
await Get.putAsync(() => TextToSpeechService().init());

// Step 2: Bind ViewModels to routes (app_pages.dart)
GetPage(
  name: AppRoutes.camera,
  page: () => CameraView(),
  binding: CameraBinding(),  // Creates CameraViewModel
)

// Step 3: Inject services in Repository
class ObjectDetectionRepository {
  final TFLiteService _tflite = Get.find<TFLiteService>();
  final TextToSpeechService _tts = Get.find<TextToSpeechService>();
}

// Step 4: Use ViewModel in View
class CameraView extends GetView<CameraViewModel> {
  // 'controller' automatically available
}
```

## 📊 State Management with GetX

### Reactive Variables

```dart
// In ViewModel
final RxBool isDetecting = false.obs;
final Rx<DetectionResult?> currentDetection = Rx<DetectionResult?>(null);

// Update
isDetecting.value = true;
currentDetection.value = newResult;

// In View
Obx(() => Text(controller.currentDetection.value?.label ?? 'Searching...'))
```

### Lifecycle

```dart
class CameraViewModel extends GetxController {
  @override
  void onInit() {
    // Called when ViewModel is created
    super.onInit();
  }

  @override
  void onClose() {
    // Called when ViewModel is destroyed
    super.onClose();
  }
}
```

## 🎨 Key Design Patterns Used

### 1. **MVVM (Model-View-ViewModel)**

- Separation of UI and business logic
- Testable code
- Reactive updates

### 2. **Repository Pattern**

- Single source of truth for data operations
- Abstracts data sources
- Coordinates multiple services

### 3. **Service Layer**

- Encapsulates external dependencies
- Reusable business logic
- Easy to mock for testing

### 4. **Dependency Injection**

- Loose coupling
- Easy testing
- Service lifecycle management

### 5. **Singleton Pattern**

- Services initialized once
- Shared across app
- Managed by GetX

## 🔄 Real-time Detection Flow

```
1. User taps "Start Detection"
   ↓
2. CameraView calls CameraViewModel.startDetection()
   ↓
3. ViewModel starts camera image stream
   ↓
4. For each camera frame:
   ├─> Convert CameraImage to img.Image (Repository)
   ├─> Run TFLite detection (TFLiteService)
   ├─> Process results (Repository)
   └─> Update UI state (ViewModel)
   ↓
5. If valid detection:
   ├─> Update currentDetection observable
   ├─> UI automatically updates (Obx)
   └─> Speak object name (TTS Service)
```

## 📱 Screen Navigation

```
App Launch
    ↓
Main (Service Initialization)
    ↓
HomeView
    ├─> Test Voice → TTS Service
    ├─> Start Camera → CameraView
    └─> Pick Gallery → (Future implementation)
         ↓
    CameraView
         ├─> Start/Stop Detection
         ├─> Capture Photo
         ├─> Repeat Name
         └─> Back → HomeView
```

## 🎯 Component Responsibilities

### Services (domain/services/)

| Service                 | Responsibility      | Key Methods                                |
| ----------------------- | ------------------- | ------------------------------------------ |
| **TFLiteService**       | ML model operations | `init()`, `detectObject()`                 |
| **CameraService**       | Camera management   | `initializeCamera()`, `startImageStream()` |
| **TextToSpeechService** | Voice output        | `speak()`, `setSpeechRate()`               |

### ViewModels (presentation/viewmodels/)

| ViewModel           | Responsibility         | Key State                         |
| ------------------- | ---------------------- | --------------------------------- |
| **HomeViewModel**   | Home screen logic      | `servicesReady`, `statusMessage`  |
| **CameraViewModel** | Detection coordination | `currentDetection`, `isDetecting` |

### Views (presentation/views/)

| View           | Purpose             | Features                        |
| -------------- | ------------------- | ------------------------------- |
| **HomeView**   | Landing screen      | Service status, navigation      |
| **CameraView** | Detection interface | Live preview, controls, results |

## 🛠️ Customization Points

### Change Detection Sensitivity

`lib/utils/constants.dart`:

```dart
static const double minimumConfidence = 0.5;  // 0.0 to 1.0
```

### Adjust Speech Settings

`lib/utils/constants.dart`:

```dart
static const double speechRate = 0.5;   // Slower for children
static const double speechPitch = 1.0;  // Normal pitch
```

### Use Different Model

1. Update model path:

```dart
static const String modelPath = 'assets/models/your_model.tflite';
```

2. Update labels path:

```dart
static const String labelsPath = 'assets/labels/your_labels.txt';
```

### Modify Theme Colors

`lib/app/theme/app_theme.dart`:

```dart
static const Color primaryColor = Color(0xFF6C63FF);
static const Color secondaryColor = Color(0xFFFF6584);
```

## 🧪 Testing Structure (Future)

```
test/
├── unit/
│   ├── models/
│   │   └── detection_result_test.dart
│   ├── services/
│   │   ├── tflite_service_test.dart
│   │   └── tts_service_test.dart
│   └── viewmodels/
│       └── camera_viewmodel_test.dart
├── widget/
│   └── views/
│       ├── home_view_test.dart
│       └── camera_view_test.dart
└── integration/
    └── detection_flow_test.dart
```

## 📦 Dependencies Overview

| Package                | Purpose               | Usage                  |
| ---------------------- | --------------------- | ---------------------- |
| **get**                | State management & DI | ViewModels, navigation |
| **camera**             | Camera access         | Live preview, capture  |
| **tflite_flutter**     | ML inference          | Object detection       |
| **flutter_tts**        | Text-to-speech        | Voice output           |
| **permission_handler** | Runtime permissions   | Camera access          |
| **image**              | Image processing      | Format conversion      |
| **image_picker**       | Gallery selection     | Pick images            |

## 🚀 Performance Optimizations

1. **Frame Throttling**: Process every Nth frame for slower devices
2. **Async Processing**: Detection runs on separate isolate
3. **Image Resizing**: Downscale to model input size
4. **Model Quantization**: Use quantized models for speed
5. **Memory Management**: Properly dispose resources

## 🔒 Security & Privacy

- ✅ Camera permission requested at runtime
- ✅ No data collection or storage
- ✅ All processing on-device
- ✅ No internet required (after model download)
- ✅ Privacy-first design

## 📈 Future Enhancements Roadmap

- [ ] Gallery image detection
- [ ] Multi-language support
- [ ] Learning history tracking
- [ ] Custom object training
- [ ] AR object overlays
- [ ] Quiz mode
- [ ] Parent dashboard
- [ ] Offline mode improvements

---

**Architecture follows industry best practices**: Clean Code, SOLID principles, separation of concerns, testability, and maintainability.
