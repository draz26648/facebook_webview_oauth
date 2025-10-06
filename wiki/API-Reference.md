# API Reference

Complete API documentation for the Facebook WebView OAuth package, including all classes, methods, and parameters.

## 📚 Core Classes

### FacebookWebAuth

Main class for performing Facebook OAuth authentication.

#### Methods

##### `signIn(FacebookWebAuthParams params, {required BuildContext context})`

Performs Facebook OAuth authentication using WebView.

**Parameters:**

- `params` (FacebookWebAuthParams) - Authentication configuration
- `context` (BuildContext) - Flutter build context for navigation

**Returns:** `Future<FacebookWebAuthResult>`

**Example:**

```dart
final result = await FacebookWebAuth().signIn(params, context: context);
```

##### `createGraphClient(String accessToken)`

Creates a Facebook Graph API client with the provided access token.

**Parameters:**

- `accessToken` (String) - Valid Facebook access token

**Returns:** `FacebookGraphClient`

**Example:**

```dart
final client = FacebookWebAuth().createGraphClient(accessToken);
```

##### `validateTokenPermissions(String accessToken, List<String> requiredScopes)`

Validates that an access token has the required permissions.

**Parameters:**

- `accessToken` (String) - Facebook access token to validate
- `requiredScopes` (List<String>) - List of required permission scopes

**Returns:** `Future<List<String>>` - List of missing scopes (empty if all granted)

**Example:**

```dart
final missingScopes = await FacebookWebAuth().validateTokenPermissions(
  accessToken,
  ['ads_management', 'business_management'],
);
```

---

### FacebookWebAuthConfigs

Factory class for creating common authentication configurations.

#### Static Methods

##### `basic({required String clientId, String? configId, String? redirectUri, bool freshSession = true, Duration timeout = const Duration(minutes: 3)})`

Creates basic authentication configuration with minimal permissions.

**Parameters:**

- `clientId` (String) - Facebook App ID
- `configId` (String?) - Optional Facebook App Configuration ID
- `redirectUri` (String?) - Optional custom redirect URI
- `freshSession` (bool) - Whether to clear cookies before auth (default: true)
- `timeout` (Duration) - Authentication timeout (default: 3 minutes)

**Returns:** `FacebookWebAuthParams`

**Included Scopes:** `public_profile`, `email`

##### `business({required String clientId, String? configId, String? redirectUri, bool freshSession = true, Duration timeout = const Duration(minutes: 3)})`

Creates business authentication configuration with full business permissions.

**Parameters:** Same as `basic()`

**Returns:** `FacebookWebAuthParams`

**Included Scopes:** `public_profile`, `email`, `ads_management`, `ads_read`, `business_management`, `pages_show_list`, `instagram_basic`

##### `adsOnly({required String clientId, String? configId, String? redirectUri, bool freshSession = true, Duration timeout = const Duration(minutes: 3)})`

Creates ads-focused authentication configuration.

**Parameters:** Same as `basic()`

**Returns:** `FacebookWebAuthParams`

**Included Scopes:** `public_profile`, `email`, `ads_management`, `ads_read`

##### `custom({required String clientId, required List<String> scopes, String? configId, String? redirectUri, bool freshSession = true, Duration timeout = const Duration(minutes: 3), bool rerequestDeclinedPermissions = false})`

Creates custom authentication configuration with specified permissions.

**Parameters:**

- `clientId` (String) - Facebook App ID
- `scopes` (List<String>) - List of Facebook permissions to request
- `configId` (String?) - Optional Facebook App Configuration ID
- `redirectUri` (String?) - Optional custom redirect URI
- `freshSession` (bool) - Whether to clear cookies before auth (default: true)
- `timeout` (Duration) - Authentication timeout (default: 3 minutes)
- `rerequestDeclinedPermissions` (bool) - Re-request declined permissions (default: false)

**Returns:** `FacebookWebAuthParams`

---

### FacebookGraphClient

HTTP client for making Facebook Graph API requests.

#### Constructor

```dart
FacebookGraphClient({required String accessToken})
```

**Parameters:**

- `accessToken` (String) - Valid Facebook access token

#### Methods

##### `getMe({String fields = 'id,name,email'})`

Fetches current user's profile information.

**Parameters:**

- `fields` (String) - Comma-separated list of fields to retrieve

**Returns:** `Future<Map<String, dynamic>>`

**Example:**

```dart
final userData = await client.getMe(
  fields: 'id,name,email,picture.width(200).height(200)',
);
```

##### `getAdAccounts({String fields = 'id,name,account_status'})`

Fetches user's ad accounts.

**Parameters:**

- `fields` (String) - Comma-separated list of fields to retrieve

**Returns:** `Future<Map<String, dynamic>>`

**Example:**

```dart
final adAccounts = await client.getAdAccounts(
  fields: 'id,name,account_status,currency,balance',
);
```

##### `getBusinesses({String fields = 'id,name'})`

Fetches user's businesses.

**Parameters:**

- `fields` (String) - Comma-separated list of fields to retrieve

**Returns:** `Future<Map<String, dynamic>>`

##### `getPages({String fields = 'id,name,category'})`

Fetches user's pages.

**Parameters:**

- `fields` (String) - Comma-separated list of fields to retrieve

**Returns:** `Future<Map<String, dynamic>>`

##### `customRequest(String endpoint, {Map<String, dynamic>? queryParameters})`

Makes a custom Graph API request.

**Parameters:**

- `endpoint` (String) - Graph API endpoint (e.g., '/me/photos')
- `queryParameters` (Map<String, dynamic>?) - Optional query parameters

**Returns:** `Future<Map<String, dynamic>>`

**Example:**

```dart
final customData = await client.customRequest(
  '/me/photos',
  queryParameters: {'limit': '10'},
);
```

##### `close()`

Closes the HTTP client and releases resources.

**Returns:** `void`

---

## 📊 Data Models

### FacebookWebAuthParams

Configuration parameters for Facebook OAuth authentication.

#### Properties

- `clientId` (String) - Facebook App ID
- `scopes` (List<String>) - List of permissions to request
- `configId` (String?) - Optional Facebook App Configuration ID
- `redirectUri` (String?) - Optional custom redirect URI
- `freshSession` (bool) - Whether to clear cookies before auth
- `timeout` (Duration) - Authentication timeout duration
- `rerequestDeclinedPermissions` (bool) - Re-request declined permissions

#### Constructor

```dart
FacebookWebAuthParams({
  required String clientId,
  required List<String> scopes,
  String? configId,
  String? redirectUri,
  bool freshSession = true,
  Duration timeout = const Duration(minutes: 3),
  bool rerequestDeclinedPermissions = false,
})
```

---

### FacebookWebAuthResult

Result of Facebook OAuth authentication attempt.

#### Union Type

`FacebookWebAuthResult` is a union type with the following variants:

##### `success(String accessToken, Duration? expiresIn, List<String> grantedScopes, List<String> declinedScopes)`

Authentication completed successfully.

**Properties:**

- `accessToken` (String) - Facebook access token
- `expiresIn` (Duration?) - Token expiration duration
- `grantedScopes` (List<String>) - Permissions granted by user
- `declinedScopes` (List<String>) - Permissions declined by user

##### `cancelled()`

User cancelled the authentication process.

##### `error(String errorDescription)`

Authentication failed with an error.

**Properties:**

- `errorDescription` (String) - Description of the error

##### `permissionsDeclined(List<String> declinedScopes)`

User declined all requested permissions.

**Properties:**

- `declinedScopes` (List<String>) - All declined permissions

##### `timeout()`

Authentication timed out.

##### `stateMismatch()`

CSRF state parameter mismatch (security issue).

#### Usage

```dart
result.when(
  success: (token, expires, granted, declined) {
    // Handle success
  },
  cancelled: () {
    // Handle cancellation
  },
  error: (error) {
    // Handle error
  },
  permissionsDeclined: (declined) {
    // Handle declined permissions
  },
  timeout: () {
    // Handle timeout
  },
  stateMismatch: () {
    // Handle security error
  },
);
```

#### Extension Methods

##### `isSuccess`

Returns `true` if the result is a success.

```dart
if (result.isSuccess) {
  // Handle success case
}
```

##### `isCancelled`

Returns `true` if the result was cancelled.

##### `isError`

Returns `true` if the result is an error.

##### `hasMissingScopes(List<String> requiredScopes)`

Returns `true` if any required scopes are missing from granted scopes.

```dart
if (result.hasMissingScopes(['ads_management'])) {
  // Handle missing permissions
}
```

---

### FacebookWebAuthStatus

Enumeration of possible authentication statuses.

#### Values

- `success` - Authentication completed successfully
- `cancelled` - User cancelled authentication
- `error` - Authentication failed with error
- `permissionsDeclined` - User declined permissions
- `timeout` - Authentication timed out
- `stateMismatch` - CSRF state mismatch

---

## 🛠️ Utility Classes

### FacebookGraphHelper

Helper class with utility methods for Facebook Graph API.

#### Static Methods

##### `isPermissionError(dynamic error)`

Checks if an error is related to insufficient permissions.

**Parameters:**

- `error` (dynamic) - Error object to check

**Returns:** `bool`

##### `isTokenError(dynamic error)`

Checks if an error is related to invalid or expired token.

**Parameters:**

- `error` (dynamic) - Error object to check

**Returns:** `bool`

##### `getErrorMessage(dynamic error)`

Extracts user-friendly error message from Facebook error.

**Parameters:**

- `error` (dynamic) - Error object

**Returns:** `String`

#### Static Properties

##### `basicScopes`

List of basic permission scopes.

**Type:** `List<String>`

**Value:** `['public_profile', 'email']`

##### `adsScopes`

List of advertising permission scopes.

**Type:** `List<String>`

**Value:** `['ads_management', 'ads_read']`

##### `businessScopes`

List of business permission scopes.

**Type:** `List<String>`

**Value:** `['business_management', 'pages_show_list', 'instagram_basic']`

##### `allBusinessScopes`

Combined list of all business-related permission scopes.

**Type:** `List<String>`

**Value:** Combination of `basicScopes`, `adsScopes`, and `businessScopes`

---

## 🔧 Service Classes

### FacebookWebAuthService

Internal service class for handling OAuth operations. (Not intended for direct use)

#### Static Methods

##### `isSuccessUrl(String url, [String? redirectUri])`

Checks if a URL is a Facebook OAuth success URL.

**Parameters:**

- `url` (String) - URL to check
- `redirectUri` (String?) - Optional custom redirect URI

**Returns:** `bool`

##### `isErrorUrl(String url)`

Checks if a URL contains Facebook OAuth errors.

**Parameters:**

- `url` (String) - URL to check

**Returns:** `bool`

##### `parseSuccessFragment(String url, String expectedState, List<String> requestedScopes, {String? redirectUri})`

Parses OAuth success response from URL fragment.

**Parameters:**

- `url` (String) - Success URL with fragment
- `expectedState` (String) - Expected CSRF state parameter
- `requestedScopes` (List<String>) - Originally requested scopes
- `redirectUri` (String?) - Optional custom redirect URI

**Returns:** `FacebookWebAuthResult`

##### `parseErrorResponse(String url)`

Parses OAuth error response from URL.

**Parameters:**

- `url` (String) - Error URL

**Returns:** `FacebookWebAuthResult`

##### `validateParams(FacebookWebAuthParams params)`

Validates OAuth parameters.

**Parameters:**

- `params` (FacebookWebAuthParams) - Parameters to validate

**Returns:** `String?` - Error message if invalid, null if valid

---

## 🎨 UI Components

### FacebookWebAuthScreen

Internal WebView screen for OAuth authentication. (Not intended for direct use)

This widget handles the WebView display and OAuth flow management internally.

---

## 📋 Constants

### Default Values

```dart
// Default timeout duration
const Duration defaultTimeout = Duration(minutes: 3);

// Default redirect URI
const String defaultRedirectUri = 'https://www.facebook.com/connect/login_success.html';

// Facebook OAuth base URL
const String facebookOAuthBaseUrl = 'https://www.facebook.com/v21.0/dialog/oauth';
```

### Permission Scopes

```dart
// Basic permissions (no review required)
const List<String> basicPermissions = [
  'public_profile',
  'email',
];

// Business permissions (may require review)
const List<String> businessPermissions = [
  'ads_management',
  'ads_read',
  'business_management',
  'pages_show_list',
  'instagram_basic',
];

// Advanced permissions (require review)
const List<String> advancedPermissions = [
  'pages_manage_ads',
  'instagram_manage_comments',
  'pages_manage_posts',
];
```

---

## 🚨 Error Handling

### Exception Types

The package uses standard Dart exceptions with descriptive messages:

- `Exception` - General authentication errors
- `TimeoutException` - Authentication timeout
- `FormatException` - Invalid response format
- `StateError` - Invalid state or configuration

### Error Messages

Common error message patterns:

```dart
// Authentication errors
'Authentication was cancelled by user'
'Authentication timed out'
'Invalid Facebook App configuration'
'Network error occurred'

// Permission errors
'Required permissions were declined'
'Insufficient permissions for this operation'
'Permission [permission_name] is required'

// Token errors
'Access token is invalid or expired'
'Failed to retrieve access token'
'Token validation failed'

// Configuration errors
'Invalid client ID format'
'Invalid redirect URI'
'Missing required configuration'
```

---

## 📖 Usage Examples

### Basic Authentication

```dart
final params = FacebookWebAuthConfigs.basic(
  clientId: 'your_app_id',
);

final result = await FacebookWebAuth().signIn(params, context: context);

result.when(
  success: (token, expires, granted, declined) {
    print('Success! Token: $token');
  },
  error: (error) {
    print('Error: $error');
  },
  // ... handle other cases
);
```

### Business Authentication with Graph API

```dart
final params = FacebookWebAuthConfigs.business(
  clientId: 'your_app_id',
  configId: 'your_config_id',
);

final result = await FacebookWebAuth().signIn(params, context: context);

await result.when(
  success: (token, expires, granted, declined) async {
    final client = FacebookGraphClient(accessToken: token);

    try {
      final userData = await client.getMe();
      final adAccounts = await client.getAdAccounts();

      print('User: ${userData['name']}');
      print('Ad Accounts: ${adAccounts['data'].length}');
    } finally {
      client.close();
    }
  },
  // ... handle other cases
);
```

### Custom Configuration

```dart
final params = FacebookWebAuthConfigs.custom(
  clientId: 'your_app_id',
  scopes: ['public_profile', 'email', 'ads_management'],
  configId: 'your_config_id',
  redirectUri: 'https://yourdomain.com/auth/callback',
  timeout: Duration(minutes: 5),
  rerequestDeclinedPermissions: true,
);

final result = await FacebookWebAuth().signIn(params, context: context);
```

---

## 🔄 Migration Guide

### From Version 0.x to 1.0

If migrating from a previous version, note these breaking changes:

1. **Configuration Classes**: Use `FacebookWebAuthConfigs` instead of manual parameter creation
2. **Result Handling**: Use the `when()` method for result handling
3. **Graph Client**: Create clients using `FacebookWebAuth().createGraphClient()`

### Deprecated Methods

None in version 1.0.0 (initial release).

---

## 🆘 Support

For API-related questions:

1. Check the [FAQ](FAQ) for common API usage questions
2. Review [Error Codes](Error-Codes) for specific error meanings
3. Visit [GitHub Issues](https://github.com/draz26648/facebook_webview_oauth/issues)
4. Contact support: [mohamed.draz1198@gmail.com](mailto:mohamed.draz1198@gmail.com)

---

**API Reference Version:** 1.0.0  
**Last Updated:** October 6, 2024
