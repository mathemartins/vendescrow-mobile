class P2PTradeModel {
  String url;
  int id;
  int tradeCreator;
  String tradeCreatorUsername;
  int transactions;
  String tradeListedAs;
  String creatorRateInDollar;
  String cryptoTradingAmount;
  String minTradingAmountInFiat;
  String maxTradingAmountInFiat;
  String assetToTrade;
  String priceSlippage;
  String minSlippage;
  String maxSlippage;
  bool active;
  String slug;
  String timestamp;
  String updated;

  P2PTradeModel(
      {this.url,
        this.id,
        this.tradeCreator,
        this.tradeCreatorUsername,
        this.transactions,
        this.tradeListedAs,
        this.creatorRateInDollar,
        this.cryptoTradingAmount,
        this.minTradingAmountInFiat,
        this.maxTradingAmountInFiat,
        this.assetToTrade,
        this.priceSlippage,
        this.minSlippage,
        this.maxSlippage,
        this.active,
        this.slug,
        this.timestamp,
        this.updated});

  P2PTradeModel.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    id = json['id'];
    tradeCreator = json['trade_creator'];
    tradeCreatorUsername = json['trade_creator_username'];
    transactions = json['transactions'];
    tradeListedAs = json['trade_listed_as'];
    creatorRateInDollar = json['creator_rate_in_dollar'];
    cryptoTradingAmount = json['crypto_trading_amount'];
    minTradingAmountInFiat = json['min_trading_amount_in_fiat'];
    maxTradingAmountInFiat = json['max_trading_amount_in_fiat'];
    assetToTrade = json['asset_to_trade'];
    priceSlippage = json['price_slippage'];
    minSlippage = json['min_slippage'];
    maxSlippage = json['max_slippage'];
    active = json['active'];
    slug = json['slug'];
    timestamp = json['timestamp'];
    updated = json['updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['id'] = this.id;
    data['trade_creator'] = this.tradeCreator;
    data['trade_creator_username'] = this.tradeCreatorUsername;
    data['transactions'] = this.transactions;
    data['trade_listed_as'] = this.tradeListedAs;
    data['creator_rate_in_dollar'] = this.creatorRateInDollar;
    data['crypto_trading_amount'] = this.cryptoTradingAmount;
    data['min_trading_amount_in_fiat'] = this.minTradingAmountInFiat;
    data['max_trading_amount_in_fiat'] = this.maxTradingAmountInFiat;
    data['asset_to_trade'] = this.assetToTrade;
    data['price_slippage'] = this.priceSlippage;
    data['min_slippage'] = this.minSlippage;
    data['max_slippage'] = this.maxSlippage;
    data['active'] = this.active;
    data['slug'] = this.slug;
    data['timestamp'] = this.timestamp;
    data['updated'] = this.updated;
    return data;
  }
}