import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../models/facebook_web_auth_models.dart';
import '../services/facebook_web_auth_service.dart';

/// WebView screen for Facebook OAuth authentication
class FacebookWebAuthScreen extends StatefulWidget {
  final String authUrl;
  final FacebookWebAuthParams params;
  final String expectedState;

  const FacebookWebAuthScreen({
    Key? key,
    required this.authUrl,
    required this.params,
    required this.expectedState,
  }) : super(key: key);

  @override
  State<FacebookWebAuthScreen> createState() => _FacebookWebAuthScreenState();
}

class _FacebookWebAuthScreenState extends State<FacebookWebAuthScreen> {
  InAppWebViewController? _webViewController;
  bool _isLoading = true;
  String? _currentUrl;
  Timer? _timeoutTimer;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimeout();
  }

  @override
  void dispose() {
    _timeoutTimer?.cancel();
    super.dispose();
  }

  /// Start the timeout timer
  void _startTimeout() {
    _timeoutTimer = Timer(widget.params.timeout, () {
      if (mounted) {
        _handleResult(
          const FacebookWebAuthResult(
            status: FacebookWebAuthStatus.timeout,
            errorDescription: 'Authentication timed out',
          ),
        );
      }
    });
  }

  /// Handle the authentication result and close the screen
  void _handleResult(FacebookWebAuthResult result) {
    _timeoutTimer?.cancel();
    if (mounted) {
      Navigator.of(context).pop(result);
    }
  }

  /// Extract access token from current session when OAuth doesn't redirect properly
  Future<void> _extractTokenFromSession(
    InAppWebViewController controller,
  ) async {
    try {
      if (kDebugMode) {
        print('Attempting to extract access token from Facebook session...');
      }

      // Try to get access token using JavaScript
      final jsCode = '''
        (function() {
          try {
            // Try to get access token from various possible locations
            var token = null;
            
            // Method 1: Check if there's an access token in the URL hash
            if (window.location.hash) {
              var hash = window.location.hash.substring(1);
              var params = new URLSearchParams(hash);
              token = params.get('access_token');
              if (token) {
                return {
                  success: true,
                  access_token: token,
                  expires_in: params.get('expires_in'),
                  token_type: params.get('token_type') || 'bearer',
                  state: params.get('state'),
                  granted_scopes: params.get('granted_scopes'),
                  denied_scopes: params.get('denied_scopes')
                };
              }
            }
            
            // Method 2: Try to get token from Facebook's JavaScript SDK if available
            if (typeof FB !== 'undefined' && FB.getAccessToken) {
              token = FB.getAccessToken();
              if (token) {
                return {
                  success: true,
                  access_token: token,
                  token_type: 'bearer'
                };
              }
            }
            
            // Method 3: Check localStorage for any stored token
            if (typeof localStorage !== 'undefined') {
              var storedToken = localStorage.getItem('accessToken') || 
                               localStorage.getItem('access_token') ||
                               localStorage.getItem('fb_access_token');
              if (storedToken) {
                return {
                  success: true,
                  access_token: storedToken,
                  token_type: 'bearer'
                };
              }
            }
            
            return { success: false, error: 'No access token found' };
          } catch (e) {
            return { success: false, error: e.toString() };
          }
        })();
      ''';

      final result = await controller.evaluateJavascript(source: jsCode);

      if (kDebugMode) {
        print('JavaScript result: $result');
      }

      if (result != null && result is Map) {
        final success = result['success'] == true;
        if (success) {
          final accessToken = result['access_token'] as String?;
          if (kDebugMode) {
            print('Extracted access token: $accessToken');
            print('Access token length: ${accessToken?.length ?? 0}');
          }
          if (accessToken != null && accessToken.isNotEmpty) {
            // Create a successful result
            final authResult = FacebookWebAuthResult(
              status: FacebookWebAuthStatus.success,
              accessToken: accessToken,
              tokenType: result['token_type'] as String? ?? 'bearer',
              expiresIn: result['expires_in'] != null
                  ? Duration(
                      seconds:
                          int.tryParse(result['expires_in'].toString()) ?? 3600,
                    )
                  : null,
              state: result['state'] as String?,
              grantedScopes: result['granted_scopes'] != null
                  ? (result['granted_scopes'] as String).split(',').toSet()
                  : widget.params.scopes.toSet(),
              declinedScopes: result['denied_scopes'] != null
                  ? (result['denied_scopes'] as String).split(',').toSet()
                  : <String>{},
            );

            if (kDebugMode) {
              print(
                'Successfully extracted access token: ${accessToken.substring(0, 20)}...',
              );
            }

            _handleResult(authResult);
            return;
          }
        }
      }

      // If we couldn't extract the token, show an error
      if (kDebugMode) {
        print('Failed to extract access token from session');
      }

      _handleResult(
        const FacebookWebAuthResult(
          status: FacebookWebAuthStatus.error,
          errorDescription:
              'Login completed but could not retrieve access token. Please try again.',
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error extracting token from session: $e');
      }

      _handleResult(
        FacebookWebAuthResult(
          status: FacebookWebAuthStatus.error,
          errorDescription: 'Failed to extract access token: ${e.toString()}',
        ),
      );
    }
  }

  /// Attempt to manually redirect to OAuth completion when user is logged in
  Future<void> _attemptManualOAuthRedirect(
    InAppWebViewController controller,
  ) async {
    try {
      if (kDebugMode) {
        print('Attempting manual OAuth redirect...');
      }

      // Reconstruct the OAuth URL to force completion
      final originalUrl = widget.authUrl;

      if (kDebugMode) {
        print('Redirecting to OAuth URL: $originalUrl');
      }

      // Load the original OAuth URL again - this should now complete since user is logged in
      await controller.loadUrl(
        urlRequest: URLRequest(url: WebUri(originalUrl)),
      );

      // Give it a moment, then try to extract token if still no redirect
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          _extractTokenFromSession(controller);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in manual OAuth redirect: $e');
      }
      _extractTokenFromSession(controller);
    }
  }

  /// Handle URL changes in the WebView
  void _handleUrlChange(String url) {
    setState(() {
      _currentUrl = url;
    });

    if (kDebugMode) {
      print('WebView URL changed: $url');
      print(
        'Checking if success URL: ${FacebookWebAuthService.isSuccessUrl(url, widget.params.redirectUri)}',
      );
      print('Checking if error URL: ${FacebookWebAuthService.isErrorUrl(url)}');
    }

    // Check if this is the success URL
    if (FacebookWebAuthService.isSuccessUrl(url, widget.params.redirectUri)) {
      final result = FacebookWebAuthService.parseSuccessFragment(
        url,
        widget.expectedState,
        widget.params.scopes,
        redirectUri: widget.params.redirectUri,
      );
      _handleResult(result);
      return;
    }

    // Check if this is an error URL
    if (FacebookWebAuthService.isErrorUrl(url)) {
      final result = FacebookWebAuthService.parseErrorResponse(url);
      _handleResult(result);
      return;
    }

    // Check for actual error URLs (not just URLs that contain error parameters in other contexts)
    final uri = Uri.tryParse(url);
    if (uri != null) {
      // Only treat as cancellation if it's actually an error response, not just a URL containing error parameters
      final actualError = uri.queryParameters['error'];
      final actualErrorReason = uri.queryParameters['error_reason'];

      if (kDebugMode) {
        print('URL query parameters: ${uri.queryParameters}');
        print(
          'Actual error: $actualError, Actual error reason: $actualErrorReason',
        );
      }

      if (actualError == 'access_denied' &&
          actualErrorReason == 'user_denied') {
        if (kDebugMode) {
          print('Detected user cancellation');
        }
        _handleResult(
          const FacebookWebAuthResult(
            status: FacebookWebAuthStatus.cancelled,
            errorDescription: 'User cancelled the authentication',
          ),
        );
        return;
      }
    }
  }

  /// Handle WebView navigation decisions
  NavigationActionPolicy _shouldOverrideUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) {
    final url = navigationAction.request.url?.toString() ?? '';

    if (kDebugMode) {
      print('Navigation requested to: $url');
    }

    // Block non-HTTPS URLs for security
    if (!url.startsWith('https://') && !url.startsWith('http://localhost')) {
      if (kDebugMode) {
        print('Blocked non-HTTPS URL: $url');
      }
      return NavigationActionPolicy.CANCEL;
    }

    // Allow Facebook domains and custom redirect domain
    final uri = Uri.tryParse(url);
    if (uri != null) {
      final host = uri.host.toLowerCase();
      final allowedHosts = [
        'www.facebook.com',
        'm.facebook.com',
        'facebook.com',
        'web.facebook.com',
      ];

      // Add custom redirect domain if provided
      final redirectUri =
          widget.params.redirectUri ??
          FacebookWebAuthService.defaultRedirectUri;
      final redirectHost = Uri.parse(redirectUri).host.toLowerCase();
      if (!allowedHosts.contains(redirectHost)) {
        allowedHosts.add(redirectHost);
      }

      if (!allowedHosts.contains(host)) {
        if (kDebugMode) {
          print('Blocked URL from unauthorized host: $url');
        }
        return NavigationActionPolicy.CANCEL;
      }

      // If we're being redirected to mobile Facebook, try to force desktop version
      if (host == 'm.facebook.com') {
        if (kDebugMode) {
          print(
            'Detected mobile redirect, attempting to force desktop version',
          );
        }
        // Convert mobile URL to desktop URL
        final desktopUrl = url.replaceFirst(
          'm.facebook.com',
          'www.facebook.com',
        );
        controller.loadUrl(urlRequest: URLRequest(url: WebUri(desktopUrl)));
        return NavigationActionPolicy.CANCEL;
      }

      // Check if user is being redirected to Facebook home page after login
      // This might indicate the OAuth flow completed but didn't redirect properly
      if ((host == 'www.facebook.com' || host == 'facebook.com') &&
          (url.contains('/home') ||
              url == 'https://www.facebook.com/' ||
              url == 'https://facebook.com/')) {
        if (kDebugMode) {
          print(
            'Detected redirect to Facebook home page - OAuth might have completed',
          );
          print('Attempting to extract token from current session...');
        }

        // Try to manually redirect to the OAuth completion URL first
        _attemptManualOAuthRedirect(controller);
        return NavigationActionPolicy.CANCEL;
      }
    }

    _handleUrlChange(url);
    return NavigationActionPolicy.ALLOW;
  }

  /// Handle WebView loading errors
  void _handleWebViewError(
    InAppWebViewController controller,
    WebResourceRequest request,
    WebResourceError error,
  ) {
    if (kDebugMode) {
      print('WebView error: ${error.description} (${error.type})');
    }

    setState(() {
      _errorMessage =
          'Failed to load Facebook login page: ${error.description}';
      _isLoading = false;
    });
  }

  /// Retry loading the WebView
  void _retry() {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });
    _webViewController?.loadUrl(
      urlRequest: URLRequest(url: WebUri(widget.authUrl)),
    );
  }

  /// Handle back button press
  Future<bool> _onWillPop() async {
    _handleResult(
      const FacebookWebAuthResult(
        status: FacebookWebAuthStatus.cancelled,
        errorDescription: 'User cancelled the authentication',
      ),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          await _onWillPop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Facebook Login'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _onWillPop(),
          ),
          actions: [
            if (_currentUrl != null)
              IconButton(icon: const Icon(Icons.refresh), onPressed: _retry),
          ],
        ),
        body: Column(
          children: [
            // Progress indicator
            if (_isLoading) const LinearProgressIndicator(),

            // Error message
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                color: Colors.red.shade50,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Connection Error',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red.shade600),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: _retry,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

            // WebView
            Expanded(
              child: InAppWebView(
                initialUrlRequest: URLRequest(url: WebUri(widget.authUrl)),
                initialSettings: InAppWebViewSettings(
                  javaScriptEnabled: true,
                  domStorageEnabled: true,
                  databaseEnabled: true,
                  userAgent: _getUserAgent(),
                  // Security settings
                  allowsInlineMediaPlayback: false,
                  allowsPictureInPictureMediaPlayback: false,
                  allowsAirPlayForMediaPlayback: false,
                  // Clear cache settings
                  clearCache: widget.params.freshSession,
                  clearSessionCache: widget.params.freshSession,
                  // iOS specific
                  allowsLinkPreview: false,
                  allowsBackForwardNavigationGestures: true,
                  // Android specific
                  supportZoom: false,
                  displayZoomControls: false,
                  builtInZoomControls: false,
                  // Force desktop mode
                  preferredContentMode: UserPreferredContentMode.DESKTOP,
                  // Disable automatic redirects that might cause domain issues
                  useShouldOverrideUrlLoading: true,
                ),
                onWebViewCreated: (controller) {
                  _webViewController = controller;
                },
                onLoadStart: (controller, url) {
                  if (kDebugMode) {
                    print('WebView started loading: $url');
                  }
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                },
                onLoadStop: (controller, url) {
                  if (kDebugMode) {
                    print('WebView finished loading: $url');
                  }
                  setState(() {
                    _isLoading = false;
                  });

                  if (url != null) {
                    _handleUrlChange(url.toString());
                  }
                },
                onReceivedError: _handleWebViewError,
                onReceivedHttpError: (controller, request, errorResponse) {
                  if (kDebugMode) {
                    print('WebView HTTP error: ${errorResponse.statusCode}');
                  }
                  setState(() {
                    _errorMessage = 'HTTP Error: ${errorResponse.statusCode}';
                    _isLoading = false;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  return _shouldOverrideUrlLoading(
                    controller,
                    navigationAction,
                  );
                },
                onUpdateVisitedHistory: (controller, url, isReload) {
                  if (url != null) {
                    _handleUrlChange(url.toString());
                  }
                },
                onConsoleMessage: (controller, consoleMessage) {
                  if (kDebugMode) {
                    print('WebView Console: ${consoleMessage.message}');
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get appropriate user agent for the WebView
  String _getUserAgent() {
    // Use a desktop browser user agent to avoid mobile redirects and domain issues
    return 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36';
  }
}
