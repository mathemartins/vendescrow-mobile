import 'package:flutter/material.dart';

class usdtMarket {
  String icon,name,pairValue,priceValue,priceDollar,percent;
  Color colorChg;
  usdtMarket({this.icon,this.name,this.pairValue,this.percent,this.priceDollar,this.priceValue,this.colorChg});
}

List<usdtMarket> usdtMarketList = [
  usdtMarket(
    icon: "assets/image/market/BCH.png",
    name: "BCH",
    pairValue: "1.7",
    priceValue: "0.0003214",
    priceDollar: "\$158.5432",
    percent: "-0.44%",
    colorChg: Colors.red
  ),
  usdtMarket(
    icon: "assets/image/market/btc.png",
    name: "BCHSV",
    pairValue: "960.6",
    priceValue: "65.1645",
    priceDollar: "\$65.5132",
    percent: "-0.18%",
    colorChg: Colors.red
  ),
 usdtMarket(
    icon: "assets/image/market/bitcoin.png",
    name: "BTC",
    pairValue: "813048.6",
    priceValue: "3.69610",
    priceDollar: "\$3993.69610",
    percent: "-0.18%",
    colorChg: Colors.red
  ),
  usdtMarket(
    icon: "assets/image/market/EOS.png",
    name: "EOS",
    pairValue: "0.6",
    priceValue: "0.0001645",
    priceDollar: "\$3.3932",
    percent: "+0.03%",
    colorChg: Color(0xFF00C087)
  ),
  usdtMarket(
    icon: "assets/image/market/ETC.png",
    name: "ETC",
    pairValue: "0.8",
    priceValue: "0.0011011",
    priceDollar: "\$4.539122",
    percent: "+3.36%",
    colorChg: Color(0xFF00C087)
  ),
  usdtMarket(
    icon: "assets/image/market/eth.png",
    name: "ETH",
    pairValue: "380.8",
    priceValue: "0.0364231",
    priceDollar: "\$137.539122",
    percent: "+1.36%",
    colorChg: Color(0xFF00C087)
  ),
  usdtMarket(
    icon: "assets/image/market/NEO.png",
    name: "NEO",
    pairValue: "2.6",
    priceValue: "0.0064231",
    priceDollar: "\$9.129122",
    percent: "+0.36%",
    colorChg: Color(0xFF00C087)
  ),
  usdtMarket(
    icon: "assets/image/market/aion.png",
    name: "AION",
    pairValue: "0.6",
    priceValue: "0.0000341",
    priceDollar: "\$0.1358",
    percent: "-0.87%",
    colorChg: Colors.red
  ),
  usdtMarket(
    icon: "assets/image/market/bat.png",
    name: "BAT",
    pairValue: "1.7",
    priceValue: "0.0004356",
    priceDollar: "\$0.2412",
    percent: "+0.18%",
    colorChg: Color(0xFF00C087)
  ),
  usdtMarket(
    icon: "assets/image/market/bee.png",
    name: "BEE",
    pairValue: "0.8",
    priceValue: "0.000086",
    priceDollar: "\$0.00343",
    percent: "-2.27%",
    colorChg: Colors.red
  ),
  usdtMarket(
    icon: "assets/image/market/bnt.png",
    name: "BNT",
    pairValue: "4.1",
    priceValue: "0.000151",
    priceDollar: "\$0.60188",
    percent: "-2.25%",
    colorChg: Colors.red
  ),
  usdtMarket(
    icon: "assets/image/market/dnt.png",
    name: "DNT",
    pairValue: "0.2",
    priceValue: "0.0000359",
    priceDollar: "\$0.01432",
    percent: "-2.97%",
    colorChg: Colors.red
  ),
];