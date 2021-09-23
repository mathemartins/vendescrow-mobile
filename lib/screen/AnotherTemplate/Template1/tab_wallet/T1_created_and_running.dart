import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/P2PTrade/MyP2PTransactions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class T1_created_and_running extends StatefulWidget {
  @override
  _T1_created_and_runningState createState() => _T1_created_and_runningState();
}

class _T1_created_and_runningState extends State<T1_created_and_running> {
  APIService apiService = new APIService();
  List<MyTransactions> p2pTradeCompleted = new List <MyTransactions>();
  bool loadData = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiService.getP2PTransactionListPerUser().then((value) {
      setState(() {
        p2pTradeCompleted.addAll(value.where((element) => element.status == 'CREATED AND RUNNING').toList().reversed);
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
                      Text("Transactions",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Sans")),
                    ],
                  ),
                ),
              )
          ),
          loadData ? _loadingDataAnimation(context) : _dataLoaded(context, p2pTradeCompleted, Icons.mobile_screen_share),
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
              "d40207r7m83nq1x7ol7dc4yres8qjz2rqzcyfjp8b44o", "COMPLETED", "- 0.01",
              "9000", Icons.mobile_screen_share
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
                        style: TextStyle(fontSize: 12,fontFamily: "Sans"),
                      ),
                      Text(_info,
                          style: TextStyle(
                              color: Colors.white24,
                              fontFamily: "Popins",
                              fontSize: 12.0))
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
                        fontSize: 12.0))
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataLoaded(BuildContext context, List<MyTransactions> myP2PTransactions, _icon) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: myP2PTransactions.length,
        itemBuilder: (ctx, i) {
          return _card(context, myP2PTransactions[i], _icon);
        },
      ),
    );
  }

  ///
  /// Widget card transaction
  ///
  Widget _card(context, MyTransactions myP2PTransactions, IconData _icon) {
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
                    myP2PTransactions.status == 'COMPLETED'? Icons.check : Icons.mobile_screen_share,
                    color:  myP2PTransactions.status == 'COMPLETED' ? Colors.green.withOpacity(0.75): Colors.blue.withOpacity(0.75),
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
                      myP2PTransactions.transactionKey,
                      style: TextStyle(fontSize: 12, fontFamily: "Sans"),
                    ),
                    Text(myP2PTransactions.status,
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
                myP2PTransactions.cryptoUnitTransacted,
                style: TextStyle(
                    fontSize: 11,
                    fontFamily: "Sans",
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.withOpacity(0.75)),
              ),
              Text(myP2PTransactions.fiatPaid,
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


