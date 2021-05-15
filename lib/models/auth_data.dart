class AuthData {
  String login;
  String password;

  AuthData(this.login, this.password);

  @override
  String toString() {
    return 'AuthData{login: $login, password: $password}';
  }
}