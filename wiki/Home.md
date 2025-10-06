# Facebook WebView OAuth - Documentation

Welcome to the comprehensive documentation for the **Facebook WebView OAuth** Flutter package! This package provides a robust solution for Facebook OAuth authentication using WebView, specifically designed to bypass Limited Login restrictions and provide full Business permissions access.

## 📚 Documentation Overview

### Getting Started

- **[Installation Guide](Installation)** - How to add the package to your Flutter project
- **[Quick Start](Quick-Start)** - Get up and running in 5 minutes
- **[Facebook App Setup](Facebook-App-Setup)** - Configure your Facebook App correctly

### Core Features

- **[Authentication Flow](Authentication-Flow)** - Understanding the OAuth process
- **[Configuration Options](Configuration-Options)** - Customize the authentication experience
- **[Custom Redirect URIs](Custom-Redirect-URIs)** - Use your own domain for OAuth callbacks
- **[Permission Management](Permission-Management)** - Handle Facebook permissions effectively

### Advanced Usage

- **[Graph API Integration](Graph-API-Integration)** - Make Facebook Graph API calls
- **[Error Handling](Error-Handling)** - Handle authentication errors gracefully
- **[Security Best Practices](Security-Best-Practices)** - Keep your app secure
- **[Testing & Debugging](Testing-Debugging)** - Debug authentication issues

### Reference

- **[API Reference](API-Reference)** - Complete API documentation
- **[Configuration Reference](Configuration-Reference)** - All configuration options
- **[Error Codes](Error-Codes)** - Complete list of error codes and meanings
- **[FAQ](FAQ)** - Frequently asked questions

### Examples & Tutorials

- **[Basic Authentication](Example-Basic-Authentication)** - Simple user authentication
- **[Business Authentication](Example-Business-Authentication)** - Full business permissions
- **[Custom Implementation](Example-Custom-Implementation)** - Advanced customization
- **[Migration Guide](Migration-Guide)** - Migrating from other Facebook auth solutions

## 🚀 Key Features

- ✅ **Full Business Permissions**: Bypasses Limited Login to access all Facebook Business features
- ✅ **WebView-Based Authentication**: Uses `flutter_inappwebview` for secure OAuth flow
- ✅ **Comprehensive Error Handling**: Detailed error states and user-friendly messages
- ✅ **Graph API Client**: Built-in client for Facebook Graph API calls
- ✅ **CSRF Protection**: Built-in state parameter validation for security
- ✅ **Flexible Configuration**: Support for custom permissions, timeouts, and settings
- ✅ **Custom Redirect URIs**: Use your own domain for OAuth callbacks
- ✅ **TypeScript-like Models**: Using Freezed for immutable data classes
- ✅ **Extensive Testing**: Comprehensive unit tests included

## 🎯 Why Use This Package?

Facebook's Limited Login can restrict access to essential business features like Ads Management, Business Manager, and advanced user data. This package provides a WebView-based solution that:

1. **Bypasses Limited Login** - Get full access to Facebook's business APIs
2. **Provides Better Control** - Full control over the authentication flow
3. **Supports All Permissions** - Access to ads_management, business_management, and more
4. **Handles Edge Cases** - Robust error handling and fallback mechanisms
5. **Production Ready** - Used in production apps with millions of users

## 📖 Quick Example

```dart
import 'package:facebook_webview_oauth/facebook_webview_oauth.dart';

// Configure authentication
final params = FacebookWebAuthConfigs.business(
  clientId: 'your_facebook_app_id',
  configId: 'your_config_id', // Optional: to avoid Limited Login
);

// Perform authentication
final result = await FacebookWebAuth().signIn(params, context: context);

// Handle result
result.when(
  success: (accessToken, expiresIn, grantedScopes, declinedScopes) {
    print('Authentication successful!');
    print('Access Token: $accessToken');
    print('Granted Scopes: $grantedScopes');
  },
  cancelled: () => print('User cancelled authentication'),
  error: (error) => print('Authentication failed: $error'),
  permissionsDeclined: (declinedScopes) => print('Some permissions were declined: $declinedScopes'),
  timeout: () => print('Authentication timed out'),
  stateMismatch: () => print('Security error: state mismatch'),
);
```

## 🆘 Need Help?

- 📧 **Email**: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)
- 🐛 **Issues**: [GitHub Issues](https://github.com/draz26648/facebook_webview_oauth/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/draz26648/facebook_webview_oauth/discussions)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](Contributing) for details on how to contribute to this project.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/draz26648/facebook_webview_oauth/blob/main/LICENSE) file for details.

---

**Happy coding! 🚀**
