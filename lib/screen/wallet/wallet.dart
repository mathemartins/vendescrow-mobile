import 'dart:math';

import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/AssetsWallet/BitcoinWallet.dart';
import 'package:crypto_v2/component/AssetsWallet/DashWallet.dart';
import 'package:crypto_v2/component/AssetsWallet/DogecoinWallet.dart';
import 'package:crypto_v2/component/AssetsWallet/EthereumWallet.dart';
import 'package:crypto_v2/component/AssetsWallet/LitecoinWallet.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/screen/wallet/walletDetail.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as Vector;

class wallet extends StatefulWidget {
  @override
  _walletState createState() => new _walletState();

  ///
  /// time for wave header wallet
  ///
  wallet() {
    timeDilation = 1.0;
  }
}

class _walletState extends State<wallet> {
  APIService apiService = new APIService();
  EthereumWallet userEthWallet = EthereumWallet();
  BitcoinWallet userBTCWallet = BitcoinWallet();
  // DashWallet userDashWallet = DashWallet();
  // DogecoinWallet userDogeWallet = DogecoinWallet();
  // LitecoinWallet userLTCWallet = LitecoinWallet();
  BlackMarketRate blackMarketRate = BlackMarketRate();
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    fetchPageData();
  }

  void fetchPageData() async {
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseUserWallet = await apiService.get('wallet/');
    var responseUserBTCWallet = await apiService.get('wallet/btc/');
    // var responseUserLTCWallet = await apiService.get('wallet/ltc/');
    // var responseUserDashWallet = await apiService.get('wallet/dash/');
    // var responseUserDogeWallet = await apiService.get('wallet/doge/');

    setState(() {
      userEthWallet = EthereumWallet.fromJson(responseUserWallet['data'][0]);
      userBTCWallet = BitcoinWallet.fromJson(responseUserBTCWallet['data'][0]);
      // userDashWallet = DashWallet.fromJson(responseUserDashWallet['data'][0]);
      // userDogeWallet =
      //     DogecoinWallet.fromJson(responseUserDogeWallet['data'][0]);
      // userLTCWallet = LitecoinWallet.fromJson(responseUserLTCWallet['data'][0]);
      blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      loadData = false;
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Size size = new Size(MediaQuery.of(context).size.width, 200.0);
    return loadData
        ? Center(child: CircularProgressIndicator())
        : new Scaffold(
            body: Stack(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 225.0),

                  ///
                  /// Create card list
                  ///
                  child: Container(
                      child: Column(
                    children: [
                      displayBTCWallet(context, userBTCWallet),
                      displayEthWallet(context, userEthWallet),
                      displayTetherWallet(context, userEthWallet),
                      // displayLTCWallet(context, userLTCWallet),
                      // displayDogeWallet(context, userDogeWallet),
                      // displayDashWallet(context, userDashWallet),
                    ],
                  )),
                ),
                Column(
                  children: <Widget>[
                    new Stack(
                      children: <Widget>[
                        ///
                        /// Create wave header
                        ///
                        new waveBody(
                            size: size,
                            xOffset: 0,
                            yOffset: 0,
                            color: Colors.red),
                        new Opacity(
                          opacity: 0.9,
                          child: new waveBody(
                            size: size,
                            xOffset: 60,
                            yOffset: 10,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 13.0, right: 13.0, top: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "Coin Type",
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontFamily: "Popins",
                                fontSize: 14.0),
                          ),
                          Text(
                            "Value",
                            style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontFamily: "Popins",
                                fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }

  displayEthWallet(BuildContext ctx, EthereumWallet userEthWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      new walletDetail(assetName: userEthWallet.shortName)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: Image.network(
                          userEthWallet.icon.toString(),
                          height: 25.0,
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
                            Text(
                              userEthWallet.name,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              userEthWallet.frozen == true
                                  ? "Froze: ${userEthWallet.amount}"
                                  : "No Frozen Asset",
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
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${userEthWallet.balance} ETH",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 19.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(
                  color: Theme.of(ctx).hintColor.withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }

  displayUserEth(balance) {
    return double.parse(balance).toStringAsFixed(5);
  }

  displayTetherWallet(BuildContext ctx, EthereumWallet userEthWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new walletDetail(
                      assetName: userEthWallet.tether.shortName)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: Image.network(
                          userEthWallet.tether.icon.toString(),
                          height: 25.0,
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
                            Text(
                              userEthWallet.tether.name,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              userEthWallet.tether.frozen == true
                                  ? "Froze: ${userEthWallet.tether.amount}"
                                  : "No Frozen Asset",
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
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${userEthWallet.tether.balance} USDT",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 19.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(
                  color: Theme.of(ctx).hintColor.withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }

  displayBTCWallet(BuildContext ctx, BitcoinWallet userBTCWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      new walletDetail(assetName: userBTCWallet.shortName)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: Image.network(
                          userBTCWallet.icon.toString(),
                          height: 25.0,
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
                            Text(
                              userBTCWallet.name,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              userBTCWallet.frozen == true
                                  ? "Froze: ${userBTCWallet.amount}"
                                  : "No Frozen Asset",
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
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${userBTCWallet.balance} BTC",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 19.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(
                  color: Theme.of(ctx).hintColor.withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }

  displayLTCWallet(BuildContext ctx, LitecoinWallet userLTCWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      new walletDetail(assetName: userLTCWallet.shortName)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: Image.network(
                          userLTCWallet.icon.toString(),
                          height: 25.0,
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
                            Text(
                              userLTCWallet.name,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              userLTCWallet.frozen == true
                                  ? "Froze: ${userLTCWallet.amount}"
                                  : "No Frozen Asset",
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
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${userLTCWallet.balance} LTC",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 19.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(
                  color: Theme.of(ctx).hintColor.withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }

  displayDogeWallet(BuildContext ctx, DogecoinWallet userDogeWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      new walletDetail(assetName: userDogeWallet.shortName)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: Image.network(
                          userDogeWallet.icon.toString(),
                          height: 25.0,
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
                            Text(
                              userDogeWallet.name,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              userDogeWallet.frozen == true
                                  ? "Froze: ${userDogeWallet.amount}"
                                  : "No Frozen Asset",
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
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${userDogeWallet.balance} DOGE",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 19.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(
                  color: Theme.of(ctx).hintColor.withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }

  displayDashWallet(BuildContext ctx, DashWallet userDashWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      new walletDetail(assetName: userDashWallet.shortName)));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 12.0),
                        child: Image.network(
                          userDashWallet.icon.toString(),
                          height: 25.0,
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
                            Text(
                              userDashWallet.name,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              userDashWallet.frozen == true
                                  ? "Froze: ${userDashWallet.amount}"
                                  : "No Frozen Asset",
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
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${userDashWallet.balance} DASH",
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          size: 19.0,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 20.0, top: 6.0),
            child: Container(
              width: double.infinity,
              height: 0.5,
              decoration: BoxDecoration(
                  color: Theme.of(ctx).hintColor.withOpacity(0.1)),
            ),
          )
        ],
      ),
    );
  }
}

class waveBody extends StatefulWidget {
  final Size size;
  final int xOffset;
  final int yOffset;
  final Color color;

  waveBody(
      {Key key, @required this.size, this.xOffset, this.yOffset, this.color})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _waveBodyState();
  }
}

class _waveBodyState extends State<waveBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));

    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset;
          i <= widget.size.width.toInt() + 2;
          i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) %
                        360 *
                        Vector.degrees2Radians) *
                    20 +
                50 +
                widget.yOffset));
      }
    });
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 185.0,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  tileMode: TileMode.repeated,
                  colors: [Color(0xFF15EDED), Color(0xFF029CF5)])),
          child: new Container(
            margin: EdgeInsets.only(top: 75.0),
            height: 20.0,
            child: new AnimatedBuilder(
              animation: new CurvedAnimation(
                parent: animationController,
                curve: Curves.easeInOut,
              ),
              builder: (context, child) => new ClipPath(
                child: widget.color == null
                    ? new Container(
                        width: widget.size.width,
                        height: widget.size.height,
                        color: Colors.white.withOpacity(0.25),
                      )
                    : new Container(
                        width: widget.size.width,
                        height: widget.size.height,
                        color: Colors.white.withOpacity(0.9),
                      ),
                clipper: new WaveClipper(animationController.value, animList1),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 180.0),
          height: 5.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: <Color>[
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.1),
                  Theme.of(context).scaffoldBackgroundColor
                ],
                stops: [
                  0.0,
                  1.0
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 1.0)),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 70.0),
          alignment: Alignment.topCenter,
          child: Column(children: <Widget>[
            Text(
              "Total Assets",
              style: TextStyle(fontFamily: "Popins", color: Colors.white),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              "0.0",
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "Popins",
                  fontSize: 30.0,
                  color: Colors.white),
            ),
          ]),
        )
      ],
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animation;

  List<Offset> waveList1 = [];

  WaveClipper(this.animation, this.waveList1);

  @override
  Path getClip(Size size) {
    Path path = new Path();

    path.addPolygon(waveList1, false);

    path.lineTo(size.width, size.height);
    path.lineTo(5.0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      animation != oldClipper.animation;
}
