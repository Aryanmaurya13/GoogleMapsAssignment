# 🗺️ Google Maps Route Finder

A professional Flutter application demonstrating Google Maps integration, location services, marker interaction, and route calculation using Google Directions API. Built with **GetX** state management following **Clean MVVM Architecture**.

## 📋 Table of Contents

- [Project Overview](#-project-overview)
- [Setup Instructions](#-setup-instructions)
- [Dependencies](#-dependencies)
- [Architecture](#-architecture-explanation)
- [Features](#-features)
- [Project Structure](#-project-structure)
- [How It Works](#-how-it-works)
- [Future Improvements](#-future-improvements)

---

## 🎯 Project Overview

### What is this project?

This is a Flutter mobile application that allows users to:
- View their current location on an interactive Google Map
- Drop custom markers by tapping on the map
- Find routes between two locations using Google Directions API
- View route distance and estimated travel time
- Use Google Places Autocomplete for easy location input

### Technology Stack

- **Flutter**: Cross-platform mobile framework
- **GetX**: State management, dependency injection, and navigation
- **Google Maps Flutter**: Interactive map display
- **Geolocator**: Location services and permissions
- **Google Directions API**: Route calculation
- **Google Places API**: Location autocomplete

### Problems It Solves

- ✅ Seamless location-based navigation
- ✅ Real-time route planning with distance and duration
- ✅ Intuitive map interaction with custom markers
- ✅ Clean, maintainable code architecture
- ✅ Reactive UI updates without manual state management

---

## 🚀 Setup Instructions

### Prerequisites

- **Flutter SDK**: Version 3.7.2 or higher
- **Dart SDK**: Version 3.7.2 or higher
- **Android Studio** / **Xcode** (for iOS development)
- **Google Cloud Platform** account with billing enabled

### Step 1: Clone and Install

```bash
# Clone the repository
git clone <repository-url>
cd assisment

# Install dependencies
flutter pub get
```

### Step 2: Get Google API Keys

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - **Maps SDK for Android**
   - **Maps SDK for iOS**
   - **Directions API**
   - **Places API**
   - **Geocoding API**
4. Create API keys in **APIs & Services** > **Credentials**
5. **Important**: Enable billing for your project (required for Directions API)

### Step 3: Configure API Keys

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

**Note**: You can use the same API key for all services if it has all required APIs enabled.

### Step 4: Run the Application

```bash
# For Android
flutter run

# For iOS
flutter run

# Or use your IDE's run button
```

---

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

## 🏗️ Architecture Explanation

### What is MVVM?

**MVVM (Model-View-ViewModel)** is an architectural pattern that separates code into three distinct layers:

- **Model**: Data structures and business entities
- **View**: User interface (UI) - displays data and captures user input
- **ViewModel**: Transforms model data for presentation in the view
- **Controller** (GetX): Handles business logic and state management

### Why MVVM for This Project?

- ✅ **Separation of Concerns**: UI, business logic, and data are clearly separated
- ✅ **Testability**: Each layer can be tested independently
- ✅ **Maintainability**: Easy to locate and modify specific functionality
- ✅ **Scalability**: Easy to add new features without affecting existing code

### Role of Each Component

#### **Views** (`modules/home/views/`)
- **Purpose**: Display UI only, no business logic
- **Example**: `home_view.dart` - Shows the map, buttons, and input fields
- **Uses**: `GetView<HomeController>` to access controller automatically

#### **ViewModels** (`modules/home/viewmodels/`)
- **Purpose**: Transform data models for UI presentation
- **Example**: `home_viewmodel.dart` - Converts polyline points to Google Maps LatLng format
- **Benefit**: Keeps data transformation logic separate from views

#### **Controllers** (`modules/home/controllers/`)
- **Purpose**: Business logic and state management
- **Example**: `home_controller.dart` - Manages map state, markers, routes, permissions
- **Uses**: GetX reactive variables (`.obs`) for automatic UI updates

#### **Services** (`data/services/`)
- **Purpose**: Handle external API calls and platform-specific operations
- **Examples**:
  - `location_service.dart` - Location permissions and GPS
  - `directions_service.dart` - Google Directions API calls
  - `places_service.dart` - Google Places Autocomplete API

#### **Models** (`data/models/`)
- **Purpose**: Data structures and entities
- **Example**: `directions_model.dart` - Represents route information (distance, duration, polyline)

### What GetX Provides

1. **State Management**
   - Reactive variables using `.obs`
   - Automatic UI updates with `Obx()` widget
   - No need for `setState()`

2. **Dependency Injection**
   - Automatic service registration with `Get.put()`
   - Lazy loading with `Get.lazyPut()`
   - Automatic controller injection with `GetView`

3. **Navigation**
   - Route management with `GetMaterialApp`
   - Named routes with `GetPage`
   - Easy navigation with `Get.to()`, `Get.back()`

---

## ✨ Features

### 1. Location Permission Handling

**What it does**: Requests and manages location permissions gracefully.

**How it's implemented**:
- Uses `LocationService` to check permission status
- Requests permission if denied
- Shows error messages if permanently denied
- Handles both Android and iOS permission flows

**Files**:
- `data/services/location_service.dart`
- `modules/home/controllers/home_controller.dart` (initializeLocation method)

### 2. Showing User's Current Location

**What it does**: Displays the user's current position on the map and centers the view.

**How it's implemented**:
- `LocationService` retrieves GPS coordinates using `Geolocator`
- Controller stores position in reactive variable
- Map centers on position when loaded
- Blue dot shows current location (myLocationEnabled: true)

**Files**:
- `data/services/location_service.dart`
- `modules/home/controllers/home_controller.dart` (centerOnCurrentLocation method)

### 3. Dropping Markers on Map

**What it does**: Allows users to tap anywhere on the map to place a marker.

**How it's implemented**:
- Map's `onTap` callback captures tap coordinates
- Controller's `addMarker()` creates a new `Marker` object
- Marker added to reactive `RxSet<Marker>`
- UI automatically updates via `Obx()`

**Files**:
- `modules/home/controllers/home_controller.dart` (addMarker method)
- `modules/home/views/home_view.dart` (GoogleMap onTap)

### 4. Drawing Polylines Using Google Directions API

**What it does**: Draws a route line between source and destination on the map.

**How it's implemented**:
- User enters source and destination addresses
- `DirectionsService` calls Google Directions API
- API returns encoded polyline string
- `DirectionsModel` decodes polyline to coordinate points
- Controller creates `Polyline` object with decoded points
- Map displays polyline in blue color

**Files**:
- `data/services/directions_service.dart`
- `data/models/directions_model.dart` (_decodePolyline method)
- `modules/home/controllers/home_controller.dart` (getRoute method)

### 5. Calculating Distance & Duration

**What it does**: Displays route distance and estimated travel time.

**How it's implemented**:
- Google Directions API returns distance and duration in response
- `DirectionsModel` extracts this information
- Controller stores in reactive `routeInfo` variable
- `DistanceInfo` widget displays in bottom card

**Files**:
- `data/models/directions_model.dart`
- `modules/home/widgets/distance_info.dart`
- `modules/home/controllers/home_controller.dart`

### 6. Google Places Autocomplete

**What it does**: Provides location suggestions as user types in source/destination fields.

**How it's implemented**:
- `PlacesService` calls Google Places Autocomplete API
- Returns list of matching place predictions
- Controller stores suggestions in reactive list
- `InputFields` widget displays suggestions below text field
- User taps suggestion to select

**Files**:
- `data/services/places_service.dart`
- `modules/home/controllers/home_controller.dart` (getSourceSuggestions, getDestinationSuggestions)
- `modules/home/widgets/input_fields.dart`

### 7. Clear Markers Button

**What it does**: Removes all markers and routes from the map.

**How it's implemented**:
- Floating action button calls `clearMarkers()` and `clearRoute()`
- Controller clears reactive marker and polyline sets
- UI automatically updates

**Files**:
- `modules/home/controllers/home_controller.dart` (clearMarkers, clearRoute methods)
- `modules/home/views/home_view.dart` (Clear Markers FAB)

### 8. My Location Button

**What it does**: Re-centers the map on the user's current location.

**How it's implemented**:
- Floating action button calls `centerOnCurrentLocation()`
- Controller animates map camera to current position
- Uses `GoogleMapController.animateCamera()`

**Files**:
- `modules/home/controllers/home_controller.dart` (centerOnCurrentLocation method)
- `modules/home/views/home_view.dart` (My Location FAB)

---

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point
│
├── routes/                            # GetX routing
│   ├── app_routes.dart               # Route name constants
│   └── app_pages.dart                # Route definitions with bindings
│
├── core/                             # Core functionality
│   └── bindings/
│       └── home_binding.dart         # Dependency injection bindings
│
├── modules/                           # Feature modules (MVVM)
│   └── home/
│       ├── controllers/
│       │   └── home_controller.dart  # Business logic & state management
│       ├── viewmodels/
│       │   └── home_viewmodel.dart  # Data transformation for UI
│       ├── views/
│       │   └── home_view.dart       # UI only (no logic)
│       └── widgets/
│           ├── input_fields.dart     # Source/Destination input widgets
│           └── distance_info.dart   # Route info display widget
│
├── data/                             # Data layer
│   ├── models/
│   │   └── directions_model.dart    # Route data model
│   └── services/
│       ├── directions_service.dart  # Google Directions API
│       ├── location_service.dart    # Location & permissions
│       └── places_service.dart      # Google Places API
│
└── config/
    └── api_keys.dart                 # API keys configuration
```

### Folder Responsibilities

- **`modules/`**: Feature-based organization, each feature has its own folder
- **`controllers/`**: Business logic and state management
- **`viewmodels/`**: Data transformation for UI presentation
- **`views/`**: Pure UI components
- **`services/`**: External API calls and platform services
- **`models/`**: Data structures and entities
- **`widgets/`**: Reusable UI components
- **`routes/`**: Navigation and routing configuration
- **`config/`**: Configuration files (API keys, constants)

---

## 🔄 How It Works

### Step-by-Step Flow

#### 1. **App Launches**
   - `main.dart` runs
   - `Get.put(LocationService())` registers location service
   - `GetMaterialApp` initializes with routes
   - App navigates to `HomeView`

#### 2. **Permissions Requested**
   - `HomeController.onInit()` called automatically
   - Controller calls `initializeLocation()`
   - `LocationService` checks if location services enabled
   - Requests location permission if needed
   - Shows error dialog if denied

#### 3. **Controller Fetches Location**
   - `LocationService.getCurrentPosition()` called
   - GPS coordinates retrieved
   - Stored in `currentPosition` reactive variable
   - `isLoading` set to false

#### 4. **Map Loads**
   - `HomeView` builds with `GetView<HomeController>`
   - `GoogleMap` widget created with initial position
   - `onMapCreated` callback sets map controller
   - Map centers on user location

#### 5. **User Taps → Marker Added**
   - User taps anywhere on map
   - `onTap` callback fires with `LatLng` coordinates
   - Controller's `addMarker()` called
   - New `Marker` added to `markers` reactive set
   - UI automatically updates (Obx rebuilds)

#### 6. **User Enters Source/Destination → Places Autocomplete**
   - User types in source field
   - `onChanged` callback triggers
   - Controller calls `getSourceSuggestions()`
   - `PlacesService` queries Google Places API
   - Suggestions stored in `sourceSuggestions` reactive list
   - UI shows dropdown with suggestions
   - User selects suggestion → address stored

#### 7. **DirectionsService → Fetch Route**
   - User taps "Get Route" button
   - Controller's `getRoute()` called
   - `DirectionsService.getRoute()` makes HTTP request to Google Directions API
   - API returns JSON with route data
   - `DirectionsModel.fromJson()` parses response
   - Extracts: distance, duration, encoded polyline

#### 8. **Controller → Updates Polyline + Distance + Duration**
   - Polyline decoded to coordinate points
   - `Polyline` object created with points
   - Added to `polylines` reactive set
   - Source/destination markers added
   - `routeInfo` reactive variable updated
   - Map camera animates to show entire route

#### 9. **View → Automatically Updates Using GetX**
   - All reactive variables changed (`.obs`)
   - `Obx()` widgets detect changes
   - UI automatically rebuilds
   - Map shows polyline
   - Bottom card shows distance and duration
   - No manual `setState()` needed!

### Reactive Updates Example

```dart
// In Controller
final RxBool isLoading = false.obs;
final RxSet<Marker> markers = <Marker>{}.obs;

// In View
Obx(() => isLoading.value 
    ? CircularProgressIndicator() 
    : GoogleMap(markers: markers))
```

When `isLoading` or `markers` changes, `Obx()` automatically rebuilds the widget tree.

---

## 🚀 Future Improvements

### 1. **Offline Maps**
   - Cache map tiles for offline use
   - Store recent routes locally
   - Use `flutter_map` or similar for offline support

### 2. **Multiple Stop Routing**
   - Allow users to add waypoints between source and destination
   - Calculate routes with multiple stops
   - Optimize route order

### 3. **Saving Favorite Locations**
   - Local storage for saved locations
   - Quick access to frequently used places
   - Share favorites between devices

### 4. **Better UI Polish**
   - Custom map styles
   - Animations for route drawing
   - Dark mode support
   - Custom marker icons
   - Route alternatives display

### 5. **Advanced Features**
   - Real-time traffic information
   - Route sharing via link
   - Turn-by-turn navigation
   - Route history
   - Estimated fuel cost calculation

### 6. **Performance Optimizations**
   - Debounce autocomplete API calls
   - Cache API responses
   - Lazy load map markers
   - Optimize polyline rendering

---

## 📝 Additional Notes

### API Key Security

For production apps, consider:
- Using environment variables (`.env` file)
- Restricting API keys by package name/bundle ID
- Using separate keys for different environments
- Never committing API keys to version control

### Error Handling

The app includes error handling for:
- Location permission denials
- Network failures
- Invalid API responses
- Missing location services

### Testing

To test the app:
1. Grant location permission when prompted
2. Tap map to add markers
3. Enter valid addresses in source/destination fields
4. Tap "Get Route" to see route calculation
5. Use floating buttons to clear markers or re-center map

---

## 🤝 Contributing

This is an educational project demonstrating GetX + MVVM architecture with Google Maps integration. Feel free to fork, modify, and use as a learning resource.

---

## 📄 License

This project is created for educational purposes.

---

## 🙏 Acknowledgments

- Google Maps Platform for excellent mapping APIs
- GetX team for powerful state management solution
- Flutter team for the amazing framework

---

**Happy Coding! 🚀**
