import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../data/models/directions_model.dart';

/// Home ViewModel - Transforms data for UI presentation
class HomeViewModel {
  /// Convert DirectionsModel polyline points to Google Maps LatLng list
  static List<LatLng> polylinePointsToLatLng(DirectionsModel directions) {
    return directions.polylinePoints
        .map((point) => LatLng(point.latitude, point.longitude))
        .toList();
  }

  /// Format distance for display
  static String formatDistance(String distance) {
    return distance;
  }

  /// Format duration for display
  static String formatDuration(String duration) {
    return duration;
  }
}


