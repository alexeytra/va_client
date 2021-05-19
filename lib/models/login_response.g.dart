// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
    json['userId'] as String,
    json['access_token'] as String,
    json['refresh_token'] as String,
    json['expires_in'] as int,
    json['lastName'] as String,
    json['firstName'] as String,
    json['patronymic'] as String,
    json['userType'] as String,
  );
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'expires_in': instance.expiresIn,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'patronymic': instance.patronymic,
      'userType': instance.userType,
    };
