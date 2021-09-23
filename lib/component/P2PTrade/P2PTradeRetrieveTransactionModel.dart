class P2PTradeTransactionRetrieve {
  String transactionKey;
  String tradeVisitor;
  double unitsOfAsset;
  String fiatPaid;
  String bank;
  String accountNumber;
  String accountName;
  String status;
  String slug;

  P2PTradeTransactionRetrieve(
      {this.transactionKey,
        this.tradeVisitor,
        this.unitsOfAsset,
        this.fiatPaid,
        this.bank,
        this.accountNumber,
        this.accountName,
        this.status,
        this.slug});

  P2PTradeTransactionRetrieve.fromJson(Map<String, dynamic> json) {
    transactionKey = json['transaction_key'];
    tradeVisitor = json['trade_visitor'];
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
    data['trade_visitor'] = this.tradeVisitor;
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