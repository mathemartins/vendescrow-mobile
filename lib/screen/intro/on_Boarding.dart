import 'package:crypto_v2/Library/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:crypto_v2/Library/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/intro/login.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';

class onBoarding extends StatefulWidget {
  ThemeBloc themeBloc;
  onBoarding({this.themeBloc});
  @override
  _onBoardingState createState() => _onBoardingState(themeBloc);
}

///
/// Page View Model for on boarding
///
final pages = [
  new PageViewModel(
      pageColor: colorStyle.background,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Peer To Peer Trade',
        style: txtStyle.headerStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
          'Liquidate crypto asset \nwith any and everybody all over the world instantly',
          textAlign: TextAlign.center,
          style: txtStyle.descriptionStyle,
        ),
      ),
      mainImage: Image.asset(
        'assets/ilustration/boarding1.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  new PageViewModel(
      pageColor: colorStyle.background,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Rising Tokens & Crypto Assets',
        style: txtStyle.headerStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
          'Instant Notifications to new \ntokens, rising assets and crypto trends for DeFi investments',
          textAlign: TextAlign.center,
          style: txtStyle.descriptionStyle,
        ),
      ),
      mainImage: Image.asset(
        'assets/ilustration/boarding2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  new PageViewModel(
      pageColor: colorStyle.background,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Live Crypto Tracker',
        style: txtStyle.headerStyle,
      ),
      body: Container(
        height: 250.0,
        child: Text(
          'Get realtime updates and live \nchanges to your crypto assets and their change history. make smarter decisions',
          textAlign: TextAlign.center,
          style: txtStyle.descriptionStyle,
        ),
      ),
      mainImage: Image.asset(
        'assets/ilustration/boarding3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
];

class _onBoardingState extends State<onBoarding> {
  ThemeBloc _themeBloc;
  _onBoardingState(this._themeBloc);
  @override
  Widget build(BuildContext context) {
    return IntroViewsFlutter(
      pages,
      pageButtonsColor: Colors.black45,
      skipText: Text(
        "SKIP",
        style: txtStyle.descriptionStyle.copyWith(
            color: Color(0xFF45C2DA),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0),
      ),
      doneText: Text(
        "DONE",
        style: txtStyle.descriptionStyle.copyWith(
            color: Color(0xFF45C2DA),
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0),
      ),
      onTapDoneButton: () {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new login(themeBloc: _themeBloc)));
      },
    );
  }
}
