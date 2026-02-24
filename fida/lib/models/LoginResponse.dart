class LoginResponse {
  final int? id;
  final String? userName;
  final String? token;

  LoginResponse({this.id, this.userName, this.token});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      userName: json['userName'],
      token: json['token'],
    );
  }
}
