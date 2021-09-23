import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/model_data/Lrm_dataModel.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template4/model_data/cardWallet_model.dart';
import 'package:flutter/material.dart';

class T4_wallet extends StatefulWidget {
  T4_wallet({Key key}) : super(key: key);

  _T4_walletState createState() => _T4_walletState();
}

class _T4_walletState extends State<T4_wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFBFBFD),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                        gradient: LinearGradient(
                            colors: [Theme.of(context).scaffoldBackgroundColor, Theme.of(context).backgroundColor])),
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
                Padding(padding: const EdgeInsets.only(top: 70.0, left: 20.0),
                  child: Row(
                    children: [
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
                        "My Escrow Wallet",
                        style: TextStyle(
                            fontSize: 18.0,
                            fontFamily: 'avenir',
                            fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),

            ///
            /// Credit card header slider
            ///
            CarouselSlider(
              options: CarouselOptions(
                  aspectRatio: 9 / 10,
                  autoPlay: true,
                  viewportFraction: 0.93,
                  height: 200.0,
              ),
              items: [0].map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 6.0, right: 6.0),
                      child: _cardHeader(),
                    );
                  },
                );
              }).toList(),
            ),

            ///
            /// List horizontal for card contact
            ///

            Padding(
              padding:const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Recent Transactions",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w700,
                        fontSize: 16.0),
                  ),
                  Text(
                    "Credit / Debit",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),

            ///
            /// Create card recent transaction
            ///
            _cardToday("assets/avatars/avatar-4.jpg", "Marisa Rene","12/03/2019", "-\$110", Colors.redAccent),
            SizedBox(
              height: 30.0,
            )
          ],
        ),
      ),
    );
  }

  ///
  /// Widget for card today
  ///
  Widget _cardToday(String image, String _title, String _subTitle, String _value, Color _textColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15.0),
      child: Container(
        height: 80.0,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Colors.black12.withOpacity(0.05),
              blurRadius: 10.0,
              spreadRadius: 3.0),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Container(
                    height: 45.0,
                    width: 45.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      image: DecorationImage(
                          image: AssetImage(image), fit: BoxFit.cover),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _title,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        _subTitle,
                        style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.w400,
                            fontSize: 13.0),
                      )
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Text(
                _value,
                style:
                    TextStyle(color: _textColor, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///
  /// Widget for create card contact
  ///
  Widget _cardContact(String image, String name) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 1.0, bottom: 10.0, top: 5.0),
      child: Container(
        width: 100.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(7.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12.withOpacity(0.05),
                blurRadius: 3.0,
                spreadRadius: 1.0),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 47.0,
                width: 47.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12.withOpacity(0.2),
                        blurRadius: 2.0,
                        spreadRadius: 1.0)
                  ],
                  image: DecorationImage(
                      image: AssetImage(image), fit: BoxFit.cover),
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  color: Colors.lightBlueAccent,
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(name,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Sans"))
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// Widget for create credit card
  ///
  Widget _cardHeader() {
    return Stack(
      children: <Widget>[
        Container(
          height: 220.0,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6496F4), Color(0xFF736AE6)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "GEETICO HQ",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "avenir",
                          fontSize: 14.0),
                    ),
                    Icon(Icons.add)
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "2055583745",
                      style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontFamily: "avenir",
                          fontSize: 18.0,),
                    ),
                    Text(
                      "ACCESS BANK",
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "avenir",
                          fontSize: 15.0),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "\$ 4.5",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18.0,
                            fontFamily: "avenir",
                          ),
                        ),
                        Text(
                          "NGN 2,259.09",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "avenir",
                              fontSize: 15.0),
                        )
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Text(
                          "Account Owner",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontFamily: "Sans",
                          ),
                        ),
                        Text(
                          "Martins Chigoziem",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: "avenir",
                              fontSize: 14.0),
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Container(
            height: 170.0,
            width: 170.0,
            decoration: BoxDecoration(
                color: Colors.white10.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(200.0),
                    topRight: Radius.circular(20.0))),
          ),
        ),
      ],
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
