class Login {
  Login({
    required this.userId,
    required this.name,
    required this.token,
  });

  String userId;
  String name;
  String token;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        userId: json['userId'],
        name: json['name'],
        token: json['token'],
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'token': token,
      };
}
