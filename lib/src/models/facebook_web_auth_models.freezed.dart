// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'facebook_web_auth_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FacebookWebAuthParams _$FacebookWebAuthParamsFromJson(
    Map<String, dynamic> json) {
  return _FacebookWebAuthParams.fromJson(json);
}

/// @nodoc
mixin _$FacebookWebAuthParams {
  /// Facebook App Client ID
  String get clientId => throw _privateConstructorUsedError;

  /// List of permissions/scopes to request
  /// e.g., ["email", "public_profile", "ads_management", "ads_read", "business_management"]
  List<String> get scopes => throw _privateConstructorUsedError;

  /// Optional Facebook App Config ID to avoid Limited Login
  String? get configId => throw _privateConstructorUsedError;

  /// Custom redirect URI for OAuth flow
  /// Defaults to 'https://www.facebook.com/connect/login_success.html'
  /// You can use your own domain, e.g., 'https://yourdomain.com/auth/facebook/callback'
  String? get redirectUri => throw _privateConstructorUsedError;

  /// Whether to clear cookies/cache before starting authentication
  bool get freshSession => throw _privateConstructorUsedError;

  /// Timeout duration for the authentication process
  Duration get timeout => throw _privateConstructorUsedError;

  /// Whether to re-request previously declined permissions
  bool get rerequestDeclinedPermissions => throw _privateConstructorUsedError;

  /// Serializes this FacebookWebAuthParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacebookWebAuthParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacebookWebAuthParamsCopyWith<FacebookWebAuthParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacebookWebAuthParamsCopyWith<$Res> {
  factory $FacebookWebAuthParamsCopyWith(FacebookWebAuthParams value,
          $Res Function(FacebookWebAuthParams) then) =
      _$FacebookWebAuthParamsCopyWithImpl<$Res, FacebookWebAuthParams>;
  @useResult
  $Res call(
      {String clientId,
      List<String> scopes,
      String? configId,
      String? redirectUri,
      bool freshSession,
      Duration timeout,
      bool rerequestDeclinedPermissions});
}

/// @nodoc
class _$FacebookWebAuthParamsCopyWithImpl<$Res,
        $Val extends FacebookWebAuthParams>
    implements $FacebookWebAuthParamsCopyWith<$Res> {
  _$FacebookWebAuthParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacebookWebAuthParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? scopes = null,
    Object? configId = freezed,
    Object? redirectUri = freezed,
    Object? freshSession = null,
    Object? timeout = null,
    Object? rerequestDeclinedPermissions = null,
  }) {
    return _then(_value.copyWith(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      scopes: null == scopes
          ? _value.scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      configId: freezed == configId
          ? _value.configId
          : configId // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUri: freezed == redirectUri
          ? _value.redirectUri
          : redirectUri // ignore: cast_nullable_to_non_nullable
              as String?,
      freshSession: null == freshSession
          ? _value.freshSession
          : freshSession // ignore: cast_nullable_to_non_nullable
              as bool,
      timeout: null == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      rerequestDeclinedPermissions: null == rerequestDeclinedPermissions
          ? _value.rerequestDeclinedPermissions
          : rerequestDeclinedPermissions // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FacebookWebAuthParamsImplCopyWith<$Res>
    implements $FacebookWebAuthParamsCopyWith<$Res> {
  factory _$$FacebookWebAuthParamsImplCopyWith(
          _$FacebookWebAuthParamsImpl value,
          $Res Function(_$FacebookWebAuthParamsImpl) then) =
      __$$FacebookWebAuthParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String clientId,
      List<String> scopes,
      String? configId,
      String? redirectUri,
      bool freshSession,
      Duration timeout,
      bool rerequestDeclinedPermissions});
}

/// @nodoc
class __$$FacebookWebAuthParamsImplCopyWithImpl<$Res>
    extends _$FacebookWebAuthParamsCopyWithImpl<$Res,
        _$FacebookWebAuthParamsImpl>
    implements _$$FacebookWebAuthParamsImplCopyWith<$Res> {
  __$$FacebookWebAuthParamsImplCopyWithImpl(_$FacebookWebAuthParamsImpl _value,
      $Res Function(_$FacebookWebAuthParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of FacebookWebAuthParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? clientId = null,
    Object? scopes = null,
    Object? configId = freezed,
    Object? redirectUri = freezed,
    Object? freshSession = null,
    Object? timeout = null,
    Object? rerequestDeclinedPermissions = null,
  }) {
    return _then(_$FacebookWebAuthParamsImpl(
      clientId: null == clientId
          ? _value.clientId
          : clientId // ignore: cast_nullable_to_non_nullable
              as String,
      scopes: null == scopes
          ? _value._scopes
          : scopes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      configId: freezed == configId
          ? _value.configId
          : configId // ignore: cast_nullable_to_non_nullable
              as String?,
      redirectUri: freezed == redirectUri
          ? _value.redirectUri
          : redirectUri // ignore: cast_nullable_to_non_nullable
              as String?,
      freshSession: null == freshSession
          ? _value.freshSession
          : freshSession // ignore: cast_nullable_to_non_nullable
              as bool,
      timeout: null == timeout
          ? _value.timeout
          : timeout // ignore: cast_nullable_to_non_nullable
              as Duration,
      rerequestDeclinedPermissions: null == rerequestDeclinedPermissions
          ? _value.rerequestDeclinedPermissions
          : rerequestDeclinedPermissions // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FacebookWebAuthParamsImpl implements _FacebookWebAuthParams {
  const _$FacebookWebAuthParamsImpl(
      {required this.clientId,
      required final List<String> scopes,
      this.configId,
      this.redirectUri,
      this.freshSession = true,
      this.timeout = const Duration(minutes: 3),
      this.rerequestDeclinedPermissions = false})
      : _scopes = scopes;

  factory _$FacebookWebAuthParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacebookWebAuthParamsImplFromJson(json);

  /// Facebook App Client ID
  @override
  final String clientId;

  /// List of permissions/scopes to request
  /// e.g., ["email", "public_profile", "ads_management", "ads_read", "business_management"]
  final List<String> _scopes;

  /// List of permissions/scopes to request
  /// e.g., ["email", "public_profile", "ads_management", "ads_read", "business_management"]
  @override
  List<String> get scopes {
    if (_scopes is EqualUnmodifiableListView) return _scopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_scopes);
  }

  /// Optional Facebook App Config ID to avoid Limited Login
  @override
  final String? configId;

  /// Custom redirect URI for OAuth flow
  /// Defaults to 'https://www.facebook.com/connect/login_success.html'
  /// You can use your own domain, e.g., 'https://yourdomain.com/auth/facebook/callback'
  @override
  final String? redirectUri;

  /// Whether to clear cookies/cache before starting authentication
  @override
  @JsonKey()
  final bool freshSession;

  /// Timeout duration for the authentication process
  @override
  @JsonKey()
  final Duration timeout;

  /// Whether to re-request previously declined permissions
  @override
  @JsonKey()
  final bool rerequestDeclinedPermissions;

  @override
  String toString() {
    return 'FacebookWebAuthParams(clientId: $clientId, scopes: $scopes, configId: $configId, redirectUri: $redirectUri, freshSession: $freshSession, timeout: $timeout, rerequestDeclinedPermissions: $rerequestDeclinedPermissions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacebookWebAuthParamsImpl &&
            (identical(other.clientId, clientId) ||
                other.clientId == clientId) &&
            const DeepCollectionEquality().equals(other._scopes, _scopes) &&
            (identical(other.configId, configId) ||
                other.configId == configId) &&
            (identical(other.redirectUri, redirectUri) ||
                other.redirectUri == redirectUri) &&
            (identical(other.freshSession, freshSession) ||
                other.freshSession == freshSession) &&
            (identical(other.timeout, timeout) || other.timeout == timeout) &&
            (identical(other.rerequestDeclinedPermissions,
                    rerequestDeclinedPermissions) ||
                other.rerequestDeclinedPermissions ==
                    rerequestDeclinedPermissions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      clientId,
      const DeepCollectionEquality().hash(_scopes),
      configId,
      redirectUri,
      freshSession,
      timeout,
      rerequestDeclinedPermissions);

  /// Create a copy of FacebookWebAuthParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacebookWebAuthParamsImplCopyWith<_$FacebookWebAuthParamsImpl>
      get copyWith => __$$FacebookWebAuthParamsImplCopyWithImpl<
          _$FacebookWebAuthParamsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacebookWebAuthParamsImplToJson(
      this,
    );
  }
}

abstract class _FacebookWebAuthParams implements FacebookWebAuthParams {
  const factory _FacebookWebAuthParams(
      {required final String clientId,
      required final List<String> scopes,
      final String? configId,
      final String? redirectUri,
      final bool freshSession,
      final Duration timeout,
      final bool rerequestDeclinedPermissions}) = _$FacebookWebAuthParamsImpl;

  factory _FacebookWebAuthParams.fromJson(Map<String, dynamic> json) =
      _$FacebookWebAuthParamsImpl.fromJson;

  /// Facebook App Client ID
  @override
  String get clientId;

  /// List of permissions/scopes to request
  /// e.g., ["email", "public_profile", "ads_management", "ads_read", "business_management"]
  @override
  List<String> get scopes;

  /// Optional Facebook App Config ID to avoid Limited Login
  @override
  String? get configId;

  /// Custom redirect URI for OAuth flow
  /// Defaults to 'https://www.facebook.com/connect/login_success.html'
  /// You can use your own domain, e.g., 'https://yourdomain.com/auth/facebook/callback'
  @override
  String? get redirectUri;

  /// Whether to clear cookies/cache before starting authentication
  @override
  bool get freshSession;

  /// Timeout duration for the authentication process
  @override
  Duration get timeout;

  /// Whether to re-request previously declined permissions
  @override
  bool get rerequestDeclinedPermissions;

  /// Create a copy of FacebookWebAuthParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacebookWebAuthParamsImplCopyWith<_$FacebookWebAuthParamsImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FacebookWebAuthResult _$FacebookWebAuthResultFromJson(
    Map<String, dynamic> json) {
  return _FacebookWebAuthResult.fromJson(json);
}

/// @nodoc
mixin _$FacebookWebAuthResult {
  /// Access token returned by Facebook (null if authentication failed)
  String? get accessToken => throw _privateConstructorUsedError;

  /// Token expiration duration (null if not provided or authentication failed)
  Duration? get expiresIn => throw _privateConstructorUsedError;

  /// Token type (usually "bearer")
  String? get tokenType => throw _privateConstructorUsedError;

  /// Set of permissions that were granted by the user
  Set<String> get grantedScopes => throw _privateConstructorUsedError;

  /// Set of permissions that were declined by the user
  Set<String> get declinedScopes => throw _privateConstructorUsedError;

  /// Status of the authentication process
  FacebookWebAuthStatus get status => throw _privateConstructorUsedError;

  /// Error description if status is error
  String? get errorDescription => throw _privateConstructorUsedError;

  /// Error code from Facebook if available
  String? get errorCode => throw _privateConstructorUsedError;

  /// CSRF state parameter that was used in the request
  String? get state => throw _privateConstructorUsedError;

  /// Serializes this FacebookWebAuthResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacebookWebAuthResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacebookWebAuthResultCopyWith<FacebookWebAuthResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacebookWebAuthResultCopyWith<$Res> {
  factory $FacebookWebAuthResultCopyWith(FacebookWebAuthResult value,
          $Res Function(FacebookWebAuthResult) then) =
      _$FacebookWebAuthResultCopyWithImpl<$Res, FacebookWebAuthResult>;
  @useResult
  $Res call(
      {String? accessToken,
      Duration? expiresIn,
      String? tokenType,
      Set<String> grantedScopes,
      Set<String> declinedScopes,
      FacebookWebAuthStatus status,
      String? errorDescription,
      String? errorCode,
      String? state});
}

/// @nodoc
class _$FacebookWebAuthResultCopyWithImpl<$Res,
        $Val extends FacebookWebAuthResult>
    implements $FacebookWebAuthResultCopyWith<$Res> {
  _$FacebookWebAuthResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacebookWebAuthResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? expiresIn = freezed,
    Object? tokenType = freezed,
    Object? grantedScopes = null,
    Object? declinedScopes = null,
    Object? status = null,
    Object? errorDescription = freezed,
    Object? errorCode = freezed,
    Object? state = freezed,
  }) {
    return _then(_value.copyWith(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresIn: freezed == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as Duration?,
      tokenType: freezed == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String?,
      grantedScopes: null == grantedScopes
          ? _value.grantedScopes
          : grantedScopes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      declinedScopes: null == declinedScopes
          ? _value.declinedScopes
          : declinedScopes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FacebookWebAuthStatus,
      errorDescription: freezed == errorDescription
          ? _value.errorDescription
          : errorDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FacebookWebAuthResultImplCopyWith<$Res>
    implements $FacebookWebAuthResultCopyWith<$Res> {
  factory _$$FacebookWebAuthResultImplCopyWith(
          _$FacebookWebAuthResultImpl value,
          $Res Function(_$FacebookWebAuthResultImpl) then) =
      __$$FacebookWebAuthResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? accessToken,
      Duration? expiresIn,
      String? tokenType,
      Set<String> grantedScopes,
      Set<String> declinedScopes,
      FacebookWebAuthStatus status,
      String? errorDescription,
      String? errorCode,
      String? state});
}

/// @nodoc
class __$$FacebookWebAuthResultImplCopyWithImpl<$Res>
    extends _$FacebookWebAuthResultCopyWithImpl<$Res,
        _$FacebookWebAuthResultImpl>
    implements _$$FacebookWebAuthResultImplCopyWith<$Res> {
  __$$FacebookWebAuthResultImplCopyWithImpl(_$FacebookWebAuthResultImpl _value,
      $Res Function(_$FacebookWebAuthResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of FacebookWebAuthResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accessToken = freezed,
    Object? expiresIn = freezed,
    Object? tokenType = freezed,
    Object? grantedScopes = null,
    Object? declinedScopes = null,
    Object? status = null,
    Object? errorDescription = freezed,
    Object? errorCode = freezed,
    Object? state = freezed,
  }) {
    return _then(_$FacebookWebAuthResultImpl(
      accessToken: freezed == accessToken
          ? _value.accessToken
          : accessToken // ignore: cast_nullable_to_non_nullable
              as String?,
      expiresIn: freezed == expiresIn
          ? _value.expiresIn
          : expiresIn // ignore: cast_nullable_to_non_nullable
              as Duration?,
      tokenType: freezed == tokenType
          ? _value.tokenType
          : tokenType // ignore: cast_nullable_to_non_nullable
              as String?,
      grantedScopes: null == grantedScopes
          ? _value._grantedScopes
          : grantedScopes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      declinedScopes: null == declinedScopes
          ? _value._declinedScopes
          : declinedScopes // ignore: cast_nullable_to_non_nullable
              as Set<String>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as FacebookWebAuthStatus,
      errorDescription: freezed == errorDescription
          ? _value.errorDescription
          : errorDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      errorCode: freezed == errorCode
          ? _value.errorCode
          : errorCode // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FacebookWebAuthResultImpl implements _FacebookWebAuthResult {
  const _$FacebookWebAuthResultImpl(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      final Set<String> grantedScopes = const {},
      final Set<String> declinedScopes = const {},
      required this.status,
      this.errorDescription,
      this.errorCode,
      this.state})
      : _grantedScopes = grantedScopes,
        _declinedScopes = declinedScopes;

  factory _$FacebookWebAuthResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacebookWebAuthResultImplFromJson(json);

  /// Access token returned by Facebook (null if authentication failed)
  @override
  final String? accessToken;

  /// Token expiration duration (null if not provided or authentication failed)
  @override
  final Duration? expiresIn;

  /// Token type (usually "bearer")
  @override
  final String? tokenType;

  /// Set of permissions that were granted by the user
  final Set<String> _grantedScopes;

  /// Set of permissions that were granted by the user
  @override
  @JsonKey()
  Set<String> get grantedScopes {
    if (_grantedScopes is EqualUnmodifiableSetView) return _grantedScopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_grantedScopes);
  }

  /// Set of permissions that were declined by the user
  final Set<String> _declinedScopes;

  /// Set of permissions that were declined by the user
  @override
  @JsonKey()
  Set<String> get declinedScopes {
    if (_declinedScopes is EqualUnmodifiableSetView) return _declinedScopes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableSetView(_declinedScopes);
  }

  /// Status of the authentication process
  @override
  final FacebookWebAuthStatus status;

  /// Error description if status is error
  @override
  final String? errorDescription;

  /// Error code from Facebook if available
  @override
  final String? errorCode;

  /// CSRF state parameter that was used in the request
  @override
  final String? state;

  @override
  String toString() {
    return 'FacebookWebAuthResult(accessToken: $accessToken, expiresIn: $expiresIn, tokenType: $tokenType, grantedScopes: $grantedScopes, declinedScopes: $declinedScopes, status: $status, errorDescription: $errorDescription, errorCode: $errorCode, state: $state)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacebookWebAuthResultImpl &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.expiresIn, expiresIn) ||
                other.expiresIn == expiresIn) &&
            (identical(other.tokenType, tokenType) ||
                other.tokenType == tokenType) &&
            const DeepCollectionEquality()
                .equals(other._grantedScopes, _grantedScopes) &&
            const DeepCollectionEquality()
                .equals(other._declinedScopes, _declinedScopes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorDescription, errorDescription) ||
                other.errorDescription == errorDescription) &&
            (identical(other.errorCode, errorCode) ||
                other.errorCode == errorCode) &&
            (identical(other.state, state) || other.state == state));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      accessToken,
      expiresIn,
      tokenType,
      const DeepCollectionEquality().hash(_grantedScopes),
      const DeepCollectionEquality().hash(_declinedScopes),
      status,
      errorDescription,
      errorCode,
      state);

  /// Create a copy of FacebookWebAuthResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacebookWebAuthResultImplCopyWith<_$FacebookWebAuthResultImpl>
      get copyWith => __$$FacebookWebAuthResultImplCopyWithImpl<
          _$FacebookWebAuthResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacebookWebAuthResultImplToJson(
      this,
    );
  }
}

abstract class _FacebookWebAuthResult implements FacebookWebAuthResult {
  const factory _FacebookWebAuthResult(
      {final String? accessToken,
      final Duration? expiresIn,
      final String? tokenType,
      final Set<String> grantedScopes,
      final Set<String> declinedScopes,
      required final FacebookWebAuthStatus status,
      final String? errorDescription,
      final String? errorCode,
      final String? state}) = _$FacebookWebAuthResultImpl;

  factory _FacebookWebAuthResult.fromJson(Map<String, dynamic> json) =
      _$FacebookWebAuthResultImpl.fromJson;

  /// Access token returned by Facebook (null if authentication failed)
  @override
  String? get accessToken;

  /// Token expiration duration (null if not provided or authentication failed)
  @override
  Duration? get expiresIn;

  /// Token type (usually "bearer")
  @override
  String? get tokenType;

  /// Set of permissions that were granted by the user
  @override
  Set<String> get grantedScopes;

  /// Set of permissions that were declined by the user
  @override
  Set<String> get declinedScopes;

  /// Status of the authentication process
  @override
  FacebookWebAuthStatus get status;

  /// Error description if status is error
  @override
  String? get errorDescription;

  /// Error code from Facebook if available
  @override
  String? get errorCode;

  /// CSRF state parameter that was used in the request
  @override
  String? get state;

  /// Create a copy of FacebookWebAuthResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacebookWebAuthResultImplCopyWith<_$FacebookWebAuthResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

FacebookGraphError _$FacebookGraphErrorFromJson(Map<String, dynamic> json) {
  return _FacebookGraphError.fromJson(json);
}

/// @nodoc
mixin _$FacebookGraphError {
  String get message => throw _privateConstructorUsedError;
  String get type => throw _privateConstructorUsedError;
  int get code => throw _privateConstructorUsedError;
  String? get errorSubcode => throw _privateConstructorUsedError;
  String? get fbtrace_id => throw _privateConstructorUsedError;

  /// Serializes this FacebookGraphError to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacebookGraphError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacebookGraphErrorCopyWith<FacebookGraphError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacebookGraphErrorCopyWith<$Res> {
  factory $FacebookGraphErrorCopyWith(
          FacebookGraphError value, $Res Function(FacebookGraphError) then) =
      _$FacebookGraphErrorCopyWithImpl<$Res, FacebookGraphError>;
  @useResult
  $Res call(
      {String message,
      String type,
      int code,
      String? errorSubcode,
      String? fbtrace_id});
}

/// @nodoc
class _$FacebookGraphErrorCopyWithImpl<$Res, $Val extends FacebookGraphError>
    implements $FacebookGraphErrorCopyWith<$Res> {
  _$FacebookGraphErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacebookGraphError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? code = null,
    Object? errorSubcode = freezed,
    Object? fbtrace_id = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      errorSubcode: freezed == errorSubcode
          ? _value.errorSubcode
          : errorSubcode // ignore: cast_nullable_to_non_nullable
              as String?,
      fbtrace_id: freezed == fbtrace_id
          ? _value.fbtrace_id
          : fbtrace_id // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FacebookGraphErrorImplCopyWith<$Res>
    implements $FacebookGraphErrorCopyWith<$Res> {
  factory _$$FacebookGraphErrorImplCopyWith(_$FacebookGraphErrorImpl value,
          $Res Function(_$FacebookGraphErrorImpl) then) =
      __$$FacebookGraphErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String message,
      String type,
      int code,
      String? errorSubcode,
      String? fbtrace_id});
}

/// @nodoc
class __$$FacebookGraphErrorImplCopyWithImpl<$Res>
    extends _$FacebookGraphErrorCopyWithImpl<$Res, _$FacebookGraphErrorImpl>
    implements _$$FacebookGraphErrorImplCopyWith<$Res> {
  __$$FacebookGraphErrorImplCopyWithImpl(_$FacebookGraphErrorImpl _value,
      $Res Function(_$FacebookGraphErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of FacebookGraphError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? type = null,
    Object? code = null,
    Object? errorSubcode = freezed,
    Object? fbtrace_id = freezed,
  }) {
    return _then(_$FacebookGraphErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      code: null == code
          ? _value.code
          : code // ignore: cast_nullable_to_non_nullable
              as int,
      errorSubcode: freezed == errorSubcode
          ? _value.errorSubcode
          : errorSubcode // ignore: cast_nullable_to_non_nullable
              as String?,
      fbtrace_id: freezed == fbtrace_id
          ? _value.fbtrace_id
          : fbtrace_id // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FacebookGraphErrorImpl implements _FacebookGraphError {
  const _$FacebookGraphErrorImpl(
      {required this.message,
      required this.type,
      required this.code,
      this.errorSubcode,
      this.fbtrace_id});

  factory _$FacebookGraphErrorImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacebookGraphErrorImplFromJson(json);

  @override
  final String message;
  @override
  final String type;
  @override
  final int code;
  @override
  final String? errorSubcode;
  @override
  final String? fbtrace_id;

  @override
  String toString() {
    return 'FacebookGraphError(message: $message, type: $type, code: $code, errorSubcode: $errorSubcode, fbtrace_id: $fbtrace_id)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacebookGraphErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.code, code) || other.code == code) &&
            (identical(other.errorSubcode, errorSubcode) ||
                other.errorSubcode == errorSubcode) &&
            (identical(other.fbtrace_id, fbtrace_id) ||
                other.fbtrace_id == fbtrace_id));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, message, type, code, errorSubcode, fbtrace_id);

  /// Create a copy of FacebookGraphError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacebookGraphErrorImplCopyWith<_$FacebookGraphErrorImpl> get copyWith =>
      __$$FacebookGraphErrorImplCopyWithImpl<_$FacebookGraphErrorImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacebookGraphErrorImplToJson(
      this,
    );
  }
}

abstract class _FacebookGraphError implements FacebookGraphError {
  const factory _FacebookGraphError(
      {required final String message,
      required final String type,
      required final int code,
      final String? errorSubcode,
      final String? fbtrace_id}) = _$FacebookGraphErrorImpl;

  factory _FacebookGraphError.fromJson(Map<String, dynamic> json) =
      _$FacebookGraphErrorImpl.fromJson;

  @override
  String get message;
  @override
  String get type;
  @override
  int get code;
  @override
  String? get errorSubcode;
  @override
  String? get fbtrace_id;

  /// Create a copy of FacebookGraphError
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacebookGraphErrorImplCopyWith<_$FacebookGraphErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FacebookGraphResponse _$FacebookGraphResponseFromJson(
    Map<String, dynamic> json) {
  return _FacebookGraphResponse.fromJson(json);
}

/// @nodoc
mixin _$FacebookGraphResponse {
  Map<String, dynamic>? get data => throw _privateConstructorUsedError;
  FacebookGraphError? get error => throw _privateConstructorUsedError;

  /// Serializes this FacebookGraphResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FacebookGraphResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FacebookGraphResponseCopyWith<FacebookGraphResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FacebookGraphResponseCopyWith<$Res> {
  factory $FacebookGraphResponseCopyWith(FacebookGraphResponse value,
          $Res Function(FacebookGraphResponse) then) =
      _$FacebookGraphResponseCopyWithImpl<$Res, FacebookGraphResponse>;
  @useResult
  $Res call({Map<String, dynamic>? data, FacebookGraphError? error});

  $FacebookGraphErrorCopyWith<$Res>? get error;
}

/// @nodoc
class _$FacebookGraphResponseCopyWithImpl<$Res,
        $Val extends FacebookGraphResponse>
    implements $FacebookGraphResponseCopyWith<$Res> {
  _$FacebookGraphResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FacebookGraphResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      data: freezed == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as FacebookGraphError?,
    ) as $Val);
  }

  /// Create a copy of FacebookGraphResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $FacebookGraphErrorCopyWith<$Res>? get error {
    if (_value.error == null) {
      return null;
    }

    return $FacebookGraphErrorCopyWith<$Res>(_value.error!, (value) {
      return _then(_value.copyWith(error: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FacebookGraphResponseImplCopyWith<$Res>
    implements $FacebookGraphResponseCopyWith<$Res> {
  factory _$$FacebookGraphResponseImplCopyWith(
          _$FacebookGraphResponseImpl value,
          $Res Function(_$FacebookGraphResponseImpl) then) =
      __$$FacebookGraphResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Map<String, dynamic>? data, FacebookGraphError? error});

  @override
  $FacebookGraphErrorCopyWith<$Res>? get error;
}

/// @nodoc
class __$$FacebookGraphResponseImplCopyWithImpl<$Res>
    extends _$FacebookGraphResponseCopyWithImpl<$Res,
        _$FacebookGraphResponseImpl>
    implements _$$FacebookGraphResponseImplCopyWith<$Res> {
  __$$FacebookGraphResponseImplCopyWithImpl(_$FacebookGraphResponseImpl _value,
      $Res Function(_$FacebookGraphResponseImpl) _then)
      : super(_value, _then);

  /// Create a copy of FacebookGraphResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = freezed,
    Object? error = freezed,
  }) {
    return _then(_$FacebookGraphResponseImpl(
      data: freezed == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as FacebookGraphError?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FacebookGraphResponseImpl implements _FacebookGraphResponse {
  const _$FacebookGraphResponseImpl(
      {final Map<String, dynamic>? data, this.error})
      : _data = data;

  factory _$FacebookGraphResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$FacebookGraphResponseImplFromJson(json);

  final Map<String, dynamic>? _data;
  @override
  Map<String, dynamic>? get data {
    final value = _data;
    if (value == null) return null;
    if (_data is EqualUnmodifiableMapView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final FacebookGraphError? error;

  @override
  String toString() {
    return 'FacebookGraphResponse(data: $data, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FacebookGraphResponseImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.error, error) || other.error == error));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_data), error);

  /// Create a copy of FacebookGraphResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FacebookGraphResponseImplCopyWith<_$FacebookGraphResponseImpl>
      get copyWith => __$$FacebookGraphResponseImplCopyWithImpl<
          _$FacebookGraphResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FacebookGraphResponseImplToJson(
      this,
    );
  }
}

abstract class _FacebookGraphResponse implements FacebookGraphResponse {
  const factory _FacebookGraphResponse(
      {final Map<String, dynamic>? data,
      final FacebookGraphError? error}) = _$FacebookGraphResponseImpl;

  factory _FacebookGraphResponse.fromJson(Map<String, dynamic> json) =
      _$FacebookGraphResponseImpl.fromJson;

  @override
  Map<String, dynamic>? get data;
  @override
  FacebookGraphError? get error;

  /// Create a copy of FacebookGraphResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FacebookGraphResponseImplCopyWith<_$FacebookGraphResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
