import 'package:crypto_v2/screen/AnotherTemplate/Template1/T1_BottomNav1_wallet.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/T1_BottomNav1_wallet_completed.dart';
import 'package:flutter/material.dart';

import '../../../progressHUD.dart';

class T4_setting extends StatefulWidget {
  T4_setting({Key key}) : super(key: key);

  _T4_settingState createState() => _T4_settingState();
}

class _T4_settingState extends State<T4_setting> {
  bool isAPICallProcess = false;

  @override
  static var _txtCustomHead = TextStyle(
    color: Colors.black54,
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    fontFamily: "Gotik",
  );

  static var _txtCustomSub = TextStyle(
    color: Colors.black38,
    fontSize: 15.0,
    fontWeight: FontWeight.w500,
    fontFamily: "Gotik",
  );

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: _uiSetup(context), inAsyncCall: isAPICallProcess, opacity: 0.3,);
  }

  Widget _uiSetup(BuildContext context) {
    return Scaffold(
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
                Padding(padding: const EdgeInsets.only(top: 70.0, left: 20.0),
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
                    Text(
                      'Orders',
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w700),
                    )
                  ]),
                )
              ],
            ),

            ///
            /// Create list for category
            ///
            category(
              txt: "Trades",
              padding: 35.0,
              image: "assets/icon/Template4/notification.png",
              tap: () {
                Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => new T1_wallet()));
              },
            ),
            _line(),
            category(
              txt: "Transaction Records",
              padding: 35.0,
              image: "assets/icon/Template4/creditAcount.png",
              tap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    pageBuilder: (_, __, ___) => new T1_wallet_completed()));
              },
            ),
            Padding(padding: EdgeInsets.only(bottom: 20.0)),
          ],
        ),
      ),
    );
  }

  Widget _line() {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0, left: 85.0, right: 30.0),
      child: Divider(
        color: Colors.black12,
        height: 2.0,
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

/// Custom Font
var _txt = TextStyle(
  color: Colors.black,
  fontFamily: "Sans",
);

/// Get _txt and custom value of Variable for Category Text
var _txtCategory = _txt.copyWith(
    fontSize: 14.5, color: Colors.black54, fontWeight: FontWeight.w500);

/// Component category class to set list
class category extends StatelessWidget {
  @override
  String txt, image;
  GestureTapCallback tap;
  double padding;

  category({this.txt, this.image, this.tap, this.padding});

  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 30.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: padding),
                  child: Image.asset(
                    image,
                    height: 25.0,
                    color: Color(0xFFA665D1),
                  ),
                ),
                Text(
                  txt,
                  style: _txtCategory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
