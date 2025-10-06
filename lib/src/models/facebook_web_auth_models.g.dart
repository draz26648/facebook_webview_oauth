// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facebook_web_auth_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FacebookWebAuthParamsImpl _$$FacebookWebAuthParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$FacebookWebAuthParamsImpl(
      clientId: json['clientId'] as String,
      scopes:
          (json['scopes'] as List<dynamic>).map((e) => e as String).toList(),
      configId: json['configId'] as String?,
      redirectUri: json['redirectUri'] as String?,
      freshSession: json['freshSession'] as bool? ?? true,
      timeout: json['timeout'] == null
          ? const Duration(minutes: 3)
          : Duration(microseconds: (json['timeout'] as num).toInt()),
      rerequestDeclinedPermissions:
          json['rerequestDeclinedPermissions'] as bool? ?? false,
    );

Map<String, dynamic> _$$FacebookWebAuthParamsImplToJson(
        _$FacebookWebAuthParamsImpl instance) =>
    <String, dynamic>{
      'clientId': instance.clientId,
      'scopes': instance.scopes,
      'configId': instance.configId,
      'redirectUri': instance.redirectUri,
      'freshSession': instance.freshSession,
      'timeout': instance.timeout.inMicroseconds,
      'rerequestDeclinedPermissions': instance.rerequestDeclinedPermissions,
    };

_$FacebookWebAuthResultImpl _$$FacebookWebAuthResultImplFromJson(
        Map<String, dynamic> json) =>
    _$FacebookWebAuthResultImpl(
      accessToken: json['accessToken'] as String?,
      expiresIn: json['expiresIn'] == null
          ? null
          : Duration(microseconds: (json['expiresIn'] as num).toInt()),
      tokenType: json['tokenType'] as String?,
      grantedScopes: (json['grantedScopes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      declinedScopes: (json['declinedScopes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toSet() ??
          const {},
      status: $enumDecode(_$FacebookWebAuthStatusEnumMap, json['status']),
      errorDescription: json['errorDescription'] as String?,
      errorCode: json['errorCode'] as String?,
      state: json['state'] as String?,
    );

Map<String, dynamic> _$$FacebookWebAuthResultImplToJson(
        _$FacebookWebAuthResultImpl instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'expiresIn': instance.expiresIn?.inMicroseconds,
      'tokenType': instance.tokenType,
      'grantedScopes': instance.grantedScopes.toList(),
      'declinedScopes': instance.declinedScopes.toList(),
      'status': _$FacebookWebAuthStatusEnumMap[instance.status]!,
      'errorDescription': instance.errorDescription,
      'errorCode': instance.errorCode,
      'state': instance.state,
    };

const _$FacebookWebAuthStatusEnumMap = {
  FacebookWebAuthStatus.success: 'success',
  FacebookWebAuthStatus.cancelled: 'cancelled',
  FacebookWebAuthStatus.error: 'error',
  FacebookWebAuthStatus.permissionsDeclined: 'permissionsDeclined',
  FacebookWebAuthStatus.timeout: 'timeout',
  FacebookWebAuthStatus.stateMismatch: 'stateMismatch',
};

_$FacebookGraphErrorImpl _$$FacebookGraphErrorImplFromJson(
        Map<String, dynamic> json) =>
    _$FacebookGraphErrorImpl(
      message: json['message'] as String,
      type: json['type'] as String,
      code: (json['code'] as num).toInt(),
      errorSubcode: json['errorSubcode'] as String?,
      fbtrace_id: json['fbtrace_id'] as String?,
    );

Map<String, dynamic> _$$FacebookGraphErrorImplToJson(
        _$FacebookGraphErrorImpl instance) =>
    <String, dynamic>{
      'message': instance.message,
      'type': instance.type,
      'code': instance.code,
      'errorSubcode': instance.errorSubcode,
      'fbtrace_id': instance.fbtrace_id,
    };

_$FacebookGraphResponseImpl _$$FacebookGraphResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$FacebookGraphResponseImpl(
      data: json['data'] as Map<String, dynamic>?,
      error: json['error'] == null
          ? null
          : FacebookGraphError.fromJson(json['error'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FacebookGraphResponseImplToJson(
        _$FacebookGraphResponseImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'error': instance.error,
    };
