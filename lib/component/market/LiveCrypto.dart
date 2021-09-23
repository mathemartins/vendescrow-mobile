class LiveCrypto {
  int id;
  String name;
  String symbol;
  String slug;
  dynamic numMarketPairs;
  String dateAdded;
  List<String> tags;
  dynamic maxSupply;
  dynamic circulatingSupply;
  dynamic totalSupply;
  dynamic platform;
  dynamic cmcRank;
  String lastUpdated;
  Quote quote;

  LiveCrypto({
      this.id,
      this.name,
      this.symbol,
      this.slug,
      this.numMarketPairs,
      this.dateAdded,
      this.tags,
      this.maxSupply,
      this.circulatingSupply,
      this.totalSupply,
      this.platform,
      this.cmcRank,
      this.lastUpdated,
      this.quote
  });

  LiveCrypto.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    symbol = json['symbol'];
    slug = json['slug'];
    numMarketPairs = json['num_market_pairs'];
    dateAdded = json['date_added'];
    tags = json['tags'].cast<String>();
    maxSupply = json['max_supply'];
    circulatingSupply = json['circulating_supply'];
    totalSupply = json['total_supply'];
    platform = json['platform'];
    cmcRank = json['cmc_rank'];
    lastUpdated = json['last_updated'];
    quote = json['quote'] != null ? new Quote.fromJson(json['quote']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['slug'] = this.slug;
    data['num_market_pairs'] = this.numMarketPairs;
    data['date_added'] = this.dateAdded;
    data['tags'] = this.tags;
    data['max_supply'] = this.maxSupply;
    data['circulating_supply'] = this.circulatingSupply;
    data['total_supply'] = this.totalSupply;
    data['platform'] = this.platform;
    data['cmc_rank'] = this.cmcRank;
    data['last_updated'] = this.lastUpdated;
    if (this.quote != null) {
      data['quote'] = this.quote.toJson();
    }
    return data;
  }
}

class Quote {
  USD uSD;

  Quote({this.uSD});

  Quote.fromJson(Map<String, dynamic> json) {
    uSD = json['USD'] != null ? new USD.fromJson(json['USD']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.uSD != null) {
      data['USD'] = this.uSD.toJson();
    }
    return data;
  }
}

class USD {
  dynamic price;
  dynamic volume24h;
  dynamic percentChange1h;
  dynamic percentChange24h;
  dynamic percentChange7d;
  dynamic percentChange30d;
  dynamic percentChange60d;
  dynamic percentChange90d;
  dynamic marketCap;
  String lastUpdated;

  USD(
      {this.price,
      this.volume24h,
      this.percentChange1h,
      this.percentChange24h,
      this.percentChange7d,
      this.percentChange30d,
      this.percentChange60d,
      this.percentChange90d,
      this.marketCap,
      this.lastUpdated});

  USD.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    volume24h = json['volume_24h'];
    percentChange1h = json['percent_change_1h'];
    percentChange24h = json['percent_change_24h'];
    percentChange7d = json['percent_change_7d'];
    percentChange30d = json['percent_change_30d'];
    percentChange60d = json['percent_change_60d'];
    percentChange90d = json['percent_change_90d'];
    marketCap = json['market_cap'];
    lastUpdated = json['last_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['price'] = this.price;
    data['volume_24h'] = this.volume24h;
    data['percent_change_1h'] = this.percentChange1h;
    data['percent_change_24h'] = this.percentChange24h;
    data['percent_change_7d'] = this.percentChange7d;
    data['percent_change_30d'] = this.percentChange30d;
    data['percent_change_60d'] = this.percentChange60d;
    data['percent_change_90d'] = this.percentChange90d;
    data['market_cap'] = this.marketCap;
    data['last_updated'] = this.lastUpdated;
    return data;
  }
}
