import 'dart:convert';

import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Common/Common.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/HumanReadableNumbers.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/CoinModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/cryptoDetail.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/crypto_detail_card_homeScreen/DetailCryptoValue/orderHistory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:shared_preferences/shared_preferences.dart';

class btcDetail extends StatefulWidget {
  Coins item;
  btcDetail({Key key, this.item}) : super(key: key);

  _btcDetailState createState() => _btcDetailState();
}

class _btcDetailState extends State<btcDetail> {
  APIService apiService = new APIService();
  User user = new User();
  CryptoDetail cryptoDetail = new CryptoDetail();
  CryptoValueDetail cryptoValueDetail = new CryptoValueDetail();
  BlackMarketRate _blackMarketRate = BlackMarketRate();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isFavourite = false;
  bool loadData = true;
  List<Coins> favCoins = new List<Coins>();

  @override
  void initState() {
    super.initState();

    fetchPageContent(widget.item.symbol);
  }

  void fetchPageContent(String asset) async {
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseCryptoDetail = await apiService.getCryptoDetail(asset);
    var responseCryptoValueDetail = await apiService.getCryptoValueDetail(asset);
    setState(() {
      _blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      cryptoDetail = CryptoDetail.fromJson(responseCryptoDetail['data']['${asset.toUpperCase()}']);
      cryptoValueDetail = CryptoValueDetail.fromJson(responseCryptoValueDetail['data']['${asset.toUpperCase()}']);
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var grayText = TextStyle(color: Theme.of(context).hintColor, fontFamily: "avenir", fontSize: 12.5);
    var styleValueChart = TextStyle(color: Theme.of(context).hintColor, fontFamily: "avenir", fontSize: 11.5);
    return loadData ? Center(child: CircularProgressIndicator()) : Scaffold(
            key: scaffoldKey,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              brightness: Brightness.dark,
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(cryptoDetail.logo.toString(), fit: BoxFit.contain, height: 32,),
                  Container(padding: const EdgeInsets.all(8.0), child: Text('${cryptoDetail.name.toString()}',
                        style: TextStyle(color: Theme.of(context).textSelectionColor),
                      ))
                ],
              ),
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).hintColor,),
            ),
            body: Column(
              children: <Widget>[
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 15.0, right: 15.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  cryptoValueDetail.quote.uSD.price == null ? "fetching.." :
                                  getPriceInUserDataFiat(
                                      cryptoValueDetail.quote.uSD.price, _blackMarketRate.country,
                                      _blackMarketRate.dollarRate
                                  ),
                                  style: TextStyle(
                                      color: cryptoValueDetail.quote.uSD.percentChange24h < 0 ?
                                      Colors.redAccent : Color(0xFF00C087),
                                      fontSize: 20.0,
                                      fontFamily: "Sans",
                                      fontWeight: FontWeight.w700
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 15.0),
                                          child: Text(
                                            "Max Supply:",
                                            style: grayText,
                                          ),
                                        ),
                                        Text(cryptoValueDetail.maxSupply == null
                                            ? "0.00"
                                            : "${cryptoValueDetail.maxSupply}")
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "\u{0024} ${cryptoValueDetail.quote.uSD.price.toStringAsFixed(2)}",
                                      style: grayText,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "${cryptoValueDetail.quote.uSD.percentChange24h.toStringAsFixed(2)} %",
                                        style: TextStyle(
                                          color: cryptoValueDetail.quote.uSD
                                                      .percentChange24h <
                                                  0
                                              ? Colors.redAccent
                                              : Color(0xFF00C087),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 35.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Container(
                        height: 300.0,
                        child: Stack(
                          children: <Widget>[
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 15.0),
                            //   child: _line(),
                            // ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 300.0,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Stack(children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 70.0),
                                            child: _line()),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${cryptoValueDetail.quote.uSD.percentChange90d}",
                                              style: styleValueChart,
                                            ))
                                      ]),
                                      Stack(children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 70.0),
                                            child: _line()),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${cryptoValueDetail.quote.uSD.percentChange60d}",
                                              style: styleValueChart,
                                            ))
                                      ]),
                                      Stack(children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 70.0),
                                            child: _line()),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${cryptoValueDetail.quote.uSD.percentChange30d}",
                                              style: styleValueChart,
                                            ))
                                      ]),
                                      Stack(children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 70.0),
                                            child: _line()),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${cryptoValueDetail.quote.uSD.percentChange7d}",
                                              style: styleValueChart,
                                            ))
                                      ]),
                                      Stack(children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 70.0),
                                            child: _line()),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${cryptoValueDetail.quote.uSD.percentChange1h}",
                                              style: styleValueChart,
                                            ))
                                      ]),
                                      Stack(children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 30.0),
                                            child: _line()),
                                        Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "${cryptoValueDetail.quote.uSD.percentChange24h}",
                                              style: styleValueChart,
                                            ))
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: new Sparkline(
                                data: generateRandomDecimals(),
                                lineWidth: 0.3,
                                fillMode: FillMode.below,
                                lineColor: cryptoValueDetail.quote.uSD.percentChange24h < 0
                                    ? Colors.redAccent : Color(0xFF00C087),
                                fillGradient: new LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.greenAccent.withOpacity(0.2),
                                    Colors.greenAccent.withOpacity(0.01)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "${cryptoValueDetail.quote.uSD.percentChange90d.toStringAsFixed(2)}",
                              style: styleValueChart,
                            ),
                            Text(
                              "${cryptoValueDetail.quote.uSD.percentChange60d.toStringAsFixed(2)}",
                              style: styleValueChart,
                            ),
                            Text(
                              "${cryptoValueDetail.quote.uSD.percentChange30d.toStringAsFixed(2)}",
                              style: styleValueChart,
                            ),
                            Text(
                              "${cryptoValueDetail.quote.uSD.percentChange7d.toStringAsFixed(2)}",
                              style: styleValueChart,
                            ),
                            Text(
                              "${cryptoValueDetail.quote.uSD.percentChange24h.toStringAsFixed(2)}",
                              style: styleValueChart,
                            ),
                            Text(
                              "${cryptoValueDetail.quote.uSD.percentChange1h.toStringAsFixed(2)}",
                              style: styleValueChart,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 470.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: DefaultTabController(
                                length: 2,
                                child: new Scaffold(
                                  appBar: PreferredSize(
                                    preferredSize: Size.fromHeight(53.0), // here the desired height
                                    child: new AppBar(
                                      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                      elevation: 0.0,
                                      centerTitle: true,
                                      flexibleSpace: SafeArea(
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.only(right: 100.0),
                                            child: new TabBar(
                                              // labelColor: Theme.of(context).primaryColor,
                                              indicatorColor: colorStyle.primaryColor,
                                              labelColor: Theme.of(context).primaryColor,
                                              unselectedLabelColor: Theme.of(context).textSelectionColor,
                                              indicatorSize: TabBarIndicatorSize.label,
                                              tabs: [
                                                new Tab(
                                                  child: Text("About ${cryptoDetail.name.toString()}",
                                                    style: TextStyle(fontFamily: "avenir"),
                                                  ),
                                                ),
                                                new Tab(
                                                  child: Text("${cryptoDetail.name.toString()} Metrics",
                                                    style: TextStyle(fontFamily: "avenir"),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      automaticallyImplyLeading: false,
                                    ),
                                  ),
                                  body: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: new TabBarView(
                                      children: [
                                        displayCryptoContent(),
                                        orderHistory(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (isFavourite == false) {
                            // add data to favourite list
                            addToFavouriteList();
                            setState(() {
                              isFavourite = true;
                            });

                            final snackBar = SnackBar(
                              content: Text("${cryptoDetail.name.toString()} has been added to your favourite assets"),
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          } else {
                            // remove data from favourite list

                            setState(() {
                              isFavourite = false;
                            });
                            final snackBar = SnackBar(
                              content: Text("${cryptoDetail.name.toString()} has been removed from your favourite assets"),
                            );
                            scaffoldKey.currentState.showSnackBar(snackBar);
                          }
                        },
                        child: Column(children: <Widget>[
                          Icon(Icons.star, color: isFavourite ? colorStyle.primaryColor : Theme.of(context).hintColor,),
                          Container(
                              width: 50.0,
                              child: Center(
                                  child: Text("Favorites Asset",
                                  style: TextStyle(fontSize: 10.0, color: isFavourite ? colorStyle.primaryColor : Theme.of(context).hintColor,),
                                  textAlign: TextAlign.center,
                              )))
                        ]),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget _line() {
    return Container(
      height: 0.2,
      width: double.infinity,
      color: Theme.of(context).hintColor,
    );
  }

  Widget _backgroundLine() {
    return Container(
        height: 13.2,
        width: double.infinity,
        color: Theme.of(context).canvasColor);
  }

  String getPriceInUserDataFiat(
      priceIndollars, userCountry, userFiatRateToDollar) {
    final userLocalFiat = k_m_b_generator(priceIndollars, userFiatRateToDollar);
    final currencySymbol = getUserCurrency(userCountry);
    return '$currencySymbol $userLocalFiat';
  }

  displayCryptoContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Theme.of(context).canvasColor,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 0.0, top: 7.0, bottom: 7.0),
              child: Container(
                child: Text("${cryptoDetail.description}",
                    style: TextStyle(fontSize: 15, fontFamily: "avenir")),
              )),
        ),
      ],
    );
  }

  void addToFavouriteList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final getFavCoinList = preferences.getString("favCoinList");
    if (getFavCoinList != null) {
      final serializePayload = json.decode(getFavCoinList);
      final liveFavCoin = List<Coins>();

      for (var data in serializePayload) {
        liveFavCoin.add(Coins.fromJson(data));
      }
      setState(() {
        favCoins = liveFavCoin;
        for (var data in favCoins) {
          if (widget.item.name == data.name) {
            isFavourite = true;
          }
        }
      });
    }
  }

}
