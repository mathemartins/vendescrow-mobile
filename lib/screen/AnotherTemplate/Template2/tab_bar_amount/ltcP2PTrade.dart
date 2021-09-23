import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeModel.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/cryptoDetail.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template4/setting_layout/T4_payment.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class ltcP2PTrade extends StatefulWidget {
  final Widget child;

  ltcP2PTrade({Key key, this.child}) : super(key: key);

  _ltcP2PTradeState createState() => _ltcP2PTradeState();
}

class _ltcP2PTradeState extends State<ltcP2PTrade> {
  CryptoValueDetail cryptoValueDetail = new CryptoValueDetail();
  List<P2PTradeModel> p2pTradeList = List<P2PTradeModel>();
  User user = new User();
  APIService apiService = new APIService();
  BlackMarketRate _blackMarketRate = BlackMarketRate();
  bool loadData = true;

  String asset = 'ltc';

  @override
  void initState() {
    super.initState();
    apiService.getP2PTradeSellList().then((value) {
      print(value);
      setState(() {
        p2pTradeList.addAll(value.where((element) => element.assetToTrade.toLowerCase() == asset).toList());
        print(p2pTradeList.length);
      });
    });

    fetchPageData();
  }

  void fetchPageData() async {
    var responseCurrentUser = await apiService.get('accounts/retrieve/');
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseCryptoValueDetail = await apiService.getCryptoValueDetail(asset);
    print(responseCryptoValueDetail);

    setState(() {
      user = User.fromJson(responseCurrentUser['data'][0]);
      cryptoValueDetail = CryptoValueDetail.fromJson(responseCryptoValueDetail['data']['${asset.toUpperCase()}']);
      _blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      loadData = false;
    });
  }

  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          loadData ? _loadingData(context) :
          _dataLoaded(context, p2pTradeList, _blackMarketRate, cryptoValueDetail, user),
        ],
      ),
    );
  }
}


/// Calling imageLoading animation for set a grid layout

Widget _loadingData(BuildContext context) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: 10,
      itemBuilder: (ctx, i) {
        return loadingCard(ctx);
      },
    ),
  );
}

Widget loadingCard(BuildContext ctx) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0),
    child: Shimmer.fromColors(
      baseColor: Color(0xFF3B4659),
      highlightColor: Color(0xFF606B78),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
        child: Container(
          height: 120.0,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                )
              ]),
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Container(
                            height: 8.0,
                            width: 8.0,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                                color: Colors.deepPurple),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Text(
                              "Title",
                              style: TextStyle(
                                  fontFamily: "Sans",
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        Icons.open_in_new,
                        size: 17.0,
                        color: Colors.white24,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(left: 45.0, right: 20.0, top: 13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "24th Nov, 2021",
                        style: TextStyle(
                            fontFamily: "Sans",
                            fontWeight: FontWeight.w100,
                            color: Colors.white54),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            "Value",
                            style: TextStyle(
                                fontFamily: "Sans",
                                fontWeight: FontWeight.w800,
                                fontSize: 19.0),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 4.0),
                            child: Icon(
                              Icons.check_circle,
                              size: 17.0,
                              color: Colors.lightGreen,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _dataLoaded(BuildContext context, List<P2PTradeModel> p2pTradeSellList, blackmarketRate, CryptoValueDetail cryptoValueDetail, User user) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: p2pTradeSellList.length,
      itemBuilder: (context, i) {
        return _card(context, p2pTradeSellList[i], blackmarketRate, cryptoValueDetail, user);
      },
    ),
  );
}

Widget _card(BuildContext context, P2PTradeModel item, BlackMarketRate blackMarketRate, CryptoValueDetail cryptoValueDetail, User user) {
  return Padding(
    padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
    child: GestureDetector(
      onTap: (){
        Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (_, __, ___) => new T4_payment(tradeInfo: item, transactionType: "sell"),
        ));
      },
      child: Container(
        height: 120.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 8.0,
                          width: 8.0,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.red),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            getCurrentPriceOfAssetInUserFiat(
                                blackMarketRate.dollarRate,
                                blackMarketRate.country,
                                item.creatorRateInDollar,
                                cryptoValueDetail.quote.uSD.price
                            ),
                            style: TextStyle(
                                fontFamily: "Sans",
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      getMinAndMaxTradingAmount(item.minTradingAmountInFiat, item.maxTradingAmountInFiat),
                      style: TextStyle(
                          fontFamily: "avenir",
                          fontSize: 11,
                          fontWeight: FontWeight.w100,
                          color: Colors.white54),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 45.0, right: 20.0, top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Amount: ${item.cryptoTradingAmount} ${item.assetToTrade}",
                      style: TextStyle(
                          fontFamily: "avenir",
                          fontSize: 13,
                          fontWeight: FontWeight.w100,
                          color: Colors.white54),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: Icon(
                            Icons.person_outline,
                            size: 17.0,
                            color: Colors.lightGreen,
                          ),
                        ),
                        Text(
                          item.tradeCreatorUsername,
                          style: TextStyle(
                              fontFamily: "avenir",
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.open_in_new,
                            size: 17.0,
                            color: Colors.white24,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

String getMinAndMaxTradingAmount(String minTradingAmountInFiat, String maxTradingAmountInFiat) {
  final formattedMinTradingAmount = numberFormatter(double.parse(minTradingAmountInFiat));
  final formattedMaxTradingAmount = numberFormatter(double.parse(maxTradingAmountInFiat));
  return "Limit: $formattedMinTradingAmount - $formattedMaxTradingAmount";
}


String numberFormatter(double amount) {
  var formatter = NumberFormat("#,##0.00", "en_US");
  return "${formatter.format(amount)}";
}

String getCurrentPriceOfAssetInUserFiat(double dollarRate, String country, String creatorRateInDollar, price) {
  double assetPriceInDollar = double.parse(price.toString());
  double assetPrice = assetPriceInDollar * dollarRate;
  var formattedFigure = numberFormatter(assetPrice);
  final currencySymbol = getUserCurrency(country);
  return "$currencySymbol $formattedFigure";
}

