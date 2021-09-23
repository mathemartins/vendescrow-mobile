import 'package:crypto_v2/screen/AnotherTemplate/Template1/tab_wallet/T1_btc.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/tab_wallet/T1_dash.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/tab_wallet/T1_all.dart';
import 'package:crypto_v2/screen/AnotherTemplate/Template1/tab_wallet/T1_trade_all.dart';
import 'package:flutter/material.dart';
import 'package:crypto_v2/component/style.dart';

class T1_wallet extends StatefulWidget {
  final Widget child;

  T1_wallet({Key key, this.child}) : super(key: key);

  _T1_walletState createState() => _T1_walletState();
}

class _T1_walletState extends State<T1_wallet>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  /// Set Top App Navigation Bar
  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141C35),

      ///
      /// Appbar
      ///
      appBar: AppBar(
        brightness: Brightness.dark,
        elevation: 0.0,
        backgroundColor: Color(0xFF141C35),
        centerTitle: true,
        title: Text(
          "Trade Records",
          style: TextStyle(color: Colors.white, fontFamily: "Gotik"),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              "assets/image/messageAppbar.png",
              color: Colors.white,
              height: 20.0,
              width: 20.0,
            ),
          )
        ],
      ),

      ///
      /// Set container for tab bar custom in top (bottom appbar)
      ///
      body: ListView(
        children: <Widget>[
          Container(
            color: Color(0xFF141C35),
            height: 1000.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ///
                /// Custom tab bar
                ///
                Expanded(
                  child: DefaultTabController(
                    length: 3,
                    child: new Scaffold(
                      backgroundColor: Color(0xFF141C35),
                      appBar: PreferredSize(
                        preferredSize:
                            Size.fromHeight(53.0), // here the desired height
                        child: new AppBar(
                          backgroundColor: Color(0xFF141C35),
                          elevation: 0.0,
                          centerTitle: true,
                          flexibleSpace: SafeArea(
                            child: Stack(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 46.0),
                                  child: Container(
                                    width: double.infinity,
                                    height: 2.5,
                                    color: Colors.white12.withOpacity(0.1),
                                  ),
                                ),
                                Container(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 50.0, left: 50.0),
                                    child: new TabBar(
                                      // labelColor: Theme.of(context).primaryColor,
                                      indicatorColor: colorStyle.primaryColor,
                                      labelColor:Theme.of(context).primaryColor,
                                      unselectedLabelColor: Colors.white24,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      tabs: [
                                        new Tab(
                                          child: Text("All")
                                        ),
                                        new Tab(
                                            child: Text("Running")
                                        ),
                                        new Tab(
                                            child: Text("Sold Out")
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          automaticallyImplyLeading: false,
                        ),
                      ),

                      ///
                      /// Body for tab bar
                      ///
                      body: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: new TabBarView(
                          children: [
                            T1_trade_all(),
                            T1_btc(),
                            T1_dash(),
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
    );
  }
}
