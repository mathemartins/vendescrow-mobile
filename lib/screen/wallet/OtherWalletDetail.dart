import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/HumanReadableNumbers.dart';
import 'package:crypto_v2/component/AssetsWallet/CryptoWalletModel.dart';
import 'package:crypto_v2/component/AssetsWallet/OtherAssetGasFee.dart';
import 'package:crypto_v2/component/AssetsWallet/OtherAssetTransferModel.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../progressHUD.dart';

class otherWalletDetail extends StatefulWidget {
  final Widget child;
  final String assetName;

  otherWalletDetail({Key key, this.child, this.assetName}) : super(key: key);

  _otherWalletDetailState createState() => _otherWalletDetailState();
}

class _otherWalletDetailState extends State<otherWalletDetail> with SingleTickerProviderStateMixin {
  APIService apiService = new APIService();
  BlackMarketRate blackMarketRate = BlackMarketRate();
  CryptoValueDetail cryptoValueDetail = new CryptoValueDetail();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  CryptoWallet userCryptoWallet = CryptoWallet();
  OtherAssetTransferRequestModel _otherAssetTransferRequestModel;
  OtherAssetGasFeeResponseModel _otherAssetGasFeeResponseModel;

  bool loadData = true;
  bool isAPICallProcess = false;

  @override
  void initState() {
    _otherAssetTransferRequestModel = new OtherAssetTransferRequestModel();
    super.initState();
    fetchPageData(widget.assetName);
  }

  void fetchPageData(String asset) async {
    print(asset.toLowerCase());
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseUserCryptoWallet =
        await apiService.get('wallet/${asset.toLowerCase()}/');
    var responseCryptoValueDetail =
        await apiService.getCryptoValueDetail(asset);
    var responseOtherAssetGasFee = await apiService.post('wallet/gas-fee/', {
      "asset": "${asset.toLowerCase()}",
      "receiverAddress": "2NEwRkyeXcNKPdYVBENHmNbp1pKBZYBhtgy",
      "amount": "2"
    });
    setState(() {
      userCryptoWallet =
          CryptoWallet.fromJson(responseUserCryptoWallet['data'][0]);
      _otherAssetGasFeeResponseModel = OtherAssetGasFeeResponseModel.fromJson(
          responseOtherAssetGasFee['data'][0]);
      print(_otherAssetGasFeeResponseModel.estimatedFee);
      blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      cryptoValueDetail = CryptoValueDetail.fromJson(
          responseCryptoValueDetail['data']['$asset']);
      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(
      child: _uiSetup(context),
      inAsyncCall: isAPICallProcess,
      opacity: 0.3,
    );
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return loadData
        ? Center(child: CircularProgressIndicator())
        : Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              brightness: Brightness.dark,
              centerTitle: true,
              title: Text(
                widget.assetName.toString(),
                style: TextStyle(
                    color: Theme.of(context).textSelectionColor,
                    fontFamily: "Gotik",
                    fontWeight: FontWeight.w600,
                    fontSize: 18.5),
              ),
              iconTheme:
                  IconThemeData(color: Theme.of(context).textSelectionColor),
              elevation: 0.0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Column(
              children: <Widget>[
                SizedBox(
                  height: 5.0,
                ),

                ///
                /// Create custom tab bar
                ///
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: new Scaffold(
                      backgroundColor: Colors.transparent,
                      appBar: PreferredSize(
                        preferredSize:
                            Size.fromHeight(42.0), // here the desired height
                        child: new AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0.0,
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          title: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                border: Border.all(color: Colors.black54),
                                color: Colors.black26),
                            child: new TabBar(
                              indicatorColor: Theme.of(context).accentColor,
                              labelColor: Theme.of(context).accentColor,
                              unselectedLabelColor: Theme.of(context).hintColor,
                              indicator: ShapeDecoration.fromBoxDecoration(
                                  BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      color: Theme.of(context).canvasColor)),
                              tabs: [
                                new Tab(
                                  child: Text(
                                    "Receive ${widget.assetName}",
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                new Tab(
                                    child: Text(
                                  "Send ${widget.assetName}",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: new TabBarView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 20.0),
                            child: displayReceiveAsset(
                                context,
                                userCryptoWallet,
                                blackMarketRate,
                                cryptoValueDetail),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 20.0),
                            child: displaySendAsset(context, userCryptoWallet,
                                blackMarketRate, cryptoValueDetail),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  Widget displayReceiveAsset(
      BuildContext context,
      CryptoWallet userCryptoWallet,
      BlackMarketRate blackMarketRate,
      CryptoValueDetail cryptoValueDetail) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 140.0,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Total ${widget.assetName}",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "avenir",
                            fontSize: 15.5),
                      ),
                      Text(
                        "${userCryptoWallet.balance} ${widget.assetName} / ${getUserPriceInFiat(userCryptoWallet.balance, cryptoValueDetail.quote.uSD.price, blackMarketRate.country, blackMarketRate.dollarRate)}",
                        style: TextStyle(fontFamily: "avenir"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Available ${widget.assetName}",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "avenir",
                            fontSize: 15.5),
                      ),
                      Text(
                        "${displayAvailableBalance(userCryptoWallet.balance.toString(), userCryptoWallet.amount)} ${widget.assetName} / ${getUserAvailablePriceInFiat(userCryptoWallet.balance.toString(), userCryptoWallet.amount, cryptoValueDetail.quote.uSD.price, blackMarketRate.country, blackMarketRate.dollarRate)}",
                        style: TextStyle(fontFamily: "avenir"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Frozen",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "avenir",
                            fontSize: 15.5),
                      ),
                      Text(
                        "${userCryptoWallet.amount} ${widget.assetName} / ${getUserFrozenPriceInFiat(userCryptoWallet.amount, cryptoValueDetail.quote.uSD.price, blackMarketRate.country, blackMarketRate.dollarRate)}",
                        style: TextStyle(
                          fontFamily: "Popins",
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 125.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                        ClipboardData(text: "${userCryptoWallet.address}"));

                    final snackBar = SnackBar(
                      content: Text("Copied"),
                    );
                    scaffoldKey.currentState.showSnackBar(snackBar);
                  },
                  child: Text(
                    "${userCryptoWallet.address}",
                    style: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(0.7),
                      fontFamily: "Popins",
                    ),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Container(
                  height: 40.0,
                  width: 300.0,
                  color: Theme.of(context).primaryColor,
                  child: Center(
                    child: Text(
                      "Balance: ${getWalletBalComplete(userCryptoWallet.balance.toString(), cryptoValueDetail.quote.uSD.price, blackMarketRate.country, blackMarketRate.dollarRate)}",
                      style: TextStyle(
                          color: Theme.of(context).textSelectionColor,
                          fontFamily: "avenir"),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              QrImage(
                data: "${userCryptoWallet.address}",
                version: QrVersions.auto,
                backgroundColor: Colors.white,
                size: 210.0,
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                height: 40.0,
                width: 150.0,
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: Text(
                    "Scan QR Code",
                    style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontFamily: "avenir"),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }

  String getUserPriceInFiat(
      balance, double price, String country, double dollarRate) {
    print(balance);
    print(price);
    final floatVal = double.parse(balance);
    final priceIndollars = floatVal * price;
    final userLocalFiat = k_m_b_generator(priceIndollars, dollarRate);
    final currencySymbol = getUserCurrency(country);
    return '$currencySymbol $userLocalFiat';
  }

  displayAvailableBalance(String balance, String amount) {
    final availableBal = double.parse(balance) - double.parse(amount);
    return availableBal.toString();
  }

  getUserAvailablePriceInFiat(String balance, String amount, double price,
      String country, double dollarRate) {
    final availableBal = double.parse(balance) - double.parse(amount);
    final availableBalStr = availableBal.toString();
    return getUserPriceInFiat(availableBalStr, price, country, dollarRate);
  }

  String numberFormatter(double amount) {
    var formatter = NumberFormat("#,##0.00", "en_US");
    return "${formatter.format(amount)}";
  }

  getWalletBalComplete(
      String balance, double price, String country, double dollarRate) {
    final balanceIndollars = double.parse(balance) * price;
    final localFiat = balanceIndollars * dollarRate;
    final approxFiat =
        numberFormatter(localFiat); //localFiat.toStringAsFixed(2);
    final currencySymbol = getUserCurrency(country);

    return '$currencySymbol $approxFiat';
  }

  getUserFrozenPriceInFiat(
      String amount, double price, String country, double dollarRate) {
    final frozen = amount;
    return getUserPriceInFiat(frozen, price, country, dollarRate);
  }

  Widget displaySendAsset(BuildContext context, CryptoWallet userCryptoWallet,
      BlackMarketRate blackMarketRate, CryptoValueDetail cryptoValueDetail) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              children: <Widget>[
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Available ${widget.assetName}",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "avenir",
                            fontSize: 15.5),
                      ),
                      Text(
                        "${displayAvailableBalance(userCryptoWallet.balance.toString(), userCryptoWallet.amount)} ${widget.assetName} / ${getUserAvailablePriceInFiat(userCryptoWallet.balance.toString(), userCryptoWallet.amount, cryptoValueDetail.quote.uSD.price, blackMarketRate.country, blackMarketRate.dollarRate)}",
                        style: TextStyle(fontFamily: "avenir"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Frozen",
                        style: TextStyle(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            fontFamily: "avenir",
                            fontSize: 15.5),
                      ),
                      Text(
                        "${userCryptoWallet.amount} ${widget.assetName} / ${getUserFrozenPriceInFiat(userCryptoWallet.amount, cryptoValueDetail.quote.uSD.price, blackMarketRate.country, blackMarketRate.dollarRate)}",
                        style: TextStyle(
                          fontFamily: "avenir",
                          color: Theme.of(context).hintColor.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            height: 355.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Form(
                key: globalFormKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 27.0,
                    ),
                    Text(
                      "${widget.assetName} Receiver Address",
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.7),
                        fontFamily: "avenir",
                      ),
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.name,
                      onSaved: (input) => _otherAssetTransferRequestModel
                          .receiverAddress = input,
                      validator: (input) => input.isEmpty
                          ? "Transfer address cannot be empty"
                          : null,
                      decoration: InputDecoration(
                          labelText: "Receiver's  Address",
                          labelStyle: TextStyle(
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF45C2DA))),
                          prefixIcon: Icon(
                            Icons.input,
                            color: Colors.grey,
                          )),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Text(
                      "Quantity",
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.7),
                        fontFamily: "avenir",
                      ),
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (input) {
                        if (input.isEmpty) {
                          setState(() {
                            _otherAssetTransferRequestModel.amount = "0";
                            _otherAssetTransferRequestModel.networkFee = "0";
                          });
                        } else {
                          setState(() {
                            _otherAssetTransferRequestModel.amount = input;
                          });
                        }
                      },
                      onSaved: (input) {
                        _otherAssetTransferRequestModel.amount = input;
                        _otherAssetTransferRequestModel.networkFee =
                            "${_otherAssetGasFeeResponseModel.estimatedFee}";
                        _otherAssetTransferRequestModel.asset =
                            "${widget.assetName.toLowerCase()}";
                      },
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Transaction amount has  no value";
                        }

                        double theValue = double.parse(input);
                        double totalAsset =
                            double.parse("${userCryptoWallet.balance}");
                        double frozenAsset =
                            double.parse("${userCryptoWallet.amount}");
                        double availableAsset =
                            double.parse("${totalAsset - frozenAsset}");
                        if (theValue > availableAsset) {
                          return "Your balance is ${availableAsset.toString()}, cannot transfer above available balance";
                        } else if (theValue == 0) {
                          return "Cannot make zero('0') transactions";
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                          labelText:
                              "Quantity Of ${userCryptoWallet.name} In ${widget.assetName}",
                          labelStyle: TextStyle(
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF45C2DA))),
                          prefixIcon: Icon(
                            Icons.dialpad,
                            color: Colors.grey,
                          )),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "${_otherAssetTransferRequestModel.amount} ${widget.assetName}: ${getUserInputInFiat(_otherAssetTransferRequestModel.amount, cryptoValueDetail.quote.uSD.price, blackMarketRate.dollarRate, blackMarketRate.country)}",
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontFamily: "Popins",
                            fontSize: 12.0),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "Receiver Would Get (Due To Network Fee)",
                style: TextStyle(color: Theme.of(context).hintColor),
              ),
              Text(
                "${getUserReceiveAmountInFiat(_otherAssetTransferRequestModel.amount, _otherAssetGasFeeResponseModel.estimatedFee)}",
                style: TextStyle(
                    color: Theme.of(context).hintColor.withOpacity(0.7)),
              )
            ],
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            height: 50.0,
            //color: Theme.of(context).primaryColor,
            child: GestureDetector(
              onTap: () {
                if (validateAndSave()) {
                  print(_otherAssetTransferRequestModel.toJson());
                  performTransfer();
                }
              },
              child: Material(
                borderRadius: BorderRadius.circular(20.0),
                shadowColor: colorStyle.primaryColor,
                color: colorStyle.primaryColor,
                elevation: 1.0,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Transfer ${widget.assetName} ",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 17,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }

  String getUserInputInFiat(
      String amount, double price, double dollarRate, String country) {
    if (amount == null) {
      amount = "0";
    }
    final assetUnit = double.parse(amount);
    final inputIndollar = assetUnit * price;
    final inputInFiat = inputIndollar * dollarRate;
    final dataInputInFiat =
        numberFormatter(inputInFiat); // .toStringAsFixed(2);
    final currencySymbol = getUserCurrency(country);
    return '$currencySymbol $dataInputInFiat';
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  getUserReceiveAmountInFiat(amount, fast) {
    if (amount == null) {
      amount = "0";
    }
    return double.parse(amount) - double.parse(fast);
  }

  void performTransfer() async {
    setState(() {
      isAPICallProcess = true;
    });
    APIService apiService = new APIService();
    apiService.otherAssetTransfer(_otherAssetTransferRequestModel).then((value) {
      setState(() {
        isAPICallProcess = false;
      });

      if (value.message != null) {
        final snackBar = SnackBar(
          content: Text("Transfer Successful!"),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        final snackBar = SnackBar(
          content: Text("Error during transfer"),
        );
        scaffoldKey.currentState.showSnackBar(snackBar);
      }

      setState(() {
        loadData = false;
      });
    });
  }
}
