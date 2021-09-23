enum UserState { available, away, busy }

class User {
  String username;
  String firstName;
  String lastName;
  String email;
  bool active;
  String keycode;
  String phoneNumber;
  String ssn;
  String slug;
  String country;
  String countryFlag;
  String token;
  String firebaseToken;
  String message;
  String password;
  String password2;
  dynamic error;

  User(
      {this.username,
      this.firstName,
      this.lastName,
      this.email,
      this.active,
      this.keycode,
      this.phoneNumber,
      this.ssn,
      this.slug,
      this.country,
      this.countryFlag,
      this.token,
      this.firebaseToken,
      this.message,
      this.password,
      this.password2,
      this.error});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    active = json['active'];
    keycode = json['keycode'];
    phoneNumber = json['phoneNumber'];
    ssn = json['ssn'];
    slug = json['slug'];
    country = json['country'];
    countryFlag = json['country_flag'];
    token = json['token'];
    message = json['message'];
  }

  User.fromJSON(Map<String, dynamic> json) {
    token = json['token'];
    message = json['message'];
  }

  User.fromUnsuccessfulJson(Map<String, dynamic> json) {
    error = json;
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username.trim();
    data['firstName'] = this.firstName.trim();
    data['lastName'] = this.lastName.trim();
    data['email'] = this.email.trim();
    data['phone'] = this.phoneNumber.trim();
    data['password'] = this.password.trim();
    data['password2'] = this.password2.trim();
    return data;
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = username;
    map["password"] = password;
    return map;
  }
}
