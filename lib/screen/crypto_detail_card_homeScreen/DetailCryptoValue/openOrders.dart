import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/component/CardDetail/AmountSell.dart';
import 'package:crypto_v2/component/CardDetail/BuyAmount.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/cryptoDetail.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:flutter/material.dart';

class openOrders extends StatefulWidget {
  final Widget child;
  final String symbol;

  openOrders({Key key, this.child, this.symbol}) : super(key: key);

  _openOrdersState createState() => _openOrdersState(this.symbol);
}

class _openOrdersState extends State<openOrders> {
  String symbol;
  _openOrdersState(String symbol);
  APIService apiService = new APIService();
  User user = new User();
  CryptoDetail cryptoDetail = new CryptoDetail();
  CryptoValueDetail cryptoValueDetail = new CryptoValueDetail();
  BlackMarketRate _blackMarketRate = new BlackMarketRate();
  bool loadData = true;

  @override
  void initState() {
    super.initState();
    fetchPageContent(symbol);
  }

  void fetchPageContent(String asset) async {
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseCryptoDetail = await apiService.getCryptoDetail(asset);
    var responseCryptoValueDetail =
        await apiService.getCryptoValueDetail(asset);
    setState(() {
      _blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      cryptoDetail =
          CryptoDetail.fromJson(responseCryptoDetail['data']['$asset']);
      cryptoValueDetail = CryptoValueDetail.fromJson(
          responseCryptoValueDetail['data']['$asset']);
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaQuery = MediaQuery.of(context).size.width / 2.2;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          color: Theme.of(context).canvasColor,
          child: Padding(
              padding: const EdgeInsets.only(
                  left: 0.0, right: 0.0, top: 7.0, bottom: 7.0),
              child: Container(
                child: Text("${cryptoDetail.description}"),
              )),
        ),
        SizedBox(
          height: 10.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              height: 350.0,
              width: mediaQuery,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: buyAmountList.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return _buyAmount(mediaQuery, buyAmountList[i]);
                },
              ),
            ),
            Container(
              height: 350.0,
              width: 1.0,
              color: Theme.of(context).canvasColor,
            ),
            Container(
              height: 350.0,
              width: mediaQuery,
              child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: amountSellList.length,
                itemBuilder: (BuildContext ctx, int i) {
                  return _amountSell(mediaQuery, amountSellList[i]);
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buyAmount(double _width, buyAmount item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19.0),
      child: Container(
        width: _width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                item.number,
                style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontFamily: "Gotik",
                    fontSize: 15.0),
              ),
            ),
            Text(
              item.value,
              style: TextStyle(fontFamily: "Gotik", fontSize: 15.0),
            ),
            Text(
              item.price,
              style: TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Gotik",
                  fontSize: 15.0),
            )
          ],
        ),
      ),
    );
  }

  Widget _amountSell(double _width, amountSell item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 19.0),
      child: Container(
        width: _width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              item.price,
              style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Gotik",
                  fontSize: 15.0),
            ),
            Text(
              item.value,
              style: TextStyle(fontFamily: "Gotik", fontSize: 15.0),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                item.number,
                style: TextStyle(
                    color: Theme.of(context).hintColor,
                    fontFamily: "Gotik",
                    fontSize: 15.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
