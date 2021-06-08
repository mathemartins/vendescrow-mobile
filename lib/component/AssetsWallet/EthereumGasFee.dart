class EthereumNetworkFee {
  dynamic fast;
  dynamic fastest;
  dynamic safeLow;
  dynamic average;
  dynamic blockTime;
  dynamic blockNum;
  dynamic speed;
  dynamic safeLowWait;
  dynamic avgWait;
  dynamic fastWait;
  dynamic fastestWait;
  GasPriceRange gasPriceRange;

  EthereumNetworkFee(
      {this.fast,
      this.fastest,
      this.safeLow,
      this.average,
      this.blockTime,
      this.blockNum,
      this.speed,
      this.safeLowWait,
      this.avgWait,
      this.fastWait,
      this.fastestWait,
      this.gasPriceRange});

  EthereumNetworkFee.fromJson(Map<String, dynamic> json) {
    fast = json['fast'];
    fastest = json['fastest'];
    safeLow = json['safeLow'];
    average = json['average'];
    blockTime = json['block_time'];
    blockNum = json['blockNum'];
    speed = json['speed'];
    safeLowWait = json['safeLowWait'];
    avgWait = json['avgWait'];
    fastWait = json['fastWait'];
    fastestWait = json['fastestWait'];
    gasPriceRange = json['gasPriceRange'] != null
        ? new GasPriceRange.fromJson(json['gasPriceRange'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fast'] = this.fast;
    data['fastest'] = this.fastest;
    data['safeLow'] = this.safeLow;
    data['average'] = this.average;
    data['block_time'] = this.blockTime;
    data['blockNum'] = this.blockNum;
    data['speed'] = this.speed;
    data['safeLowWait'] = this.safeLowWait;
    data['avgWait'] = this.avgWait;
    data['fastWait'] = this.fastWait;
    data['fastestWait'] = this.fastestWait;
    if (this.gasPriceRange != null) {
      data['gasPriceRange'] = this.gasPriceRange.toJson();
    }
    return data;
  }
}

class GasPriceRange {
  dynamic d4;
  dynamic d6;
  dynamic d8;
  dynamic d10;
  dynamic d20;
  dynamic d30;
  dynamic d40;
  dynamic d50;
  dynamic d60;
  dynamic d70;
  dynamic d80;
  dynamic d90;
  dynamic d100;
  dynamic d110;
  dynamic d120;
  dynamic d130;
  dynamic d140;
  dynamic d150;
  dynamic d160;
  dynamic d170;
  dynamic d180;
  dynamic d190;
  dynamic d210;
  dynamic d230;
  dynamic d250;
  dynamic d270;
  dynamic d290;
  dynamic d310;
  dynamic d330;
  dynamic d350;
  dynamic d360;
  dynamic d370;
  dynamic d390;
  dynamic d410;
  dynamic d430;
  dynamic d450;

  GasPriceRange(
      {this.d4,
      this.d6,
      this.d8,
      this.d10,
      this.d20,
      this.d30,
      this.d40,
      this.d50,
      this.d60,
      this.d70,
      this.d80,
      this.d90,
      this.d100,
      this.d110,
      this.d120,
      this.d130,
      this.d140,
      this.d150,
      this.d160,
      this.d170,
      this.d180,
      this.d190,
      this.d210,
      this.d230,
      this.d250,
      this.d270,
      this.d290,
      this.d310,
      this.d330,
      this.d350,
      this.d360,
      this.d370,
      this.d390,
      this.d410,
      this.d430,
      this.d450});

  GasPriceRange.fromJson(Map<String, dynamic> json) {
    d4 = json['4'];
    d6 = json['6'];
    d8 = json['8'];
    d10 = json['10'];
    d20 = json['20'];
    d30 = json['30'];
    d40 = json['40'];
    d50 = json['50'];
    d60 = json['60'];
    d70 = json['70'];
    d80 = json['80'];
    d90 = json['90'];
    d100 = json['100'];
    d110 = json['110'];
    d120 = json['120'];
    d130 = json['130'];
    d140 = json['140'];
    d150 = json['150'];
    d160 = json['160'];
    d170 = json['170'];
    d180 = json['180'];
    d190 = json['190'];
    d210 = json['210'];
    d230 = json['230'];
    d250 = json['250'];
    d270 = json['270'];
    d290 = json['290'];
    d310 = json['310'];
    d330 = json['330'];
    d350 = json['350'];
    d360 = json['360'];
    d370 = json['370'];
    d390 = json['390'];
    d410 = json['410'];
    d430 = json['430'];
    d450 = json['450'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['4'] = this.d4;
    data['6'] = this.d6;
    data['8'] = this.d8;
    data['10'] = this.d10;
    data['20'] = this.d20;
    data['30'] = this.d30;
    data['40'] = this.d40;
    data['50'] = this.d50;
    data['60'] = this.d60;
    data['70'] = this.d70;
    data['80'] = this.d80;
    data['90'] = this.d90;
    data['100'] = this.d100;
    data['110'] = this.d110;
    data['120'] = this.d120;
    data['130'] = this.d130;
    data['140'] = this.d140;
    data['150'] = this.d150;
    data['160'] = this.d160;
    data['170'] = this.d170;
    data['180'] = this.d180;
    data['190'] = this.d190;
    data['210'] = this.d210;
    data['230'] = this.d230;
    data['250'] = this.d250;
    data['270'] = this.d270;
    data['290'] = this.d290;
    data['310'] = this.d310;
    data['330'] = this.d330;
    data['350'] = this.d350;
    data['360'] = this.d360;
    data['370'] = this.d370;
    data['390'] = this.d390;
    data['410'] = this.d410;
    data['430'] = this.d430;
    data['450'] = this.d450;
    return data;
  }
}
