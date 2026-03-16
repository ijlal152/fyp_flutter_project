import 'package:get/get.dart';

import '../../viewmodels/home_viewmodel.dart';

/// Binding for Home View
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewModel>(() => HomeViewModel());
  }
}
