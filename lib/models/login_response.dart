import 'package:json_annotation/json_annotation.dart';
part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String userId;
  String accessToken;
  String refreshToken;
  int expiresIn;
  String lastName;
  String firstName;
  String patronymic;
  String userType;

  LoginResponse(
      this.userId,
      this.accessToken,
      this.refreshToken,
      this.expiresIn,
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

  String getInitials() {
    return lastName[0] + firstName[0];
  }

  @override
  String toString() {
    return 'LoginResponse{userId: $userId, access_token: $accessToken, refresh_token: $refreshToken, expires_in: $expiresIn, lastName: $lastName, firstName: $firstName, patronymic: $patronymic, userType: $userType}';
  }
}