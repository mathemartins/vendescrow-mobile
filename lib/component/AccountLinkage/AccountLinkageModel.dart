class AccountLinkage {
  String fullName;
  String bank;
  String accountNumber;
  String accountType;
  String currency;
  String bvn;
  String message;
  String exchangeToken;
  String monoCode;

  AccountLinkage(
      {this.message,
      this.exchangeToken,
      this.monoCode,
      this.fullName,
      this.bank,
      this.accountType,
      this.accountNumber,
      this.currency,
      this.bvn});

  AccountLinkage.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    exchangeToken = json['exchangeToken'];
    fullName = json['fullName'];
    bank = json['bank'];
    accountNumber = json['accountNumber'];
    accountType = json['accountType'];
    currency = json['currency'];
    bvn = json['bvn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['monoCode'] = this.monoCode;
    return data;
  }
}
