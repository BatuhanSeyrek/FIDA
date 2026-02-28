class UserModel {
  final int? id;
  final String userName;
  final String email;
  final String? phoneNumber;
  final String? password; // Yeni alan eklendi

  UserModel({
    this.id,
    required this.userName,
    required this.email,
    this.phoneNumber,
    this.password, // Constructor'a eklendi
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      userName: json['userName'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'],
      // Sunucudan şifre genelde güvenlik için dönmez,
      // ama gelirse de okuyabilmesi için ekledik:
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "userName": userName,
      "email": email,
      "phoneNumber": phoneNumber,
    };

    // Eğer şifre doluysa (güncellenmek isteniyorsa) JSON'a ekle
    if (password != null && password!.isNotEmpty) {
      data["password"] = password;
    }

    return data;
  }
}
