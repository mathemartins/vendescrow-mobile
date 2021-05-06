import 'package:carousel_slider/carousel_slider.dart';
import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Common/Common.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/HumanReadableNumbers.dart';
import 'package:crypto_v2/component/News/NewsModel.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/LiveCrypto.dart';
import 'package:crypto_v2/component/modelGridHome.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/crypto_detail_card_homeScreen/DetailCryptoValue/cardDetailHome.dart';
import 'package:crypto_v2/screen/home/Loser.dart';
import 'package:crypto_v2/screen/news/news_list_detail/news_list_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:shimmer/shimmer.dart';

import 'LiveCryptoAsset.dart';

class home extends StatefulWidget {
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  List<LiveCrypto> _liveCrypto = List<LiveCrypto>();
  List<News> _news = List<News>();
  APIService apiService = new APIService();
  BlackMarketRate _blackMarketRate = BlackMarketRate();
  News news = new News();
  User user = new User();
  bool loadCard = true;

  @override
  @override
  void initState() {
    super.initState();
    apiService.getLiveCryptoData().then((value) {
      setState(() {
        _liveCrypto.addAll(value);
        apiService.getCurrentUser().then((value) => user = value);
      });
    });

    fetchPageContent();
  }

  void fetchPageContent() async {
    var responseFiatData = await apiService.get('fiat-rates/');
    apiService.getNewsData().then((value) {
      setState(() {
        _news.addAll(value);
        _blackMarketRate =
            BlackMarketRate.fromJson(responseFiatData['data'][0]);
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
                items: List<String>.generate(
                        _news.length, (index) => _news[index].image.toString())
                    .map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(color: Colors.amber),
                        child: GestureDetector(
                          child: Image.network(i, fit: BoxFit.cover),
                          onTap: () {
                            print(i);
                            Navigator.push<Widget>(
                              context,
                              MaterialPageRoute(
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
                : _cardLoaded(context, _liveCrypto, _blackMarketRate),

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
                          preferredSize:
                              Size.fromHeight(53.0), // here the desired height
                          child: new AppBar(
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            elevation: 0.0,
                            centerTitle: true,
                            flexibleSpace: SafeArea(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 100.0),
                                  child: new TabBar(
                                    indicatorColor: colorStyle.primaryColor,
                                    labelColor: Theme.of(context).primaryColor,
                                    unselectedLabelColor:
                                        Theme.of(context).textSelectionColor,
                                    indicatorSize: TabBarIndicatorSize.label,
                                    tabs: [
                                      new Tab(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0),
                                              child: Icon(
                                                IconData(0xe900,
                                                    fontFamily: 'gainers'),
                                                size: 15.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                "Live Tracker",
                                                style: TextStyle(
                                                    fontFamily: "Sans"),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      new Tab(
                                        child: Row(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Icon(
                                                IconData(61316,
                                                    fontFamily:
                                                        'MaterialIcons'),
                                                size: 20.0,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text("Send Fiat"),
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
                  builder: (_) => AlertDialog(
                        title: Text(
                          'Make Direct Bank Transfer Into The Account Below',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'avenir',
                          ),
                        ),
                        content: Text(
                          '1. 3002069181, AMJU, PREMATURE LIQUIDATION \n\n2. Send Screenshot Of Payment Slip or Proof Of Payment to \n\n3. loans@amjuuniquemfbng.com',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                            fontFamily: 'avenir',
                          ),
                        ),
                      ));
            } else {
              Navigator.pushNamed(context, routePath);
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
        serviceWidget("receiveMoney", "Wallet", "/lockfundsPage"),
        serviceWidget("phone", "Referrals", "/lockfunds-account-details"),
        serviceWidget("more", "VendToken", "snackbar"),
      ],
    );
  }
}

class card extends StatelessWidget {
  LiveCrypto item;
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
              pageBuilder: (_, __, ___) => new cardDetailHome(
                  //item: item,
                  )));
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
                            "${getUserCurrency(blackMarketRate.country.toString())} ${k_m_b_generator(item.quote.uSD.price, blackMarketRate.dollarRate)}",
                            //item.quote.uSD.price.toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Gotik",
                                fontSize: 13.5),
                          ),
                          Text(
                            "${item.quote.uSD.percentChange1h.toStringAsFixed(2)}%",
                            style: TextStyle(
                                color: item.quote.uSD.percentChange1h < 0
                                    ? Colors.redAccent
                                    : Colors.greenAccent),
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
                    lineColor: item.quote.uSD.percentChange24h < 0
                        ? Colors.redAccent
                        : Colors.greenAccent,
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
  return GridView.count(
    shrinkWrap: true,
    padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
    crossAxisSpacing: 12.0,
    mainAxisSpacing: 12.0,
    childAspectRatio: 1.745,
    crossAxisCount: 2,
    primary: false,
    children: List.generate(
        2, (index) => card(liveCryptoData[index], blackMarketRate)),
  );
}
