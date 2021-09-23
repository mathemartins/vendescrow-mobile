import 'package:crypto_v2/component/User/LocalAuthBiometrics.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/screen/Bottom_Nav_Bar/bottom_nav_bar.dart';
import 'package:crypto_v2/screen/intro/login.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

import '../../progressHUD.dart';
import 'forget_password.dart';

class fingerprint extends StatefulWidget {
  ThemeBloc themeBloc;
  fingerprint({this.themeBloc});
  @override
  _fingerprintState createState() => _fingerprintState(themeBloc);
}

class _fingerprintState extends State<fingerprint> {
  ThemeBloc _themeBloc;
  _fingerprintState(this._themeBloc);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
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
    return SafeArea(
      child: Scaffold(
          key: scaffoldKey,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical:12.0, horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Text("Biometric Scan", style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'avenir', fontWeight: FontWeight.w700),),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 50.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset('assets/image/fingerprint.png', width: 120,),

                      SizedBox(height: 20.0,),

                      Text("Fingerprint Authentication", style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),),

                      SizedBox(height: 15.0,),

                      Container(
                        width: 300.0,
                        child: Text("Vendescrow Authentication Using Fingerprint", textAlign: TextAlign.center, style: TextStyle(
                          color: Colors.white, fontSize: 12
                        ),),
                      ),

                      SizedBox(height: 15.0,),

                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 0.0,
                          onPressed: () async {
                            final isAvailable = await LocalAuthApi.hasBiometrics();
                            final biometrics = await LocalAuthApi.getBiometrics();
                            final hasFingerprint = biometrics.contains(BiometricType.fingerprint);

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Supported Authentication Method', style: TextStyle(fontFamily: 'avenir', fontSize: 13),),
                                content: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    buildText('Biometrics', isAvailable),
                                    buildText('Fingerprint', hasFingerprint),
                                  ],
                                ),
                              ),
                            );
                          },
                          color: Color(0xFF45C2DA),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                            child: Text("Verify Device Compatibility", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'avenir'),),
                          ),
                        ),
                      ),


                      SizedBox(height: 15.0,),

                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 0.0,
                          onPressed: () async {
                            final isAuthenticated = await LocalAuthApi.authenticate();
                            if (isAuthenticated) {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(pageBuilder: (_, __, ___) => bottomNavBar(themeBloc: _themeBloc,),),
                              );
                            }  
                          },
                          color: Color(0xFF172E4D),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0)
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 24.0),
                            child: Text("Authenticate", style: TextStyle(color: Colors.white, fontSize: 13, fontFamily: 'avenir'),),
                          ),
                        ),
                      ),


                      SizedBox(height: 50.0,),

                      GestureDetector(
                        onTap: (){
                          Navigator.of(context).pushReplacement(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) => new login(themeBloc: _themeBloc,),
                            ),
                          );
                        },
                        child: Text("Use Traditional Authentication", style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.0,
                          fontFamily: 'avenir',
                        ),),
                      ),


                    ],
                  ),
                )
              ],
            ),
          )
      ),
    );
  }

  Widget buildText(String text, bool checked) => Container(
    margin: EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        checked ? Icon(Icons.check_circle, color: Colors.teal,) : Icon(Icons.close, color: Colors.red,),
        const SizedBox(width: 12,),
        Text(text, style: TextStyle(fontSize: 18, fontFamily: 'avenir'),)
      ],
    ),
  );
}