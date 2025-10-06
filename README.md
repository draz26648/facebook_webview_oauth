# Facebook WebView OAuth

[![pub package](https://img.shields.io/pub/v/facebook_webview_oauth.svg)](https://pub.dev/packages/facebook_webview_oauth)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A Flutter package for Facebook OAuth authentication using WebView. This package bypasses Facebook's Limited Login restrictions and provides full Business permissions access, making it ideal for applications that need comprehensive Facebook integration.

## Features

- ✅ **Full Business Permissions**: Bypasses Limited Login to access all Facebook Business features
- ✅ **WebView-Based Authentication**: Uses `flutter_inappwebview` for secure OAuth flow
- ✅ **Comprehensive Error Handling**: Detailed error states and user-friendly messages
- ✅ **Graph API Client**: Built-in client for Facebook Graph API calls
- ✅ **CSRF Protection**: Built-in state parameter validation for security
- ✅ **Flexible Configuration**: Support for custom permissions, timeouts, and settings
- ✅ **TypeScript-like Models**: Using Freezed for immutable data classes
- ✅ **Extensive Testing**: Comprehensive unit tests included

## Why Use This Package?

Facebook's Limited Login restricts access to many business-critical permissions and APIs. This package uses a WebView-based approach to perform standard OAuth 2.0 authentication, giving you access to:

- Full ads management permissions (`ads_management`, `ads_read`)
- Business management capabilities (`business_management`)
- Page management (`pages_show_list`, `pages_manage_posts`)
- Instagram integration (`instagram_basic`, `instagram_manage_comments`)
- And many more business permissions

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  facebook_webview_oauth: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## Quick Start

### 1. Basic Usage

```dart
import 'package:facebook_webview_oauth/facebook_webview_oauth.dart';

// Configure OAuth parameters
final params = FacebookWebAuthParams(
  clientId: 'your_facebook_app_id',
  scopes: [
    'public_profile',
    'email',
    'ads_management',
    'ads_read',
    'business_management',
  ],
  configId: 'your_config_id', // Optional: for avoiding Limited Login
);

// Perform authentication
final result = await FacebookWebAuth().signIn(params, context: context);

// Handle the result
result.when(
  success: (accessToken, expiresIn, grantedScopes, declinedScopes) {
    print('Success! Access token: $accessToken');
    print('Granted scopes: $grantedScopes');
  },
  cancelled: (error) => print('User cancelled: $error'),
  error: (error) => print('Error: $error'),
  permissionsDeclined: (declined, error) => print('Declined: $declined'),
  timeout: (error) => print('Timeout: $error'),
  stateMismatch: (error) => print('Security error: $error'),
);
```

### 2. Using Graph API Client

```dart
// Create Graph API client with access token
final client = FacebookGraphClient(accessToken: accessToken);

try {
  // Get user information
  final userData = await client.getMe(
    fields: 'id,name,email,picture.width(200).height(200)',
  );
  print('User: ${userData['name']} (${userData['email']})');

  // Get ad accounts
  final adAccounts = await client.getAdAccounts(
    fields: 'id,name,account_status,currency,timezone_name',
    limit: 50,
  );
  print('Ad accounts: ${adAccounts['data']}');

  // Get business accounts
  final businesses = await client.getBusinesses(
    fields: 'id,name,verification_status',
  );
  print('Businesses: ${businesses['data']}');

} catch (e) {
  print('Graph API error: $e');
} finally {
  client.close();
}
```

### 3. Advanced Configuration

```dart
// Custom configuration with all options
final params = FacebookWebAuthParams(
  clientId: 'your_facebook_app_id',
  scopes: [
    'public_profile',
    'email',
    'ads_management',
    'ads_read',
    'business_management',
    'pages_show_list',
    'instagram_basic',
  ],
  configId: 'your_config_id',
  redirectUri: 'https://yourdomain.com/auth/facebook/callback', // Optional: custom redirect URI
  freshSession: true, // Clear cookies/cache
  timeout: Duration(minutes: 5),
  rerequestDeclinedPermissions: false,
);

// Use predefined configurations
final businessParams = FacebookWebAuthConfigs.business(
  clientId: 'your_app_id',
  configId: 'your_config_id',
);

final adsOnlyParams = FacebookWebAuthConfigs.adsOnly(
  clientId: 'your_app_id',
  configId: 'your_config_id',
);
```

## Facebook App Setup

### 1. Create Facebook App

1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app or use existing one
3. Add "Facebook Login" product

### 2. Configure OAuth Settings

In your Facebook App settings:

```
Valid OAuth Redirect URIs:
https://www.facebook.com/connect/login_success.html
```

**For Custom Redirect URI**: If you want to use your own domain instead of Facebook's default, add your custom URI:

```
Valid OAuth Redirect URIs:
https://yourdomain.com/auth/facebook/callback
```

Then configure it in your app:

```dart
final params = FacebookWebAuthParams(
  clientId: 'your_app_id',
  scopes: ['public_profile', 'email'],
  redirectUri: 'https://yourdomain.com/auth/facebook/callback',
);
```

### 3. App Domains (Optional)

Add your domain to App Domains (only needed if using custom redirect URI):

```
yourdomain.com
```

### 4. Business Verification

For production apps requiring business permissions:

- Complete Business Verification
- Submit for App Review for required permissions
- Ensure your app complies with Facebook's policies

## Permissions Guide

### Basic Permissions

- `public_profile` - User's basic profile info
- `email` - User's email address

### Business Permissions

- `ads_management` - Create and manage ads
- `ads_read` - Read ads insights and data
- `business_management` - Manage business assets
- `pages_show_list` - Access list of pages
- `pages_manage_posts` - Manage page posts
- `instagram_basic` - Basic Instagram access
- `instagram_manage_comments` - Manage Instagram comments

### Advanced Permissions

- `leads_retrieval` - Access lead ads data
- `read_insights` - Read page and app insights
- `publish_pages` - Publish as pages
- `manage_pages` - Full page management

## Error Handling

The package provides comprehensive error handling:

```dart
result.when(
  success: (token, expiresIn, granted, declined) {
    // Handle successful authentication
    if (declined.isNotEmpty) {
      // Some permissions were declined
      print('Declined permissions: ${declined.join(', ')}');
    }
  },
  cancelled: (error) {
    // User cancelled the authentication
    showDialog(/* show user-friendly message */);
  },
  error: (error) {
    // General error occurred
    print('Authentication failed: $error');
  },
  permissionsDeclined: (declined, error) {
    // Required permissions were declined
    showDialog(/* ask user to grant permissions */);
  },
  timeout: (error) {
    // Authentication timed out
    print('Please try again: $error');
  },
  stateMismatch: (error) {
    // Security error - possible CSRF attack
    print('Security error: $error');
  },
);
```

## Testing

The package includes comprehensive unit tests. Run them with:

```bash
cd facebook_webview_oauth
flutter test
```

## Troubleshooting

### Common Issues

1. **"Can't Load URL" Error**

   - Ensure your redirect URI is correctly configured in Facebook App settings
   - Check that your app domains are properly set up
   - Verify the app is not restricted by Facebook policies

2. **Limited Login Triggered**

   - Make sure you're using a `configId` parameter
   - Verify your app has the necessary permissions approved
   - Check that you're not using Facebook's JavaScript SDK alongside this package

3. **Permissions Declined**

   - Review Facebook's permission guidelines
   - Ensure your app use case matches the requested permissions
   - Consider implementing permission re-request flow

4. **Token Expires Quickly**
   - Use `exchangeForLongLivedToken()` to get 60-day tokens
   - Implement token refresh logic in your app
   - Store tokens securely

### Debug Mode

Enable debug logging to troubleshoot issues:

```dart
// Debug mode will print detailed logs
final result = await FacebookWebAuth().signIn(
  params,
  context: context,
  // Debug logs are automatically enabled in debug builds
);
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📧 Email: mohamed.draz1198@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/draz26648/facebook_webview_oauth/issues)
- 📖 Documentation: [GitHub Wiki](https://github.com/draz26648/facebook_webview_oauth/wiki)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed list of changes.

---

**Note**: This package is not officially affiliated with Facebook/Meta. It's a community-driven solution for developers who need comprehensive Facebook integration in their Flutter applications.
