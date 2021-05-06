import 'package:crypto_v2/component/User/UserModel.dart';

class News {
  String url;
  User user;
  String title;
  String image;
  String content;
  String publish;

  News(
      {this.url,
      this.user,
      this.title,
      this.image,
      this.content,
      this.publish});

  News.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    title = json['title'];
    image = json['image'];
    content = json['content'];
    publish = json['publish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['title'] = this.title;
    data['image'] = this.image;
    data['content'] = this.content;
    data['publish'] = this.publish;
    return data;
  }
}
