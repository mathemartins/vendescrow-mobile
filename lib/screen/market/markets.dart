import 'package:crypto_v2/screen/market/TabBarBody/btc.dart';
import 'package:crypto_v2/screen/market/TabBarBody/favorite.dart';
import 'package:flutter/material.dart';

import 'TabBarBody/eth.dart';

class market extends StatefulWidget {
  final Widget child;

  market({Key key, this.child}) : super(key: key);

  _marketState createState() => _marketState();
}

class _marketState extends State<market> with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Market",
          style: TextStyle(
              color: Theme.of(context).textSelectionColor,
              fontFamily: "Gotik",
              fontWeight: FontWeight.w600,
              fontSize: 18.5),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.search,
              color: Theme.of(context).textSelectionColor,
            ),
          ),
        ],
        elevation: 3.0,
        backgroundColor: Theme.of(context).canvasColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textSelectionColor,
          tabs: <Widget>[
            new Tab(
              child: Text(
                "FAV",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
            new Tab(
              child: Text(
                "Crypto",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
            new Tab(
              child: Text(
                "Fiat",
                style: TextStyle(fontFamily: "Popins"),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: <Widget>[favorite(), btc(), eth()],
        controller: _tabController,
      ),
    );
  }
}
