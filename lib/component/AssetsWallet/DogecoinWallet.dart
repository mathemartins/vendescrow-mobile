class DogecoinWallet {
  String username;
  String name;
  dynamic balance;
  String shortName;
  String icon;
  String private;
  String public;
  String address;
  bool frozen;
  dynamic amount;

  DogecoinWallet(
      {this.username,
      this.name,
      this.balance,
      this.shortName,
      this.icon,
      this.private,
      this.public,
      this.address,
      this.frozen,
      this.amount});

  DogecoinWallet.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    balance = json['balance'];
    shortName = json['short_name'];
    icon = json['icon'];
    private = json['private'];
    public = json['public'];
    address = json['address'];
    frozen = json['frozen'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['name'] = this.name;
    data['balance'] = this.balance;
    data['short_name'] = this.shortName;
    data['icon'] = this.icon;
    data['private'] = this.private;
    data['public'] = this.public;
    data['address'] = this.address;
    data['frozen'] = this.frozen;
    data['amount'] = this.amount;
    return data;
  }
}
