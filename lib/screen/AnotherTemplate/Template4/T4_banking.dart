import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/helper.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeModel.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeRetrieveTransactionModel.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeSettingsModel.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template4/setting_layout/T4_callCenter.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template4/setting_layout/T4_payment.dart';
import 'package:crypto_v2/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:crypto_v2/screen/P2P/p2pHome.dart';
import 'package:crypto_v2/screen/home/home.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../progressHUD.dart';

class T4_banking extends StatefulWidget {
  final String narration;
  final P2PTradeModel tradeInfo;
  final User user;
  final CryptoValueDetail cryptoValueDetail;
  final P2PTradeSettings p2pTradeSettings;
  final String transactionType;

  T4_banking({Key key, this.narration, this.tradeInfo, this.user, this.cryptoValueDetail, this.p2pTradeSettings, this.transactionType}) : super(key: key);

  _T4_bankingState createState() => _T4_bankingState();
}

class _T4_bankingState extends State<T4_banking> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  APIService apiService = new APIService();
  P2PTradeTransactionRetrieve _transactionRetrieve = new P2PTradeTransactionRetrieve();
  BlackMarketRate _blackMarketRate = new BlackMarketRate();
  bool loadData = true;
  bool isAPICallProcess = false;

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


  void fetchPageData(String tradeSlug, String transactionKey, String transactionType) async {
    var responseData = await apiService.get('p2p/$tradeSlug/$transactionKey/transaction/$transactionType/');
    var responseFiatData = await apiService.get('fiat-rates/');
    setState(() {
      _transactionRetrieve = P2PTradeTransactionRetrieve.fromJson(responseData['data'][0]);
      _blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: _uiSetup(context), inAsyncCall: isAPICallProcess, opacity: 0.3,);
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return loadData ? Center(child: CircularProgressIndicator()): Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFFBFBFD),
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
                    _triangle(20.0, 10.0,),
                    _triangle(110.0, 80.0,),
                    _triangle(60.0, 190.0,),
                    _triangle(40.0, 300.0,),
                    _triangle(130.0, 330.0,),
                    Padding(padding: const EdgeInsets.only(top:70.0,left: 20.0),

                      child: Row(
                        children: [
                          InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (_) => CustomCancelTradeDialog(
                                      title: "Cancel Trade",
                                      description: "I do not want to proceed with this trade!",
                                      tradeInfo: widget.tradeInfo,
                                      transactionKey: widget.narration,
                                    )
                                );
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                                size: 19.0,
                              )),
                          SizedBox(
                            width: 10.0,
                          ),
                          Text("Finalize Trade",style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.w700, fontFamily: 'avenir'),),
                        ],
                      ),
                    )
                ],
              ),

              ///
              /// Create card above appbar wave
              ///
               card("assets/image/Template_3/deals_layout/giveMenu.png","Transfer to ${_transactionRetrieve.accountName}", "${_transactionRetrieve.bank}", "${_transactionRetrieve.accountNumber}", "${_transactionRetrieve.accountNumber}"),
               card("assets/image/Template_3/deals_layout/moneyMenu.png","Amount", "", "${Helper.getFormattedFiat(_transactionRetrieve.fiatPaid, _blackMarketRate.country)}", "${_transactionRetrieve.fiatPaid}"),
               card("","${widget.narration}", "", "Tap to copy and use as transfer narration", "${widget.narration}"),

               SizedBox(height: 20,),

               Padding(
                 padding: const EdgeInsets.only(top: 30.0, left: 15.0, bottom: 10.0, right: 15.0),
                 child: GestureDetector(
                   onTap: () {
                     Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => T4_callCenter(
                       tradeInfo: widget.tradeInfo,
                       user: widget.user,
                       cryptoValueDetail: widget.cryptoValueDetail,
                       p2pTradeSettings: widget.p2pTradeSettings,
                       narration: widget.narration,
                       transactionInfo: _transactionRetrieve,
                       transactionType: widget.transactionType,
                     )));
                   },
                   child: Container(
                     height: 40.0,
                     width: double.infinity,
                     decoration: BoxDecoration(
                       borderRadius:
                       BorderRadius.all(Radius.circular(10.0)),
                       color: Theme.of(context).primaryColor,
                     ),
                     child: Center(
                       child: Text(
                         "I have transferred ${Helper.getFormattedFiat(_transactionRetrieve.fiatPaid, _blackMarketRate.country)} To ${widget.tradeInfo.tradeCreatorUsername}",
                         style: TextStyle(
                           color: Colors.white,
                           fontFamily: 'avenir',
                           fontWeight: FontWeight.w800,
                           fontSize: 15.0,
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
               Padding(
               padding: const EdgeInsets.only(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0),
               child: GestureDetector(
                 onTap: () {
                   showDialog(
                       context: context,
                       builder: (_) => CustomCancelTradeDialog(
                         title: "Cancel Trade",
                         description: "I do not want to proceed with this trade!",
                         tradeInfo: widget.tradeInfo,
                         transactionKey: widget.narration,
                       )
                   );
                 },
                 child: Container(
                   height: 40.0,
                   width: double.infinity,
                   decoration: BoxDecoration(
                     borderRadius:
                     BorderRadius.all(Radius.circular(10.0)),
                     color: Colors.red,
                   ),
                   child: Center(
                     child: Text(
                       "I did not transfer any money To ${widget.tradeInfo.tradeCreatorUsername}",
                       style: TextStyle(
                         color: Colors.white,
                         fontFamily: 'avenir',
                         fontWeight: FontWeight.w800,
                         fontSize: 15.0,
                       ),
                     ),
                   ),
                 ),
               ),
             ),
             //   Padding(
             //   padding: const EdgeInsets.only(top: 10.0, left: 15.0, bottom: 10.0, right: 15.0),
             //   child: GestureDetector(
             //     onTap: () async {
             //       // set order state to cancelled and release trade
             //       Map data = {"trade": "${widget.tradeInfo.slug}", "transactionKey": "${widget.narration}", "currency": getUserCurrency(_blackMarketRate.country), "actionType": 2};
             //       setState(() {
             //         isAPICallProcess = true;
             //       });
             //       APIService apiService = new APIService();
             //       apiService.post("p2p/create/transaction/", data).then((value) {
             //         setState(() {
             //           isAPICallProcess = false;
             //         });
             //         if (value['message'].toString().contains("Successfully")) {
             //           final snackBar = SnackBar(
             //             content: Text("Transaction Has Been Placed On Appeal Successfully! "),
             //           );
             //           scaffoldKey.currentState.showSnackBar(snackBar);
             //           //Navigator.of(context).push(new MaterialPageRoute(builder: (context) => p2pHome()));
             //         } else {
             //           showDialog(
             //               context: context,
             //               builder: (_) => CustomDialog(
             //                 title: "Trade Appeal",
             //                 description: "An error with trade appeal, please redo!",
             //               )
             //           );
             //         }
             //       });
             //     },
             //     child: Container(
             //       height: 40.0,
             //       width: double.infinity,
             //       decoration: BoxDecoration(
             //         borderRadius:
             //         BorderRadius.all(Radius.circular(10.0)),
             //         color: Colors.orangeAccent,
             //       ),
             //       child: Center(
             //         child: Text(
             //           "Transaction has taken too long, I want to appeal",
             //           style: TextStyle(
             //             color: Colors.white,
             //             fontFamily: 'avenir',
             //             fontWeight: FontWeight.w800,
             //             fontSize: 15.0,
             //           ),
             //         ),
             //       ),
             //     ),
             //   ),
             // ),
            
           ],
         ),
       ),
    );
  }

  ///
  /// Widget card category
  ///
  Widget card(String img, String title, String subTitle, String message, String copyData){
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        onTap: (){
          Clipboard.setData(ClipboardData(text: copyData));
        },
        child: Container(
          height: 80.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 10.0,color: Colors.black12.withOpacity(0.1),spreadRadius: 3.0),]
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
               Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: TextStyle(fontFamily: "avenir",color: Colors.black87,fontWeight: FontWeight.w700,fontSize: 14.0,),),
                    Text(subTitle, style: TextStyle(color: Colors.black54,fontFamily: "avenir",fontWeight: FontWeight.w600, fontSize: 14.0,),),
                    Text(message, style: TextStyle(color: Colors.black54,fontFamily: "avenir",fontWeight: FontWeight.w600, fontSize: 14.0,),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right:20.0),
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10.0),bottomRight: Radius.circular(10.0)),
                    image: DecorationImage(image: AssetImage(img),fit: BoxFit.fill)
                  ),
                 ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  ///
  /// Create triangle 
  ///
  Widget _triangle(double top,left){
   return Padding(
        padding:  EdgeInsets.only(top: top,left: left),
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
}

class CustomCancelTradeDialog extends StatelessWidget {
  ThemeBloc _themeBloc;
  final String title, description, buttonText;
  final Image image;
  final P2PTradeModel tradeInfo;
  final String transactionKey;

  CustomCancelTradeDialog({this.title, this.description, this.buttonText, this.image, this.tradeInfo, this.transactionKey});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          height: 400,
          child: dialogContent(context),
        ),
      ),
    );
  }

  dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 100, bottom: 16, left: 16, right: 16),
          margin: EdgeInsets.only(top: 16),
          decoration: BoxDecoration(
            color: Colors.black, shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(17),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10.0, offset: Offset(0.0, 10.0))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),),
              SizedBox(height: 14.0,),
              Text(description, style: TextStyle(fontSize: 15.0, fontFamily: 'avenir'),),
              SizedBox(height: 14.0,),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: () async {
                    // set order state to cancelled and release trade
                    Map data = {"trade": "${tradeInfo.slug}", "transactionKey": "$transactionKey", "actionType": 0};
                    APIService apiService = new APIService();
                    apiService.post("p2p/create/transaction/sell/", data).then((value) {
                      if (value['message'].toString().contains("Successfully")) {
                        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (context) => bottomNavBar(
                          themeBloc: _themeBloc,
                        ),), (route) => false);
                      } else {
                        showDialog(
                            context: context,
                            builder: (_) => CustomCancelTradeDialog(
                              title: "Cancel Trade",
                              description: "I do not intend to proceed with this trade!",
                              tradeInfo: tradeInfo,
                              transactionKey: transactionKey,
                            )
                        );
                      }
                    });
                  }, child: Text("Cancel Trade"),
                ),
              )
            ],),
        ),
        Positioned(top: 0, left: 16, right: 16, child: CircleAvatar(backgroundColor: Colors.blue, radius: 50, backgroundImage: AssetImage('assets/image/fancynotify.gif', ),),)
      ],
    );
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