import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/custom_trace.dart';
import 'package:crypto_v2/component/AuthorizationLock/AuthLock.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/setting/setting.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../progressHUD.dart';

class T1_wallet_detail extends StatefulWidget {
  ///
  /// Get data bloc from
  ///
  ThemeBloc themeBloc;

  T1_wallet_detail({Key key, this.themeBloc}) : super(key: key);

  @override
  _T1_wallet_detailState createState() => _T1_wallet_detailState(themeBloc);
}

class _T1_wallet_detailState extends State<T1_wallet_detail> {
  ThemeBloc themeBloc;
  _T1_wallet_detailState(this.themeBloc);
  bool theme = true;

  UserLock userLock = new UserLock();
  User user = new User();
  APIService apiService = new APIService();
  bool loadCard = true;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  bool hidePassword = true;
  bool isAPICallProcess = false;

  @override
  void initState() {
    super.initState();
    fetchPageContent();
  }

  void fetchPageContent() async {
    var responseCurrentUser = await apiService.get('accounts/retrieve/');
    print(responseCurrentUser);

    setState(() {
      user = User.fromJson(responseCurrentUser['data'][0]);
      loadCard = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isAPICallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,

      ///
      /// Appbar
      ///
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Activate Authorization Pin',
          style: TextStyle(color: Theme.of(context).textSelectionColor),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      ///
      /// Body
      ///
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding:
                  const EdgeInsets.only(top: 10.0, left: 20.0, right: 10.0),

              ///
              /// Header image with title
              ///
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/image/create_wallet.png",
                        height: 30.0,
                        width: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Set Pin ",
                              style: TextStyle(
                                  fontFamily: "Popins",
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 1.5,
                                  fontSize: 17.0),
                            ),
                            Text(
                              "Authorization Pin For Transactions",
                              style: TextStyle(
                                  fontFamily: "Sans",
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 1.5,
                                  fontSize: 13.0,
                                  color: Colors.white24),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ///
            /// text editing
            ///

            _line(),
            Form(
                key: globalFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _textEditing("Enter 4 Digit Pin"),

                    ///
                    /// Button in bottom
                    ///
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 40.0),
                      child: GestureDetector(
                        onTap: () {
                          if (validateAndSave()) {
                            print(userLock.toJson());
                            activateAuthPin();
                          }
                        },
                        child: Container(
                          height: 50.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF15EDED),
                                    Color(0xFF029CF5),
                                  ])),
                          child: Center(
                            child: Text(
                              "Submit",
                              style:
                                  TextStyle(fontSize: 18.5, letterSpacing: 1.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Container(
        height: 1.0,
        width: double.infinity,
        color: Colors.white10,
      ),
    );
  }

  ///
  ///  TextEditing widget
  ///
  Widget _textEditing(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Container(
        height: 57.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50.0)),
            border: Border.all(color: Colors.white24)),
        child: Theme(
          data: ThemeData(hintColor: Colors.transparent),
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, bottom: 0.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              onSaved: (input) => userLock.pin = input,
              validator: (input) => input.isEmpty ? "Pin Must Be A 4 Digit" : null,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: title,
                labelStyle: TextStyle(color: Colors.white24, fontSize: 15.0),
                prefixIcon: Icon(
                  Icons.lock,
                  color: colorStyle.primaryColor,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                  color: colorStyle.primaryColor.withOpacity(0.4),
                  icon: Icon(
                      hidePassword ? Icons.visibility_off : Icons.visibility),
                ),
              ),
              obscureText: hidePassword,
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  addObjectToSharedPreference(pin) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('pin', pin);
  }

  void activateAuthPin() {
    setState(() {
      isAPICallProcess = true;
    });

    APIService apiService = new APIService();
    apiService.post('auth/user-lock/', {'pin': userLock.pin}).then((value) {
      setState(() {
        isAPICallProcess = false;
      });

      final snackBar = SnackBar(content: Text('Authorization Pin Activated!'));
      addObjectToSharedPreference(userLock.pin);
      scaffoldKey.currentState.showSnackBar(snackBar);
      print(CustomTrace(StackTrace.current, message: "data-payload: $value"));
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => new setting(themeBloc: themeBloc),
        ),
      );
    });
  }
}
