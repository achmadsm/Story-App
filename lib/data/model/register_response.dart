class RegisterResponse {
  RegisterResponse({
    required this.error,
    required this.message,
  });

  bool error;
  String message;

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      RegisterResponse(
        error: json['error'],
        message: json['message'],
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'message': message,
      };
}
