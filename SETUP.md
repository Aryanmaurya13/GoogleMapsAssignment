# Quick Setup Guide

## Step 1: Install Dependencies

```bash
flutter pub get
```

## Step 2: Get Google API Keys

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select an existing one
3. Enable the following APIs:
   - Maps SDK for Android
   - Maps SDK for iOS
   - Directions API
   - Places API
   - Geocoding API
4. Create API keys in "Credentials" section

## Step 3: Add API Keys to Project

### Android (AndroidManifest.xml)
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_ANDROID_MAPS_API_KEY" />
```

### iOS (AppDelegate.swift)
```swift
GMSServices.provideAPIKey("YOUR_ACTUAL_IOS_MAPS_API_KEY")
```

### Dart Files

1. **lib/services/directions_service.dart** (line 7)
   ```dart
   static const String _apiKey = 'YOUR_DIRECTIONS_API_KEY';
   ```

2. **lib/services/geocoding_service.dart** (line 7)
   ```dart
   static const String _apiKey = 'YOUR_GEOCODING_API_KEY';
   ```

3. **lib/widgets/input_fields.dart** (lines 42 and 81)
   ```dart
   googleAPIKey: 'YOUR_PLACES_API_KEY',
   ```

## Step 4: Run the App

```bash
flutter run
```

## Important Notes

- **API Key Restrictions**: For testing, you can use unrestricted keys. For production, set proper restrictions.
- **Billing**: Google Directions API requires billing to be enabled on your Google Cloud project.
- **Same Key**: You can use the same API key for all services if it has all APIs enabled, or use separate keys for better security.

## Troubleshooting

- **Map not showing**: Check API key in AndroidManifest.xml (Android) or AppDelegate.swift (iOS)
- **Routes not working**: Verify Directions API is enabled and billing is set up
- **Autocomplete not working**: Check Places API key in input_fields.dart
- **Location permission**: Grant location permission when prompted


