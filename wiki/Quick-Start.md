# Quick Start Guide

Get up and running with Facebook WebView OAuth in just 5 minutes! This guide will walk you through implementing basic Facebook authentication in your Flutter app.

## 🚀 Prerequisites

Before you begin, make sure you have:

- ✅ Flutter SDK installed (3.0.0 or later)
- ✅ Facebook App created and configured ([Facebook App Setup](Facebook-App-Setup))
- ✅ Package installed ([Installation Guide](Installation))

## 📱 Basic Implementation

### Step 1: Import the Package

```dart
import 'package:flutter/material.dart';
import 'package:facebook_webview_oauth/facebook_webview_oauth.dart';
```

### Step 2: Create Authentication Method

```dart
class FacebookAuthExample extends StatefulWidget {
  @override
  _FacebookAuthExampleState createState() => _FacebookAuthExampleState();
}

class _FacebookAuthExampleState extends State<FacebookAuthExample> {
  String? _accessToken;
  Map<String, dynamic>? _userData;
  bool _isLoading = false;
  String? _error;

  Future<void> _authenticateWithFacebook() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Configure OAuth parameters
      final params = FacebookWebAuthConfigs.basic(
        clientId: 'YOUR_FACEBOOK_APP_ID', // Replace with your App ID
      );

      // Perform authentication
      final result = await FacebookWebAuth().signIn(params, context: context);

      // Handle the result
      await result.when(
        success: (accessToken, expiresIn, grantedScopes, declinedScopes) async {
          setState(() {
            _accessToken = accessToken;
          });

          // Fetch user data
          await _fetchUserData(accessToken);
        },
        cancelled: () {
          setState(() {
            _error = 'Authentication was cancelled by user';
          });
        },
        error: (error) {
          setState(() {
            _error = 'Authentication failed: $error';
          });
        },
        permissionsDeclined: (declinedScopes) {
          setState(() {
            _error = 'Some permissions were declined: ${declinedScopes.join(', ')}';
          });
        },
        timeout: () {
          setState(() {
            _error = 'Authentication timed out';
          });
        },
        stateMismatch: () {
          setState(() {
            _error = 'Security error: state mismatch';
          });
        },
      );
    } catch (e) {
      setState(() {
        _error = 'Unexpected error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserData(String accessToken) async {
    try {
      final client = FacebookGraphClient(accessToken: accessToken);
      final userData = await client.getMe(
        fields: 'id,name,email,picture.width(200).height(200)',
      );

      setState(() {
        _userData = userData;
      });
    } catch (e) {
      print('Failed to fetch user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Facebook Auth Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Authentication Button
            if (_accessToken == null) ...[
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _authenticateWithFacebook,
                icon: _isLoading
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(Icons.login),
                label: Text(_isLoading ? 'Authenticating...' : 'Login with Facebook'),
              ),
            ] else ...[
              // Success State
              Text(
                '✅ Successfully authenticated with Facebook!',
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _accessToken = null;
                    _userData = null;
                  });
                },
                child: Text('Logout'),
              ),
            ],

            // Error Display
            if (_error != null) ...[
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Error:',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                    ),
                    Text(_error!, style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],

            // User Data Display
            if (_userData != null) ...[
              SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Information',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 12),
                      if (_userData!['picture']?['data']?['url'] != null)
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(_userData!['picture']['data']['url']),
                        ),
                      SizedBox(height: 12),
                      Text('Name: ${_userData!['name'] ?? 'N/A'}'),
                      Text('Email: ${_userData!['email'] ?? 'N/A'}'),
                      Text('ID: ${_userData!['id'] ?? 'N/A'}'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

### Step 3: Replace Your App ID

Replace `'YOUR_FACEBOOK_APP_ID'` with your actual Facebook App ID from the [Facebook Developers Console](https://developers.facebook.com/).

### Step 4: Run Your App

```bash
flutter run
```

## 🎯 Business Authentication

For business features like ads management, use the business configuration:

```dart
Future<void> _authenticateForBusiness() async {
  final params = FacebookWebAuthConfigs.business(
    clientId: 'YOUR_FACEBOOK_APP_ID',
    configId: 'YOUR_CONFIG_ID', // Optional: helps avoid Limited Login
  );

  final result = await FacebookWebAuth().signIn(params, context: context);

  result.when(
    success: (accessToken, expiresIn, grantedScopes, declinedScopes) async {
      // Access business features
      final client = FacebookGraphClient(accessToken: accessToken);

      // Get ad accounts
      final adAccounts = await client.getAdAccounts();
      print('Ad Accounts: $adAccounts');

      // Get business information
      final businesses = await client.getBusinesses();
      print('Businesses: $businesses');
    },
    // ... handle other cases
  );
}
```

## 🔧 Custom Configuration

For advanced use cases, create custom configurations:

```dart
final params = FacebookWebAuthConfigs.custom(
  clientId: 'YOUR_FACEBOOK_APP_ID',
  scopes: [
    'public_profile',
    'email',
    'ads_management',
    'ads_read',
    'business_management',
  ],
  configId: 'YOUR_CONFIG_ID',
  redirectUri: 'https://yourdomain.com/auth/facebook/callback', // Optional
  timeout: Duration(minutes: 5),
  freshSession: true, // Clear cookies before auth
);
```

## 📊 Handling Permissions

### Checking Granted Permissions

```dart
result.when(
  success: (accessToken, expiresIn, grantedScopes, declinedScopes) {
    print('Granted: ${grantedScopes.join(', ')}');
    print('Declined: ${declinedScopes.join(', ')}');

    // Check if specific permission was granted
    if (grantedScopes.contains('ads_management')) {
      // User granted ads management permission
      _loadAdAccounts(accessToken);
    }

    if (declinedScopes.isNotEmpty) {
      // Some permissions were declined
      _showPermissionDialog(declinedScopes);
    }
  },
  permissionsDeclined: (declinedScopes) {
    // All requested permissions were declined
    _showPermissionRequiredDialog(declinedScopes);
  },
  // ... other cases
);
```

### Re-requesting Declined Permissions

```dart
Future<void> _rerequestPermissions() async {
  final params = FacebookWebAuthConfigs.business(
    clientId: 'YOUR_FACEBOOK_APP_ID',
    rerequestDeclinedPermissions: true, // This will re-ask for declined permissions
  );

  final result = await FacebookWebAuth().signIn(params, context: context);
  // Handle result...
}
```

## 🔐 Security Best Practices

### 1. Store Access Tokens Securely

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const _storage = FlutterSecureStorage();
  static const _tokenKey = 'facebook_access_token';

  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }
}
```

### 2. Validate Tokens

```dart
Future<bool> _validateToken(String accessToken) async {
  try {
    final client = FacebookGraphClient(accessToken: accessToken);
    await client.getMe(fields: 'id');
    return true;
  } catch (e) {
    return false;
  }
}
```

### 3. Handle Token Expiration

```dart
Future<void> _makeAuthenticatedRequest(String accessToken) async {
  try {
    final client = FacebookGraphClient(accessToken: accessToken);
    final result = await client.getMe();
    // Handle success
  } catch (e) {
    if (e.toString().contains('token') || e.toString().contains('expired')) {
      // Token expired, re-authenticate
      await _authenticateWithFacebook();
    }
  }
}
```

## 🧪 Testing

### Test with Facebook Test Users

```dart
// Use test user credentials during development
final params = FacebookWebAuthConfigs.basic(
  clientId: 'YOUR_FACEBOOK_APP_ID',
  // Test users don't require app review for permissions
);
```

### Debug Mode

Enable debug logging to troubleshoot issues:

```dart
import 'package:flutter/foundation.dart';

// Debug prints are automatically enabled in debug mode
// Check console output for detailed authentication flow
```

## ✅ Quick Start Checklist

- [ ] Package installed and imported
- [ ] Facebook App ID configured
- [ ] Basic authentication implemented
- [ ] Error handling added
- [ ] User data fetching working
- [ ] Permissions properly handled
- [ ] Security measures implemented
- [ ] Testing completed

## 🚨 Common Issues

### Issue 1: "Invalid App ID"

**Solution**: Verify your Facebook App ID is correct and the app is active.

### Issue 2: "Redirect URI Mismatch"

**Solution**: Ensure your Facebook App's OAuth redirect URIs are configured correctly.

### Issue 3: WebView Not Loading

**Solution**: Check internet permissions and network connectivity.

### Issue 4: Permissions Denied

**Solution**: Ensure your Facebook App has the required permissions approved.

## 🔄 Next Steps

Now that you have basic authentication working:

1. **[Configuration Options](Configuration-Options)** - Customize the authentication experience
2. **[Graph API Integration](Graph-API-Integration)** - Make Facebook API calls
3. **[Error Handling](Error-Handling)** - Implement robust error handling
4. **[Custom Redirect URIs](Custom-Redirect-URIs)** - Use your own domain

## 🆘 Need Help?

If you encounter issues:

1. Check the [FAQ](FAQ) for common solutions
2. Review [Error Codes](Error-Codes) for specific error meanings
3. Search [GitHub Issues](https://github.com/draz26648/facebook_webview_oauth/issues)
4. Contact support: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)

**Happy coding! 🚀**
