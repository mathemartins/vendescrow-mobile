import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/FiatListModel.dart';
import 'package:crypto_v2/component/market/ethModel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class eth extends StatefulWidget {
  final Widget child;

  eth({Key key, this.child}) : super(key: key);

  _ethState createState() => _ethState();
}

class _ethState extends State<eth> {
  List<FiatListModel> listFiat = List<FiatListModel>();
  APIService apiService = new APIService();
  User user = User();
  BlackMarketRate blackMarketRate = BlackMarketRate();
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    apiService.getLiveFiatData().then((value) {
      setState(() {
        listFiat.addAll(value);
      });
    });

    fetchPageData();
  }

  void fetchPageData() async {
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseCurrentUser = await apiService.getCurrentUser();

    setState(() {
      user = responseCurrentUser;
      blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      loadData = false;
    });
  }

  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: <Widget>[
        Padding(
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
                      "Currency",
                      style: TextStyle(
                          color: Theme.of(context).hintColor,
                          fontFamily: "Popins"),
                    )),
              ),
              Container(
                  width: 100.0,
                  child: Text(
                    "Rate",
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: "Popins"),
                  )),
              Container(
                  width: 80.0,
                  child: Text(
                    "Symbol",
                    style: TextStyle(
                        color: Theme.of(context).hintColor,
                        fontFamily: "Popins"),
                  )),
            ],
          ),
        ),
        SizedBox(
          height: 5.0,
        ),

        ///
        ///
        /// check the condition if image data from server firebase loaded or no
        /// if image loaded true (image still downloading from server)
        /// Card to set card loading animation
        ///

        loadData
            ? _loadingData(context)
            : _dataLoaded(context, listFiat, user, blackMarketRate),
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
      itemCount: ethMarketList.length,
      itemBuilder: (ctx, i) {
        return loadingCard(ctx, ethMarketList[i]);
      },
    ),
  );
}

///
///
/// Calling ImageLoaded animation for set a grid layout
///
///
Widget _dataLoaded(
    BuildContext context, List<FiatListModel> listFiat, user, blackmarketRate) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: listFiat.length,
      itemBuilder: (ctx, i) {
        return card(ctx, listFiat[i], user, blackmarketRate);
      },
    ),
  );
}

Widget loadingCard(BuildContext ctx, ethMarket item) {
  return Padding(
    padding: const EdgeInsets.only(top: 12.0),
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

Widget card(BuildContext ctx, FiatListModel item, User user,
    BlackMarketRate blackMarketRate) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0),
    child: Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            // Navigator.of(ctx).push(PageRouteBuilder(
            //     pageBuilder: (_, __, ___) => new ethDetail(item: item)));
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
                        child: Text("")),
                    Container(
                      width: 95.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                displayUserCurrencyName(item.country),
                                style: TextStyle(
                                    fontFamily: "Popins", fontSize: 16.5),
                              ),
                            ],
                          ),
                          Text(
                            item.dollarRate.toString(),
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
                      item.dollarRate,
                      style: TextStyle(
                          fontFamily: "Popins",
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.country,
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
                        color: Colors.green),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        displayUserCurrency(item.country),
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

String displayUserCurrency(String country) {
  String currencySymbol = getUserCurrency(country);
  return currencySymbol;
}

String displayUserCurrencyName(String country) {
  String currencyData = getUserCurrencyName(country);
  return currencyData;
}
