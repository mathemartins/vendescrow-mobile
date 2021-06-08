class UserLock {
  String message;
  String user;
  String pin;

  UserLock({this.message, this.user, this.pin});

  UserLock.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    user = json['user'];
    pin = json['pin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pin'] = this.pin;
    return data;
  }
}
