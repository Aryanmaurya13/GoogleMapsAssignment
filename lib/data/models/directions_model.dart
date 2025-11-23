/// Directions Model - Represents route information from Google Directions API
class DirectionsModel {
  final String distance;
  final String duration;
  final List<LatLngPoint> polylinePoints;
  final String? errorMessage;

  DirectionsModel({
    required this.distance,
    required this.duration,
    required this.polylinePoints,
    this.errorMessage,
  });

  factory DirectionsModel.fromJson(Map<String, dynamic> json) {
    try {
      final routes = json['routes'] as List?;
      if (routes == null || routes.isEmpty) {
        return DirectionsModel(
          distance: '0 km',
          duration: '0 mins',
          polylinePoints: [],
          errorMessage: 'No route found',
        );
      }

      final route = routes[0] as Map<String, dynamic>;
      final legs = route['legs'] as List;
      if (legs.isEmpty) {
        return DirectionsModel(
          distance: '0 km',
          duration: '0 mins',
          polylinePoints: [],
          errorMessage: 'No route legs found',
        );
      }

      final leg = legs[0] as Map<String, dynamic>;
      final distance = leg['distance'] as Map<String, dynamic>;
      final duration = leg['duration'] as Map<String, dynamic>;
      final overviewPolyline = route['overview_polyline'] as Map<String, dynamic>;
      final encodedPolyline = overviewPolyline['points'] as String;

      return DirectionsModel(
        distance: distance['text'] as String? ?? '0 km',
        duration: duration['text'] as String? ?? '0 mins',
        polylinePoints: _decodePolyline(encodedPolyline),
      );
    } catch (e) {
      return DirectionsModel(
        distance: '0 km',
        duration: '0 mins',
        polylinePoints: [],
        errorMessage: 'Error parsing route: $e',
      );
    }
  }

  factory DirectionsModel.error(String message) {
    return DirectionsModel(
      distance: '0 km',
      duration: '0 mins',
      polylinePoints: [],
      errorMessage: message,
    );
  }

  /// Decode polyline string to list of coordinates
  static List<LatLngPoint> _decodePolyline(String encoded) {
    List<LatLngPoint> poly = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      poly.add(LatLngPoint(
        latitude: lat / 1e5,
        longitude: lng / 1e5,
      ));
    }
    return poly;
  }
}

/// LatLng Point Model
class LatLngPoint {
  final double latitude;
  final double longitude;

  LatLngPoint({
    required this.latitude,
    required this.longitude,
  });

  Map<String, double> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}


