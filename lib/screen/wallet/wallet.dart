import 'dart:math';

import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/helper.dart';
import 'package:crypto_v2/component/AssetsWallet/CryptoWalletModel.dart';
import 'package:crypto_v2/component/AssetsWallet/EthereumWallet.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:crypto_v2/screen/wallet/walletDetail.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math.dart' as Vector;

import '../../component/AssetsWallet/EthereumWallet.dart';
import '../../component/market/FiatBlackMarket.dart';
import 'OtherWalletDetail.dart';
import 'package:shimmer/shimmer.dart';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();

  APIService apiService = new APIService();
  EthereumWallet userCryptoETHWallet = EthereumWallet();
  CryptoWallet userCryptoBTCWallet = CryptoWallet();
  CryptoWallet userCryptoLTCWallet = CryptoWallet();
  CryptoWallet userCryptoDOGEWallet = CryptoWallet();
  BlackMarketRate blackMarketRate = BlackMarketRate();
  bool loadData = true;

  String _btcImageUrl ="https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/BTC_Logo.svg/1200px-BTC_Logo.svg.png";
  String _ltcImageUrl = "https://cryptologos.cc/logos/litecoin-ltc-logo.png";
  String _dogeImageUrl = "https://i.imgflip.com/4w3qc7.png";
  String _ethImageUrl = "https://cryptologos.cc/logos/ethereum-eth-logo.png";
  String _usdtImageUrl = "https://cryptologos.cc/logos/tether-usdt-logo.png";

  @override
  void initState() {
    super.initState();
    fetchPageData();
  }

  void fetchPageData() async {
    var responseUserCryptoBTCWallet =
        await apiService.get('wallet/return/btc/');
    var responseUserCryptoLTCWallet =
        await apiService.get('wallet/return/ltc/');
    var responseUserCryptoDOGEWallet =
        await apiService.get('wallet/return/doge/');
    var responseUserCryptoETHWallet = await apiService.get('wallet/');

    setState(() {
      userCryptoBTCWallet =
          CryptoWallet.fromJson(responseUserCryptoBTCWallet['data'][0]);
      userCryptoLTCWallet =
          CryptoWallet.fromJson(responseUserCryptoLTCWallet['data'][0]);
      userCryptoDOGEWallet =
          CryptoWallet.fromJson(responseUserCryptoDOGEWallet['data'][0]);
      userCryptoETHWallet =
          EthereumWallet.fromJson(responseUserCryptoETHWallet['data'][0]);
      loadData = false;
    });
  }

  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    Size size = new Size(MediaQuery.of(context).size.width, 200.0);
    return Scaffold(
      key: scaffoldKey,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 225.0),

            ///
            /// Create card list
            ///
            child: Container(
                child: loadData ? Shimmer.fromColors(
                  baseColor: Color(0xFF3B4659),
                  highlightColor: Color(0xFF606B78),
                  child: Column(
                      children: [
                        tapToCreateCryptoWallet(context, apiService, 'btc','Bitcoin', _btcImageUrl, userCryptoBTCWallet),

                        tapToCreateCryptoWallet(context, apiService, 'ltc','Litecoin', _ltcImageUrl, userCryptoLTCWallet),

                        tapToCreateCryptoWallet(context, apiService, 'doge','Dogecoin', _dogeImageUrl, userCryptoDOGEWallet),

                        tapToCreateEthCryptoWallet(context, apiService, 'eth','Ethereum', _ethImageUrl, userCryptoETHWallet),

                        tapToCreateEthCryptoWallet(context, apiService, 'usdt','Tether USD', _usdtImageUrl, userCryptoETHWallet),
                      ],
                  ),
                ) : Column(
                  children: [
                    userCryptoBTCWallet.shortNameBTC == null
                        ? tapToCreateCryptoWallet(context, apiService, 'btc','Bitcoin', _btcImageUrl, userCryptoBTCWallet)
                        : displayCryptoWallet(context, userCryptoBTCWallet),

                    userCryptoLTCWallet.shortNameLTC == null
                        ? tapToCreateCryptoWallet(context, apiService, 'ltc',
                        'Litecoin', _ltcImageUrl, userCryptoLTCWallet)
                        : displayCryptoWallet(context, userCryptoLTCWallet),

                    userCryptoDOGEWallet.shortNameDOGE == null
                        ? tapToCreateCryptoWallet(context, apiService, 'doge',
                        'Dogecoin', _dogeImageUrl, userCryptoDOGEWallet)
                        : displayCryptoWallet(context, userCryptoDOGEWallet),

                    userCryptoETHWallet.shortName == null
                        ? tapToCreateEthCryptoWallet(context, apiService, 'eth',
                        'Ethereum', _ethImageUrl, userCryptoETHWallet)
                        : displayEthWallet(context, userCryptoETHWallet),

                    userCryptoETHWallet.shortName == null
                        ? tapToCreateEthCryptoWallet(context, apiService, 'usdt',
                        'Tether USD', _usdtImageUrl, userCryptoETHWallet)
                        : displayTetherWallet(context, userCryptoETHWallet),
                  ],
                ),
            ),
          ),
          Column(
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  ///
                  /// Create wave header
                  ///
                  new waveBody(
                    size: size, xOffset: 0, yOffset: 0, color: Colors.red,
                  ),
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
                padding:
                    const EdgeInsets.only(left: 13.0, right: 13.0, top: 6.0),
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

  displayCryptoWallet(BuildContext ctx, CryptoWallet userCryptoWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(ctx).push(PageRouteBuilder(
                  pageBuilder: (_, __, ___) => new otherWalletDetail(
                      assetName: userCryptoWallet.shortName)));
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
                          userCryptoWallet.icon.toString(),
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
                              userCryptoWallet.name,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              userCryptoWallet.frozen == true
                                  ? "Froze: ${userCryptoWallet.amount}"
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
                          "${userCryptoWallet.balance} ${userCryptoWallet.shortName}",
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

  tapToCreateCryptoWallet(
      BuildContext context,
      APIService apiService,
      String asset,
      String assetFullName,
      String assetImageUrl,
      CryptoWallet userCryptoWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
            children: <Widget>[
              InkWell(
                onTap: () {
                  // api call to backend to fetch btc address
                  getWallet(asset, userCryptoWallet);

                  // Show snackbar for success or error message
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(content: Text('Wallet Created Successfully!')));

                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
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
                              assetImageUrl,
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
                                  assetFullName,
                                  style: TextStyle(
                                      fontFamily: "Popins", fontSize: 16.5),
                                ),
                                Text(
                                  "No Frozen Asset",
                                  style: TextStyle(
                                      fontFamily: "Popins",
                                      fontSize: 11.5,
                                      color: Theme.of(context).hintColor),
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
                              "Tap to create",
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
                      color: Theme.of(context).hintColor.withOpacity(0.1)),
                ),
              )
            ],
          ),
    );
  }

  void getWallet(String walletCurrency, CryptoWallet userCryptoWallet) async {
    if (walletCurrency == 'btc') {
      var responseUserCryptoWallet =
          await apiService.get('wallet/$walletCurrency/');
      print(responseUserCryptoWallet);
      setState(() {
        userCryptoWallet =
            CryptoWallet.fromJson(responseUserCryptoWallet['data'][0]);
        loadData = false;
      });
    } else if (walletCurrency == 'ltc') {
      var responseUserCryptoWallet =
          await apiService.get('wallet/$walletCurrency/');
      setState(() {
        userCryptoWallet =
            CryptoWallet.fromJson(responseUserCryptoWallet['data'][0]);
        loadData = false;
      });
    } else if (walletCurrency == 'doge') {
      var responseUserCryptoWallet =
          await apiService.get('wallet/$walletCurrency/');
      setState(() {
        userCryptoWallet =
            CryptoWallet.fromJson(responseUserCryptoWallet['data'][0]);
        loadData = false;
      });
    }
  }

  tapToCreateEthCryptoWallet(
      BuildContext context,
      APIService apiService,
      String asset,
      String assetFullName,
      String assetImageUrl,
      EthereumWallet userCryptoWallet) {
    return Padding(
      padding: const EdgeInsets.only(top: 7.0),
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              // Show snackbar for success or error message
              scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('We are creating your wallet automatically!')));
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
                          assetImageUrl,
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
                              assetFullName,
                              style: TextStyle(
                                  fontFamily: "Popins", fontSize: 16.5),
                            ),
                            Text(
                              "No Frozen Asset",
                              style: TextStyle(
                                  fontFamily: "Popins",
                                  fontSize: 11.5,
                                  color: Theme.of(context).hintColor),
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
                          "Tap to create",
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
                  color: Theme.of(context).hintColor.withOpacity(0.1)),
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


  waveBody({
    Key key, @required this.size, this.xOffset, this.yOffset, this.color
  })
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _waveBodyState();
  }
}

class _waveBodyState extends State<waveBody> with TickerProviderStateMixin {
  AnimationController animationController;
  List<Offset> animList1 = [];
  APIService apiService = new APIService();
  BlackMarketRate blackMarketRate = new BlackMarketRate();
  CryptoValueDetail cryptoBTCValueDetail = new CryptoValueDetail();
  CryptoValueDetail cryptoLTCValueDetail = new CryptoValueDetail();
  CryptoValueDetail cryptoDOGEValueDetail = new CryptoValueDetail();
  CryptoValueDetail cryptoETHValueDetail = new CryptoValueDetail();
  CryptoValueDetail cryptoUSDTValueDetail = new CryptoValueDetail();

  EthereumWallet userCryptoETHWallet = EthereumWallet();
  CryptoWallet userCryptoBTCWallet = CryptoWallet();
  CryptoWallet userCryptoLTCWallet = CryptoWallet();
  CryptoWallet userCryptoDOGEWallet = CryptoWallet();
  bool loadData = true;


  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(vsync: this, duration: new Duration(seconds: 2));
    animationController.addListener(() {
      animList1.clear();
      for (int i = -2 - widget.xOffset; i <= widget.size.width.toInt() + 2; i++) {
        animList1.add(new Offset(
            i.toDouble() + widget.xOffset,
            sin((animationController.value * 360 - i) % 360 * Vector.degrees2Radians) * 20 + 50 + widget.yOffset));
      }
    });
    animationController.repeat();
    fetchBottomPageData();
  }

  void fetchBottomPageData() async {
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseCryptoBTCValueDetail = await apiService.getCryptoValueDetail('btc');
    print(responseCryptoBTCValueDetail);
    var responseCryptoLTCValueDetail = await apiService.getCryptoValueDetail('ltc');
    var responseCryptoDOGEValueDetail = await apiService.getCryptoValueDetail('doge');
    var responseCryptoETHValueDetail = await apiService.getCryptoValueDetail('eth');
    var responseCryptoUSDTValueDetail = await apiService.getCryptoValueDetail('usdt');

    var responseUserCryptoBTCWallet = await apiService.get('wallet/return/btc/');
    var responseUserCryptoLTCWallet = await apiService.get('wallet/return/ltc/');
    var responseUserCryptoDOGEWallet = await apiService.get('wallet/return/doge/');
    var responseUserCryptoETHWallet = await apiService.get('wallet/');


    setState(() {
      blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      cryptoBTCValueDetail = CryptoValueDetail.fromJson(responseCryptoBTCValueDetail['data']['BTC']);
      cryptoLTCValueDetail = CryptoValueDetail.fromJson(responseCryptoLTCValueDetail['data']['LTC']);
      cryptoDOGEValueDetail = CryptoValueDetail.fromJson(responseCryptoDOGEValueDetail['data']['DOGE']);
      cryptoETHValueDetail = CryptoValueDetail.fromJson(responseCryptoETHValueDetail['data']['ETH']);
      cryptoUSDTValueDetail = CryptoValueDetail.fromJson(responseCryptoUSDTValueDetail['data']['USDT']);

      userCryptoBTCWallet = CryptoWallet.fromJson(responseUserCryptoBTCWallet['data'][0]);
      userCryptoLTCWallet = CryptoWallet.fromJson(responseUserCryptoLTCWallet['data'][0]);
      userCryptoDOGEWallet = CryptoWallet.fromJson(responseUserCryptoDOGEWallet['data'][0]);
      userCryptoETHWallet = EthereumWallet.fromJson(responseUserCryptoETHWallet['data'][0]);
      loadData = false;
    });
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
              loadData ? "0.00":getUserNetWorthInUserFiat(
                  userCryptoBTCWallet.balance, userCryptoLTCWallet.balance, userCryptoDOGEWallet.balance,
                  userCryptoETHWallet.balance, userCryptoETHWallet.tether.balance, blackMarketRate,
                  cryptoBTCValueDetail.quote.uSD.price, cryptoLTCValueDetail.quote.uSD.price,
                  cryptoDOGEValueDetail.quote.uSD.price, cryptoETHValueDetail.quote.uSD.price, cryptoUSDTValueDetail.quote.uSD.price
              ),
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: "Popins",
                  fontSize: 20.0,
                  color: Colors.white),
            ),
          ]),
        )
      ],
    );
  }

  String getUserNetWorthInUserFiat(
      String btcBalance, String ltcBalance, String dogeBalance, String ethBalance,
      String usdtBalance, BlackMarketRate blackMarketRate, btcDollarRate, ltcDollarRate,
      dogeDollarRate, ethDollarRate, usdtDollarRate
  ) {
    var btcBal = double.parse(btcBalance);
    double netValue = btcBal * btcDollarRate * blackMarketRate.dollarRate + double.parse(ltcBalance) * ltcDollarRate * blackMarketRate.dollarRate + double.parse(dogeBalance) * dogeDollarRate * blackMarketRate.dollarRate + double.parse(ethBalance) * ethDollarRate * blackMarketRate.dollarRate + double.parse(usdtBalance) * usdtDollarRate * blackMarketRate.dollarRate;
    String formattedValue = Helper.numberFormatter(netValue);
    return "${getUserCurrency(blackMarketRate.country)} $formattedValue";
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
