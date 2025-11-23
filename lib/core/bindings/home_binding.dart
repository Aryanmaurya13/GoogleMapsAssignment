import 'package:get/get.dart';
import '../../modules/home/controllers/home_controller.dart';
import '../../data/services/location_service.dart';

/// Home Binding - Dependency injection for Home module
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // LocationService should already be registered in main.dart
    // If not found, create it
    if (!Get.isRegistered<LocationService>()) {
      Get.put(LocationService(), permanent: true);
    }
    
    Get.lazyPut<HomeController>(
      () => HomeController(),
      fenix: true,
    );
  }
}

