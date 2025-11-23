import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/directions_model.dart';
import '../../config/api_keys.dart';

/// Directions Service - Handles Google Directions API calls
class DirectionsService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/directions/json';

  /// Get route information between two points
  /// 
  /// [origin] - Starting location (can be address string or "lat,lng")
  /// [destination] - Ending location (can be address string or "lat,lng")
  /// 
  /// Returns DirectionsModel with distance, duration, and polyline points
  Future<DirectionsModel> getRoute({
    required String origin,
    required String destination,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl?origin=${Uri.encodeComponent(origin)}&destination=${Uri.encodeComponent(destination)}&key=${ApiKeys.googleDirectionsApiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          return DirectionsModel.fromJson(data);
        } else {
          final errorMsg = data['error_message'] as String? ?? 
              'Directions API error: ${data['status']}';
          return DirectionsModel.error(errorMsg);
        }
      } else {
        return DirectionsModel.error(
            'Failed to load route: ${response.statusCode}');
      }
    } catch (e) {
      return DirectionsModel.error('Error getting route: $e');
    }
  }

  /// Get route using coordinates
  Future<DirectionsModel> getRouteByCoordinates({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    return getRoute(
      origin: '$originLat,$originLng',
      destination: '$destLat,$destLng',
    );
  }
}


