import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/LiveCrypto.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/tab_bar_amount/btcP2PTrade.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/tab_bar_amount/dogeP2PTrade.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/tab_bar_amount/ethP2PTrade.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/tab_bar_amount/ltcP2PTrade.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template2/tab_bar_amount/usdtP2PTrade.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';

class T2_home extends StatefulWidget {
  /// Get data bloc from
  ThemeBloc themeBloc;
  final Widget child;
  final String transactionType;

  T2_home({Key key, this.themeBloc, this.child, this.transactionType}) : super(key: key);

  @override
  _T2_homeState createState() => _T2_homeState(themeBloc);
}

class _T2_homeState extends State<T2_home> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 5, vsync: this, initialIndex: 1);
    super.initState();
  }

  ThemeBloc themeBloc;
  _T2_homeState(this.themeBloc);
  bool theme = true;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.dark,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text('${widget.transactionType.toUpperCase()} ASSET', style: TextStyle(color: Theme.of(context).textSelectionColor),),
        actions: <Widget>[IconButton(icon: Icon(Icons.search), onPressed: (){showSearch(context: context, delegate: DataSearch());},)],
        iconTheme: IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textSelectionColor,
          tabs: <Widget>[
            new Tab(
              child: Text(
                "USDT",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
            new Tab(
              child: Text(
                "BTC",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
            new Tab(
              child: Text(
                "ETH",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
            new Tab(
              child: Text(
                "LTC",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
            new Tab(
              child: Text(
                "DOGE",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: TabBarView(
        children: <Widget>[usdtP2PTrade(), btcP2PTrade(), ethP2PTrade(), ltcP2PTrade(), dogeP2PTrade()],
        controller: _tabController,
      ),
    );
  }

}

class DataSearch extends SearchDelegate<String> {
  final users = ['mathemartins', 'alphador', 'olowoBTC', 'kelvin212', 'mathew', 'James', 'Lubiricon'];
  final recentUsers = ['mathemartins', 'alphador', 'olowoBTC'];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () {query = "";})];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,),
        onPressed: (){close(context, null);}
        );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _card(context, colorStyle.primaryColor, query, "23th Nov, 2021", "0.22ETH");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionUsers = query.isEmpty ? recentUsers : users.where((parameter) => parameter.contains(query)).toList();

    return ListView.builder(itemBuilder: (context, index) => ListTile(
      onTap: () {
        showResults(context);
      },
      leading: Icon(Icons.person),
       title: RichText(
         text: TextSpan(
           text: suggestionUsers[index].substring(0, query.length),
           style: TextStyle(color: colorStyle.primaryColor, fontWeight: FontWeight.w800, fontFamily: "avenir"),
           children: [
             TextSpan(
               text: suggestionUsers[index].substring(query.length),
               style: TextStyle(color: Colors.grey)
             )
           ]
         ),

       )
    ), itemCount: suggestionUsers.length,);
  }

  Widget _card(BuildContext context, Color _color, String _title, String _time, String _value) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
      child: Container(
        height: 120.0,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 8.0,
                          width: 8.0,
                          decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                              color: _color),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            _title,
                            style: TextStyle(
                                fontFamily: "Sans",
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.open_in_new,
                      size: 17.0,
                      color: Colors.white24,
                    )
                  ],
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.only(left: 45.0, right: 20.0, top: 13.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      _time,
                      style: TextStyle(
                          fontFamily: "Sans",
                          fontWeight: FontWeight.w100,
                          color: Colors.white54),
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          _value,
                          style: TextStyle(
                              fontFamily: "Sans",
                              fontWeight: FontWeight.w800,
                              fontSize: 19.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Icon(
                            Icons.check_circle,
                            size: 17.0,
                            color: Colors.lightGreen,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}

Widget line(double width) {
  return Container(
    height: 0.5,
    width: width,
    color: Color(0xFF86CBF9).withOpacity(0.6),
  );
}

///
/// item widget for drawer
///
Widget itemDrawer(IconData icon, String txt) {
  return Padding(
    padding: const EdgeInsets.only(top: 30.0, left: 20.0),
    child: Row(
      children: <Widget>[
        Icon(
          icon,
          size: 25.0,
          color: Colors.lightBlue,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                txt,
                style: TextStyle(color: Colors.white70, fontSize: 15.5),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
              )
            ],
          ),
        )
      ],
    ),
  );
}
