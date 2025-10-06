# Frequently Asked Questions (FAQ)

Common questions and answers about the Facebook WebView OAuth package.

## 🚀 Getting Started

### Q: Why should I use this package instead of Facebook's official SDK?

**A:** This package offers several advantages:

- **Bypasses Limited Login**: Provides full access to business permissions that Limited Login restricts
- **Better Control**: Complete control over the authentication flow and UI
- **No Native Dependencies**: Pure Flutter implementation without platform-specific setup
- **Business-Focused**: Specifically designed for business applications requiring ads management
- **Comprehensive Error Handling**: Detailed error states and recovery mechanisms

### Q: What's the difference between this and Facebook's Limited Login?

**A:** Limited Login is Facebook's new default that restricts access to advanced permissions and business features. This package uses WebView-based OAuth to bypass those restrictions and provide full access to:

- Ads Management API
- Business Manager API
- Advanced user data
- Page management features
- Instagram business features

### Q: Is this package production-ready?

**A:** Yes! The package is designed for production use with:

- ✅ Comprehensive error handling
- ✅ Security best practices (CSRF protection)
- ✅ Extensive unit testing
- ✅ Support for custom redirect URIs
- ✅ Timeout and cancellation handling
- ✅ Memory leak prevention

## 🔧 Installation & Setup

### Q: What are the minimum requirements?

**A:**

- **Flutter**: 3.0.0 or later
- **Dart**: 3.0.0 or later
- **Android**: API 19 (Android 4.4) or later
- **iOS**: iOS 11.0 or later

### Q: Do I need to configure anything platform-specific?

**A:** Minimal platform configuration required:

**Android:**

- Internet permission in `AndroidManifest.xml`
- Minimum SDK 19

**iOS:**

- NSAppTransportSecurity settings for network access
- Minimum iOS 11.0

See the [Installation Guide](Installation) for detailed setup.

### Q: Can I use this package with web platforms?

**A:** Limited support for web platforms. WebView functionality is restricted on web, so we recommend using this package primarily for mobile platforms (iOS/Android).

## 🏗️ Facebook App Configuration

### Q: Do I need a Facebook Developer account?

**A:** Yes, you need:

1. Facebook Developer account
2. Facebook App created in the Developer Console
3. Facebook Login product added to your app
4. Proper OAuth redirect URIs configured

### Q: What's a Config ID and do I need one?

**A:** A Config ID is a Facebook App Configuration that helps avoid Limited Login restrictions. It's:

- **Highly recommended** for business applications
- **Required** for advanced permissions
- **Optional** for basic user authentication

Create one in your Facebook App settings under Facebook Login > Settings.

### Q: How do I get my app approved for business permissions?

**A:** For permissions requiring review:

1. Go to App Review in your Facebook App
2. Request specific permissions
3. Provide detailed use case descriptions
4. Submit video demonstrations
5. Wait for Facebook's review (3-7 days typically)

### Q: My app is in development mode. Can I still test?

**A:** Yes! Development mode allows:

- Testing with developers and test users
- Access to most permissions without review
- Up to 100 test users
- Full functionality for testing

## 🔐 Authentication & Permissions

### Q: What permissions can I request?

**A:** The package supports all Facebook permissions:

**Basic (No Review Required):**

- `public_profile` - Basic profile info
- `email` - User's email address

**Business (May Require Review):**

- `ads_management` - Manage ads
- `ads_read` - Read ad data
- `business_management` - Manage business assets
- `pages_show_list` - List pages
- `instagram_basic` - Instagram access

See [Permission Management](Permission-Management) for complete list.

### Q: What happens if a user declines permissions?

**A:** The package handles this gracefully:

```dart
result.when(
  success: (token, expires, granted, declined) {
    // Some permissions granted, some declined
    if (declined.isNotEmpty) {
      _handleOptionalPermissions(declined);
    }
  },
  permissionsDeclined: (declined) {
    // All permissions declined
    _showPermissionExplanation(declined);
  },
);
```

You can re-request declined permissions using `rerequestDeclinedPermissions: true`.

### Q: How long do access tokens last?

**A:** Facebook access tokens typically last:

- **User tokens**: 60 days (can be extended)
- **Page tokens**: 60 days (can be made permanent)
- **App tokens**: Never expire

The package provides the `expiresIn` duration in the success callback.

### Q: Can I refresh expired tokens?

**A:** Facebook doesn't provide refresh tokens for user access tokens. When a token expires, users need to re-authenticate. The package will return appropriate errors for expired tokens.

## 🌐 Custom Redirect URIs

### Q: Do I need to use custom redirect URIs?

**A:** No, it's optional. The package works with Facebook's default redirect URI:

```
https://www.facebook.com/connect/login_success.html
```

Custom redirect URIs are useful for:

- Branding consistency
- Custom landing pages
- Server-side token processing

### Q: What domains can I use for redirect URIs?

**A:** You can use any domain you control, but:

- Must be HTTPS (except localhost for development)
- Must be added to your Facebook App's "Valid OAuth Redirect URIs"
- Domain must be added to "App Domains"
- Must be accessible and return a valid response

### Q: Can I use localhost for development?

**A:** Yes! For development, you can use:

```
http://localhost:3000/auth/facebook/callback
https://localhost:3000/auth/facebook/callback
```

Add these to your Facebook App's redirect URIs for testing.

## 🔧 Technical Issues

### Q: WebView shows blank screen or doesn't load

**A:** Common solutions:

1. **Check internet permissions** (Android)
2. **Verify NSAppTransportSecurity settings** (iOS)
3. **Ensure Facebook App ID is correct**
4. **Check Facebook App is active and not restricted**
5. **Verify redirect URIs are configured correctly**

### Q: Getting "Invalid App ID" error

**A:** Verify:

- Facebook App ID is correct (no spaces or extra characters)
- Facebook App is active (not in restricted mode)
- App has Facebook Login product added
- You're using the correct App ID for your environment (dev/prod)

### Q: Authentication works in development but fails in production

**A:** Check:

- Facebook App is switched to "Live" mode
- Production redirect URIs are configured
- Business verification completed (if required)
- Required permissions approved through App Review
- HTTPS certificates are valid

### Q: Getting CORS errors on web platform

**A:** Web platform has limitations with WebView. Consider:

- Using the package primarily on mobile platforms
- Implementing server-side OAuth for web
- Using Facebook's JavaScript SDK for web

### Q: Memory leaks or performance issues

**A:** The package includes memory management:

```dart
// Always close Graph API clients
final client = FacebookGraphClient(accessToken: token);
try {
  // Use client
} finally {
  client.close(); // Important: releases resources
}
```

## 🛠️ Development & Testing

### Q: How do I test with different users?

**A:** Use Facebook Test Users:

1. Go to your Facebook App dashboard
2. Navigate to Roles > Test Users
3. Create test users with required permissions
4. Use test user credentials during development

### Q: Can I test without a real Facebook account?

**A:** Yes, using Facebook Test Users (see above). Test users:

- Don't require real Facebook accounts
- Can be granted permissions without app review
- Are isolated from real Facebook data
- Perfect for development and testing

### Q: How do I debug authentication issues?

**A:** Enable debug logging:

```dart
import 'package:flutter/foundation.dart';

// Debug prints are automatically enabled in debug mode
// Check console output for detailed authentication flow
```

Also check:

- Facebook App Event Logs
- Browser developer tools (for redirect URI issues)
- Device logs for WebView errors

### Q: Can I customize the WebView appearance?

**A:** The WebView displays Facebook's login page, which can't be customized. However, you can:

- Customize your app's UI around the authentication flow
- Use custom redirect URIs with branded landing pages
- Implement custom loading and error states

## 📊 Graph API Integration

### Q: How do I make Facebook API calls after authentication?

**A:** Use the built-in Graph API client:

```dart
result.when(
  success: (token, expires, granted, declined) async {
    final client = FacebookGraphClient(accessToken: token);

    try {
      final userData = await client.getMe();
      final adAccounts = await client.getAdAccounts();
    } finally {
      client.close();
    }
  },
);
```

### Q: What Graph API endpoints are supported?

**A:** The package includes built-in methods for common endpoints:

- `/me` - User profile data
- `/me/adaccounts` - Ad accounts
- `/me/businesses` - Business accounts
- `/me/accounts` - Pages

Plus a `customRequest()` method for any other endpoint.

### Q: How do I handle API rate limits?

**A:** Facebook enforces rate limits. The Graph API client includes:

- Automatic error detection for rate limit errors
- Proper error messages for rate limit issues
- Recommendations to implement exponential backoff

### Q: Can I use the access token with other HTTP clients?

**A:** Yes! The access token is a standard Facebook token that works with any HTTP client:

```dart
final response = await http.get(
  Uri.parse('https://graph.facebook.com/me?access_token=$accessToken'),
);
```

## 🔒 Security & Privacy

### Q: How should I store access tokens?

**A:** Use secure storage:

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

// Store token securely
await storage.write(key: 'facebook_token', value: accessToken);

// Retrieve token
final token = await storage.read(key: 'facebook_token');
```

### Q: Is the authentication flow secure?

**A:** Yes, the package implements security best practices:

- ✅ CSRF protection with state parameter validation
- ✅ HTTPS enforcement for production
- ✅ URL validation and sanitization
- ✅ Secure token extraction from URL fragments
- ✅ Protection against mobile redirect attacks

### Q: What data does Facebook collect during authentication?

**A:** Facebook collects standard OAuth data:

- App usage for their analytics
- User consent for requested permissions
- Basic device/browser information
- IP address and location data

The package doesn't collect any additional data beyond what Facebook's OAuth requires.

### Q: How do I comply with privacy regulations (GDPR, CCPA)?

**A:** Ensure compliance by:

1. **Obtaining user consent** before authentication
2. **Clearly explaining** what data you'll access
3. **Providing opt-out mechanisms** for users
4. **Implementing data deletion** when users revoke access
5. **Following Facebook's privacy policies**

## 🚨 Troubleshooting

### Q: "Can't Load URL" error in WebView

**A:** This usually means:

- Facebook App domains not configured correctly
- Redirect URI not in allowed list
- App in restricted mode
- Network connectivity issues

### Q: "Domain of this URL isn't included in the app's domains"

**A:** Add your domain to Facebook App settings:

1. Go to Settings > Basic
2. Add domain to "App Domains" (without http/https)
3. Ensure redirect URI is in "Valid OAuth Redirect URIs"

### Q: Authentication succeeds but Graph API calls fail

**A:** Check:

- Access token is valid and not expired
- Required permissions were granted (not declined)
- Facebook App has necessary permissions approved
- API endpoints are correct

### Q: Package conflicts with other dependencies

**A:** Common solutions:

```bash
# Clean and reinstall dependencies
flutter clean
flutter pub get

# Check for conflicts
flutter pub deps

# Update conflicting packages
flutter pub upgrade
```

## 📱 Platform-Specific Issues

### Q: iOS Simulator issues

**A:** iOS Simulator limitations:

- Test on physical devices when possible
- Ensure simulator runs iOS 11.0+
- Clear simulator data if issues persist
- Some WebView features may not work in simulator

### Q: Android build errors

**A:** Common Android fixes:

```gradle
// In android/app/build.gradle
android {
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

### Q: Web platform limitations

**A:** Web platform has restrictions:

- Limited WebView functionality
- CORS restrictions
- Consider server-side OAuth for web
- Use Facebook JavaScript SDK as alternative

## 🔄 Migration & Updates

### Q: How do I update to newer versions?

**A:** Standard Flutter package update:

```bash
flutter pub upgrade facebook_webview_oauth
```

Check the [CHANGELOG](https://github.com/draz26648/facebook_webview_oauth/blob/main/CHANGELOG.md) for breaking changes.

### Q: Will my existing tokens work after updates?

**A:** Yes, access tokens are independent of the package version. However:

- Token format may change with Facebook API updates
- New permissions may require re-authentication
- Always test thoroughly after updates

## 🆘 Getting Help

### Q: Where can I get additional support?

**A:** Multiple support channels:

1. **Documentation**: Check all wiki pages for detailed guides
2. **GitHub Issues**: [Report bugs or request features](https://github.com/draz26648/facebook_webview_oauth/issues)
3. **Email Support**: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)
4. **Facebook Developer Community**: For Facebook-specific questions

### Q: How do I report a bug?

**A:** When reporting bugs, include:

1. **Package version** you're using
2. **Flutter version** and platform (iOS/Android)
3. **Facebook App configuration** (without sensitive data)
4. **Complete error messages** and stack traces
5. **Steps to reproduce** the issue
6. **Expected vs actual behavior**

### Q: Can I contribute to the package?

**A:** Yes! Contributions are welcome:

1. Fork the repository
2. Create a feature branch
3. Make your changes with tests
4. Submit a pull request
5. Follow the contribution guidelines

---

## 📚 Additional Resources

- **[Quick Start Guide](Quick-Start)** - Get started in 5 minutes
- **[Configuration Options](Configuration-Options)** - Customize authentication
- **[API Reference](API-Reference)** - Complete API documentation
- **[Error Codes](Error-Codes)** - Detailed error explanations
- **[Facebook Developer Docs](https://developers.facebook.com/docs/)** - Official Facebook documentation

---

**Still have questions?** Feel free to [create an issue](https://github.com/draz26648/facebook_webview_oauth/issues) or contact support at [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com).

**FAQ Last Updated:** October 6, 2024
