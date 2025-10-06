import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_webview_oauth/facebook_webview_oauth.dart';

void main() {
  group('FacebookWebAuthService', () {
    group('URL Building', () {
      test('should build correct OAuth URL with basic parameters', () {
        const clientId = 'test_client_id';
        const scopes = ['email', 'public_profile'];
        const state = 'test_state';

        final params = FacebookWebAuthParams(
          clientId: clientId,
          scopes: scopes,
        );

        final service = FacebookWebAuthService();
        final url = service.buildAuthUrl(params, state);

        expect(url, contains('https://www.facebook.com/v21.0/dialog/oauth'));
        expect(url, contains('client_id=$clientId'));
        expect(
          url,
          contains(
            'redirect_uri=https%3A%2F%2Fwww.facebook.com%2Fconnect%2Flogin_success.html',
          ),
        );
        expect(url, contains('response_type=token'));
        expect(url, contains('scope=email%2Cpublic_profile'));
        expect(url, contains('state=$state'));
        expect(url, contains('display=popup'));
      });

      test('should include config_id when provided', () {
        const configId = 'test_config_id';

        final params = FacebookWebAuthParams(
          clientId: 'test_client_id',
          scopes: ['email'],
          configId: configId,
        );

        final service = FacebookWebAuthService();
        final url = service.buildAuthUrl(params, 'test_state');

        expect(url, contains('config_id=$configId'));
      });

      test('should use custom redirect URI when provided', () {
        const customRedirectUri = 'https://myapp.com/auth/facebook/callback';

        final params = FacebookWebAuthParams(
          clientId: 'test_client_id',
          scopes: ['email'],
          redirectUri: customRedirectUri,
        );

        final service = FacebookWebAuthService();
        final url = service.buildAuthUrl(params, 'test_state');

        expect(
          url,
          contains(
            'redirect_uri=https%3A%2F%2Fmyapp.com%2Fauth%2Ffacebook%2Fcallback',
          ),
        );
      });

      test(
        'should include auth_type=rerequest when rerequesting permissions',
        () {
          final params = FacebookWebAuthParams(
            clientId: 'test_client_id',
            scopes: ['email'],
            rerequestDeclinedPermissions: true,
          );

          final service = FacebookWebAuthService();
          final url = service.buildAuthUrl(params, 'test_state');

          expect(url, contains('auth_type=rerequest'));
        },
      );

      test('should properly encode scopes with special characters', () {
        const scopes = ['ads_management', 'business_management'];

        final params = FacebookWebAuthParams(
          clientId: 'test_client_id',
          scopes: scopes,
        );

        final service = FacebookWebAuthService();
        final url = service.buildAuthUrl(params, 'test_state');

        expect(url, contains('scope=ads_management%2Cbusiness_management'));
      });
    });

    group('Fragment Parsing', () {
      test('should parse successful authentication response', () {
        const url =
            'https://www.facebook.com/connect/login_success.html#access_token=test_token&token_type=bearer&expires_in=3600&state=test_state';
        const expectedState = 'test_state';
        const requestedScopes = ['email', 'public_profile'];

        final result = FacebookWebAuthService.parseSuccessFragment(
          url,
          expectedState,
          requestedScopes,
        );

        expect(result.status, FacebookWebAuthStatus.success);
        expect(result.accessToken, 'test_token');
        expect(result.tokenType, 'bearer');
        expect(result.expiresIn, const Duration(seconds: 3600));
        expect(result.state, expectedState);
      });

      test('should handle missing access token', () {
        const url =
            'https://www.facebook.com/connect/login_success.html#token_type=bearer&expires_in=3600&state=test_state';
        const expectedState = 'test_state';
        const requestedScopes = ['email'];

        final result = FacebookWebAuthService.parseSuccessFragment(
          url,
          expectedState,
          requestedScopes,
        );

        expect(result.status, FacebookWebAuthStatus.error);
        expect(result.errorDescription, contains('No access token found'));
      });

      test('should detect state mismatch', () {
        const url =
            'https://www.facebook.com/connect/login_success.html#access_token=test_token&state=wrong_state';
        const expectedState = 'correct_state';
        const requestedScopes = ['email'];

        final result = FacebookWebAuthService.parseSuccessFragment(
          url,
          expectedState,
          requestedScopes,
        );

        expect(result.status, FacebookWebAuthStatus.stateMismatch);
        expect(result.errorDescription, contains('State parameter mismatch'));
      });

      test('should parse granted and declined scopes', () {
        const url =
            'https://www.facebook.com/connect/login_success.html#access_token=test_token&granted_scopes=email%2Cpublic_profile&denied_scopes=ads_management&state=test_state';
        const expectedState = 'test_state';
        const requestedScopes = ['email', 'public_profile', 'ads_management'];

        final result = FacebookWebAuthService.parseSuccessFragment(
          url,
          expectedState,
          requestedScopes,
        );

        expect(result.status, FacebookWebAuthStatus.permissionsDeclined);
        expect(result.grantedScopes, {'email', 'public_profile'});
        expect(result.declinedScopes, {'ads_management'});
      });

      test('should handle malformed fragment', () {
        const url =
            'https://www.facebook.com/connect/login_success.html#invalid_fragment';
        const expectedState = 'test_state';
        const requestedScopes = ['email'];

        final result = FacebookWebAuthService.parseSuccessFragment(
          url,
          expectedState,
          requestedScopes,
        );

        // The malformed fragment will cause a state mismatch since no state is found
        expect(result.status, FacebookWebAuthStatus.stateMismatch);
        expect(result.errorDescription, contains('State parameter mismatch'));
      });

      test('should handle empty fragment', () {
        const url = 'https://www.facebook.com/connect/login_success.html#';
        const expectedState = 'test_state';
        const requestedScopes = ['email'];

        final result = FacebookWebAuthService.parseSuccessFragment(
          url,
          expectedState,
          requestedScopes,
        );

        expect(result.status, FacebookWebAuthStatus.error);
        expect(result.errorDescription, contains('No fragment found'));
      });
    });

    group('Error Response Parsing', () {
      test('should parse access denied error', () {
        const url =
            'https://www.facebook.com/dialog/oauth?error=access_denied&error_code=200&error_description=Permissions+error&error_reason=user_denied';

        final result = FacebookWebAuthService.parseErrorResponse(url);

        expect(result.status, FacebookWebAuthStatus.cancelled);
        expect(result.errorCode, 'access_denied');
        expect(result.errorDescription, 'Permissions error');
      });

      test('should parse server error', () {
        const url =
            'https://www.facebook.com/dialog/oauth?error=server_error&error_description=Internal+server+error';

        final result = FacebookWebAuthService.parseErrorResponse(url);

        expect(result.status, FacebookWebAuthStatus.error);
        expect(result.errorCode, 'server_error');
        expect(result.errorDescription, 'Internal server error');
      });

      test('should handle unknown error', () {
        const url = 'https://www.facebook.com/dialog/oauth?error=unknown_error';

        final result = FacebookWebAuthService.parseErrorResponse(url);

        expect(result.status, FacebookWebAuthStatus.error);
        expect(result.errorCode, 'unknown_error');
      });
    });

    group('URL Detection', () {
      test('should detect success URL', () {
        const url =
            'https://www.facebook.com/connect/login_success.html#access_token=test';

        expect(FacebookWebAuthService.isSuccessUrl(url), isTrue);
      });

      test('should detect non-success URL', () {
        const url = 'https://www.facebook.com/login.php';

        expect(FacebookWebAuthService.isSuccessUrl(url), isFalse);
      });

      test('should detect custom redirect URI success URL', () {
        const customRedirectUri = 'https://myapp.com/auth/facebook/callback';
        const url =
            'https://myapp.com/auth/facebook/callback#access_token=test';

        expect(
          FacebookWebAuthService.isSuccessUrl(url, customRedirectUri),
          isTrue,
        );
      });

      test('should not detect wrong custom redirect URI', () {
        const customRedirectUri = 'https://myapp.com/auth/facebook/callback';
        const url =
            'https://wrongdomain.com/auth/facebook/callback#access_token=test';

        expect(
          FacebookWebAuthService.isSuccessUrl(url, customRedirectUri),
          isFalse,
        );
      });

      test('should detect error URL', () {
        const url = 'https://www.facebook.com/dialog/oauth?error=access_denied';

        expect(FacebookWebAuthService.isErrorUrl(url), isTrue);
      });

      test('should detect non-error URL', () {
        const url = 'https://www.facebook.com/login.php';

        expect(FacebookWebAuthService.isErrorUrl(url), isFalse);
      });
    });

    group('Parameter Validation', () {
      test('should validate valid parameters', () {
        final params = FacebookWebAuthParams(
          clientId: '123456789012345', // Use numeric client ID which is valid
          scopes: ['email', 'public_profile'],
        );

        final error = FacebookWebAuthService.validateParams(params);

        expect(error, isNull);
      });

      test('should reject empty client ID', () {
        final params = FacebookWebAuthParams(clientId: '', scopes: ['email']);

        final error = FacebookWebAuthService.validateParams(params);

        expect(error, contains('Client ID is required'));
      });

      test('should reject empty scopes', () {
        final params = FacebookWebAuthParams(
          clientId: 'valid_client_id',
          scopes: [],
        );

        final error = FacebookWebAuthService.validateParams(params);

        expect(error, contains('At least one scope is required'));
      });

      test('should reject invalid client ID characters', () {
        final params = FacebookWebAuthParams(
          clientId: 'invalid-client-id!',
          scopes: ['email'],
        );

        final error = FacebookWebAuthService.validateParams(params);

        expect(error, contains('Client ID contains invalid characters'));
      });

      test('should reject invalid scope format', () {
        final params = FacebookWebAuthParams(
          clientId: '123456789012345', // Use valid numeric client ID
          scopes: ['invalid scope'],
        );

        final error = FacebookWebAuthService.validateParams(params);

        expect(error, contains('Invalid scope format'));
      });
    });
  });

  group('FacebookWebAuthResult Extensions', () {
    test('should correctly identify success status', () {
      const result = FacebookWebAuthResult(
        status: FacebookWebAuthStatus.success,
        accessToken: 'test_token',
      );

      expect(result.isSuccess, isTrue);
      expect(result.isCancelled, isFalse);
      expect(result.hasError, isFalse);
      expect(result.hasValidToken, isTrue);
    });

    test('should correctly identify cancelled status', () {
      const result = FacebookWebAuthResult(
        status: FacebookWebAuthStatus.cancelled,
      );

      expect(result.isSuccess, isFalse);
      expect(result.isCancelled, isTrue);
      expect(result.hasError, isFalse);
      expect(result.hasValidToken, isFalse);
    });

    test('should correctly identify missing scopes', () {
      const result = FacebookWebAuthResult(
        status: FacebookWebAuthStatus.success,
        grantedScopes: {'email', 'public_profile'},
      );

      final requestedScopes = ['email', 'public_profile', 'ads_management'];
      final missingScopes = result.getMissingScopes(requestedScopes);

      expect(missingScopes, {'ads_management'});
    });

    test('should handle empty granted scopes', () {
      const result = FacebookWebAuthResult(
        status: FacebookWebAuthStatus.success,
        grantedScopes: {},
      );

      final requestedScopes = ['email', 'public_profile'];
      final missingScopes = result.getMissingScopes(requestedScopes);

      expect(missingScopes, {'email', 'public_profile'});
    });
  });

  group('FacebookWebAuthConfigs', () {
    test('should create basic configuration', () {
      final config = FacebookWebAuthConfigs.basic(clientId: 'test_client_id');

      expect(config.clientId, 'test_client_id');
      expect(config.scopes, FacebookGraphHelper.basicScopes);
      expect(config.freshSession, isTrue);
    });

    test('should create business configuration', () {
      final config = FacebookWebAuthConfigs.business(
        clientId: 'test_client_id',
        configId: 'test_config_id',
      );

      expect(config.clientId, 'test_client_id');
      expect(config.configId, 'test_config_id');
      expect(config.scopes, FacebookGraphHelper.allBusinessScopes);
    });

    test('should create ads-only configuration', () {
      final config = FacebookWebAuthConfigs.adsOnly(clientId: 'test_client_id');

      expect(config.clientId, 'test_client_id');
      expect(config.scopes, contains('email'));
      expect(config.scopes, contains('ads_management'));
      expect(config.scopes, contains('ads_read'));
    });

    test('should create custom configuration', () {
      const customScopes = ['email', 'custom_scope'];

      final config = FacebookWebAuthConfigs.custom(
        clientId: 'test_client_id',
        scopes: customScopes,
        rerequestDeclinedPermissions: true,
      );

      expect(config.clientId, 'test_client_id');
      expect(config.scopes, customScopes);
      expect(config.rerequestDeclinedPermissions, isTrue);
    });
  });

  group('FacebookGraphHelper', () {
    test('should identify permission errors', () {
      const error = FacebookGraphException(
        message: 'Permission denied',
        type: 'OAuthException',
        code: 200,
      );

      expect(FacebookGraphHelper.isPermissionError(error), isTrue);
    });

    test('should identify token errors', () {
      const error = FacebookGraphException(
        message: 'Invalid token',
        type: 'OAuthException',
        code: 190,
      );

      expect(FacebookGraphHelper.isTokenError(error), isTrue);
    });

    test('should extract error messages', () {
      const error = FacebookGraphException(
        message: 'Test error message',
        type: 'TestError',
        code: 123,
      );

      final message = FacebookGraphHelper.getErrorMessage(error);

      expect(message, 'Test error message');
    });

    test('should provide correct scope lists', () {
      expect(FacebookGraphHelper.basicScopes, contains('email'));
      expect(FacebookGraphHelper.basicScopes, contains('public_profile'));

      expect(FacebookGraphHelper.adsScopes, contains('ads_management'));
      expect(FacebookGraphHelper.adsScopes, contains('ads_read'));

      expect(
        FacebookGraphHelper.businessScopes,
        contains('business_management'),
      );

      expect(
        FacebookGraphHelper.allBusinessScopes.length,
        greaterThan(FacebookGraphHelper.basicScopes.length),
      );
    });
  });
}
