import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/directions_model.dart';
import '../../../data/services/directions_service.dart';
import '../../../data/services/location_service.dart';
import '../../../data/services/places_service.dart';
import '../viewmodels/home_viewmodel.dart';

/// Home Controller - Manages map state and business logic
class HomeController extends GetxController {
  // Services
  late final LocationService _locationService;
  final DirectionsService _directionsService = DirectionsService();
  final PlacesService _placesService = PlacesService();

  // Google Map Controller
  GoogleMapController? mapController;

  // Reactive state variables
  final Rx<Position?> currentPosition = Rx<Position?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasLocationPermission = false.obs;

  // Markers
  final RxSet<Marker> markers = <Marker>{}.obs;

  // Route
  final Rx<DirectionsModel?> routeInfo = Rx<DirectionsModel?>(null);
  final RxSet<Polyline> polylines = <Polyline>{}.obs;

  // Input fields
  final RxString sourceAddress = ''.obs;
  final RxString destinationAddress = ''.obs;
  final Rx<LatLng?> sourceLocation = Rx<LatLng?>(null);
  final Rx<LatLng?> destinationLocation = Rx<LatLng?>(null);

  // Places autocomplete
  final RxList<String> sourceSuggestions = <String>[].obs;
  final RxList<String> destinationSuggestions = <String>[].obs;
  final RxBool isLoadingSuggestions = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get LocationService from GetX
    _locationService = Get.find<LocationService>();
    initializeLocation();
  }

  /// Initialize location and request permissions
  Future<void> initializeLocation() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Check if location services are enabled
      bool serviceEnabled = await _locationService.isLocationServiceEnabled();
      if (!serviceEnabled) {
        errorMessage.value = 'Location services are disabled. Please enable them.';
        isLoading.value = false;
        hasLocationPermission.value = false;
        Get.snackbar(
          'Location Error',
          errorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Check location permission
      LocationPermission permission = await _locationService.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await _locationService.requestPermission();
        if (permission == LocationPermission.denied) {
          errorMessage.value = 'Location permissions are denied.';
          isLoading.value = false;
          hasLocationPermission.value = false;
          Get.snackbar(
            'Permission Denied',
            'Please grant location permission to use this feature.',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        errorMessage.value =
            'Location permissions are permanently denied. Please enable them in settings.';
        isLoading.value = false;
        hasLocationPermission.value = false;
        Get.snackbar(
          'Permission Required',
          'Please enable location permission in app settings.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Get current position
      final position = await _locationService.getCurrentPosition();
      if (position != null) {
        currentPosition.value = position;
        hasLocationPermission.value = true;
        // Center map on current location
        centerOnCurrentLocation();
      } else {
        errorMessage.value = 'Could not get current location.';
        hasLocationPermission.value = false;
      }

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error getting location: $e';
      isLoading.value = false;
      hasLocationPermission.value = false;
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Set the GoogleMapController
  void setMapController(GoogleMapController controller) {
    mapController = controller;
    if (currentPosition.value != null) {
      centerOnCurrentLocation();
    }
  }

  /// Add marker at tapped location
  void addMarker(LatLng position) {
    final markerId = 'marker_${markers.length}';
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(
        title: 'Marker ${markers.length + 1}',
        snippet:
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}',
      ),
    );

    markers.add(marker);
  }

  /// Clear all markers
  void clearMarkers() {
    markers.clear();
  }

  /// Center map on current location
  Future<void> centerOnCurrentLocation() async {
    if (currentPosition.value != null && mapController != null) {
      await mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            currentPosition.value!.latitude,
            currentPosition.value!.longitude,
          ),
        ),
      );
    } else {
      await initializeLocation();
      if (currentPosition.value != null && mapController != null) {
        await mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(
              currentPosition.value!.latitude,
              currentPosition.value!.longitude,
            ),
          ),
        );
      }
    }
  }

  /// Set source address
  void setSourceAddress(String address) {
    sourceAddress.value = address;
  }

  /// Set destination address
  void setDestinationAddress(String address) {
    destinationAddress.value = address;
  }

  /// Get place suggestions for autocomplete
  Future<void> getSourceSuggestions(String input) async {
    if (input.isEmpty) {
      sourceSuggestions.clear();
      return;
    }

    isLoadingSuggestions.value = true;
    try {
      final predictions = await _placesService.getPlacePredictions(input);
      sourceSuggestions.value =
          predictions.map((p) => p.description).toList();
    } catch (e) {
      sourceSuggestions.clear();
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  /// Get destination suggestions for autocomplete
  Future<void> getDestinationSuggestions(String input) async {
    if (input.isEmpty) {
      destinationSuggestions.clear();
      return;
    }

    isLoadingSuggestions.value = true;
    try {
      final predictions = await _placesService.getPlacePredictions(input);
      destinationSuggestions.value =
          predictions.map((p) => p.description).toList();
    } catch (e) {
      destinationSuggestions.clear();
    } finally {
      isLoadingSuggestions.value = false;
    }
  }

  /// Get route between source and destination
  Future<void> getRoute() async {
    if (sourceAddress.value.isEmpty || destinationAddress.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter both source and destination',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Get route from Directions API
      final directions = await _directionsService.getRoute(
        origin: sourceAddress.value,
        destination: destinationAddress.value,
      );

      if (directions.errorMessage != null) {
        errorMessage.value = directions.errorMessage!;
        Get.snackbar(
          'Route Error',
          directions.errorMessage!,
          snackPosition: SnackPosition.BOTTOM,
        );
        isLoading.value = false;
        return;
      }

      routeInfo.value = directions;

      // Convert polyline points to LatLng
      final latLngPoints = HomeViewModel.polylinePointsToLatLng(directions);

      if (latLngPoints.isNotEmpty) {
        // Get first and last points for markers
        sourceLocation.value = latLngPoints.first;
        destinationLocation.value = latLngPoints.last;

        // Update markers
        markers.removeWhere((m) =>
            m.markerId.value == 'source' || m.markerId.value == 'destination');
        markers.add(
          Marker(
            markerId: const MarkerId('source'),
            position: latLngPoints.first,
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            infoWindow: const InfoWindow(
              title: 'Source',
              snippet: 'Starting point',
            ),
          ),
        );
        markers.add(
          Marker(
            markerId: const MarkerId('destination'),
            position: latLngPoints.last,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: const InfoWindow(
              title: 'Destination',
              snippet: 'Ending point',
            ),
          ),
        );

        // Draw polyline
        polylines.value = {
          Polyline(
            polylineId: const PolylineId('route'),
            points: latLngPoints,
            color: Colors.blue,
            width: 5,
          ),
        };
      }

      // Fit camera to show entire route
      if (mapController != null &&
          sourceLocation.value != null &&
          destinationLocation.value != null) {
        final bounds = LatLngBounds(
          southwest: LatLng(
            sourceLocation.value!.latitude < destinationLocation.value!.latitude
                ? sourceLocation.value!.latitude
                : destinationLocation.value!.latitude,
            sourceLocation.value!.longitude <
                    destinationLocation.value!.longitude
                ? sourceLocation.value!.longitude
                : destinationLocation.value!.longitude,
          ),
          northeast: LatLng(
            sourceLocation.value!.latitude >
                    destinationLocation.value!.latitude
                ? sourceLocation.value!.latitude
                : destinationLocation.value!.latitude,
            sourceLocation.value!.longitude >
                    destinationLocation.value!.longitude
                ? sourceLocation.value!.longitude
                : destinationLocation.value!.longitude,
          ),
        );
        await mapController!.animateCamera(
          CameraUpdate.newLatLngBounds(bounds, 100),
        );
      }

      isLoading.value = false;
    } catch (e) {
      errorMessage.value = 'Error getting route: $e';
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Failed to get route: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  /// Clear route
  void clearRoute() {
    routeInfo.value = null;
    polylines.clear();
    sourceAddress.value = '';
    destinationAddress.value = '';
    sourceLocation.value = null;
    destinationLocation.value = null;
    markers.removeWhere((m) =>
        m.markerId.value == 'source' || m.markerId.value == 'destination');
  }

  @override
  void onClose() {
    mapController?.dispose();
    super.onClose();
  }
}

