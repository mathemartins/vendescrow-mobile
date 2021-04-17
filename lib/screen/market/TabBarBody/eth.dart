import 'dart:async';

import 'package:crypto_v2/component/market/ethModel.dart';
import 'package:crypto_v2/screen/market/detailCrypto/ethDetail.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class eth extends StatefulWidget {
  final Widget child;

  eth({Key key, this.child}) : super(key: key);

  _ethState createState() => _ethState();
}

class _ethState extends State<eth> {
  ///
  /// Get image data dummy from firebase server
  ///
  var imageNetwork = NetworkImage(
      "https://firebasestorage.googleapis.com/v0/b/beauty-look.appspot.com/o/Artboard%203.png?alt=media&token=dc7f4bf5-8f80-4f38-bb63-87aed9d59b95");

  ///
  /// check the condition is right or wrong for image loaded or no
  ///
  bool loadImage = true;

  @override
  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      setState(() {
        loadImage = false;
      });
    });

    // TODO: implement initState
    super.initState();
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
          height: 5.0,
        ),

        ///
        ///
        /// check the condition if image data from server firebase loaded or no
        /// if image loaded true (image still downloading from server)
        /// Card to set card loading animation
        ///

        loadImage ? _loadingData(context) : _dataLoaded(context),
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
Widget _dataLoaded(BuildContext context) {
  return Container(
    child: ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: ethMarketList.length,
      itemBuilder: (ctx, i) {
        return card(ctx, ethMarketList[i]);
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

Widget card(BuildContext ctx, ethMarket item) {
  return Padding(
    padding: const EdgeInsets.only(top: 7.0),
    child: Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(ctx).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => new ethDetail(item: item)));
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
                      child: Image.asset(
                        item.icon,
                        height: 22.0,
                        fit: BoxFit.contain,
                        width: 22.0,
                      ),
                    ),
                    Container(
                      width: 95.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                item.name,
                                style: TextStyle(
                                    fontFamily: "Popins", fontSize: 16.5),
                              ),
                              Text(
                                "/BTC",
                                style: TextStyle(
                                    fontFamily: "Popins",
                                    fontSize: 11.5,
                                    color: Theme.of(ctx).hintColor),
                              ),
                            ],
                          ),
                          Text(
                            item.pairValue,
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
                      item.priceValue,
                      style: TextStyle(
                          fontFamily: "Popins",
                          fontSize: 14.5,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      item.priceDollar,
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
                        color: item.colorChg),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Text(
                        item.percent,
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
