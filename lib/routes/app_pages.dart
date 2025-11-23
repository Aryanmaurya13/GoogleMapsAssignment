import 'package:get/get.dart';
import '../core/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

/// App Pages - Define all routes and their bindings
class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
  ];
}


