import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/api_keys.dart';

/// Places Service - Handles Google Places API calls
class PlacesService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';

  /// Get place predictions (autocomplete)
  Future<List<PlacePrediction>> getPlacePredictions(String input) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/autocomplete/json?input=${Uri.encodeComponent(input)}&key=${ApiKeys.googlePlacesApiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['predictions'] != null) {
          final predictions = data['predictions'] as List;
          return predictions
              .map((p) => PlacePrediction.fromJson(p as Map<String, dynamic>))
              .toList();
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get place details by place ID
  Future<PlaceDetails?> getPlaceDetails(String placeId) async {
    try {
      final url = Uri.parse(
        '$_baseUrl/details/json?place_id=$placeId&key=${ApiKeys.googlePlacesApiKey}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          return PlaceDetails.fromJson(data['result'] as Map<String, dynamic>);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

/// Place Prediction Model
class PlacePrediction {
  final String description;
  final String placeId;

  PlacePrediction({
    required this.description,
    required this.placeId,
  });

  factory PlacePrediction.fromJson(Map<String, dynamic> json) {
    return PlacePrediction(
      description: json['description'] as String? ?? '',
      placeId: json['place_id'] as String? ?? '',
    );
  }
}

/// Place Details Model
class PlaceDetails {
  final String name;
  final String formattedAddress;
  final double? latitude;
  final double? longitude;

  PlaceDetails({
    required this.name,
    required this.formattedAddress,
    this.latitude,
    this.longitude,
  });

  factory PlaceDetails.fromJson(Map<String, dynamic> json) {
    double? lat;
    double? lng;

    if (json['geometry'] != null) {
      final geometry = json['geometry'] as Map<String, dynamic>;
      if (geometry['location'] != null) {
        final location = geometry['location'] as Map<String, dynamic>;
        lat = (location['lat'] as num?)?.toDouble();
        lng = (location['lng'] as num?)?.toDouble();
      }
    }

    return PlaceDetails(
      name: json['name'] as String? ?? '',
      formattedAddress: json['formatted_address'] as String? ?? '',
      latitude: lat,
      longitude: lng,
    );
  }
}


