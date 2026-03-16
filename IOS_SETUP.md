# iOS Setup & Troubleshooting Guide

## 🍎 Running on Real iOS Device

### Prerequisites

- macOS with Xcode installed
- Physical iPhone/iPad with iOS 12.0 or later
- USB cable to connect device
- Apple Developer account (free account works)

## 📱 Quick Setup

### Method 1: Using Flutter CLI (Recommended)

```bash
# 1. Run the setup script
./setup_ios.sh

# 2. Connect your iPhone/iPad via USB

# 3. Trust the computer on your device
# (A popup will appear on your device - tap "Trust")

# 4. Run the app
flutter run --release
```

### Method 2: Using Xcode

```bash
# 1. Install pods
cd ios
pod install --repo-update
cd ..

# 2. Open in Xcode
open ios/Runner.xcworkspace

# 3. In Xcode:
#    - Select your device from the device menu
#    - Go to Signing & Capabilities
#    - Select your Team (Apple ID)
#    - Click Run (▶️) button
```

## 🔧 iOS Configuration Completed

✅ **Podfile** - iOS 12.0 minimum version set
✅ **Info.plist** - Camera & Photo Library permissions added
✅ **Labels** - Correct COCO dataset labels (91 classes)
✅ **TFLite** - Enhanced debugging and logging

## 📋 Permissions Added

The app requests these permissions on iOS:

1. **Camera** - To capture live video for object detection
2. **Photo Library** - To select images from gallery
3. **Microphone** - For text-to-speech features

## 🐛 Common iOS Issues

### Issue 1: "Code Signing Required"

**Error**: Code signing is required for product type 'Application' in SDK 'iOS'

**Solution**:

1. Open `ios/Runner.xcworkspace` in Xcode
2. Click on "Runner" in the left panel
3. Go to "Signing & Capabilities" tab
4. Check "Automatically manage signing"
5. Select your Team from the dropdown

### Issue 2: "No Valid Code Signing Certificates"

**Solution**:

1. Open Xcode → Preferences → Accounts
2. Add your Apple ID
3. Click "Download Manual Profiles"
4. Try setup again

### Issue 3: "Untrusted Developer"

**On Device**: Settings → General → Device Management
→ Trust [Your Apple ID]

### Issue 4: Pod Install Fails

```bash
cd ios
sudo gem install cocoapods
pod repo update
pod install
cd ..
```

### Issue 5: "The operation couldn't be completed"

**Solution**: Clean and rebuild

```bash
flutter clean
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
flutter run
```

### Issue 6: Object Detection Not Working

**Check these**:

1. Model file exists: `ls -la assets/models/ssd_mobilenet.tflite`
2. Labels file is correct: `head assets/labels/labels.txt`
   - Should show: `???`, `person`, `bicycle`, `car`...
3. Check debug logs in Xcode console for errors

## 📊 Debug Logging

The app now has enhanced logging. Check Xcode console for:

```
✅ TFLite model loaded successfully
📊 Model input shape: ...
📊 Model output shape: ...
📋 Loaded XX labels
🔍 Starting detection...
✅ Image preprocessed: 300x300
⚡ Running inference...
✅ Inference completed
📊 Scores: [0.95, 0.12, ...]
✅ Detected: person (95.0%)
```

## 🎯 Testing on Device

1. **Camera Detection**:
   - Launch app
   - Tap "Start Camera"
   - Point at: person, bicycle, car, cup, phone, laptop
   - Watch console logs in Xcode

2. **Gallery Detection**:
   - Tap "Pick from Gallery"
   - Select a photo
   - Object should be detected and spoken

## 📱 Device Requirements

- **iOS Version**: 12.0 or later
- **Storage**: ~50MB free space
- **Camera**: Required for live detection
- **Microphone**: Required for TTS (text-to-speech)

## 🔍 Verification Steps

### 1. Check Model & Labels

```bash
# Model should be ~4MB
ls -lh assets/models/ssd_mobilenet.tflite

# Should show 91 lines with COCO labels
wc -l assets/labels/labels.txt
head -10 assets/labels/labels.txt
```

### 2. Check iOS Permissions

```bash
# Should show camera, photo, and microphone permissions
grep -A1 "Usage" ios/Runner/Info.plist
```

### 3. Check Podfile

```bash
# Should show platform :ios, '12.0'
grep "platform :ios" ios/Podfile
```

## 🚀 Production Build

For TestFlight or App Store:

```bash
# 1. Update version in pubspec.yaml
version: 1.0.0+1

# 2. Build release
flutter build ios --release

# 3. Archive in Xcode
open ios/Runner.xcworkspace
# Product → Archive → Distribute App
```

## 📝 Important Notes

1. **First Launch**: App may take 5-10 seconds to load the ML model
2. **Detection Speed**: Real-time detection processes ~5-10 frames/second
3. **Accuracy**: Better lighting = better detection
4. **Objects**: Works best with common objects (COCO dataset)
5. **Debug Build**: Use `--release` flag for better performance

## 🎓 COCO Dataset Objects

The app can detect 80 common objects:

**People & Animals**: person, bird, cat, dog, horse, sheep, cow, elephant, bear, zebra, giraffe

**Vehicles**: bicycle, car, motorcycle, airplane, bus, train, truck, boat

**Indoor**: chair, couch, potted plant, bed, dining table, toilet, tv, laptop, mouse, keyboard, cell phone

**Food**: banana, apple, sandwich, orange, broccoli, carrot, hot dog, pizza, donut, cake

**Accessories**: backpack, umbrella, handbag, tie, suitcase

...and many more!

## 🆘 Still Having Issues?

1. Check Xcode console for error messages
2. Verify all files exist (model, labels)
3. Try on a different iOS device
4. Check iOS version compatibility
5. Review GitHub issues for similar problems

---

**Good Luck!** 🎉
