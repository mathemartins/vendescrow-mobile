import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/component/AssetsWallet/EthereumGasFee.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeModel.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeRetrieveTransactionModel.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeSettingsModel.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template4/setting_layout/T4_chatItem.dart';
import 'package:flutter/material.dart';

class T4_callCenter extends StatefulWidget {
  final String narration;
  final P2PTradeModel tradeInfo;
  final User user;
  final CryptoValueDetail cryptoValueDetail;
  final P2PTradeSettings p2pTradeSettings;
  final P2PTradeTransactionRetrieve transactionInfo;
  final String transactionType;

  T4_callCenter({
    Key key, this.narration, this.tradeInfo, this.user, this.cryptoValueDetail,
    this.p2pTradeSettings, this.transactionInfo, this.transactionType}) : super(key: key);

  _T4_callCenterState createState() => _T4_callCenterState();
}

class _T4_callCenterState extends State<T4_callCenter> {
  EthereumNetworkFee ethereumNetworkFee = new EthereumNetworkFee();
  BlackMarketRate blackMarketRate = BlackMarketRate();
  String currency;
  APIService apiService = new APIService();

  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    fontFamily: "avenir",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    fontFamily: "avenir",
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPageData(widget.tradeInfo.slug, widget.narration, widget.transactionType);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                ///
                /// Create wave appbar
                ///
                ClipPath(
                  child: Container(
                    height: 160.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [Theme.of(context).scaffoldBackgroundColor, Theme.of(context).backgroundColor])
                    ),
                  ),
                  clipper: BottomWaveClipper(),
                ),

                ///
                /// Get triangle widget
                ///
                _triangle(
                  20.0,
                  10.0,
                ),
                _triangle(
                  110.0,
                  80.0,
                ),
                _triangle(
                  60.0,
                  190.0,
                ),
                _triangle(
                  40.0,
                  300.0,
                ),
                _triangle(
                  130.0,
                  330.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 70.0, left: 20.0),
                  child: Row(children: <Widget>[
                    InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                          size: 19.0,
                        )),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text("Validating Transfer Transaction",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w700, fontFamily: 'avenir'),),
                  ]),
                )
              ],
            ),
            SizedBox(
              height: 80.0,
            ),
            Image.asset(
              "assets/image/search.gif",
              height: 175.0,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 14.0),
              child: Text(
                "Checking..",
                style: _txtCustomHead,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, right: 20.0, left: 20.0),
              child: Text(
                "Validating transaction.. \nCould take up to 1 min 59 sec",
                style: _txtCustomSub,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => T4_chatItem()));
                },
                child: Center(
                  child: Container(
                    height: 50.0,
                    width: 280.0,
                    decoration: BoxDecoration(
                        color: colorStyle.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(25.0))),
                    child: Center(
                        child: Text(
                      "Waited too long, I want to appeal",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 13.0),
                    )),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  /// Create triangle
  ///
  Widget _triangle(double top, left) {
    return Padding(
      padding: EdgeInsets.only(top: top, left: left),
      child: ClipPath(
        child: Container(
          height: 40.0,
          width: 40.0,
          color: Colors.white12.withOpacity(0.09),
        ),
        clipper: TriangleClipper(),
      ),
    );
  }

  void fetchPageData(String slug, String narration, String transactionType) async {
    var responseEthGasFee = await apiService.getEthGasFee();
    var responseFiatData = await apiService.get('fiat-rates/');


    setState(() {
      ethereumNetworkFee = EthereumNetworkFee.fromJson(responseEthGasFee);
      blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      currency = getUserCurrency(blackMarketRate.country);

      Future.delayed(const Duration(milliseconds: 120000), () {
        // Send credentials to backend server after 3mins
        Map payload  = {
          "actionType": 3, "trade": widget.tradeInfo.slug,
          "asset": widget.tradeInfo.assetToTrade,
          "transactionKey": widget.transactionInfo.transactionKey,
          "networkFee": ethereumNetworkFee.fast,
          "currency": currency,
          "cryptoUnits": widget.transactionInfo.unitsOfAsset,
        };
        print(payload);
        apiService.post("p2p/create/transaction/$transactionType/", payload).then((value) {
          if (value['message'].toString().contains("successful")) {

            // load a bottom sheet fragment and completed transaction
            setState(() {
              // Here you can write your code for bottom sheet new view
              showModalBottomSheet(context: context, builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text(
                        "Transaction Successful! \nTransfer Completed!",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),

                  ],
                );
              });
            });
          } else {
            // load bottom sheet fragment for not found and retry check in 20 mins
            setState(() {
              // Here you can write your code for bottom sheet new view
              showModalBottomSheet(context: context, builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Text(
                        "Transaction Error! \nTransfer transaction has not reflected!...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),

                  ],
                );
              });
            });
          }
        }).onError((error, stackTrace) {
          showModalBottomSheet(context: context, builder: (context) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 14.0),
                  child: Text(
                    "Oops! Transfer was not verified due to ${error.toString()}",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),

              ],
            );
          });
        });
      });
    });
  }
}

///
/// Create wave appbar
///
class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint =
        Offset(size.width - (size.width / 3.25), size.height - 65);
    var secondEndPoint = Offset(size.width, size.height - 40);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

///
/// Create triangle clipper
///
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(TriangleClipper oldClipper) => false;
}
