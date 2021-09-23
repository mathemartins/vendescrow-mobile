class Coins {
  int id;
  String name;
  String coinId;
  String symbol;
  dynamic price;
  int rank;
  String image;
  dynamic marketCap;
  dynamic fullyDilutedValuation;
  dynamic totalVolume;
  dynamic highestInTheLast24h;
  dynamic lowestInTheLast24h;
  dynamic priceChangeInTheLast24h;
  dynamic priceChangePercentageInTheLast24h;
  dynamic marketCapChangeInTheLast24h;
  dynamic marketCapChangePercentageInTheLast24h;
  dynamic circulatingSupply;
  dynamic totalSupply;
  dynamic maxSupply;
  dynamic allTimeHigh;
  dynamic allTimeHighChangePercentage;
  String allTimeHighDate;
  dynamic allTimeLow;
  dynamic allTimeLowChangePercentage;
  String allTimeLowDate;
  String lastUpdated;
  dynamic priceChangeInTheLast1hr;
  String state;

  Coins(
      {this.id,
        this.name,
        this.coinId,
        this.symbol,
        this.price,
        this.rank,
        this.image,
        this.marketCap,
        this.fullyDilutedValuation,
        this.totalVolume,
        this.highestInTheLast24h,
        this.lowestInTheLast24h,
        this.priceChangeInTheLast24h,
        this.priceChangePercentageInTheLast24h,
        this.marketCapChangeInTheLast24h,
        this.marketCapChangePercentageInTheLast24h,
        this.circulatingSupply,
        this.totalSupply,
        this.maxSupply,
        this.allTimeHigh,
        this.allTimeHighChangePercentage,
        this.allTimeHighDate,
        this.allTimeLow,
        this.allTimeLowChangePercentage,
        this.allTimeLowDate,
        this.lastUpdated,
        this.priceChangeInTheLast1hr,
        this.state});

  Coins.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    coinId = json['coin_id'];
    symbol = json['symbol'];
    price = json['price'];
    rank = json['rank'];
    image = json['image'];
    marketCap = json['market_cap'];
    fullyDilutedValuation = json['fully_diluted_valuation'];
    totalVolume = json['total_volume'];
    highestInTheLast24h = json['highest_in_the_last_24h'];
    lowestInTheLast24h = json['lowest_in_the_last_24h'];
    priceChangeInTheLast24h = json['price_change_in_the_last_24h'];
    priceChangePercentageInTheLast24h =
    json['price_change_percentage_in_the_last_24h'];
    marketCapChangeInTheLast24h = json['market_cap_change_in_the_last_24h'];
    marketCapChangePercentageInTheLast24h =
    json['market_cap_change_percentage_in_the_last_24h'];
    circulatingSupply = json['circulating_supply'];
    totalSupply = json['total_supply'];
    maxSupply = json['max_supply'];
    allTimeHigh = json['all_time_high'];
    allTimeHighChangePercentage = json['all_time_high_change_percentage'];
    allTimeHighDate = json['all_time_high_date'];
    allTimeLow = json['all_time_low'];
    allTimeLowChangePercentage = json['all_time_low_change_percentage'];
    allTimeLowDate = json['all_time_low_date'];
    lastUpdated = json['last_updated'];
    priceChangeInTheLast1hr = json['price_change_in_the_last_1hr'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['coin_id'] = this.coinId;
    data['symbol'] = this.symbol;
    data['price'] = this.price;
    data['rank'] = this.rank;
    data['image'] = this.image;
    data['market_cap'] = this.marketCap;
    data['fully_diluted_valuation'] = this.fullyDilutedValuation;
    data['total_volume'] = this.totalVolume;
    data['highest_in_the_last_24h'] = this.highestInTheLast24h;
    data['lowest_in_the_last_24h'] = this.lowestInTheLast24h;
    data['price_change_in_the_last_24h'] = this.priceChangeInTheLast24h;
    data['price_change_percentage_in_the_last_24h'] =
        this.priceChangePercentageInTheLast24h;
    data['market_cap_change_in_the_last_24h'] =
        this.marketCapChangeInTheLast24h;
    data['market_cap_change_percentage_in_the_last_24h'] =
        this.marketCapChangePercentageInTheLast24h;
    data['circulating_supply'] = this.circulatingSupply;
    data['total_supply'] = this.totalSupply;
    data['max_supply'] = this.maxSupply;
    data['all_time_high'] = this.allTimeHigh;
    data['all_time_high_change_percentage'] = this.allTimeHighChangePercentage;
    data['all_time_high_date'] = this.allTimeHighDate;
    data['all_time_low'] = this.allTimeLow;
    data['all_time_low_change_percentage'] = this.allTimeLowChangePercentage;
    data['all_time_low_date'] = this.allTimeLowDate;
    data['last_updated'] = this.lastUpdated;
    data['price_change_in_the_last_1hr'] = this.priceChangeInTheLast1hr;
    data['state'] = this.state;
    return data;
  }
}