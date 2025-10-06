/// Facebook WebView OAuth Authentication Plugin
///
/// This plugin provides a complete solution for Facebook OAuth authentication
/// using WebView, specifically designed for Business users to avoid Limited Login
/// and ensure proper permissions for ads management and business operations.
library facebook_web_auth;

// Export all public APIs
export 'models/facebook_web_auth_models.dart';
export 'services/facebook_web_auth_service.dart';
export 'services/facebook_graph_client.dart';
export 'ui/facebook_web_auth_screen.dart';

import 'package:flutter/material.dart';
import 'models/facebook_web_auth_models.dart';
import 'services/facebook_web_auth_service.dart';
import 'services/facebook_graph_client.dart';

/// Main class for Facebook WebView OAuth authentication
///
/// This class provides a simple API for authenticating users with Facebook
/// using a WebView-based OAuth flow that supports Business permissions.
class FacebookWebAuth {
  static final FacebookWebAuth _instance = FacebookWebAuth._internal();
  factory FacebookWebAuth() => _instance;
  FacebookWebAuth._internal();

  final FacebookWebAuthService _service = FacebookWebAuthService();

  /// Authenticate user with Facebook using WebView OAuth flow
  ///
  /// [params] - Configuration parameters for the OAuth flow
  /// [context] - BuildContext required to show the WebView screen
  ///
  /// Returns [FacebookWebAuthResult] with authentication status and token information
  ///
  /// Example:
  /// ```dart
  /// final result = await FacebookWebAuth().signIn(
  ///   FacebookWebAuthParams(
  ///     clientId: 'your_facebook_app_id',
  ///     scopes: [
  ///       'email',
  ///       'public_profile',
  ///       'ads_management',
  ///       'ads_read',
  ///       'business_management',
  ///     ],
  ///     configId: 'your_config_id', // Optional, helps avoid Limited Login
  ///     freshSession: true,
  ///     timeout: Duration(minutes: 2),
  ///   ),
  ///   context: context,
  /// );
  ///
  /// if (result.isSuccess) {
  ///   // Use the access token
  ///   final client = FacebookGraphClient(accessToken: result.accessToken!);
  ///   final userInfo = await client.getMe();
  ///   print('User: ${userInfo['name']}');
  /// }
  /// ```
  Future<FacebookWebAuthResult> signIn(
    FacebookWebAuthParams params, {
    required BuildContext context,
  }) async {
    // Validate parameters
    final validationError = FacebookWebAuthService.validateParams(params);
    if (validationError != null) {
      return FacebookWebAuthResult(
        status: FacebookWebAuthStatus.error,
        errorDescription: validationError,
      );
    }

    return await _service.signIn(params, context: context);
  }

  /// Create a Facebook Graph API client with the given access token
  ///
  /// [accessToken] - Valid Facebook access token
  ///
  /// Returns [FacebookGraphClient] instance for making Graph API calls
  FacebookGraphClient createGraphClient(String accessToken) {
    return FacebookGraphClient(accessToken: accessToken);
  }

  /// Validate that an access token has the required permissions
  ///
  /// [accessToken] - Facebook access token to validate
  /// [requiredScopes] - List of required permission scopes
  ///
  /// Returns list of missing scopes (empty if all permissions are granted)
  Future<List<String>> validateTokenPermissions(
    String accessToken,
    List<String> requiredScopes,
  ) async {
    final client = FacebookGraphClient(accessToken: accessToken);
    try {
      return await client.verifyRequiredScopes(requiredScopes);
    } finally {
      client.close();
    }
  }

  /// Check if a Facebook Graph API error indicates missing permissions
  static bool isPermissionError(Exception error) {
    return FacebookGraphHelper.isPermissionError(error);
  }

  /// Check if a Facebook Graph API error indicates token issues
  static bool isTokenError(Exception error) {
    return FacebookGraphHelper.isTokenError(error);
  }

  /// Get a user-friendly error message from any Facebook-related exception
  static String getErrorMessage(Exception error) {
    return FacebookGraphHelper.getErrorMessage(error);
  }
}

/// Convenience class for common Facebook OAuth configurations
class FacebookWebAuthConfigs {
  /// Basic user information scopes
  static FacebookWebAuthParams basic({
    required String clientId,
    String? configId,
    String? redirectUri,
    bool freshSession = true,
    Duration timeout = const Duration(minutes: 3),
  }) {
    return FacebookWebAuthParams(
      clientId: clientId,
      scopes: FacebookGraphHelper.basicScopes,
      configId: configId,
      redirectUri: redirectUri,
      freshSession: freshSession,
      timeout: timeout,
    );
  }

  /// Business and ads management scopes
  static FacebookWebAuthParams business({
    required String clientId,
    String? configId,
    String? redirectUri,
    bool freshSession = true,
    Duration timeout = const Duration(minutes: 3),
  }) {
    return FacebookWebAuthParams(
      clientId: clientId,
      scopes: FacebookGraphHelper.allBusinessScopes,
      configId: configId,
      redirectUri: redirectUri,
      freshSession: freshSession,
      timeout: timeout,
    );
  }

  /// Ads management only scopes
  static FacebookWebAuthParams adsOnly({
    required String clientId,
    String? configId,
    String? redirectUri,
    bool freshSession = true,
    Duration timeout = const Duration(minutes: 3),
  }) {
    return FacebookWebAuthParams(
      clientId: clientId,
      scopes: [
        ...FacebookGraphHelper.basicScopes,
        ...FacebookGraphHelper.adsScopes,
      ],
      configId: configId,
      redirectUri: redirectUri,
      freshSession: freshSession,
      timeout: timeout,
    );
  }

  /// Custom scopes configuration
  static FacebookWebAuthParams custom({
    required String clientId,
    required List<String> scopes,
    String? configId,
    String? redirectUri,
    bool freshSession = true,
    Duration timeout = const Duration(minutes: 3),
    bool rerequestDeclinedPermissions = false,
  }) {
    return FacebookWebAuthParams(
      clientId: clientId,
      scopes: scopes,
      configId: configId,
      redirectUri: redirectUri,
      freshSession: freshSession,
      timeout: timeout,
      rerequestDeclinedPermissions: rerequestDeclinedPermissions,
    );
  }
}
