class RegisterResponseModel {
  String username, fullName, email, token, message;

  RegisterResponseModel({
    this.fullName,
    this.email,
    this.token,
    this.message,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      fullName: json['full_name'] != null ? json['full_name'] : '',
      email: json['email'] != null ? json['email'] : '',
      token: json['token'] != null ? json['token'] : '',
      message: json['message'] != null ? json['message'] : '',
    );
  }
}

class RegisterRequestModel {
  String username, fullName, email, phone, password, password2;

  RegisterRequestModel({
    this.username,
    this.fullName,
    this.email,
    this.phone,
    this.password,
    this.password2,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {
      'username': username.trim(),
      'full_name': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      'password': password.trim(),
      'password2': password2.trim(),
    };
    return map;
  }
}
