import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../models/facebook_web_auth_models.dart';
import '../ui/facebook_web_auth_screen.dart';

/// Service for handling Facebook WebView-based OAuth authentication
class FacebookWebAuthService {
  static const String _facebookOAuthBaseUrl =
      'https://www.facebook.com/v21.0/dialog/oauth';

  /// Default redirect URI - Facebook's standard success URL
  static const String defaultRedirectUri =
      'https://www.facebook.com/connect/login_success.html';

  /// Singleton instance
  static final FacebookWebAuthService _instance =
      FacebookWebAuthService._internal();
  factory FacebookWebAuthService() => _instance;
  FacebookWebAuthService._internal();

  /// Main method to initiate Facebook OAuth authentication
  Future<FacebookWebAuthResult> signIn(
    FacebookWebAuthParams params, {
    BuildContext? context,
  }) async {
    try {
      // Generate CSRF state for security
      final state = _generateSecureState();

      // Build the OAuth URL
      final authUrl = buildAuthUrl(params, state);

      if (kDebugMode) {
        print('Facebook OAuth URL: $authUrl');
      }

      // Clear cookies if fresh session is requested
      if (params.freshSession) {
        await _clearCookiesAndCache();
      }

      // Navigate to WebView screen and wait for result
      final result = await _showWebViewScreen(
        context: context,
        authUrl: authUrl,
        params: params,
        expectedState: state,
      );

      return result;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Facebook OAuth error: $e');
        print('Stack trace: $stackTrace');
      }

      return FacebookWebAuthResult(
        status: FacebookWebAuthStatus.error,
        errorDescription: 'Failed to initiate Facebook OAuth: ${e.toString()}',
      );
    }
  }

  /// Build the Facebook OAuth URL with all required parameters
  @visibleForTesting
  String buildAuthUrl(FacebookWebAuthParams params, String state) {
    final redirectUri = params.redirectUri ?? defaultRedirectUri;

    final queryParams = <String, String>{
      'client_id': params.clientId,
      'redirect_uri': redirectUri,
      'response_type': 'token',
      'scope': params.scopes.join(','),
      'state': state,
      'display': 'popup',
    };

    // Add config_id if provided to avoid Limited Login
    if (params.configId != null && params.configId!.isNotEmpty) {
      queryParams['config_id'] = params.configId!;
    }

    // Add auth_type=rerequest if re-requesting declined permissions
    if (params.rerequestDeclinedPermissions) {
      queryParams['auth_type'] = 'rerequest';
    }

    final uri = Uri.parse(
      _facebookOAuthBaseUrl,
    ).replace(queryParameters: queryParams);

    return uri.toString();
  }

  /// Generate a cryptographically secure state parameter for CSRF protection
  String _generateSecureState() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(bytes).replaceAll('=', '');
  }

  /// Clear cookies and cache for fresh session
  Future<void> _clearCookiesAndCache() async {
    try {
      final cookieManager = CookieManager.instance();
      await cookieManager.deleteAllCookies();

      // Clear WebView cache
      if (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS) {
        await InAppWebViewController.clearAllCache();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear cookies/cache: $e');
      }
    }
  }

  /// Show the WebView screen and handle the OAuth flow
  Future<FacebookWebAuthResult> _showWebViewScreen({
    BuildContext? context,
    required String authUrl,
    required FacebookWebAuthParams params,
    required String expectedState,
  }) async {
    if (context == null) {
      return const FacebookWebAuthResult(
        status: FacebookWebAuthStatus.error,
        errorDescription: 'Context is required to show WebView screen',
      );
    }

    final result = await Navigator.of(context).push<FacebookWebAuthResult>(
      MaterialPageRoute(
        builder: (context) => FacebookWebAuthScreen(
          authUrl: authUrl,
          params: params,
          expectedState: expectedState,
        ),
        fullscreenDialog: true,
      ),
    );

    return result ??
        const FacebookWebAuthResult(
          status: FacebookWebAuthStatus.cancelled,
          errorDescription: 'User cancelled the authentication process',
        );
  }

  /// Parse the fragment from the success URL to extract token information
  static FacebookWebAuthResult parseSuccessFragment(
    String url,
    String expectedState,
    List<String> requestedScopes, {
    String? redirectUri,
  }) {
    try {
      final uri = Uri.parse(url);
      final targetUri = redirectUri ?? defaultRedirectUri;

      if (!url.startsWith(targetUri)) {
        return const FacebookWebAuthResult(
          status: FacebookWebAuthStatus.error,
          errorDescription: 'Invalid success URL',
        );
      }

      // Parse fragment parameters
      final fragment = uri.fragment;
      if (fragment.isEmpty) {
        return const FacebookWebAuthResult(
          status: FacebookWebAuthStatus.error,
          errorDescription: 'No fragment found in success URL',
        );
      }

      final fragmentParams = Uri.splitQueryString(fragment);

      // Verify state parameter for CSRF protection
      final returnedState = fragmentParams['state'];
      if (returnedState != expectedState) {
        return FacebookWebAuthResult(
          status: FacebookWebAuthStatus.stateMismatch,
          errorDescription:
              'State parameter mismatch. Expected: $expectedState, Got: $returnedState',
        );
      }

      // Extract token information
      final accessToken = fragmentParams['access_token'];
      final tokenType = fragmentParams['token_type'] ?? 'bearer';
      final expiresInStr = fragmentParams['expires_in'];

      if (kDebugMode) {
        print('Fragment params: $fragmentParams');
        print('Extracted access token: $accessToken');
        print('Token type: $tokenType');
        print('Expires in: $expiresInStr');
      }

      if (accessToken == null || accessToken.isEmpty) {
        return const FacebookWebAuthResult(
          status: FacebookWebAuthStatus.error,
          errorDescription: 'No access token found in response',
        );
      }

      // Parse expiration
      Duration? expiresIn;
      if (expiresInStr != null) {
        final expiresInSeconds = int.tryParse(expiresInStr);
        if (expiresInSeconds != null) {
          expiresIn = Duration(seconds: expiresInSeconds);
        }
      }

      // Parse granted and declined scopes
      final grantedScopesStr = fragmentParams['granted_scopes'];
      final declinedScopesStr = fragmentParams['denied_scopes'];

      final grantedScopes = grantedScopesStr?.split(',').toSet() ?? <String>{};
      final declinedScopes =
          declinedScopesStr?.split(',').toSet() ?? <String>{};

      // If no granted_scopes parameter, assume all requested scopes were granted
      if (grantedScopesStr == null) {
        grantedScopes.addAll(requestedScopes);
      }

      // Check if any required scopes were declined
      final hasDeclinedScopes = declinedScopes.isNotEmpty;
      final status = hasDeclinedScopes
          ? FacebookWebAuthStatus.permissionsDeclined
          : FacebookWebAuthStatus.success;

      return FacebookWebAuthResult(
        accessToken: accessToken,
        tokenType: tokenType,
        expiresIn: expiresIn,
        grantedScopes: grantedScopes,
        declinedScopes: declinedScopes,
        status: status,
        state: returnedState,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Error parsing success fragment: $e');
        print('Stack trace: $stackTrace');
      }

      return FacebookWebAuthResult(
        status: FacebookWebAuthStatus.error,
        errorDescription: 'Failed to parse success response: ${e.toString()}',
      );
    }
  }

  /// Parse error parameters from Facebook OAuth error response
  static FacebookWebAuthResult parseErrorResponse(String url) {
    try {
      final uri = Uri.parse(url);
      final queryParams = uri.queryParameters;

      final errorCode = queryParams['error'];
      final errorDescription = queryParams['error_description'];
      final errorReason = queryParams['error_reason'];

      // Map Facebook error codes to our status enum
      FacebookWebAuthStatus status;
      switch (errorCode) {
        case 'access_denied':
          status = errorReason == 'user_denied'
              ? FacebookWebAuthStatus.cancelled
              : FacebookWebAuthStatus.permissionsDeclined;
          break;
        case 'server_error':
        case 'temporarily_unavailable':
          status = FacebookWebAuthStatus.error;
          break;
        default:
          status = FacebookWebAuthStatus.error;
      }

      return FacebookWebAuthResult(
        status: status,
        errorCode: errorCode,
        errorDescription: errorDescription ?? 'Unknown Facebook OAuth error',
      );
    } catch (e) {
      return FacebookWebAuthResult(
        status: FacebookWebAuthStatus.error,
        errorDescription: 'Failed to parse error response: ${e.toString()}',
      );
    }
  }

  /// Check if a URL is the Facebook success URL
  static bool isSuccessUrl(String url, [String? redirectUri]) {
    final targetUri = redirectUri ?? defaultRedirectUri;
    return url.startsWith(targetUri);
  }

  /// Check if a URL contains Facebook OAuth errors
  static bool isErrorUrl(String url) {
    final uri = Uri.parse(url);
    return uri.queryParameters.containsKey('error');
  }

  /// Validate Facebook OAuth parameters before making the request
  static String? validateParams(FacebookWebAuthParams params) {
    if (params.clientId.isEmpty) {
      return 'Client ID is required';
    }

    if (params.scopes.isEmpty) {
      return 'At least one scope is required';
    }

    // Check for invalid characters in client ID
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(params.clientId)) {
      return 'Client ID contains invalid characters';
    }

    // Validate scopes format
    for (final scope in params.scopes) {
      if (scope.isEmpty || scope.contains(' ')) {
        return 'Invalid scope format: $scope';
      }
    }

    return null;
  }
}
