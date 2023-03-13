import 'login.dart';

class LoginResponse {
  LoginResponse({
    required this.error,
    required this.message,
    required this.loginResult,
  });

  bool error;
  String message;
  Login loginResult;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        error: json["error"],
        message: json["message"],
        loginResult: Login.fromJson(json["loginResult"]),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "loginResult": loginResult.toJson(),
      };
}
