import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'data/services/location_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() {
  // Initialize GetX services
  Get.put(LocationService(), permanent: true);
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Google Maps Route Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
    );
  }
}
