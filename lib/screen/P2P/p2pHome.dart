import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/AccountLinkage/AccountLinkageModel.dart';
import 'package:crypto_v2/component/AuthorizationLock/AuthLock.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/T1_BottomNav2_chat.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/T1_BottomNav3_new_wallet.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/T1_bottomNavBar.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/T1_wallet_detail.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/T2_home.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/T2_home_sell.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template4/T4_setting.dart';
import 'package:crypto_v2/screen/P2P/p2pPostAd.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';

class p2pHome extends StatefulWidget {
  /// Get data bloc from
  ThemeBloc themeBloc;

  p2pHome({Key key, this.themeBloc}) : super(key: key);

  _p2pHomeState createState() => _p2pHomeState(themeBloc);
}

class _p2pHomeState extends State<p2pHome> {
  ///
  /// Bloc for double theme
  ///
  ThemeBloc themeBloc;
  _p2pHomeState(this.themeBloc);
  bool theme = true;
  User user = new User();
  UserLock userLock = new UserLock();
  APIService apiService = new APIService();
  bool loadCard = true;


  @override
  void initState() {
    super.initState();
    fetchPageContent();
  }

  void fetchPageContent() async {
    var responseCurrentUser = await apiService.get('accounts/retrieve/');
    var responseUserLock = await apiService.get('auth/user-lock/');

    setState(() {
      user = User.fromJson(responseCurrentUser['data'][0]);
      userLock = UserLock.fromJson(responseUserLock['data'][0]);
      loadCard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'P2P Trade Asset',
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            listSettingP2P("I want to buy", 'Buy Asset', new T2_home(transactionType: 'buy')),
            SizedBox(height: 10.0,),
            listSettingP2P("I want to sell", "Sell Asset", new T2_home_sell(transactionType: 'sell')),
            SizedBox(height: 10.0,),
            listSettingP2P("All orders, paid, unpaid, completed, cancelled", "Orders", new T4_setting()),
            SizedBox(height: 10.0,),
            listSettingP2P("Post an order to sell an asset or how much you intend to buy an asset", "Post An Order (BUY / SELL)", new postAds()),
          ],
        ),
      ),
    );
  }

  Widget listSettingP2P(String header, String title, classInstance) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .push(PageRouteBuilder(pageBuilder: (_, __, ___) => classInstance));
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              header,
              style: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontFamily: "Popins",
                  fontSize: 13.0),
            ),
            SizedBox(
              height: 9.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 13.0,
                      fontFamily: "Popins",
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w300),
                ),
                Icon(Icons.keyboard_arrow_right)
              ],
            ),
            line()
          ],
        ),
      ),
    );
  }

  Widget line() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        width: double.infinity,
        height: 0.5,
        decoration: BoxDecoration(color: Theme.of(context).hintColor),
      ),
    );
  }

}
