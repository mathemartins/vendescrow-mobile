import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/AccountLinkage/AccountLinkageModel.dart';
import 'package:crypto_v2/component/P2PTrade/MyP2PTransactions.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeModel.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class T1_profile extends StatefulWidget {
  ///
  /// Get data bloc from
  ///
  ThemeBloc themeBloc;

  T1_profile({Key key, this.themeBloc}) : super(key: key);
  @override
  _T1_profileState createState() => _T1_profileState(themeBloc);
}

class _T1_profileState extends State<T1_profile> {
  ThemeBloc themeBloc;
  _T1_profileState(this.themeBloc);
  bool theme = true;

  User user = new User();
  AccountLinkage _accountLinkage;
  APIService apiService = new APIService();
  List<P2PTradeModel> p2pTradeModelList = new List <P2PTradeModel>();
  List<MyTransactions> p2pTradeCompleted = new List <MyTransactions>();
  int transactions;
  bool loadCard = true;

  @override
  void initState() {
    super.initState();
    _accountLinkage = new AccountLinkage();
    
    apiService.getTradeList().then((value) {
      transactions = 0;
      setState(() {
        p2pTradeModelList.addAll(value.toList());
        for (var figure in p2pTradeModelList) {
          transactions += figure.transactions;
        }
      });
    });

    apiService.getP2PTransactionListPerUser().then((value) {
      setState(() {
        p2pTradeCompleted.addAll(value.where((element) => element.status == 'COMPLETED').toList());
        print(p2pTradeCompleted.length);
      });
    });

    fetchPageContent();
  }

  void fetchPageContent() async {
    var responseCurrentUser = await apiService.get('accounts/retrieve/');
    var responseAccountLinkage = await apiService.get('connect-mono/');

    setState(() {
      user = User.fromJson(responseCurrentUser['data'][0]);
      _accountLinkage = AccountLinkage.fromJson(responseAccountLinkage['data'][0]);
      loadCard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          user.username == null
              ? '...'
              : user.username.toString().toUpperCase(),
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).hintColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 40.0),

              ///
              /// Photo profile with name and sice join
              ///
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        image: DecorationImage(
                            image: AssetImage("assets/avatars/user.png"),
                            fit: BoxFit.cover)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          user.username == null
                              ? '...'
                              : '${user.firstName.toUpperCase()} ${user.lastName.toUpperCase()}',
                          style: TextStyle(
                              fontFamily: "Popins",
                              fontWeight: FontWeight.w700,
                              fontSize: 17.0,
                              color: Colors.white),
                        ),
                        Text(
                          user.username == null ? '...' : "${user.phoneNumber}",
                          style: TextStyle(
                              fontFamily: "Sans",
                              fontWeight: FontWeight.w300,
                              color: Colors.white54),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),

            ///
            /// Card with horizontal scroll
            ///
            Container(
              height: 140.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _card(
                      "assets/image/market/ae.png",
                      "Country",
                      user.username == null
                          ? '...'
                          : "${user.country.toUpperCase()}"),
                  _card(
                      "assets/image/market/NEO.png",
                      "User Code",
                      user.username == null
                          ? '...'
                          : "${user.keycode.toUpperCase()}"),
                  _card(
                      "assets/image/market/NEO.png",
                      "B.V.N",
                      _accountLinkage.exchangeToken == null
                          ? '...'
                          : "${_accountLinkage.bvn}"),
                  _card(
                      "assets/image/market/NEO.png",
                      "Operating Currency",
                      _accountLinkage.exchangeToken == null
                          ? '...'
                          : "${_accountLinkage.currency.toUpperCase()}"),
                ],
              ),
            ),

            ///
            /// Text about me and description
            ///
            Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Email Address",
                    style: TextStyle(
                        fontFamily: "Sans", fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    user.username == null ? '...' : '${user.email}',
                    style: TextStyle(
                        fontFamily: "Popins",
                        fontWeight: FontWeight.w100,
                        color: Colors.white24),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),

            ///
            /// Circle Percent Indicator
            ///
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text("Trades"),
                      SizedBox(
                        height: 15.0,
                      ),
                      new CircularPercentIndicator(
                        radius: 60,
                        lineWidth: 2.0,
                        animation: true,
                        percent: 0.1,
                        center: new Text(
                          "${p2pTradeModelList.length}",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.lightBlueAccent,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("Transactions"),
                      SizedBox(
                        height: 15.0,
                      ),
                      new CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 2.0,
                        animation: true,
                        percent: 0.1,
                        center: new Text(
                          "$transactions",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.green,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Text("Completed"),
                      SizedBox(
                        height: 15.0,
                      ),
                      new CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 2.0,
                        animation: true,
                        percent: 0.1,
                        center: new Text(
                          "${p2pTradeCompleted.length}",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 13.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.purple,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///
  /// card for crypto list
  ///
  Widget _card(String _img, String _title, String _deskripsi) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 10.0,
        width: 180.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          color: Color(0xFF2E2E46),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 19.0, top: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(_img))),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    _title,
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontFamily: "Sans",
                        color: Colors.white),
                  ),
                  Text(
                    _deskripsi,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 17.0),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
