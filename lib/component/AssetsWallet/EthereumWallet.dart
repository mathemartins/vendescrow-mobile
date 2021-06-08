class EthereumWallet {
  String username;
  String name;
  dynamic balance;
  String shortName;
  String icon;
  String publicAddress;
  bool frozen;
  dynamic amount;
  String decryptedPrivateKey;
  Tether tether;

  EthereumWallet(
      {this.username,
      this.name,
      this.balance,
      this.shortName,
      this.icon,
      this.publicAddress,
      this.frozen,
      this.amount,
      this.decryptedPrivateKey,
      this.tether});

  EthereumWallet.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    name = json['name'];
    balance = json['balance'];
    shortName = json['short_name'];
    icon = json['icon'];
    publicAddress = json['public_address'];
    frozen = json['frozen'];
    amount = json['amount'];
    decryptedPrivateKey = json['decrypted_private_key'];
    tether =
        json['tether'] != null ? new Tether.fromJson(json['tether']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['name'] = this.name;
    data['balance'] = this.balance;
    data['short_name'] = this.shortName;
    data['icon'] = this.icon;
    data['public_address'] = this.publicAddress;
    data['frozen'] = this.frozen;
    data['amount'] = this.amount;
    data['decrypted_private_key'] = this.decryptedPrivateKey;
    if (this.tether != null) {
      data['tether'] = this.tether.toJson();
    }
    return data;
  }
}

class Tether {
  String name;
  dynamic balance;
  String shortName;
  String icon;
  String publicAddress;
  bool frozen;
  dynamic amount;
  String decryptedPrivateKey;

  Tether(
      {this.name,
      this.balance,
      this.shortName,
      this.icon,
      this.publicAddress,
      this.frozen,
      this.amount,
      this.decryptedPrivateKey});

  Tether.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    balance = json['balance'];
    shortName = json['short_name'];
    icon = json['icon'];
    publicAddress = json['public_address'];
    frozen = json['frozen'];
    amount = json['amount'];
    decryptedPrivateKey = json['decrypted_private_key'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['balance'] = this.balance;
    data['short_name'] = this.shortName;
    data['icon'] = this.icon;
    data['public_address'] = this.publicAddress;
    data['frozen'] = this.frozen;
    data['amount'] = this.amount;
    data['decrypted_private_key'] = this.decryptedPrivateKey;
    return data;
  }
}
