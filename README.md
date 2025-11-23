# 🗺️ Google Maps Route Finder

### Prerequisites

- **Flutter SDK**: Version 3.7.2 or higher
- **Dart SDK**: Version 3.7.2 or higher
- **Android Studio** / **Xcode** (for iOS development)
- **Google Cloud Platform** account with billing enabled

### Configure API Keys

#### Android Configuration

1. Open `android/app/src/main/AndroidManifest.xml`
2. Find the `<meta-data>` tag with `com.google.android.geo.API_KEY`
3. Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_ANDROID_MAPS_API_KEY" />
```

#### iOS Configuration

1. Open `ios/Runner/AppDelegate.swift`
2. Find the line with `GMSServices.provideAPIKey`
3. Replace `YOUR_GOOGLE_MAPS_API_KEY` with your actual API key:

```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_IOS_MAPS_API_KEY")
```

#### Dart Code Configuration

1. Open `lib/config/api_keys.dart`
2. Replace all placeholder keys with your actual API keys:

```dart
class ApiKeys {
  static const String googleMapsApiKey = 'YOUR_ACTUAL_MAPS_API_KEY';
  static const String googlePlacesApiKey = 'YOUR_ACTUAL_PLACES_API_KEY';
  static const String googleDirectionsApiKey = 'YOUR_ACTUAL_DIRECTIONS_API_KEY';
  static const String googleGeocodingApiKey = 'YOUR_ACTUAL_GEOCODING_API_KEY';
}
```


## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **get** | ^4.6.6 | State management, dependency injection, and navigation |
| **google_maps_flutter** | ^2.5.0 | Google Maps integration for displaying interactive maps |
| **geolocator** | ^11.0.0 | Location services and GPS position retrieval |
| **permission_handler** | ^11.3.1 | Request and check location permissions |
| **http** | ^1.2.0 | HTTP requests for API calls (Directions, Places, Geocoding) |
| **flutter_polyline_points** | ^2.0.0 | Decode polyline strings from Google Directions API |
| **google_places_flutter** | ^2.0.9 | Google Places Autocomplete for location input |
| **flutter_dotenv** | ^5.1.0 | Environment variable management (optional) |

---

