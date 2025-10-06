# Custom Redirect URIs

Learn how to configure and use custom redirect URIs for Facebook OAuth authentication, allowing you to use your own domain instead of Facebook's default redirect URL.

## 🎯 Overview

By default, the package uses Facebook's standard redirect URI:

```
https://www.facebook.com/connect/login_success.html
```

Custom redirect URIs allow you to:

- Use your own domain for OAuth callbacks
- Implement custom landing pages
- Better integrate with your app's branding
- Handle authentication results on your server

## 🚀 Quick Setup

### 1. Configure Your Domain

```dart
final params = FacebookWebAuthConfigs.business(
  clientId: 'your_facebook_app_id',
  configId: 'your_config_id',
  redirectUri: 'https://yourdomain.com/auth/facebook/callback',
);
```

### 2. Facebook App Configuration

In your Facebook App settings, add your custom URI to **Valid OAuth Redirect URIs**:

```
https://yourdomain.com/auth/facebook/callback
```

### 3. Add Domain to App Domains

Add your domain to **App Domains** in Facebook App settings:

```
yourdomain.com
```

## 🔧 Detailed Configuration

### Facebook App Setup

#### 1. OAuth Redirect URIs

Navigate to **Facebook Login > Settings** and add your URIs:

**Production:**

```
https://yourdomain.com/auth/facebook/callback
https://yourdomain.com/auth/facebook/success
```

**Development:**

```
https://dev.yourdomain.com/auth/facebook/callback
http://localhost:3000/auth/facebook/callback
https://localhost:3000/auth/facebook/callback
```

**Testing:**

```
https://staging.yourdomain.com/auth/facebook/callback
https://test.yourdomain.com/auth/facebook/callback
```

#### 2. App Domains Configuration

In **Settings > Basic > App Domains**, add:

```
yourdomain.com
dev.yourdomain.com
staging.yourdomain.com
localhost
```

#### 3. Platform Configuration

For mobile apps, ensure your platform settings are correct:

**iOS:**

- Bundle ID matches your app
- App Store ID (if published)

**Android:**

- Package name matches your app
- Key hashes are correctly configured

## 📱 Implementation Examples

### Basic Custom URI

```dart
class CustomRedirectAuth {
  static Future<FacebookWebAuthResult> authenticate() async {
    final params = FacebookWebAuthConfigs.business(
      clientId: 'your_facebook_app_id',
      configId: 'your_config_id',
      redirectUri: 'https://yourdomain.com/auth/facebook/callback',
      timeout: Duration(minutes: 5),
    );

    return await FacebookWebAuth().signIn(params, context: context);
  }
}
```

### Environment-Specific URIs

```dart
class EnvironmentConfig {
  static String get redirectUri {
    if (kDebugMode) {
      return 'https://dev.yourdomain.com/auth/facebook/callback';
    } else if (kProfileMode) {
      return 'https://staging.yourdomain.com/auth/facebook/callback';
    } else {
      return 'https://yourdomain.com/auth/facebook/callback';
    }
  }

  static FacebookWebAuthParams getAuthParams() {
    return FacebookWebAuthConfigs.business(
      clientId: _getAppId(),
      configId: _getConfigId(),
      redirectUri: redirectUri,
    );
  }
}
```

### Multiple Redirect URIs

```dart
class MultiRedirectAuth {
  static FacebookWebAuthParams getConfigForFlow(AuthFlow flow) {
    String redirectUri;

    switch (flow) {
      case AuthFlow.registration:
        redirectUri = 'https://yourdomain.com/auth/facebook/register';
        break;
      case AuthFlow.login:
        redirectUri = 'https://yourdomain.com/auth/facebook/login';
        break;
      case AuthFlow.linking:
        redirectUri = 'https://yourdomain.com/auth/facebook/link';
        break;
    }

    return FacebookWebAuthConfigs.custom(
      clientId: 'your_app_id',
      scopes: _getScopesForFlow(flow),
      redirectUri: redirectUri,
    );
  }
}
```

## 🌐 Server-Side Handling

### Landing Page Implementation

Create a landing page at your redirect URI to handle the OAuth response:

**HTML (yourdomain.com/auth/facebook/callback):**

```html
<!DOCTYPE html>
<html>
  <head>
    <title>Facebook Authentication</title>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
  </head>
  <body>
    <div id="status">Processing authentication...</div>

    <script>
      // Extract token from URL fragment
      function getTokenFromFragment() {
        const fragment = window.location.hash.substring(1);
        const params = new URLSearchParams(fragment);

        return {
          access_token: params.get("access_token"),
          token_type: params.get("token_type"),
          expires_in: params.get("expires_in"),
          state: params.get("state"),
          granted_scopes: params.get("granted_scopes"),
          denied_scopes: params.get("denied_scopes"),
          error: params.get("error"),
          error_description: params.get("error_description"),
        };
      }

      // Handle authentication result
      const result = getTokenFromFragment();
      const statusDiv = document.getElementById("status");

      if (result.error) {
        statusDiv.innerHTML = `
                <h2>Authentication Failed</h2>
                <p>Error: ${result.error}</p>
                <p>Description: ${result.error_description}</p>
            `;
      } else if (result.access_token) {
        statusDiv.innerHTML = `
                <h2>Authentication Successful!</h2>
                <p>You can now close this window.</p>
            `;

        // Optional: Send token to your server
        // sendTokenToServer(result.access_token);
      } else {
        statusDiv.innerHTML = `
                <h2>Authentication Incomplete</h2>
                <p>Please try again.</p>
            `;
      }

      // Auto-close after 3 seconds on success
      if (result.access_token) {
        setTimeout(() => {
          window.close();
        }, 3000);
      }
    </script>
  </body>
</html>
```

### Server-Side Token Processing

**Node.js/Express Example:**

```javascript
app.get("/auth/facebook/callback", (req, res) => {
  // Serve the landing page
  res.sendFile(path.join(__dirname, "facebook-callback.html"));
});

app.post("/auth/facebook/token", async (req, res) => {
  const { access_token, user_id } = req.body;

  try {
    // Verify token with Facebook
    const response = await fetch(
      `https://graph.facebook.com/me?access_token=${access_token}`
    );
    const userData = await response.json();

    if (userData.error) {
      return res.status(400).json({ error: "Invalid token" });
    }

    // Store token securely
    await storeUserToken(user_id, access_token);

    res.json({ success: true });
  } catch (error) {
    res.status(500).json({ error: "Server error" });
  }
});
```

## 🔒 Security Considerations

### 1. HTTPS Requirements

**Always use HTTPS for production redirect URIs:**

```dart
// ✅ Good: HTTPS for production
redirectUri: 'https://yourdomain.com/auth/facebook/callback'

// ❌ Bad: HTTP in production (security risk)
redirectUri: 'http://yourdomain.com/auth/facebook/callback'

// ✅ OK: HTTP for localhost development only
redirectUri: 'http://localhost:3000/auth/facebook/callback'
```

### 2. Domain Validation

Ensure your redirect URI domain matches your app's domain:

```dart
class RedirectUriValidator {
  static bool isValidRedirectUri(String uri) {
    final allowedDomains = [
      'yourdomain.com',
      'dev.yourdomain.com',
      'staging.yourdomain.com',
    ];

    try {
      final parsedUri = Uri.parse(uri);
      return allowedDomains.contains(parsedUri.host) &&
             parsedUri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }
}
```

### 3. State Parameter Validation

The package automatically handles CSRF protection, but you can add additional validation:

```dart
result.when(
  success: (token, expires, granted, declined) {
    // Token is valid and state was verified by the package
    _handleSuccessfulAuth(token);
  },
  stateMismatch: () {
    // CSRF attack detected - state parameter mismatch
    _handleSecurityError();
  },
  // ... other cases
);
```

## 🧪 Testing Custom Redirect URIs

### Local Development

For local testing, use localhost with HTTPS:

```dart
final devParams = FacebookWebAuthConfigs.business(
  clientId: 'your_dev_app_id',
  redirectUri: 'https://localhost:3000/auth/facebook/callback',
);
```

**Set up local HTTPS:**

```bash
# Using mkcert for local HTTPS
mkcert -install
mkcert localhost 127.0.0.1 ::1
```

### Testing Checklist

- [ ] Redirect URI added to Facebook App settings
- [ ] Domain added to App Domains
- [ ] HTTPS certificate valid (for production)
- [ ] Landing page accessible and functional
- [ ] Token extraction working correctly
- [ ] Error handling implemented
- [ ] Auto-close functionality working
- [ ] Mobile WebView compatibility tested

## 🔧 Advanced Configurations

### Dynamic Redirect URIs

```dart
class DynamicRedirectAuth {
  static String generateRedirectUri(String userId, String sessionId) {
    return 'https://yourdomain.com/auth/facebook/callback?user=$userId&session=$sessionId';
  }

  static FacebookWebAuthParams getAuthParams(String userId, String sessionId) {
    return FacebookWebAuthConfigs.business(
      clientId: 'your_app_id',
      redirectUri: generateRedirectUri(userId, sessionId),
    );
  }
}
```

### Custom Success Pages

Create different landing pages for different scenarios:

```dart
class CustomSuccessPages {
  static String getRedirectUri(AuthContext context) {
    switch (context.type) {
      case AuthType.firstTime:
        return 'https://yourdomain.com/auth/facebook/welcome';
      case AuthType.returning:
        return 'https://yourdomain.com/auth/facebook/success';
      case AuthType.business:
        return 'https://yourdomain.com/auth/facebook/business-success';
      default:
        return 'https://yourdomain.com/auth/facebook/callback';
    }
  }
}
```

### Branded Authentication Flow

```dart
class BrandedAuth {
  static FacebookWebAuthParams getBrandedConfig() {
    return FacebookWebAuthConfigs.custom(
      clientId: 'your_app_id',
      scopes: ['public_profile', 'email', 'ads_management'],
      redirectUri: 'https://yourdomain.com/auth/facebook/branded-success',
      timeout: Duration(minutes: 5),
    );
  }
}
```

## 🚨 Common Issues and Solutions

### Issue 1: "Invalid Redirect URI"

**Problem**: Facebook rejects the redirect URI.

**Solutions**:

- Ensure URI is exactly configured in Facebook App settings
- Check for typos in domain name
- Verify HTTPS is used (except localhost)
- Ensure domain is added to App Domains

### Issue 2: "Domain Not Allowed"

**Problem**: Domain not permitted by Facebook App.

**Solutions**:

- Add domain to App Domains in Facebook App settings
- Remove protocol (http/https) from App Domains
- Ensure domain ownership is verified

### Issue 3: Landing Page Not Loading

**Problem**: Redirect URI returns 404 or error.

**Solutions**:

- Verify server is running and accessible
- Check DNS configuration
- Ensure SSL certificate is valid
- Test URL directly in browser

### Issue 4: Token Not Extracted

**Problem**: Landing page doesn't receive token in URL fragment.

**Solutions**:

- Check JavaScript console for errors
- Verify fragment parsing logic
- Ensure page loads completely before parsing
- Test with different browsers

## 📊 Redirect URI Patterns

### Recommended Patterns

```
Production:
https://yourdomain.com/auth/facebook/callback
https://yourdomain.com/oauth/facebook/success

Development:
https://dev.yourdomain.com/auth/facebook/callback
https://localhost:3000/auth/facebook/callback

Staging:
https://staging.yourdomain.com/auth/facebook/callback
https://test.yourdomain.com/auth/facebook/callback
```

### Pattern Best Practices

1. **Consistent Structure**: Use consistent URL patterns across environments
2. **Clear Purpose**: Make the URL purpose obvious (`/auth/facebook/`)
3. **Environment Prefixes**: Use subdomains for different environments
4. **Secure Protocols**: Always HTTPS for production
5. **Descriptive Paths**: Use descriptive path segments

## ✅ Custom Redirect URI Checklist

- [ ] Redirect URI configured in Facebook App
- [ ] Domain added to App Domains
- [ ] HTTPS certificate valid (production)
- [ ] Landing page implemented and tested
- [ ] Token extraction working
- [ ] Error handling implemented
- [ ] Cross-browser compatibility tested
- [ ] Mobile WebView compatibility verified
- [ ] Security measures implemented
- [ ] Documentation updated

## 🔄 Next Steps

After setting up custom redirect URIs:

1. **[Authentication Flow](Authentication-Flow)** - Understand the complete flow
2. **[Security Best Practices](Security-Best-Practices)** - Secure your implementation
3. **[Testing & Debugging](Testing-Debugging)** - Debug authentication issues
4. **[Graph API Integration](Graph-API-Integration)** - Use the access token

## 🆘 Need Help?

For custom redirect URI issues:

1. Check [FAQ](FAQ) for common redirect URI problems
2. Review [Error Codes](Error-Codes) for specific error meanings
3. Test with [Facebook's Redirect URI Debugger](https://developers.facebook.com/tools/debug/)
4. Contact support: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)
