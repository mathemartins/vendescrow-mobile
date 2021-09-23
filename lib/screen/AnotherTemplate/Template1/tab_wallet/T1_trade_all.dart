import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/P2PTrade/MyP2PTransactions.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeModel.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class T1_trade_all extends StatefulWidget {
  @override
  _T1_trade_allState createState() => _T1_trade_allState();
}

class _T1_trade_allState extends State<T1_trade_all> {
  APIService apiService = new APIService();
  List<P2PTradeModel> p2pTradeModelList = new List <P2PTradeModel>();
  bool loadData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    apiService.getTradeList().then((value) {
      setState(() {
        p2pTradeModelList.addAll(value.reversed.toList());
        loadData = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
              padding: const EdgeInsets.only(top: 5.0),

              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Recent Trades",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Sans")),
                    ],
                  ),
                ),
              )
          ),
          loadData ? _loadingDataAnimation(context) : _dataLoaded(context, p2pTradeModelList, Icons.account_tree_rounded),
        ],
      ),
    );
  }

  Widget _loadingDataAnimation(BuildContext context) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: 9,
        itemBuilder: (ctx, i) {
          return loadingP2PTransactionList(
              ctx, Colors.redAccent.withOpacity(0.75),
              "I WANT TO BUY/SELL", "Slippage: 512.09", "0.00133 BTC",
              "6 transact", Icons.account_tree_rounded
          );
        },
      ),
    );
  }

  Widget loadingP2PTransactionList(BuildContext ctx, Color _color, String _time, String _info, String _value, String _crypto, IconData _icon) {
    return Shimmer.fromColors(
      baseColor: Color(0xFF3B4659),
      highlightColor: Color(0xFF606B78),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  height: 44.0,
                  width: 44.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(70.0)),
                    border: Border.all(color: _color),
                  ),
                  child: Center(
                    child: Icon(
                      _icon,
                      color: _color,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _time,
                        style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Sans"),
                      ),
                      Text(_info,
                          style: TextStyle(
                              color: Colors.white24,
                              fontFamily: "Popins",
                              fontSize: 12))
                    ],
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text(
                  _value,
                  style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Sans",
                      fontWeight: FontWeight.w600,
                      color: _color),
                ),
                Text(_crypto,
                    style: TextStyle(
                        color: Colors.white24,
                        fontFamily: "Popins",
                        fontSize: 12))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataLoaded(BuildContext context, List<P2PTradeModel> p2pTradeModelList, _icon) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: p2pTradeModelList.length,
        itemBuilder: (ctx, i) {
          return _card(context, p2pTradeModelList[i], _icon);
        },
      ),
    );
  }

  ///
  /// Widget card transaction
  ///
  Widget _card(context, P2PTradeModel p2pTradeModelList, IconData _icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                height: 44.0,
                width: 44.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(70.0)),
                  border: Border.all(color: Colors.blue.withOpacity(0.75)),
                ),
                child: Center(
                  child: Icon(
                    p2pTradeModelList.active ? Icons.account_tree_rounded : Icons.cancel,
                    color:  p2pTradeModelList.active ? Colors.green.withOpacity(0.75): Colors.orange.withOpacity(0.75),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${p2pTradeModelList.tradeListedAs} ${p2pTradeModelList.assetToTrade.toUpperCase()}",
                      style: TextStyle(fontSize: 12, fontFamily: "Sans"),
                    ),
                    Text("Slippage: ${p2pTradeModelList.creatorRateInDollar}",
                        style: TextStyle(
                            color: Colors.white24,
                            fontFamily: "Popins",
                            fontSize: 11))
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                "${p2pTradeModelList.cryptoTradingAmount} ${p2pTradeModelList.assetToTrade.toUpperCase()}",
                style: TextStyle(
                    fontSize: 11,
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.withOpacity(0.75)),
              ),
              Text("${p2pTradeModelList.transactions.toString()} transacts",
                  style: TextStyle(
                      color: Colors.white24,
                      fontFamily: "Popins",
                      fontSize: 11))
            ],
          ),
        ],
      ),
    );
  }
}


