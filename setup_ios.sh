#!/bin/bash

echo "🚀 Setting up iOS environment for Object Learning App"
echo ""

# Navigate to ios directory
cd "$(dirname "$0")/ios" || exit

echo "1️⃣ Cleaning previous builds..."
rm -rf Pods
rm -rf Podfile.lock
rm -rf ~/Library/Developer/Xcode/DerivedData/*

echo ""
echo "2️⃣ Installing CocoaPods dependencies..."
pod deintegrate 2>/dev/null || true
pod install --repo-update

echo ""
echo "3️⃣ Building for iOS device..."
cd ..
flutter clean
flutter pub get
flutter build ios --release

echo ""
echo "✅ iOS setup complete!"
echo ""
echo "📱 To run on your device:"
echo "   1. Connect your iPhone/iPad via USB"
echo "   2. Trust the device on your Mac"
echo "   3. Run: flutter run --release"
echo "   OR open ios/Runner.xcworkspace in Xcode and run from there"
echo ""
echo "⚠️  Make sure to:"
echo "   - Set up your Apple Developer account in Xcode"
echo "   - Select your development team in Signing & Capabilities"
echo "   - Change the Bundle Identifier if needed"
