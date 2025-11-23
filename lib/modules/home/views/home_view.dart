import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/home_controller.dart';
import '../widgets/input_fields.dart';
import '../widgets/distance_info.dart';

/// Home View - Main screen with Google Maps (UI only, no logic)
class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        // Show loading indicator while getting location
        if (controller.isLoading.value &&
            controller.currentPosition.value == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Getting your location...'),
              ],
            ),
          );
        }

        // Show error message if location permission denied
        if (controller.errorMessage.value.isNotEmpty &&
            controller.currentPosition.value == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.location_off,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      controller.initializeLocation();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show map
        final initialPosition = controller.currentPosition.value != null
            ? LatLng(
                controller.currentPosition.value!.latitude,
                controller.currentPosition.value!.longitude,
              )
            : const LatLng(37.7749, -122.4194); // Default to San Francisco

        return Stack(
          children: [
            // Google Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: initialPosition,
                zoom: 14.0,
              ),
              onMapCreated: (GoogleMapController mapController) {
                controller.setMapController(mapController);
                // Center on current location after map is created
                if (controller.currentPosition.value != null) {
                  controller.centerOnCurrentLocation();
                }
              },
              onTap: (LatLng position) {
                // Add marker on tap
                controller.addMarker(position);
              },
              markers: controller.markers,
              polylines: controller.polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
            ),

            // Input fields at top
            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 0,
              right: 0,
              child: InputFields(controller: controller),
            ),

            // Distance info at bottom
            Obx(() {
              if (controller.routeInfo.value != null) {
                return Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: const DistanceInfo(),
                );
              }
              return const SizedBox.shrink();
            }),

            // Loading overlay
            Obx(() {
              if (controller.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
          ],
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // My Location button
          FloatingActionButton(
            heroTag: 'location',
            onPressed: () {
              controller.centerOnCurrentLocation();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: Colors.blue),
          ),
          const SizedBox(height: 16),
          // Clear Markers button
          FloatingActionButton(
            heroTag: 'clear',
            onPressed: () {
              controller.clearMarkers();
              controller.clearRoute();
            },
            backgroundColor: Colors.white,
            child: const Icon(Icons.clear_all, color: Colors.red),
          ),
        ],
      ),
    );
  }
}

