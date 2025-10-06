import 'package:freezed_annotation/freezed_annotation.dart';

part 'facebook_web_auth_models.freezed.dart';
part 'facebook_web_auth_models.g.dart';

/// Status of the Facebook WebView authentication process
enum FacebookWebAuthStatus {
  /// Authentication completed successfully
  success,

  /// User cancelled the authentication process
  cancelled,

  /// An error occurred during authentication
  error,

  /// User declined required permissions
  permissionsDeclined,

  /// Authentication timed out
  timeout,

  /// CSRF state parameter mismatch (security issue)
  stateMismatch,
}

/// Parameters for configuring Facebook WebView authentication
@freezed
class FacebookWebAuthParams with _$FacebookWebAuthParams {
  const factory FacebookWebAuthParams({
    /// Facebook App Client ID
    required String clientId,

    /// List of permissions/scopes to request
    /// e.g., ["email", "public_profile", "ads_management", "ads_read", "business_management"]
    required List<String> scopes,

    /// Optional Facebook App Config ID to avoid Limited Login
    String? configId,

    /// Custom redirect URI for OAuth flow
    /// Defaults to 'https://www.facebook.com/connect/login_success.html'
    /// You can use your own domain, e.g., 'https://yourdomain.com/auth/facebook/callback'
    String? redirectUri,

    /// Whether to clear cookies/cache before starting authentication
    @Default(true) bool freshSession,

    /// Timeout duration for the authentication process
    @Default(Duration(minutes: 3)) Duration timeout,

    /// Whether to re-request previously declined permissions
    @Default(false) bool rerequestDeclinedPermissions,
  }) = _FacebookWebAuthParams;

  factory FacebookWebAuthParams.fromJson(Map<String, dynamic> json) =>
      _$FacebookWebAuthParamsFromJson(json);
}

/// Result of the Facebook WebView authentication process
@freezed
class FacebookWebAuthResult with _$FacebookWebAuthResult {
  const factory FacebookWebAuthResult({
    /// Access token returned by Facebook (null if authentication failed)
    String? accessToken,

    /// Token expiration duration (null if not provided or authentication failed)
    Duration? expiresIn,

    /// Token type (usually "bearer")
    String? tokenType,

    /// Set of permissions that were granted by the user
    @Default({}) Set<String> grantedScopes,

    /// Set of permissions that were declined by the user
    @Default({}) Set<String> declinedScopes,

    /// Status of the authentication process
    required FacebookWebAuthStatus status,

    /// Error description if status is error
    String? errorDescription,

    /// Error code from Facebook if available
    String? errorCode,

    /// CSRF state parameter that was used in the request
    String? state,
  }) = _FacebookWebAuthResult;

  factory FacebookWebAuthResult.fromJson(Map<String, dynamic> json) =>
      _$FacebookWebAuthResultFromJson(json);
}

/// Extension to provide convenience methods for FacebookWebAuthResult
extension FacebookWebAuthResultExtension on FacebookWebAuthResult {
  /// Whether the authentication was successful
  bool get isSuccess => status == FacebookWebAuthStatus.success;

  /// Whether the authentication was cancelled by the user
  bool get isCancelled => status == FacebookWebAuthStatus.cancelled;

  /// Whether there was an error during authentication
  bool get hasError => status == FacebookWebAuthStatus.error;

  /// Whether the user declined required permissions
  bool get hasPermissionsDeclined =>
      status == FacebookWebAuthStatus.permissionsDeclined;

  /// Whether the authentication timed out
  bool get isTimeout => status == FacebookWebAuthStatus.timeout;

  /// Whether there was a state mismatch (security issue)
  bool get hasStateMismatch => status == FacebookWebAuthStatus.stateMismatch;

  /// Whether the result has a valid access token
  bool get hasValidToken =>
      isSuccess && accessToken != null && accessToken!.isNotEmpty;

  /// Get missing scopes that were requested but not granted
  Set<String> getMissingScopes(List<String> requestedScopes) {
    return requestedScopes.toSet().difference(grantedScopes);
  }
}

/// Facebook Graph API error response
@freezed
class FacebookGraphError with _$FacebookGraphError {
  const factory FacebookGraphError({
    required String message,
    required String type,
    required int code,
    String? errorSubcode,
    String? fbtrace_id,
  }) = _FacebookGraphError;

  factory FacebookGraphError.fromJson(Map<String, dynamic> json) =>
      _$FacebookGraphErrorFromJson(json);
}

/// Facebook Graph API response wrapper
@freezed
class FacebookGraphResponse with _$FacebookGraphResponse {
  const factory FacebookGraphResponse({
    Map<String, dynamic>? data,
    FacebookGraphError? error,
  }) = _FacebookGraphResponse;

  factory FacebookGraphResponse.fromJson(Map<String, dynamic> json) =>
      _$FacebookGraphResponseFromJson(json);
}
