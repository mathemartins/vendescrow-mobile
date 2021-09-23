class MyTransactions {
  int id;
  int trade;
  String tradeSlug;
  String transactionKey;
  String tradeCreatorUsername;
  String tradeVisitorUsername;
  String cryptoUnitTransacted;
  String fiatPaid;
  String status;
  String slug;
  String timestamp;
  String updated;

  MyTransactions(
      {this.id,
        this.trade,
        this.tradeSlug,
        this.transactionKey,
        this.tradeCreatorUsername,
        this.tradeVisitorUsername,
        this.cryptoUnitTransacted,
        this.fiatPaid,
        this.status,
        this.slug,
        this.timestamp,
        this.updated});

  MyTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    trade = json['trade'];
    tradeSlug = json['trade_slug'];
    transactionKey = json['transaction_key'];
    tradeCreatorUsername = json['trade_creator_username'];
    tradeVisitorUsername = json['trade_visitor_username'];
    cryptoUnitTransacted = json['crypto_unit_transacted'];
    fiatPaid = json['fiat_paid'];
    status = json['status'];
    slug = json['slug'];
    timestamp = json['timestamp'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['trade'] = this.trade;
    data['trade_slug'] = this.tradeSlug;
    data['transaction_key'] = this.transactionKey;
    data['trade_creator_username'] = this.tradeCreatorUsername;
    data['trade_visitor_username'] = this.tradeVisitorUsername;
    data['crypto_unit_transacted'] = this.cryptoUnitTransacted;
    data['fiat_paid'] = this.fiatPaid;
    data['status'] = this.status;
    data['slug'] = this.slug;
    data['timestamp'] = this.timestamp;
    data['updated'] = this.updated;
    return data;
  }
}