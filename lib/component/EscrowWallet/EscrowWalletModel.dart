class EscrowWallet {
  String username;
  String firstName;
  String lastName;
  double balance;
  bool active;
  String slug;

  EscrowWallet({this.username,this.firstName,this.lastName,this.balance,this.active,this.slug});

  EscrowWallet.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    balance = json['balance'];
    active = json['active'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['balance'] = this.balance;
    data['active'] = this.active;
    data['slug'] = this.slug;
    return data;
  }
}