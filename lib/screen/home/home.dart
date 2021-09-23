import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Common/Common.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/HumanReadableNumbers.dart';
import 'package:crypto_v2/component/News/NewsModel.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/CoinModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/modelGridHome.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/T2_home.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template4/T4_wallet.dart';
import 'package:crypto_v2/screen/P2P/p2pHome.dart';
import 'package:crypto_v2/screen/home/Loser.dart';
import 'package:crypto_v2/screen/market/detailCrypto/btcDetail.dart';
import 'package:crypto_v2/screen/news/news_list_detail/news_list_detail.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'LiveCryptoAsset.dart';

class home extends StatefulWidget {
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  // static String url = '${GlobalConfiguration().getValue('websocket_base_url')}ws/coins/';
  // final WebSocketChannel channel = IOWebSocketChannel.connect(url);
  ThemeBloc _themeBloc;
  List<Coins> _coins = List<Coins>();
  List<News> _news = List<News>();
  APIService apiService = new APIService();
  BlackMarketRate _blackMarketRate = BlackMarketRate();

  String pin;
  String exchangeToken;
  TextEditingController inputValue = new TextEditingController();
  String inputValueNew;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();

  News news = new News();
  User user = new User();
  bool loadCard = true;


  @override
  void initState() {
    super.initState();
    apiService.getLiveCoinsData().then((value) {
      setState(() {
        _coins.addAll(value);
      });
    });

    //getDataFromWebsocket();
    fetchPageContent();
  }

  // void getDataFromWebsocket() async {
  //   channel.stream.listen((event) {
  //     final serializePayload = json.decode(event);
  //     final liveCoin = List<Coins>();
  //     for (var data in serializePayload) {
  //       liveCoin.add(Coins.fromJson(data));
  //     }
  //     setState(() {
  //       _coins = liveCoin.length > 0 ? liveCoin : [];
  //     });
  //   });
  // }


  void fetchPageContent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    pin = preferences.getString("pin");
    exchangeToken = preferences.getString("exchange_token");
    var responseFiatData = await apiService.get('fiat-rates/');

    apiService.getNewsData().then((value) {
      setState(() {
        _news.addAll(value);
        _blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
        loadCard = false;
      });
    });

  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /// Header image slider
            SizedBox(
              height: 210.0,
              width: double.infinity,
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400.0,
                  enableInfiniteScroll: true,
                  aspectRatio: 16 / 9,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  viewportFraction: 1.1,
                ),
                items: List<String>.generate(_news.length, (index) => _news[index].image.toString()).map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: colorStyle.blackBackground),
                        child: GestureDetector(
                          child: Image.network(i, fit: BoxFit.cover),
                          onTap: () {
                            Navigator.push<Widget>(context, MaterialPageRoute(
                                builder: (context) =>
                                    newsListDetail(imageUrl: i.toString()),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 10.0),

            /// Action buttons for system actions
            _displayActionButtons(context),

            SizedBox(height: 10.0),

            /// check the condition if image data from server firebase loaded or no
            /// if image loaded true (image still downloading from server)
            /// Card to set card loading animation

            loadCard
                ? _loadingCardAnimation(context)
                : _cardLoaded(context, _coins, _blackMarketRate),

            /// Tab bar custom
            Container(
              height: 700.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: new Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(53.0), // here the desired height
                          child: new AppBar(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            elevation: 0.0,
                            centerTitle: true,
                            flexibleSpace: SafeArea(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 100.0),
                                  child: new TabBar(
                                    indicatorColor: colorStyle.primaryColor,
                                    labelColor: Theme.of(context).primaryColor,
                                    unselectedLabelColor:Theme.of(context).textSelectionColor,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    tabs: [
                                      new Tab(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 4.0),
                                              child: Icon(IconData(0xe900, fontFamily: 'gainers'), size: 15.0,),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text("Live Tracker", style: TextStyle(fontFamily: "Sans"),),
                                            )
                                          ],
                                        ),
                                      ),
                                      new Tab(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Icon(IconData(61316, fontFamily: 'MaterialIcons'), size: 20.0,),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(left: 8.0),
                                              child: Text("Trades"),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            automaticallyImplyLeading: false,
                          ),
                        ),
                        body: Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: new TabBarView(
                            children: [
                              LiveCryptoAsset(),
                              loser(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

  // @override
  // void dispose() {
  //   channel.sink.close();
  //   super.dispose();
  // }

  Column serviceWidget(String img, String name, String routePath) {
    return Column(
      children: [
        Expanded(
            child: InkWell(
            onTap: () {
              if (routePath == "snackbar") {
                showSnackBar("Feature not available at the moment!");
              } else if (routePath == "repayLoan") {
                showDialog(
                    context: context,
                    builder: (_) => pin != null ? displayAlertDialogForPinAuth() : displayAlertDialogForInstructions()
                );
              } else {
                //Navigator.pushNamed(context, routePath);
                Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => T4_wallet()));
              }
            },
          child: Container(
            margin: EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xFFF1F3F6),
            ),
            child: Center(
              child: Container(
                margin: EdgeInsets.all(25),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/image/$img.png'))),
              ),
            ),
          ),
        )),
        SizedBox(
          height: 5,
        ),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'avenir',
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  void showSnackBar(String value) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value),
    ));
  }

  Widget _displayActionButtons(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      crossAxisSpacing: 4,
      childAspectRatio: 0.7,
      crossAxisCount: 4,
      primary: false,
      children: [
        serviceWidget("sendMoney", "Trade P2P", "repayLoan"),
        serviceWidget("receiveMoney", "Escrow Wallet", "/lockfundsPage"),
        serviceWidget("phone", "Stake Assets ", "snackbar"),
        serviceWidget("more", "Vendcoin", "snackbar"),
      ],
    );
  }

  displayAlertDialogForPinAuth() {
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        backgroundColor: Colors.black,
        content: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              right: -40.0,
              top: -40.0,
              child: InkResponse(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CircleAvatar(
                  child: Icon(Icons.close, color: Colors.white,),
                  backgroundColor: colorStyle.primaryColor,
                ),
              ),
            ),
            Form(
              key: globalFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Enter Pin",
                      style: TextStyle(
                        fontFamily: "avenir",
                        color: Colors.white,
                        fontSize: 13.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new TextFormField(
                      controller: inputValue,
                      keyboardType: TextInputType.number,
                      onSaved: (input) => inputValueNew = input,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Cannot submit empty pin field";
                        } else if (input != pin) {
                          return "Error! Invalid Pin";
                        } else if (exchangeToken.isEmpty) {
                          return "Error! You have not linked your account";
                        } else {
                          return null;
                        }
                      },
                      inputFormatters: [
                        new LengthLimitingTextInputFormatter(4),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: "Enter your pin to proceed",
                        labelStyle: TextStyle(
                          fontFamily: 'avenir',
                          fontWeight: FontWeight.bold,
                          color: colorStyle.primaryColor,
                        ),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        prefixIcon: Icon(Icons.lock, color: colorStyle.primaryColor),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      child: Text("Proceed"),
                      onPressed: () {
                        if (globalFormKey.currentState.validate()) {
                          globalFormKey.currentState.save();
                          gotoP2P();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        )
    );
  }

  displayAlertDialogForInstructions() {
    return CustomDialog(
      title: "To access P2P",
      description: "1. Set Authorization Code. \n\n 2. Sync Bank Account. \n\n 3. If device changed, re-do process again.",
    );
  }


  void gotoP2P() async {
    // print(pin); way to retrieve shared preference value
    // print(inputValue.text); way to retrieve form value
    // print(inputValueNew); way to retrieve form value
    if (pin.toString() == inputValue.text.toString()) {
      // reset form
      globalFormKey.currentState?.reset();

      // now proceed
      Navigator.of(context)
          .push(PageRouteBuilder(pageBuilder: (_, __, ___) => p2pHome(themeBloc: _themeBloc)));
    }
  }
}

class CustomDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  CustomDialog({this.title, this.description, this.buttonText, this.image});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        height: 400,
        child: dialogContent(context),
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
                child: FlatButton(onPressed: (){Navigator.pop(context);}, child: Text("I understand"),),
              )
            ],),
        ),
        Positioned(top: 0, left: 16, right: 16, child: CircleAvatar(backgroundColor: Colors.blue, radius: 50, backgroundImage: AssetImage('assets/image/fancynotify.gif', ),),)
      ],
    );
  }

}

class card extends StatelessWidget {
  Coins item;
  BlackMarketRate blackMarketRate;

  card(this.item, this.blackMarketRate);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
            pageBuilder: (_, __, ___) => new btcDetail(item: item),
          ));
        },
        child: Container(
          height: 70.0,
          width: _width / 2.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              color: Theme.of(context).canvasColor,
              boxShadow: [
                BoxShadow(
                    color: Color(0xFF656565).withOpacity(0.15),
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                    offset: Offset(0.1, 1.0))
              ]),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      item.name,
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontFamily: "Popins",
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "${getUserCurrency(blackMarketRate.country.toString())} ${k_m_b_generator(item.price, blackMarketRate.dollarRate)}",
                            //item.quote.uSD.price.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Gotik",
                                fontSize: 13.5),
                          ),
                          Text(
                            "${item.priceChangePercentageInTheLast24h.toStringAsFixed(2)}%",
                            style: TextStyle(
                                color: item.priceChangePercentageInTheLast24h < 0 ? Colors.redAccent : Colors.greenAccent),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 30.0,
                  child: new Sparkline(
                    data: generateRandomDecimals(),
                    lineWidth: 0.3,
                    fillMode: FillMode.below,
                    lineColor: item.state == 'fail' ? Colors.redAccent : Colors.greenAccent,
                    fillGradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.greenAccent.withOpacity(0.2),
                        Colors.greenAccent.withOpacity(0.01)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class cardLoading extends StatelessWidget {
  gridHome item;
  cardLoading(this.item);
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
      child: Container(
        height: 70.0,
        width: _width / 2.2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: Theme.of(context).canvasColor,
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF656565).withOpacity(0.15),
                  blurRadius: 1.0,
                  spreadRadius: 1.0,
                  offset: Offset(0.1, 1.0))
            ]),
        child: Shimmer.fromColors(
          baseColor: Color(0xFF3B4659),
          highlightColor: Color(0xFF606B78),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 12.0, left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      color: Theme.of(context).hintColor,
                      height: 20.0,
                      width: 70.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 17.0,
                            width: 70.0,
                          ),
                          Container(
                            color: Theme.of(context).hintColor,
                            height: 17.0,
                            width: 70.0,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 30.0,
                  child: new Sparkline(
                    data: item.data,
                    lineWidth: 0.3,
                    fillMode: FillMode.below,
                    lineColor: item.chartColor,
                    fillGradient: new LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: item.chartColorGradient,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Calling imageLoading animation for set a grid layout
Widget _loadingCardAnimation(BuildContext context) {
  return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 1.745,
      crossAxisCount: 2,
      primary: false,
      children: List.generate(
        listGridHome.length,
        (index) => cardLoading(listGridHome[index]),
      ));
}

/// Calling ImageLoaded animation for set a grid layout
Widget _cardLoaded(BuildContext context, liveCryptoData, blackMarketRate) {
  return liveCryptoData.length == 0 ? _loadingCardAnimation(context) : GridView.count(
    shrinkWrap: true,
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
    crossAxisSpacing: 12.0,
    mainAxisSpacing: 12.0,
    childAspectRatio: 1.745,
    crossAxisCount: 2,
    primary: false,
    children: List.generate(
        2, (index) => card(liveCryptoData[index], blackMarketRate)
    ),
  );
}
