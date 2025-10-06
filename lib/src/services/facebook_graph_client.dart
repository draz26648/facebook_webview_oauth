import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../models/facebook_web_auth_models.dart';

/// Client for interacting with Facebook Graph API
class FacebookGraphClient {
  static const String _baseUrl = 'https://graph.facebook.com/v21.0';

  final Dio _dio;
  final String _accessToken;

  /// Create a new Facebook Graph API client
  FacebookGraphClient({
    required String accessToken,
    Dio? dio,
  })  : _accessToken = accessToken,
        _dio = dio ?? Dio() {
    _setupDio();
  }

  /// Setup Dio configuration
  void _setupDio() {
    _dio.options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      },
    );

    // Add interceptor for logging in debug mode
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ));
    }

    // Add error handling interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (error, handler) {
        final facebookError = _parseFacebookError(error);
        if (facebookError != null) {
          // Create a new DioException with the Facebook error
          final newError = DioException(
            requestOptions: error.requestOptions,
            response: error.response,
            type: error.type,
            error: facebookError,
            message: facebookError.message,
          );
          handler.next(newError);
        } else {
          handler.next(error);
        }
      },
    ));
  }

  /// Parse response data to Map<String, dynamic>
  Map<String, dynamic> _parseResponseData(
      dynamic responseData, String context) {
    if (responseData is Map<String, dynamic>) {
      return responseData;
    } else if (responseData is String) {
      // Try to parse JSON string
      try {
        final decoded = jsonDecode(responseData);
        if (decoded is Map<String, dynamic>) {
          return decoded;
        }
      } catch (e) {
        if (kDebugMode) {
          print('Failed to parse JSON string response in $context: $e');
        }
      }
    }

    throw Exception(
        'Unexpected response format in $context: ${responseData.runtimeType}');
  }

  /// Parse Facebook Graph API error from Dio error
  FacebookGraphError? _parseFacebookError(DioException error) {
    try {
      if (error.response?.data is Map<String, dynamic>) {
        final data = error.response!.data as Map<String, dynamic>;
        if (data.containsKey('error')) {
          return FacebookGraphError.fromJson(data['error']);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to parse Facebook error: $e');
      }
    }
    return null;
  }

  /// Get current user information
  ///
  /// [fields] - Comma-separated list of fields to retrieve
  /// Common fields: id, name, email, picture, first_name, last_name
  Future<Map<String, dynamic>> getMe({
    String fields = 'id,name,email',
  }) async {
    try {
      final response = await _dio.get('/me', queryParameters: {
        'fields': fields,
      });

      return _parseResponseData(response.data, 'getMe');
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get user information');
    } catch (e) {
      throw Exception('Failed to get user information: $e');
    }
  }

  /// Get user's ad accounts
  ///
  /// Requires 'ads_management' or 'ads_read' permission
  Future<Map<String, dynamic>> getAdAccounts({
    String fields = 'id,name,account_status,currency,timezone_name',
    int limit = 25,
  }) async {
    try {
      final response = await _dio.get('/me/adaccounts', queryParameters: {
        'fields': fields,
        'limit': limit.toString(),
      });

      return _parseResponseData(response.data, 'getAdAccounts');
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get ad accounts');
    } catch (e) {
      throw Exception('Failed to get ad accounts: $e');
    }
  }

  /// Get user's Facebook pages
  ///
  /// Requires 'pages_show_list' permission
  Future<Map<String, dynamic>> getPages({
    String fields = 'id,name,category,access_token',
    int limit = 25,
  }) async {
    try {
      final response = await _dio.get('/me/accounts', queryParameters: {
        'fields': fields,
        'limit': limit.toString(),
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get pages');
    }
  }

  /// Get user's business accounts
  ///
  /// Requires 'business_management' permission
  Future<Map<String, dynamic>> getBusinesses({
    String fields = 'id,name,verification_status',
    int limit = 25,
  }) async {
    try {
      final response = await _dio.get('/me/businesses', queryParameters: {
        'fields': fields,
        'limit': limit.toString(),
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get businesses');
    }
  }

  /// Get permissions granted to the current access token
  Future<Map<String, dynamic>> getPermissions() async {
    try {
      final response = await _dio.get('/me/permissions');
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get permissions');
    }
  }

  /// Verify that required scopes are granted
  ///
  /// Returns a list of missing scopes if any
  Future<List<String>> verifyRequiredScopes(List<String> requiredScopes) async {
    try {
      final permissions = await getPermissions();
      final data = permissions['data'] as List<dynamic>? ?? [];

      final grantedScopes = <String>{};
      for (final permission in data) {
        if (permission is Map<String, dynamic>) {
          final permission_name = permission['permission'] as String?;
          final status = permission['status'] as String?;

          if (permission_name != null && status == 'granted') {
            grantedScopes.add(permission_name);
          }
        }
      }

      final missingScopes = <String>[];
      for (final scope in requiredScopes) {
        if (!grantedScopes.contains(scope)) {
          missingScopes.add(scope);
        }
      }

      return missingScopes;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to verify scopes');
    }
  }

  /// Get insights for an ad account
  ///
  /// Requires 'ads_read' permission
  Future<Map<String, dynamic>> getAdAccountInsights(
    String adAccountId, {
    String fields = 'impressions,clicks,spend,cpm,cpc,ctr',
    String timeRange = 'last_7_days',
    String level = 'account',
  }) async {
    try {
      final response =
          await _dio.get('/act_$adAccountId/insights', queryParameters: {
        'fields': fields,
        'time_range': '{"since":"$timeRange"}',
        'level': level,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get ad account insights');
    }
  }

  /// Get campaigns for an ad account
  ///
  /// Requires 'ads_read' permission
  Future<Map<String, dynamic>> getCampaigns(
    String adAccountId, {
    String fields = 'id,name,status,objective,created_time',
    int limit = 25,
  }) async {
    try {
      final response =
          await _dio.get('/act_$adAccountId/campaigns', queryParameters: {
        'fields': fields,
        'limit': limit.toString(),
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get campaigns');
    }
  }

  /// Get Instagram accounts connected to user's Facebook pages
  ///
  /// Requires 'instagram_basic' permission
  Future<Map<String, dynamic>> getInstagramAccounts({
    String fields = 'id,username,account_type',
    int limit = 25,
  }) async {
    try {
      final response = await _dio.get('/me/accounts', queryParameters: {
        'fields': 'instagram_business_account{$fields}',
        'limit': limit.toString(),
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to get Instagram accounts');
    }
  }

  /// Exchange short-lived token for long-lived token
  ///
  /// Note: This should typically be done on your backend server
  Future<Map<String, dynamic>> exchangeForLongLivedToken(
    String appId,
    String appSecret,
  ) async {
    try {
      final response = await _dio.get('/oauth/access_token', queryParameters: {
        'grant_type': 'fb_exchange_token',
        'client_id': appId,
        'client_secret': appSecret,
        'fb_exchange_token': _accessToken,
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to exchange token');
    }
  }

  /// Debug the current access token
  Future<Map<String, dynamic>> debugToken(String appId) async {
    try {
      final response = await _dio.get('/debug_token', queryParameters: {
        'input_token': _accessToken,
        'access_token': '$appId|$_accessToken', // App token format
      });
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Failed to debug token');
    }
  }

  /// Make a custom Graph API request
  Future<Map<String, dynamic>> customRequest(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    String method = 'GET',
    dynamic data,
  }) async {
    try {
      Response response;
      switch (method.toUpperCase()) {
        case 'GET':
          response = await _dio.get(endpoint, queryParameters: queryParameters);
          break;
        case 'POST':
          response = await _dio.post(endpoint,
              data: data, queryParameters: queryParameters);
          break;
        case 'PUT':
          response = await _dio.put(endpoint,
              data: data, queryParameters: queryParameters);
          break;
        case 'DELETE':
          response =
              await _dio.delete(endpoint, queryParameters: queryParameters);
          break;
        default:
          throw ArgumentError('Unsupported HTTP method: $method');
      }
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      throw _handleDioException(e, 'Custom request failed');
    }
  }

  /// Handle Dio exceptions and provide meaningful error messages
  Exception _handleDioException(DioException e, String context) {
    if (e.error is FacebookGraphError) {
      final fbError = e.error as FacebookGraphError;
      return FacebookGraphException(
        message: '$context: ${fbError.message}',
        type: fbError.type,
        code: fbError.code,
        subcode: fbError.errorSubcode,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return FacebookGraphException(
          message: '$context: Request timed out',
          type: 'timeout_error',
          code: 408,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 0;
        return FacebookGraphException(
          message: '$context: HTTP $statusCode',
          type: 'http_error',
          code: statusCode,
        );
      case DioExceptionType.cancel:
        return FacebookGraphException(
          message: '$context: Request was cancelled',
          type: 'cancelled_error',
          code: 0,
        );
      default:
        return FacebookGraphException(
          message: '$context: ${e.message}',
          type: 'unknown_error',
          code: 0,
        );
    }
  }

  /// Close the Dio client
  void close() {
    _dio.close();
  }
}

/// Exception thrown by Facebook Graph API operations
class FacebookGraphException implements Exception {
  final String message;
  final String type;
  final int code;
  final String? subcode;

  const FacebookGraphException({
    required this.message,
    required this.type,
    required this.code,
    this.subcode,
  });

  @override
  String toString() {
    return 'FacebookGraphException: $message (Type: $type, Code: $code${subcode != null ? ', Subcode: $subcode' : ''})';
  }
}

/// Helper class for common Facebook Graph API operations
class FacebookGraphHelper {
  /// Common permission scopes for different use cases
  static const List<String> basicScopes = ['email', 'public_profile'];
  static const List<String> adsScopes = ['ads_management', 'ads_read'];
  static const List<String> businessScopes = ['business_management'];
  static const List<String> pagesScopes = [
    'pages_show_list',
    'pages_manage_ads'
  ];
  static const List<String> instagramScopes = [
    'instagram_basic',
    'instagram_manage_insights'
  ];

  /// Get all business-related scopes
  static List<String> get allBusinessScopes => [
        ...basicScopes,
        ...adsScopes,
        ...businessScopes,
        ...pagesScopes,
        ...instagramScopes,
      ];

  /// Check if an error indicates missing permissions
  static bool isPermissionError(Exception error) {
    if (error is FacebookGraphException) {
      return error.code == 200 || // Permissions error
          error.code == 10 || // Application does not have permission
          error.type.contains('permission');
    }
    return false;
  }

  /// Check if an error indicates an invalid or expired token
  static bool isTokenError(Exception error) {
    if (error is FacebookGraphException) {
      return error.code == 190 || // Invalid OAuth access token
          error.code == 102 || // Session key invalid
          error.type.contains('token');
    }
    return false;
  }

  /// Extract error message from exception
  static String getErrorMessage(Exception error) {
    if (error is FacebookGraphException) {
      return error.message;
    }
    return error.toString();
  }
}
