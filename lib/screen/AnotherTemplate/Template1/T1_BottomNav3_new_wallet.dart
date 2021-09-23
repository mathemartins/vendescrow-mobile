import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/custom_trace.dart';
import 'package:crypto_v2/component/AccountLinkage/AccountLinkageModel.dart';
import 'package:crypto_v2/screen/setting/setting.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mono/flutter_mono.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class T1_new_wallet extends StatefulWidget {
  ThemeBloc themeBloc;

  T1_new_wallet({Key key, this.themeBloc}) : super(key: key);

  @override
  _T1_new_walletState createState() => _T1_new_walletState(themeBloc);
}

class _T1_new_walletState extends State<T1_new_wallet> {
  ThemeBloc themeBloc;
  _T1_new_walletState(this.themeBloc);
  bool theme = true;
  bool isAPICallProcess = false;
  bool loadCard = true;
  AccountLinkage _accountLinkage;
  APIService apiService = new APIService();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _accountLinkage = new AccountLinkage();
    fetchPageContent();
  }

  void fetchPageContent() async {
    var responseUserAccountLinkage = await apiService.get('connect-mono/');

    setState(() {
      _accountLinkage =
          AccountLinkage.fromJson(responseUserAccountLinkage['data'][0]);
      loadCard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loadCard
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              elevation: 0.0,
              brightness: Brightness.dark,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(
                'Link Your Bank Account',
                style: TextStyle(color: Theme.of(context).textSelectionColor),
              ),
              iconTheme: IconThemeData(color: Colors.white),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 90.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      child: Center(
                        child: Image.asset(
                          "assets/image/create_wallet.png",
                          height: 45.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      _accountLinkage.exchangeToken != null ? 'Connected' : 'Connect Bank Data',
                      style: TextStyle(
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w500,
                          fontSize: 17.0),
                    ),
                    Text(
                      _accountLinkage.exchangeToken != null ? 'Sync Code: ${_accountLinkage.exchangeToken}'
                          : 'Sync Code: Data Communication Not Connected!',
                      style: TextStyle(
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w300,
                          fontSize: 15.0,
                          color: Colors.white54),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    _card(
                        "assets/image/crypto_icon/icon_bitcoin.png",
                        _accountLinkage.bank != null ? _accountLinkage.bank.toString()
                            : "Tap to sync"
                    ),

                    _card(
                        "assets/image/crypto_icon/icon_bitcoin.png",
                        _accountLinkage.fullName != null  ?
                        _accountLinkage.fullName.toString() : ""
                    ),
                   _card(
                            "assets/image/crypto_icon/icon_bitcoin.png",
                            _accountLinkage.accountNumber != null ?
                            _accountLinkage.accountNumber.toString() : ""
                    ),
                    SizedBox(height: 40,),
                    _card(
                            "assets/image/crypto_icon/icon_elf.png",
                            _accountLinkage.accountType != null ?
                            "** All transactions should only be done from this account" : ""
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  ///
  /// Card for crypto list
  ///
  Widget _card(String img, title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: InkWell(
        onTap: () {
          _accountLinkage.exchangeToken != null
              ? scaffoldKey.currentState.showSnackBar(
                  SnackBar(content: Text("Account already synced!")))
              : loadMonoWidget();
        },
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Container(
                height: 50.0,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(70.0)),
                    color: Color(0xFF202840)),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 80.0),
                      child: Text(
                        title,
                        style: TextStyle(
                            fontFamily: "Sans",
                            letterSpacing: 1.2,
                            fontWeight: FontWeight.w300),
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        tileMode: TileMode.repeated,
                        colors: [Color(0xFF15EDED), Color(0xFF029CF5)]),
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  ),
                  child: Center(
                      child: Image.asset(
                    img,
                    color: Colors.white,
                    height: 20.0,
                    fit: BoxFit.cover,
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadMonoWidget() async {
    await MonoFlutter.launchMono(
      context,
      key:
          '${GlobalConfiguration().getValue('mono_public_key')}', // from https://app.withmono.com/apps
      onClosed: () {
        Navigator.pop(context);
        print('Widget closed');
      },
      onSuccess: (String code) {
        Navigator.pop(context);
        print("Linked successfully: $code");
        _accountLinkage.monoCode = code;

        APIService apiService = new APIService();
        apiService.linkAccount(_accountLinkage).then((value) {
          setState(() {
            isAPICallProcess = false;
          });

          if (value.exchangeToken.isNotEmpty) {
            final snackBar = SnackBar(
              content: Text(value.message.toString()),
            );
            addObjectToSharedPreference(value.exchangeToken);
            scaffoldKey.currentState.showSnackBar(snackBar);
            print(CustomTrace(StackTrace.current,
                message: "data-payload: $value"));
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                      new setting(themeBloc: themeBloc)),
            );
          } else {
            final snackBar = SnackBar(
              content: Text("Account Linking Failed!"),
            );
            scaffoldKey.currentState.showSnackBar(snackBar);
          }
        });
      },
    );
  }

  addObjectToSharedPreference(monoCode) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('exchange_token', monoCode);
  }

  AccountLinkage cast(value) {
    try {
      return (value as AccountLinkage);
    } on TypeError catch (e) {
      print(e);
      return null;
    }
  }
}
