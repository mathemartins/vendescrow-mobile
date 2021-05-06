class BlackMarketRate {
  String updated;
  String timestamp;
  String country;
  double dollarRate;

  BlackMarketRate(
      {this.updated, this.timestamp, this.country, this.dollarRate});

  BlackMarketRate.fromJson(Map<String, dynamic> json) {
    updated = json['updated'];
    timestamp = json['timestamp'];
    country = json['country'];
    dollarRate = json['dollar_rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['updated'] = this.updated;
    data['timestamp'] = this.timestamp;
    data['country'] = this.country;
    data['dollar_rate'] = this.dollarRate;
    return data;
  }
}
