import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/custom_trace.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:crypto_v2/screen/intro/login.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../progressHUD.dart';

class signUp extends StatefulWidget {
  ThemeBloc themeBloc;
  signUp({this.themeBloc});
  @override
  _signUpState createState() => _signUpState(themeBloc);
}

class _signUpState extends State<signUp> {
  ThemeBloc _themeBloc;
  _signUpState(this._themeBloc);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  FirebaseMessaging _firebaseMessaging;
  bool hidePassword = true;
  User _user;
  bool isAPICallProcess = false;

  @override
  void initState() {
    super.initState();
    _user = new User();
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
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        height: double.infinity,
        width: double.infinity,

        /// Set Background image in splash screen layout (Click to open code)
        decoration: BoxDecoration(color: colorStyle.background),
        child: Stack(
          children: <Widget>[
            ///
            /// Set image in top
            ///
            Container(
              height: 129.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/signupHeader.png"),
                      fit: BoxFit.cover)),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Form(
                  key: globalFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      /// Animation text marketplace to choose Login with Hero Animation (Click to open code)
                      Padding(
                        padding: EdgeInsets.only(
                            top: mediaQuery.padding.top + 100.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image.asset("assets/image/logo.png", height: 35.0),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 17.0, top: 7.0),
                              child: Text(
                                "VendEscrow",
                                style: TextStyle(
                                  fontFamily: "avenir",
                                  color: Colors.white,
                                  fontSize: 27.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.name,
                          onSaved: (input) => _user.username = input,
                          validator: (input) => input.isEmpty
                              ? "150 characters or fewer. Letters, digits and @/./+/-/_ only."
                              : null,
                          decoration: InputDecoration(
                              labelText: "Username",
                              labelStyle: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.bold,
                                color: colorStyle.primaryColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              prefixIcon: Icon(Icons.tag,
                                  color: colorStyle.primaryColor)),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.name,
                          onSaved: (input) => _user.firstName = input,
                          validator: (input) => input.isEmpty
                              ? "Field Cannot Be Empty, Required!"
                              : null,
                          decoration: InputDecoration(
                              labelText: "FirstName",
                              labelStyle: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.bold,
                                color: colorStyle.primaryColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              prefixIcon: Icon(
                                Icons.person,
                                color: colorStyle.primaryColor,
                              )),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.name,
                          onSaved: (input) => _user.lastName = input,
                          validator: (input) => input.isEmpty
                              ? "Field Cannot Be Empty, Required!"
                              : null,
                          decoration: InputDecoration(
                              labelText: "LastName",
                              labelStyle: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.bold,
                                color: colorStyle.primaryColor,
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              prefixIcon: Icon(
                                Icons.person,
                                color: colorStyle.primaryColor,
                              )),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onSaved: (input) => _user.email = input,
                          validator: (input) => !input.contains("@")
                              ? "Email Address Must Be Valid"
                              : null,
                          decoration: InputDecoration(
                              labelText: "Email Address",
                              labelStyle: TextStyle(
                                  fontFamily: 'avenir',
                                  fontWeight: FontWeight.bold,
                                  color: colorStyle.primaryColor),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              prefixIcon: Icon(
                                Icons.email,
                                color: colorStyle.primaryColor,
                              )),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.phone,
                          onSaved: (input) => _user.phoneNumber = input,
                          validator: (input) => !input.contains("+")
                              ? "Mobile Number Must Start With Country Code"
                              : null,
                          decoration: InputDecoration(
                              labelText: "Phone (+14XXXXXXXXX)",
                              labelStyle: TextStyle(
                                  fontFamily: 'avenir',
                                  fontWeight: FontWeight.bold,
                                  color: colorStyle.primaryColor),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: colorStyle.primaryColor,
                              )),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          onSaved: (input) => _user.password = input,
                          validator: (input) => input.length < 6
                              ? "Password Should Be Six(6) Characters and Cannot be similar to username"
                              : null,
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.bold,
                                color: colorStyle.primaryColor),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
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
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          obscureText: hidePassword,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 15.0),
                        child: new TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          onSaved: (input) => _user.password2 = input,
                          validator: (input) => input.length < 6
                              ? "Password Should Be Six(6) Characters and Cannot be similar to username"
                              : null,
                          decoration: InputDecoration(
                            labelText: "Confirm Password",
                            labelStyle: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.bold,
                                color: colorStyle.primaryColor),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            prefixIcon: Icon(
                              Icons.vpn_key,
                              color: colorStyle.primaryColor,
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  hidePassword = !hidePassword;
                                });
                              },
                              color: colorStyle.primaryColor.withOpacity(0.4),
                              icon: Icon(hidePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                            ),
                          ),
                          obscureText: hidePassword,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            if (validateAndSave()) {
                              print(_user.toJson());
                              registerAction();
                            }
                            Navigator.of(context).pushReplacement(
                              PageRouteBuilder(
                                pageBuilder: (_, __, ___) => bottomNavBar(
                                  themeBloc: _themeBloc,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 40.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              color: colorStyle.primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                "Register",
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
                        padding: const EdgeInsets.only(right: 23.0, top: 9.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) => new login(
                                    themeBloc: _themeBloc,
                                  ),
                                ),
                              );
                            },
                            child: Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Already A Member, Login!",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12.0,
                                  ),
                                ))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
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

  addObjectToSharedPreference(jwtToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('token', jwtToken);
  }

  void registerAction() async {
    setState(() {
      isAPICallProcess = true;
    });

    APIService apiService = new APIService();
    apiService.register(_user).then((value) {
      setState(() {
        isAPICallProcess = false;
      });

      if (value.token.isNotEmpty) {
        final snackBar = SnackBar(
          content: Text(value.message.toString()),
        );
        addObjectToSharedPreference(value.token);
        scaffoldKey.currentState.showSnackBar(snackBar);
        print(CustomTrace(StackTrace.current, message: "data-payload: $value"));
      } else {
        final snackBar = SnackBar(
          content: Text("Account Registration Error!"),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }
    });
  }
}
