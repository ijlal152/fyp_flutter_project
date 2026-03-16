import 'package:get/get.dart';

import '../../viewmodels/gallery_viewmodel.dart';

/// Binding for Gallery View
class GalleryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GalleryViewModel>(() => GalleryViewModel());
  }
}
