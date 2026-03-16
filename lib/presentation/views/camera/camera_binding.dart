import 'package:get/get.dart';

import '../../viewmodels/camera_viewmodel.dart';

/// Binding for Camera View
class CameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CameraViewModel>(() => CameraViewModel());
  }
}
