# Google Maps Route Finder - GetX + MVVM Architecture

A complete Flutter application demonstrating Google Maps integration, location permissions, marker interaction, and route drawing using Google Directions API. Built with **GetX** state management following **Clean MVVM Architecture**.

## Architecture

### Project Structure

```
lib/
├── main.dart                    # App entry point with GetMaterialApp
├── routes/
│   ├── app_routes.dart         # Route name constants
│   └── app_pages.dart          # GetX route definitions
├── core/
│   └── bindings/
│       └── home_binding.dart   # Dependency injection bindings
├── modules/
│   └── home/
│       ├── controllers/
│       │   └── home_controller.dart    # Business logic & state management
│       ├── viewmodels/
│       │   └── home_viewmodel.dart     # UI data transformation
│       ├── views/
│       │   └── home_view.dart          # UI only (no logic)
│       └── widgets/
│           ├── input_fields.dart        # Source/Destination inputs
│           └── distance_info.dart      # Route info display
├── data/
│   ├── models/
│   │   └── directions_model.dart       # Data models
│   └── services/
│       ├── directions_service.dart     # Directions API service
│       ├── location_service.dart       # Location & permissions service
│       └── places_service.dart         # Places API service
└── config/
    └── api_keys.dart                    # API keys configuration
```

## Architecture Principles

### MVVM Pattern

- **Model**: `DirectionsModel`, `LatLngPoint` - Data structures
- **View**: `HomeView` - UI only, uses `GetView<HomeController>`
- **ViewModel**: `HomeViewModel` - Transforms data for UI presentation
- **Controller**: `HomeController` - Business logic, state management with GetX

### GetX Features Used

- **State Management**: `Rx` variables, `Obx`, `GetBuilder`
- **Dependency Injection**: `Get.put()`, `Get.find()`, `Bindings`
- **Navigation**: `GetMaterialApp`, `GetPage`, route management
- **Snackbars**: `Get.snackbar()` for error messages

## Features

### Core Features ✅
- **Map Display**: Google Map centered on user's current location
- **Location Permissions**: Handles location permission requests gracefully
- **Marker Interaction**: Tap on map to drop markers that persist until cleared
- **Route Drawing**: Draw routes between source and destination using Google Directions API
- **Distance & Duration**: Display route information in a bottom panel

### Bonus Features ✅
- **Google Places Autocomplete**: Both source and destination fields support autocomplete
- **Clear Markers Button**: Floating action button to clear all markers
- **My Location Button**: Floating action button to re-center map on current location

## Key Components

### HomeController
- Manages all map state using GetX reactive variables
- Handles location permissions and position retrieval
- Manages markers and polylines
- Fetches routes from Directions API
- Handles Places autocomplete suggestions

### Services
- **LocationService**: Handles Geolocator operations and permissions
- **DirectionsService**: Google Directions API integration
- **PlacesService**: Google Places API for autocomplete

### ViewModel
- Transforms data models for UI presentation
- Converts polyline points to Google Maps LatLng format

## Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure API Keys

Update `lib/config/api_keys.dart` with your Google API keys:

```dart
class ApiKeys {
  static const String googleMapsApiKey = 'YOUR_API_KEY';
  static const String googlePlacesApiKey = 'YOUR_API_KEY';
  static const String googleDirectionsApiKey = 'YOUR_API_KEY';
  static const String googleGeocodingApiKey = 'YOUR_API_KEY';
}
```

Also update:
- `android/app/src/main/AndroidManifest.xml` - Maps API key
- `ios/Runner/AppDelegate.swift` - Maps API key

### 3. Run the App

```bash
flutter run
```

## GetX State Management

### Reactive Variables

```dart
// In Controller
final Rx<Position?> currentPosition = Rx<Position?>(null);
final RxBool isLoading = false.obs;
final RxSet<Marker> markers = <Marker>{}.obs;
```

### Using in Views

```dart
// Obx for reactive updates
Obx(() => Text(controller.sourceAddress.value))

// GetView for automatic controller access
class HomeView extends GetView<HomeController> {
  Widget build(BuildContext context) {
    return Obx(() => ...);
  }
}
```

## Dependencies

- `get: ^4.6.6` - GetX state management
- `google_maps_flutter: ^2.5.0` - Google Maps
- `geolocator: ^11.0.0` - Location services
- `permission_handler: ^11.3.1` - Permissions
- `http: ^1.2.0` - HTTP requests
- `flutter_polyline_points: ^2.0.0` - Polyline decoding
- `google_places_flutter: ^2.0.9` - Places autocomplete

## Architecture Benefits

1. **Separation of Concerns**: Clear separation between UI, business logic, and data
2. **Testability**: Services and controllers can be easily unit tested
3. **Maintainability**: Clean structure makes code easy to understand and modify
4. **Reactivity**: GetX provides efficient reactive state management
5. **Dependency Injection**: GetX handles DI automatically through bindings

## Code Examples

### Controller with GetX

```dart
class HomeController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxSet<Marker> markers = <Marker>{}.obs;
  
  void addMarker(LatLng position) {
    markers.add(Marker(...));
  }
}
```

### View with GetView

```dart
class HomeView extends GetView<HomeController> {
  Widget build(BuildContext context) {
    return Obx(() => Text(controller.isLoading.value ? 'Loading...' : 'Ready'));
  }
}
```

### Binding for Dependency Injection

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
```

## Notes

- All state is managed through GetX reactive variables
- Views contain zero business logic
- Controllers handle all business logic and state
- Services handle API calls and data operations
- ViewModels transform data for UI presentation


