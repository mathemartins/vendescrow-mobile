import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/LiveCrypto.dart';
import 'package:crypto_v2/component/market/btcModel.dart';
import 'package:crypto_v2/screen/home/LiveCryptoAsset.dart';
import 'package:crypto_v2/screen/market/detailCrypto/btcDetail.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class btc extends StatefulWidget {
  final Widget child;

  btc({Key key, this.child}) : super(key: key);

  _btcState createState() => _btcState();
}

class _btcState extends State<btc> {
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
    var responseCurrentUser = await apiService.getCurrentUser();

    setState(() {
      user = responseCurrentUser;
      _blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      loadData = false;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              left: 0.0, right: 0.0, top: 7.0, bottom: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 22.0),
                child: Container(
                    width: 100.0,
                    child: Text(
                      "Pair",
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "Popins"),
                    )),
              ),
              Container(
                  width: 100.0,
                  child: Text(
                    "Last Price",
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: "Popins"),
                  )),
              Container(
                  width: 80.0,
                  child: Text(
                    "24h Chg%",
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: "Popins"),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 0.0,
        ),

        /// check the condition if image data from server firebase loaded or no
        /// if image loaded true (image still downloading from server)
        /// Card to set card loading animation

        loadData
            ? _loadingData(context)
            : _dataLoaded(context, _liveCrypto, user, _blackMarketRate),
      ],
    ));
  }
}

///
///
/// Calling imageLoading animation for set a grid layout
///
///
Widget _loadingData(BuildContext context) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: btcMarketList.length,
      itemBuilder: (ctx, i) {
        return loadingCard(ctx, btcMarketList[i]);
      },
    ),
  );
}

Widget loadingCard(BuildContext ctx, btcMarket item) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0),
    child: Shimmer.fromColors(
      baseColor: Color(0xFF3B4659),
      highlightColor: Color(0xFF606B78),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                      child: CircleAvatar(
                        backgroundColor: Theme.of(ctx).hintColor,
                        radius: 13.0,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              height: 15.0,
                              width: 60.0,
                              decoration: BoxDecoration(
                                  color: Theme.of(ctx).hintColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0))),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Container(
                            height: 12.0,
                            width: 25.0,
                            decoration: BoxDecoration(
                                color: Theme.of(ctx).hintColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 15.0,
                        width: 100.0,
                        decoration: BoxDecoration(
                            color: Theme.of(ctx).hintColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          height: 12.0,
                          width: 35.0,
                          decoration: BoxDecoration(
                              color: Theme.of(ctx).hintColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                  height: 25.0,
                  width: 55.0,
                  decoration: BoxDecoration(
                      color: Theme.of(ctx).hintColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(color: Colors.black12),
            ),
          )
        ],
      ),
    ),
  );
}

Widget _dataLoaded(
    BuildContext context, List<LiveCrypto> liveCrypto, user, blackmarketRate) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: liveCrypto.length,
      itemBuilder: (ctx, i) {
        return card(ctx, liveCrypto[i], user, blackmarketRate);
      },
    ),
  );
}

Widget card(BuildContext ctx, LiveCrypto item, User user,
    BlackMarketRate blackMarketRate) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0),
    child: Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(ctx).push(PageRouteBuilder(
              pageBuilder: (_, __, ___) => new btcDetail(item: item),
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: Text(item.cmcRank.toString())),
                    Container(
                      width: 95.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                item.symbol,
                                style: TextStyle(
                                    fontFamily: "Popins", fontSize: 16.5),
                              ),
                            ],
                          ),
                          Text(
                            getPriceInUserFiat(
                                item.quote.uSD.price,
                                blackMarketRate.country,
                                blackMarketRate.dollarRate),
                            style: TextStyle(
                                fontFamily: "Popins",
                                fontSize: 11.5,
                                color: Theme.of(ctx).hintColor),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 120.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      getPriceInUserFiat(item.quote.uSD.price,
                          blackMarketRate.country, blackMarketRate.dollarRate),
                      style: TextStyle(
                          fontFamily: "Popins",
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "\u{0024} ${item.quote.uSD.price.toStringAsFixed(2)}",
                      style: TextStyle(
                          fontFamily: "Popins",
                          fontSize: 11.5,
                          color: Theme.of(ctx).hintColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Container(
                    height: 25.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      color: item.quote.uSD.percentChange24h < 0
                          ? Colors.redAccent
                          : Color(0xFF00C087),
                    ),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        "${item.quote.uSD.percentChange24h.toStringAsFixed(2)}%",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ))),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
          child: Container(
            width: double.infinity,
            height: 0.5,
            decoration: BoxDecoration(color: Colors.black12),
          ),
        )
      ],
    ),
  );
}
