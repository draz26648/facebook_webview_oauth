# Configuration Options

This guide covers all available configuration options for customizing the Facebook WebView OAuth authentication experience in your Flutter app.

## 📋 Overview

The package provides several ways to configure authentication:

1. **Predefined Configurations** - Ready-to-use configurations for common scenarios
2. **Custom Configuration** - Full control over all parameters
3. **Runtime Configuration** - Dynamic configuration based on user context

## 🎯 Predefined Configurations

### Basic Configuration

Perfect for simple user authentication with basic profile information.

```dart
final params = FacebookWebAuthConfigs.basic(
  clientId: 'your_facebook_app_id',
  configId: 'your_config_id', // Optional
  redirectUri: 'https://yourdomain.com/callback', // Optional
  freshSession: true, // Optional, default: true
  timeout: Duration(minutes: 3), // Optional, default: 3 minutes
);
```

**Included Scopes:**

- `public_profile` - Basic profile information
- `email` - User's email address

### Business Configuration

Designed for business applications requiring ads management and business data access.

```dart
final params = FacebookWebAuthConfigs.business(
  clientId: 'your_facebook_app_id',
  configId: 'your_config_id', // Highly recommended for business apps
  redirectUri: 'https://yourdomain.com/callback', // Optional
  freshSession: true, // Optional, default: true
  timeout: Duration(minutes: 5), // Optional, default: 3 minutes
);
```

**Included Scopes:**

- `public_profile` - Basic profile information
- `email` - User's email address
- `ads_management` - Manage ads and ad accounts
- `ads_read` - Read ads and ad account data
- `business_management` - Manage business assets
- `pages_show_list` - Access list of pages
- `instagram_basic` - Basic Instagram access

### Ads-Only Configuration

Focused on advertising features with minimal user data access.

```dart
final params = FacebookWebAuthConfigs.adsOnly(
  clientId: 'your_facebook_app_id',
  configId: 'your_config_id', // Recommended
  redirectUri: 'https://yourdomain.com/callback', // Optional
  freshSession: true, // Optional, default: true
  timeout: Duration(minutes: 3), // Optional, default: 3 minutes
);
```

**Included Scopes:**

- `public_profile` - Basic profile information
- `email` - User's email address
- `ads_management` - Manage ads and ad accounts
- `ads_read` - Read ads and ad account data

## 🛠️ Custom Configuration

For complete control over authentication parameters:

```dart
final params = FacebookWebAuthConfigs.custom(
  clientId: 'your_facebook_app_id',
  scopes: [
    'public_profile',
    'email',
    'ads_management',
    'business_management',
    'pages_show_list',
    'instagram_basic',
  ],
  configId: 'your_config_id', // Optional but recommended
  redirectUri: 'https://yourdomain.com/auth/callback', // Optional
  freshSession: true, // Optional, default: true
  timeout: Duration(minutes: 5), // Optional, default: 3 minutes
  rerequestDeclinedPermissions: false, // Optional, default: false
);
```

## 📖 Parameter Reference

### Required Parameters

#### `clientId` (String)

Your Facebook App ID from the Facebook Developers Console.

```dart
clientId: '1234567890123456'
```

#### `scopes` (List<String>)

List of Facebook permissions to request. Only required for custom configuration.

```dart
scopes: [
  'public_profile',
  'email',
  'ads_management',
]
```

### Optional Parameters

#### `configId` (String?)

Facebook App Configuration ID to help avoid Limited Login restrictions.

```dart
configId: 'your_app_configuration_id'
```

**When to use:**

- ✅ Business applications
- ✅ Apps requiring advanced permissions
- ✅ Production applications
- ❌ Simple personal projects (optional)

#### `redirectUri` (String?)

Custom redirect URI for OAuth callbacks. Defaults to Facebook's standard URI.

```dart
redirectUri: 'https://yourdomain.com/auth/facebook/callback'
```

**Requirements:**

- Must be HTTPS (except localhost for development)
- Must be configured in your Facebook App settings
- Domain must be added to App Domains

#### `freshSession` (bool)

Whether to clear cookies and cache before authentication.

```dart
freshSession: true  // Default: true
```

**Use cases:**

- `true` - Force new login (recommended for most cases)
- `false` - Allow existing Facebook session to persist

#### `timeout` (Duration)

Maximum time to wait for authentication completion.

```dart
timeout: Duration(minutes: 5)  // Default: 3 minutes
```

**Recommended values:**

- Basic auth: 3 minutes
- Business auth: 5 minutes
- Complex flows: 10 minutes

#### `rerequestDeclinedPermissions` (bool)

Whether to re-request permissions that were previously declined.

```dart
rerequestDeclinedPermissions: true  // Default: false
```

**When to use:**

- User previously declined permissions
- App functionality requires specific permissions
- Following up after explaining permission benefits

## 🔧 Dynamic Configuration

### Context-Based Configuration

Configure authentication based on user context or app state:

```dart
class AuthConfigurationService {
  static FacebookWebAuthParams getConfigForUser(UserType userType) {
    switch (userType) {
      case UserType.consumer:
        return FacebookWebAuthConfigs.basic(
          clientId: 'your_app_id',
          timeout: Duration(minutes: 3),
        );

      case UserType.business:
        return FacebookWebAuthConfigs.business(
          clientId: 'your_app_id',
          configId: 'business_config_id',
          timeout: Duration(minutes: 5),
        );

      case UserType.advertiser:
        return FacebookWebAuthConfigs.adsOnly(
          clientId: 'your_app_id',
          configId: 'ads_config_id',
          timeout: Duration(minutes: 5),
        );
    }
  }
}
```

### Feature-Based Configuration

Configure based on required features:

```dart
class FeatureBasedAuth {
  static FacebookWebAuthParams configureForFeatures(List<AppFeature> features) {
    final scopes = <String>['public_profile', 'email'];

    if (features.contains(AppFeature.adsManagement)) {
      scopes.addAll(['ads_management', 'ads_read']);
    }

    if (features.contains(AppFeature.pageManagement)) {
      scopes.addAll(['pages_show_list', 'pages_manage_posts']);
    }

    if (features.contains(AppFeature.instagramIntegration)) {
      scopes.add('instagram_basic');
    }

    return FacebookWebAuthConfigs.custom(
      clientId: 'your_app_id',
      scopes: scopes,
      configId: features.isNotEmpty ? 'business_config_id' : null,
      timeout: Duration(minutes: features.length > 2 ? 5 : 3),
    );
  }
}
```

## 🎨 UI Customization

### Custom Loading States

```dart
class CustomAuthButton extends StatefulWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: isLoading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Icon(Icons.facebook),
      label: Text(isLoading ? 'Connecting to Facebook...' : 'Continue with Facebook'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1877F2), // Facebook blue
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    );
  }
}
```

### Custom Error Handling

```dart
class AuthErrorHandler {
  static void handleAuthError(BuildContext context, String error) {
    String userFriendlyMessage;
    IconData icon;
    Color color;

    if (error.contains('cancelled')) {
      userFriendlyMessage = 'Login was cancelled. Please try again.';
      icon = Icons.cancel;
      color = Colors.orange;
    } else if (error.contains('timeout')) {
      userFriendlyMessage = 'Login took too long. Please check your connection and try again.';
      icon = Icons.timer;
      color = Colors.red;
    } else if (error.contains('permissions')) {
      userFriendlyMessage = 'Some permissions were declined. The app may have limited functionality.';
      icon = Icons.warning;
      color = Colors.amber;
    } else {
      userFriendlyMessage = 'Login failed. Please try again later.';
      icon = Icons.error;
      color = Colors.red;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(userFriendlyMessage)),
          ],
        ),
        backgroundColor: color,
        duration: Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () => _retryAuthentication(context),
        ),
      ),
    );
  }
}
```

## 🔍 Environment-Specific Configuration

### Development Configuration

```dart
class DevConfig {
  static FacebookWebAuthParams getDevelopmentConfig() {
    return FacebookWebAuthConfigs.custom(
      clientId: 'dev_app_id',
      scopes: ['public_profile', 'email'],
      redirectUri: 'http://localhost:3000/auth/callback', // HTTP allowed for localhost
      timeout: Duration(minutes: 10), // Longer timeout for debugging
      freshSession: true, // Always fresh for testing
    );
  }
}
```

### Production Configuration

```dart
class ProdConfig {
  static FacebookWebAuthParams getProductionConfig() {
    return FacebookWebAuthConfigs.business(
      clientId: 'prod_app_id',
      configId: 'prod_config_id',
      redirectUri: 'https://yourdomain.com/auth/facebook/callback',
      timeout: Duration(minutes: 3), // Shorter timeout for better UX
      freshSession: false, // Allow session persistence
    );
  }
}
```

### Configuration Factory

```dart
class AuthConfigFactory {
  static FacebookWebAuthParams getConfig() {
    if (kDebugMode) {
      return DevConfig.getDevelopmentConfig();
    } else {
      return ProdConfig.getProductionConfig();
    }
  }
}
```

## 📊 Permission Scopes Reference

### Basic Scopes (No Review Required)

| Scope            | Description                                | Use Case                        |
| ---------------- | ------------------------------------------ | ------------------------------- |
| `public_profile` | Basic profile info (name, profile picture) | User identification             |
| `email`          | User's email address                       | Account creation, communication |

### Business Scopes (May Require Review)

| Scope                 | Description                  | Use Case                  |
| --------------------- | ---------------------------- | ------------------------- |
| `ads_management`      | Create and manage ads        | Ad creation tools         |
| `ads_read`            | Read ads and ad account data | Analytics, reporting      |
| `business_management` | Manage business assets       | Business management tools |
| `pages_show_list`     | Access list of pages         | Page selection            |
| `pages_manage_posts`  | Manage page posts            | Content management        |
| `instagram_basic`     | Basic Instagram access       | Instagram integration     |

### Advanced Scopes (Require Review)

| Scope                       | Description               | Use Case               |
| --------------------------- | ------------------------- | ---------------------- |
| `pages_manage_ads`          | Manage page ads           | Advanced ad management |
| `business_management`       | Full business management  | Enterprise tools       |
| `instagram_manage_comments` | Manage Instagram comments | Community management   |

## ✅ Configuration Best Practices

### 1. Use Appropriate Configurations

```dart
// ✅ Good: Use predefined configs when possible
final params = FacebookWebAuthConfigs.business(clientId: 'app_id');

// ❌ Avoid: Custom config for standard use cases
final params = FacebookWebAuthConfigs.custom(
  clientId: 'app_id',
  scopes: ['public_profile', 'email'], // Just use .basic() instead
);
```

### 2. Always Include Config ID for Business Apps

```dart
// ✅ Good: Include config ID to avoid Limited Login
final params = FacebookWebAuthConfigs.business(
  clientId: 'app_id',
  configId: 'config_id', // Important for business permissions
);

// ⚠️ Risky: Missing config ID may trigger Limited Login
final params = FacebookWebAuthConfigs.business(clientId: 'app_id');
```

### 3. Set Appropriate Timeouts

```dart
// ✅ Good: Reasonable timeouts based on complexity
final basicParams = FacebookWebAuthConfigs.basic(
  clientId: 'app_id',
  timeout: Duration(minutes: 3), // Short for basic auth
);

final businessParams = FacebookWebAuthConfigs.business(
  clientId: 'app_id',
  timeout: Duration(minutes: 5), // Longer for business auth
);
```

### 4. Handle Permissions Gracefully

```dart
// ✅ Good: Graceful permission handling
result.when(
  success: (token, expires, granted, declined) {
    if (declined.isNotEmpty) {
      _showOptionalPermissionsDialog(declined);
    }
    _proceedWithGrantedPermissions(granted);
  },
  permissionsDeclined: (declined) {
    _showPermissionExplanation(declined);
  },
);
```

## 🔄 Next Steps

After configuring authentication:

1. **[Authentication Flow](Authentication-Flow)** - Understand the complete flow
2. **[Custom Redirect URIs](Custom-Redirect-URIs)** - Use your own domain
3. **[Permission Management](Permission-Management)** - Handle permissions effectively
4. **[Graph API Integration](Graph-API-Integration)** - Make Facebook API calls

## 🆘 Need Help?

For configuration questions:

1. Check [FAQ](FAQ) for common configuration issues
2. Review [Error Codes](Error-Codes) for specific errors
3. Visit [GitHub Issues](https://github.com/draz26648/facebook_webview_oauth/issues)
4. Contact support: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)
