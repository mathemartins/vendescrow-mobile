import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/HumanReadableNumbers.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/LiveCrypto.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LiveCryptoAsset extends StatefulWidget {
  final Widget child;

  LiveCryptoAsset({Key key, this.child}) : super(key: key);

  @override
  LiveCryptoAssetState createState() => new LiveCryptoAssetState();
}

class LiveCryptoAssetState extends State<LiveCryptoAsset> {
  List<LiveCrypto> _liveCrypto = List<LiveCrypto>();
  APIService apiService = new APIService();
  User user = User();
  BlackMarketRate _blackMarketRate = BlackMarketRate();
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    apiService.getLiveCryptoData().then((value) {
      setState(() {
        _liveCrypto.addAll(value);
      });
    });

    fetchPageData();
  }

  void fetchPageData() async {
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseCurrentUser = await apiService.get('accounts/retrieve/');

    setState(() {
      user = User.fromJson(responseCurrentUser['data'][0]);
      _blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Theme.of(context).canvasColor,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 0.0, right: 0.0, top: 7.0, bottom: 7.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Container(
                      width: 100.0,
                      child: Text(
                        "Asset",
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontFamily: "avenir"),
                      )),
                ),
                Container(
                    width: 100.0,
                    child: Text(
                      "Current Value",
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "avenir"),
                    )),
                Container(
                    width: 80.0,
                    child: Text(
                      "Last Chg%",
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "avenir"),
                    )),
              ],
            ),
          ),
        ),

        /// check the condition if data from coin-market is loaded or not
        /// if loaded true, Card to set card loading animation

        loadData
            ? _loadingDataAnimation(context)
            : _dataLoaded(context, _liveCrypto, user, _blackMarketRate),
      ],
    );
  }
}

Widget listCryptoData(BuildContext ctx, LiveCrypto item, User user,
    BlackMarketRate blackMarketRate) {
  return Padding(
    padding: const EdgeInsets.only(left: 12.0, top: 20.0),
    child: InkWell(
      onTap: () {
        // Navigator.of(ctx).push(
        //   PageRouteBuilder(
        //     pageBuilder: (_, __, ___) => new gainersDetail(
        //       item: item,
        //     ),
        //   ),
        // );
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 100.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: TextStyle(fontFamily: "avenir", fontSize: 16.5),
                ),
              ],
            ),
          ),
          Container(
            width: 100.0,
            child: Text(
              getPriceInUserFiat(item.quote.uSD.price, blackMarketRate.country,
                  blackMarketRate.dollarRate),
              style: TextStyle(fontFamily: "avenir", fontSize: 14.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
                width: 80.0,
                height: 35.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    color: item.quote.uSD.percentChange1h < 0
                        ? Colors.redAccent
                        : Color(0xFF00C087)),
                child: Center(
                    child: Text(
                  "${item.quote.uSD.percentChange1h.toStringAsFixed(2)}%",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ))),
          )
        ],
      ),
    ),
  );
}

String getPriceInUserFiat(priceIndollars, userCountry, userFiatRateToDollar) {
  final userLocalFiat = k_m_b_generator(priceIndollars, userFiatRateToDollar);
  final currencySymbol = getUserCurrency(userCountry);
  return '$currencySymbol $userLocalFiat';
}

Widget loadingListCryptoData(BuildContext ctx) {
  return Padding(
    padding: const EdgeInsets.only(left: 12.0, top: 17.0),
    child: Shimmer.fromColors(
      baseColor: Color(0xFF3B4659),
      highlightColor: Color(0xFF606B78),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 70.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
              color: Theme.of(ctx).hintColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                color: Theme.of(ctx).hintColor,
              ),
              height: 20.0,
              width: 70.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                color: Theme.of(ctx).hintColor,
              ),
              height: 20.0,
              width: 115.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              color: Theme.of(ctx).hintColor,
              width: 80.0,
              height: 35.0,
            ),
          )
        ],
      ),
    ),
  );
}

/// Calling imageLoading animation for set a grid layout

Widget _loadingDataAnimation(BuildContext context) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: 9,
      itemBuilder: (ctx, i) {
        return loadingListCryptoData(ctx);
      },
    ),
  );
}

/// Calling ImageLoaded animation for set a grid layout

Widget _dataLoaded(
    BuildContext context, liveCryptoData, user, blackmarketRate) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: 9, //liveCryptoData.length,
      itemBuilder: (ctx, i) {
        return listCryptoData(ctx, liveCryptoData[i], user, blackmarketRate);
      },
    ),
  );
}
