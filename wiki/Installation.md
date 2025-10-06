# Installation Guide

This guide will walk you through installing and setting up the Facebook WebView OAuth package in your Flutter project.

## 📦 Package Installation

### 1. Add Dependency

Add the package to your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  facebook_webview_oauth: ^1.0.0
```

### 2. Install Package

Run the following command to install the package:

```bash
flutter pub get
```

### 3. Import Package

Import the package in your Dart files:

```dart
import 'package:facebook_webview_oauth/facebook_webview_oauth.dart';
```

## 🔧 Platform Configuration

### Android Configuration

#### 1. Update `android/app/build.gradle`

Ensure your app targets a minimum SDK version that supports WebView:

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 19  // Minimum for WebView support
        targetSdkVersion 34
        // ... other configurations
    }
}
```

#### 2. Add Internet Permission

Add the following permission to `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />

    <application>
        <!-- Your app configuration -->
    </application>
</manifest>
```

#### 3. WebView Configuration (Optional)

For better WebView performance, add to your `MainActivity.kt` or `MainActivity.java`:

**Kotlin (`android/app/src/main/kotlin/.../MainActivity.kt`):**

```kotlin
import io.flutter.embedding.android.FlutterActivity
import android.webkit.WebView

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Enable WebView debugging in debug builds
        if (BuildConfig.DEBUG) {
            WebView.setWebContentsDebuggingEnabled(true)
        }
    }
}
```

### iOS Configuration

#### 1. Update `ios/Runner/Info.plist`

Add the following keys to enable network access and WebView features:

```xml
<dict>
    <!-- Existing keys -->

    <!-- Allow arbitrary loads for development -->
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>

    <!-- Camera and microphone permissions (if needed for Facebook features) -->
    <key>NSCameraUsageDescription</key>
    <string>This app needs camera access for Facebook authentication features.</string>

    <key>NSMicrophoneUsageDescription</key>
    <string>This app needs microphone access for Facebook authentication features.</string>
</dict>
```

#### 2. Minimum iOS Version

Ensure your app targets iOS 11.0 or later in `ios/Runner.xcodeproj/project.pbxproj`:

```
IPHONEOS_DEPLOYMENT_TARGET = 11.0;
```

Or update `ios/Flutter/AppFrameworkInfo.plist`:

```xml
<key>MinimumOSVersion</key>
<string>11.0</string>
```

### Web Configuration (Optional)

If you plan to support web platforms, add the following to `web/index.html`:

```html
<!DOCTYPE html>
<html>
  <head>
    <!-- Existing head content -->

    <!-- Add meta tag for better mobile experience -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  </head>
  <body>
    <!-- Existing body content -->
  </body>
</html>
```

## 🔍 Verify Installation

Create a simple test to verify the package is installed correctly:

```dart
import 'package:flutter/material.dart';
import 'package:facebook_webview_oauth/facebook_webview_oauth.dart';

class FacebookAuthTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Facebook Auth Test')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Test that the package is accessible
            final params = FacebookWebAuthConfigs.basic(
              clientId: 'test_client_id',
            );
            print('Package installed successfully!');
            print('Default scopes: ${params.scopes}');
          },
          child: Text('Test Package'),
        ),
      ),
    );
  }
}
```

## 🚨 Common Installation Issues

### Issue 1: WebView Not Loading

**Problem**: WebView appears blank or doesn't load Facebook login page.

**Solution**:

- Ensure internet permissions are added (Android)
- Check NSAppTransportSecurity settings (iOS)
- Verify minimum SDK/iOS versions

### Issue 2: Build Errors on Android

**Problem**: Build fails with WebView-related errors.

**Solution**:

```gradle
// In android/app/build.gradle
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

### Issue 3: iOS Simulator Issues

**Problem**: WebView doesn't work properly in iOS Simulator.

**Solution**:

- Test on a physical device when possible
- Ensure iOS Simulator is running iOS 11.0+
- Clear simulator data and restart

### Issue 4: Package Version Conflicts

**Problem**: Dependency conflicts with other packages.

**Solution**:

```bash
# Clean and reinstall dependencies
flutter clean
flutter pub get

# Check for conflicts
flutter pub deps
```

## ✅ Installation Checklist

- [ ] Added `facebook_webview_oauth` to `pubspec.yaml`
- [ ] Ran `flutter pub get`
- [ ] Added internet permission (Android)
- [ ] Updated minimum SDK version (Android 19+)
- [ ] Updated minimum iOS version (iOS 11.0+)
- [ ] Added NSAppTransportSecurity settings (iOS)
- [ ] Tested package import in code
- [ ] Verified WebView loads correctly

## 📱 Platform Support

| Platform | Minimum Version | Status          | Notes                     |
| -------- | --------------- | --------------- | ------------------------- |
| Android  | API 19 (4.4)    | ✅ Full Support | Recommended API 21+       |
| iOS      | 11.0            | ✅ Full Support | Works on all devices      |
| Web      | Any             | ⚠️ Limited      | WebView limitations apply |
| macOS    | 10.14           | ⚠️ Limited      | Desktop WebView           |
| Windows  | Any             | ⚠️ Limited      | Desktop WebView           |
| Linux    | Any             | ⚠️ Limited      | Desktop WebView           |

## 🔄 Next Steps

Once installation is complete, proceed to:

1. **[Facebook App Setup](Facebook-App-Setup)** - Configure your Facebook App
2. **[Quick Start](Quick-Start)** - Implement basic authentication
3. **[Configuration Options](Configuration-Options)** - Customize the experience

## 🆘 Need Help?

If you encounter any installation issues:

1. Check the [FAQ](FAQ) for common solutions
2. Search [GitHub Issues](https://github.com/draz26648/facebook_webview_oauth/issues)
3. Create a new issue with your error details
4. Email support: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)
