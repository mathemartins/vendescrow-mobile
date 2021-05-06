class FiatListModel {
  String country;
  String dollarRate;
  String timestamp;
  String updated;

  FiatListModel({this.country, this.dollarRate, this.timestamp, this.updated});

  FiatListModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    dollarRate = json['dollar_rate'];
    timestamp = json['timestamp'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country'] = this.country;
    data['dollar_rate'] = this.dollarRate;
    data['timestamp'] = this.timestamp;
    data['updated'] = this.updated;
    return data;
  }
}
