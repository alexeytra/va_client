import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  int userId;
  String access_token;
  String refresh_token;
  int expires_in;
  String lastName;
  String firstName;
  String patronymic;
  String userType;

  LoginResponse(
      this.userId,
      this.access_token,
      this.refresh_token,
      this.expires_in,
      this.lastName,
      this.firstName,
      this.patronymic,
      this.userType);

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}