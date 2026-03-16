import 'package:get/get.dart';

import '../../presentation/views/camera/camera_binding.dart';
import '../../presentation/views/camera/camera_view.dart';
import '../../presentation/views/gallery/gallery_binding.dart';
import '../../presentation/views/gallery/gallery_view.dart';
import '../../presentation/views/home/home_binding.dart';
import '../../presentation/views/home/home_view.dart';
import 'app_routes.dart';

/// Application pages configuration
class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.camera,
      page: () => const CameraView(),
      binding: CameraBinding(),
    ),
    GetPage(
      name: AppRoutes.gallery,
      page: () => const GalleryView(),
      binding: GalleryBinding(),
    ),
  ];
}
