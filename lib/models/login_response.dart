import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String userId;
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

  String getName() {
    return lastName + ' ' + firstName + ' ' + patronymic;
  }

  @override
  String toString() {
    return 'LoginResponse{userId: $userId, access_token: $access_token, refresh_token: $refresh_token, expires_in: $expires_in, lastName: $lastName, firstName: $firstName, patronymic: $patronymic, userType: $userType}';
  }
}