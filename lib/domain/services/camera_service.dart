import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for camera operations
class CameraService extends GetxService {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];

  CameraController? get controller => _controller;
  bool get isInitialized => _controller?.value.isInitialized ?? false;

  /// Initialize camera service
  Future<CameraService> init() async {
    try {
      _cameras = await availableCameras();
      print('✅ Found ${_cameras.length} camera(s)');
    } catch (e) {
      print('❌ Error getting cameras: $e');
    }
    return this;
  }

  /// Request camera permission
  Future<bool> requestPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  Future<bool> checkPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Initialize camera for real-time detection
  Future<bool> initializeCamera() async {
    if (_cameras.isEmpty) {
      print('No cameras available');
      return false;
    }

    try {
      // Use back camera (index 0) by default
      _controller = CameraController(
        _cameras[0],
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.yuv420,
      );

      await _controller!.initialize();
      print('✅ Camera initialized successfully');
      return true;
    } catch (e) {
      print('❌ Error initializing camera: $e');
      return false;
    }
  }

  /// Switch between front and back camera
  Future<void> switchCamera() async {
    if (_cameras.length < 2) return;

    final currentCameraIndex = _cameras.indexOf(_controller!.description);
    final newCameraIndex = (currentCameraIndex + 1) % _cameras.length;

    await disposeCamera();

    _controller = CameraController(
      _cameras[newCameraIndex],
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
  }

  /// Take a picture
  Future<XFile?> takePicture() async {
    if (!isInitialized) return null;

    try {
      return await _controller!.takePicture();
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  /// Start image stream for real-time detection
  void startImageStream(Function(CameraImage) onImage) {
    if (!isInitialized) return;

    _controller!.startImageStream(onImage);
  }

  /// Stop image stream
  Future<void> stopImageStream() async {
    if (!isInitialized) return;

    try {
      await _controller!.stopImageStream();
    } catch (e) {
      print('Error stopping image stream: $e');
    }
  }

  /// Dispose camera controller
  Future<void> disposeCamera() async {
    await _controller?.dispose();
    _controller = null;
  }

  @override
  void onClose() {
    disposeCamera();
    super.onClose();
  }
}
