class RegisterRequest {
  final String userName;
  final String email;
  final String password;
  final String phoneNumber;

  RegisterRequest({
    required this.userName,
    required this.email,
    required this.password,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      "userName": userName,
      "email": email,
      "password": password,
      "phoneNumber": phoneNumber,
    };
  }
}
