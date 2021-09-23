class P2PTradeBuyTransactionRetrieve {
  String transactionKey;
  String tradeCreator;
  String tradeCreatorPhone;
  double unitsOfAsset;
  String fiatPaid;
  String bank;
  String accountNumber;
  String accountName;
  String status;
  String slug;

  P2PTradeBuyTransactionRetrieve(
      {this.transactionKey,
        this.tradeCreator,
        this.tradeCreatorPhone,
        this.unitsOfAsset,
        this.fiatPaid,
        this.bank,
        this.accountNumber,
        this.accountName,
        this.status,
        this.slug});

  P2PTradeBuyTransactionRetrieve.fromJson(Map<String, dynamic> json) {
    transactionKey = json['transaction_key'];
    tradeCreator = json['trade_creator'];
    tradeCreatorPhone = json['trade_creator_phone'];
    unitsOfAsset = json['units_of_asset'];
    fiatPaid = json['fiat_paid'];
    bank = json['bank'];
    accountNumber = json['account_number'];
    accountName = json['account_name'];
    status = json['status'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['transaction_key'] = this.transactionKey;
    data['trade_creator'] = this.tradeCreator;
    data['trade_creator_phone'] = this.tradeCreatorPhone;
    data['units_of_asset'] = this.unitsOfAsset;
    data['fiat_paid'] = this.fiatPaid;
    data['bank'] = this.bank;
    data['account_number'] = this.accountNumber;
    data['account_name'] = this.accountName;
    data['status'] = this.status;
    data['slug'] = this.slug;
    return data;
  }
}