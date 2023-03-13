import 'dart:convert';

class UploadResponse {
  UploadResponse({
    required this.error,
    required this.message,
  });

  bool error;
  String message;

  factory UploadResponse.fromMap(Map<String, dynamic> map) {
    return UploadResponse(
      error: map['error'] ?? false,
      message: map['message'] ?? '',
    );
  }

  factory UploadResponse.fromJson(String source) =>
      UploadResponse.fromMap(json.decode(source));
}
