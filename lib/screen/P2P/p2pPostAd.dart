import 'package:crypto_v2/API/apiService.dart';
import 'package:crypto_v2/Helpers/CurrencySymbol.dart';
import 'package:crypto_v2/Helpers/HumanReadableNumbers.dart';
import 'package:crypto_v2/component/AssetsWallet/CryptoWalletModel.dart';
import 'package:crypto_v2/component/AssetsWallet/EthereumWallet.dart';
import 'package:crypto_v2/component/market/FiatBlackMarket.dart';
import 'package:crypto_v2/component/market/cryptoValueDetail.dart';
import 'package:crypto_v2/component/style.dart';
import 'package:crypto_v2/screen/setting/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../progressHUD.dart';
import 'p2pHome.dart';

class postAds extends StatefulWidget {

  postAds({Key key,}) : super(key: key);

  _postAdsState createState() => _postAdsState();
}

class _postAdsState extends State<postAds> with SingleTickerProviderStateMixin {
  ThemeBloc _themeBloc;
  APIService apiService = new APIService();
  String valueChoose;
  String cryptoUnitsChoosen;
  List assets = [ 'BTC', 'ETH', 'LTC', 'DOGE', 'USDT' ];
  CryptoValueDetail btcCryptoValueDetail = new CryptoValueDetail();
  CryptoValueDetail ltcCryptoValueDetail = new CryptoValueDetail();
  CryptoValueDetail dogeCryptoValueDetail = new CryptoValueDetail();
  CryptoValueDetail ethCryptoValueDetail = new CryptoValueDetail();
  CryptoValueDetail usdtCryptoValueDetail = new CryptoValueDetail();
  TextEditingController _priceController = TextEditingController();
  TextEditingController creatorDollarRate = TextEditingController();
  CryptoWallet userBtcWallet = CryptoWallet();
  CryptoWallet userLtcWallet = CryptoWallet();
  CryptoWallet userDogeWallet = CryptoWallet();
  EthereumWallet userEthWallet = EthereumWallet();
  BlackMarketRate blackMarketRate = BlackMarketRate();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = new GlobalKey<FormState>();
  GlobalKey<FormState> globalBuyFormKey = new GlobalKey<FormState>();
  String highestOrderValue, lowestOrderValue;

  bool loadData = true;
  bool isAPICallProcess = false;

  @override
  void initState() {
    super.initState();
    _priceController.text = "1.00";

    fetchPageData();
  }

  void fetchPageData() async {
    var responseFiatData = await apiService.get('fiat-rates/');
    var responseUserETHWallet = await apiService.get('wallet/');
    var responseUserBTCWallet = await apiService.get('wallet/btc/');
    var responseUserLTCWallet = await apiService.get('wallet/ltc/');
    var responseUserDOGEWallet = await apiService.get('wallet/doge/');
    var responseCryptoBTCValueDetail = await apiService.getCryptoValueDetail('btc');
    var responseCryptoLTCValueDetail = await apiService.getCryptoValueDetail('ltc');
    var responseCryptoDOGEValueDetail = await apiService.getCryptoValueDetail('doge');
    var responseCryptoETHValueDetail = await apiService.getCryptoValueDetail('eth');
    var responseCryptoUSDTValueDetail = await apiService.getCryptoValueDetail('usdt');

    setState(() {
      userEthWallet = EthereumWallet.fromJson(responseUserETHWallet['data'][0]);
      userBtcWallet = CryptoWallet.fromJson(responseUserBTCWallet['data'][0]);
      userLtcWallet = CryptoWallet.fromJson(responseUserLTCWallet['data'][0]);
      userDogeWallet = CryptoWallet.fromJson(responseUserDOGEWallet['data'][0]);
      blackMarketRate = BlackMarketRate.fromJson(responseFiatData['data'][0]);
      btcCryptoValueDetail = CryptoValueDetail.fromJson(responseCryptoBTCValueDetail['data']['BTC']);
      ltcCryptoValueDetail = CryptoValueDetail.fromJson(responseCryptoLTCValueDetail['data']['LTC']);
      dogeCryptoValueDetail = CryptoValueDetail.fromJson(responseCryptoDOGEValueDetail['data']['DOGE']);
      ethCryptoValueDetail = CryptoValueDetail.fromJson(responseCryptoETHValueDetail['data']['ETH']);
      usdtCryptoValueDetail = CryptoValueDetail.fromJson(responseCryptoUSDTValueDetail['data']['USDT']);

      loadData = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ProgressHUD(child: _uiSetup(context), inAsyncCall: isAPICallProcess, opacity: 0.3,);
  }

  @override
  Widget _uiSetup(BuildContext context) {
    return loadData ? Center(child: CircularProgressIndicator()): Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        brightness: Brightness.dark,
        centerTitle: true,
        title: Text(
          "Create An Order",
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
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                color: Theme.of(context).canvasColor
                            )
                        ),
                        tabs: [
                          new Tab(
                            child: Text(
                              "I WANT TO BUY",
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          new Tab(
                              child: Text(
                                "I WANT TO SELL",
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
                      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                      child: displayBuyAsset(context, userEthWallet, blackMarketRate),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0),
                      child: displaySellAsset(context, userEthWallet, blackMarketRate),
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

  String getUserPriceInFiat(balance, double price, String country, double dollarRate) {
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

  getWalletBalComplete(String balance, double price, String country, double dollarRate) {
    final balanceIndollars = double.parse(balance) * price;
    final localFiat = balanceIndollars * dollarRate;
    final approxFiat =
    numberFormatter(localFiat); //localFiat.toStringAsFixed(2);
    final currencySymbol = getUserCurrency(country);

    return '$currencySymbol $approxFiat';
  }

  getUserFrozenPriceInFiat(String amount, double price, String country, double dollarRate) {
    final frozen = amount;
    return getUserPriceInFiat(frozen, price, country, dollarRate);
  }

  Widget displayBuyAsset(BuildContext context, EthereumWallet userEthWallet, BlackMarketRate blackMarketRate) {
    return SingleChildScrollView(
      child: Form(
        key: globalBuyFormKey,
        child: Column(

          children: <Widget>[

            Container(
              width: double.infinity,
              height: 120.0,
              decoration: BoxDecoration(color: Theme.of(context).canvasColor,borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                children: <Widget>[

                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Select Asset To Buy",
                    style: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(0.7),
                      fontFamily: "avenir",
                    ),
                  ),

                  Padding(
                      padding:const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
                      child: DropdownButton(
                        hint: Text('Select Asset: '),
                        iconSize: 30,
                        isExpanded: true,
                        value: valueChoose,
                        onChanged: (newValue) {
                          setState(() {
                            valueChoose = newValue;
                          });
                        },
                        items: assets.map((asset){
                          return DropdownMenuItem(value: asset, child: Text(asset),);
                        }).toList(),
                      )
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0,),

            Container(
              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(color: Theme.of(context).canvasColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 12.0,),
                    Text(
                      "Slippage",
                      style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7),fontFamily: "avenir",),
                    ),

                    SizedBox(width: 12.0,),

                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    Container(
                      height: 38.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: InkWell(
                              child: Icon(
                                Icons.arrow_drop_up,
                                size: 18.0,
                              ),
                              onTap: () {
                                double currentValue = double.parse(_priceController.text);
                                setState(() {
                                  currentValue = currentValue + 0.01;
                                  _priceController.text = (currentValue > 1.30 ? 1.30 : currentValue).toStringAsFixed(2); // incrementing value
                                });
                              },
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.arrow_drop_down,size: 18.0,),
                            onTap: () {
                              double currentValue = double.parse(_priceController.text);
                              setState(() {
                                print("Setting state");
                                currentValue = currentValue - 0.01;
                                _priceController.text = (currentValue < 0.80 ? 0.80 : currentValue).toStringAsFixed(2); // decrementing value
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.0,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Our Price: ${getSelectedCryptoPriceInFiat(valueChoose)}",
                  style: TextStyle(color: Theme.of(context).hintColor, fontSize: 10),
                ),
                Text("Your Price: ${getSelectedUserCryptoPriceInFiat(valueChoose, _priceController.text)}",
                  style: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(0.7),
                      fontSize: 10
                  ),
                )
              ],
            ),

            SizedBox(height: 5.0,),

            Container(
              height: 355.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 27.0,
                    ),
                    Text(
                      "Set Trading Amount",
                      style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.7),
                        fontFamily: "avenir",
                      ),
                    ),
                    new TextFormField(
                      keyboardType: TextInputType.number,
                      onChanged: (unitsOfCrypto) {
                        setState(() {
                          cryptoUnitsChoosen = unitsOfCrypto;
                        });
                      },
                      onSaved: (input) {
                        creatorDollarRate.text = getCreatorDollarRate(_priceController.text);
                      },
                      validator: (input) => input.isEmpty ? "Transaction Amount Cannot Be Empty Or Zero" : null,
                      decoration: InputDecoration(
                          labelText: "Enter Total Trading Amount In $valueChoose",
                          labelStyle: TextStyle(
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey
                          ),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF45C2DA))),
                          prefixIcon: Icon(Icons.input, color: Colors.grey,)),
                    ),
                    SizedBox(height: 30.0,),
                    Text("Order Limit", style: TextStyle(
                        color: Theme.of(context).hintColor.withOpacity(0.7),
                        fontFamily: "avenir",
                      ),
                    ),

                    new TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (input) => highestOrderValue = input,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Transaction amount cannot be empty";
                        }
                        String highestOrderValue = getFiatValueOfCryptoUnits(valueChoose, cryptoUnitsChoosen, _priceController.text);
                        print(highestOrderValue);
                        double highestValueInFiat = double.parse(highestOrderValue);

                        if (double.parse(input) > highestValueInFiat) {
                          return "Your highest transaction limit can only be $highestOrderValue";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText:
                          "Highest Amount That Could Be Bought In ${getUserCurrency(blackMarketRate.country.toString())}",
                          labelStyle: TextStyle(
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF45C2DA))),
                          prefixIcon: Icon(Icons.upload_outlined, color: Colors.grey,)),
                    ),

                    SizedBox(height: 5.0,),

                    new TextFormField(
                      keyboardType: TextInputType.number,
                      onSaved: (input) => lowestOrderValue = input,
                      validator: (input) {
                        if (input.isEmpty) {
                          return "Transaction amount cannot be empty";
                        }
                        if (double.parse(input) < 0) {
                          return "Set a reasonable amount for lowest transaction";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          labelText:
                          "Lowest Amount That Could Be Bought In ${getUserCurrency(blackMarketRate.country.toString())}",
                          labelStyle: TextStyle(
                              fontFamily: 'avenir',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF45C2DA))),
                          prefixIcon: Icon(Icons.download_outlined, color: Colors.grey,)),
                    ),

                    SizedBox(height: 5.0,),

                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "Transfer fees would be charged for ETH and USDT",
                        style: TextStyle(
                            color: Theme.of(context).hintColor,
                            fontFamily: "Popins",
                            fontSize: 11.0),
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20.0,),

            Container(
              height: 50.0,
              //color: Theme.of(context).primaryColor,
              child: GestureDetector(
                onTap: () {
                  if (validateBuyAndSave()) {
                    Map payload  = {"asset": valueChoose, "priceSlippage": _priceController.text, "creatorDollarRate": creatorDollarRate.text, "unitsOfCryptoSelectedForTrade": cryptoUnitsChoosen, "highestOrderLimit": highestOrderValue, "lowestOrderLimit": lowestOrderValue, "tradeListedAs": "I WANT TO BUY"};
                    setState(() {
                      isAPICallProcess = true;
                    });
                    APIService apiService = new APIService();
                    apiService.post('p2p/create/', payload).then((value) {
                      setState(() {
                        isAPICallProcess = false;
                      });

                      if (value['message'] != null) {
                        final snackBar = SnackBar(
                          content: Text("Trade Created Successful!"),
                        );
                        scaffoldKey.currentState.showSnackBar(snackBar);

                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => p2pHome(themeBloc: _themeBloc)));
                      } else {
                        final snackBar = SnackBar(
                          content: Text("Error with trade inputs"),
                        );
                        scaffoldKey.currentState.showSnackBar(snackBar);
                      }

                      setState(() {
                        loadData = false;
                      });
                    });
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
                          "Post Ad",
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
      ),
    );
  }

  Widget displaySellAsset(BuildContext context, EthereumWallet userEthWallet, BlackMarketRate blackMarketRate) {
    return SingleChildScrollView(
      child: Form(
        key: globalFormKey,
        child: Column(

          children: <Widget>[

            Container(
              width: double.infinity,
              height: 120.0,
              decoration: BoxDecoration(color: Theme.of(context).canvasColor,borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Column(
                children: <Widget>[

                  SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Select Asset To Sell",
                    style: TextStyle(
                      color: Theme.of(context).hintColor.withOpacity(0.7),
                      fontFamily: "avenir",
                    ),
                  ),

                  Padding(
                    padding:const EdgeInsets.only(left: 20.0, right: 20.0, top: 19.0),
                    child: DropdownButton(
                      hint: Text('Select Asset: '),
                      iconSize: 30,
                      isExpanded: true,
                      value: valueChoose,
                      onChanged: (newValue) {
                        setState(() {
                          valueChoose = newValue;
                        });
                      },
                      items: assets.map((asset){
                        return DropdownMenuItem(value: asset, child: Text(asset),);
                      }).toList(),
                    )
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0,),

            Container(
              height: 100.0,
              width: double.infinity,
              decoration: BoxDecoration(color: Theme.of(context).canvasColor, borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 12.0,),
                    Text(
                      "Slippage",
                      style: TextStyle(color: Theme.of(context).hintColor.withOpacity(0.7),fontFamily: "avenir",),
                    ),

                    SizedBox(width: 12.0,),

                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ),
                    Container(
                      height: 38.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: InkWell(
                              child: Icon(
                                Icons.arrow_drop_up,
                                size: 18.0,
                              ),
                              onTap: () {
                                double currentValue = double.parse(_priceController.text);
                                setState(() {
                                  currentValue = currentValue + 0.01;
                                  _priceController.text = (currentValue > 1.30 ? 1.30 : currentValue).toStringAsFixed(2); // incrementing value
                                });
                              },
                            ),
                          ),
                          InkWell(
                            child: Icon(Icons.arrow_drop_down,size: 18.0,),
                            onTap: () {
                              double currentValue = double.parse(_priceController.text);
                              setState(() {
                                print("Setting state");
                                currentValue = currentValue - 0.01;
                                _priceController.text = (currentValue < 0.80 ? 0.80 : currentValue).toStringAsFixed(2); // decrementing value
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(
              height: 20.0,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Our Price: ${getSelectedCryptoPriceInFiat(valueChoose)}",
                  style: TextStyle(color: Theme.of(context).hintColor, fontSize: 10),
                ),
                Text("Your Price: ${getSelectedUserCryptoPriceInFiat(valueChoose, _priceController.text)}",
                  style: TextStyle(
                    color: Theme.of(context).hintColor.withOpacity(0.7),
                    fontSize: 10
                  ),
                )
              ],
            ),

            SizedBox(height: 5.0,),

            Container(
              height: 355.0,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 27.0,
                      ),
                      Text(
                        "Set Trading Amount",
                        style: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(0.7),
                          fontFamily: "avenir",
                        ),
                      ),
                      new TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (unitsOfCrypto) {
                          setState(() {
                            cryptoUnitsChoosen = unitsOfCrypto;
                          });
                        },
                        onSaved: (input) {
                          creatorDollarRate.text = getCreatorDollarRate(_priceController.text);
                        },
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Transaction amount has no value";
                          }

                          double theValue = double.parse(input);
                          double totalBTCAsset = double.parse("${userBtcWallet.balance}");
                          double totalLTCAsset = double.parse("${userLtcWallet.balance}");
                          double totalDOGEAsset = double.parse("${userDogeWallet.balance}");
                          double totalETHAsset = double.parse("${userEthWallet.balance}");
                          double totalUSDTAsset = double.parse("${userEthWallet.tether.balance}");
                          String chosenAsset = valueChoose;

                          if (chosenAsset == 'BTC' && (0.00003 + theValue) >= totalBTCAsset) {
                            return "Cannot trade P2P with $totalBTCAsset BTC In Your Account";
                          } else if (chosenAsset == 'LTC' && (0.0002 + theValue) >= totalLTCAsset) {
                              return "Cannot trade P2P with $totalLTCAsset LTC In Your Account";
                          } else if (chosenAsset == 'DOGE' && (3 + theValue) >= totalLTCAsset) {
                              return "Cannot trade P2P with $totalDOGEAsset DOGE In Your Account";
                          } else if (chosenAsset == 'ETH' && (0.0009 + theValue) >= totalETHAsset) {
                              return "Cannot trade P2P with $totalETHAsset ETH In Your Account";
                          } else if (chosenAsset == 'USDT' && (2 + theValue) >= totalUSDTAsset) {
                              return "Cannot trade P2P with $totalUSDTAsset USDT In Your Account";
                          } else if (theValue == 0) {
                              return "Cannot make zero('0') transactions";
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Enter Total Trading Amount In $valueChoose",
                            labelStyle: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey
                            ),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF45C2DA))),
                            prefixIcon: Icon(Icons.input, color: Colors.grey,)),
                      ),
                      SizedBox(height: 30.0,),
                      Text("Order Limit", style: TextStyle(
                          color: Theme.of(context).hintColor.withOpacity(0.7),
                          fontFamily: "avenir",
                        ),
                      ),

                      new TextFormField(
                            keyboardType: TextInputType.number,
                            onSaved: (input) => highestOrderValue = input,
                            validator: (input) {
                              if (input.isEmpty) {
                                return "Transaction amount cannot be empty";
                              }
                              String highestOrderValue = getFiatValueOfCryptoUnits(valueChoose, cryptoUnitsChoosen, _priceController.text);
                              print(highestOrderValue);
                              double highestValueInFiat = double.parse(highestOrderValue);

                              if (double.parse(input) > highestValueInFiat) {
                                return "Your highest transaction limit can only be $highestOrderValue";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                labelText:
                                "Highest Amount That Could Be Bought In ${getUserCurrency(blackMarketRate.country.toString())}",
                                labelStyle: TextStyle(
                                    fontFamily: 'avenir',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF45C2DA))),
                                prefixIcon: Icon(Icons.upload_outlined, color: Colors.grey,)),
                          ),

                      SizedBox(height: 5.0,),

                      new TextFormField(
                        keyboardType: TextInputType.number,
                        onSaved: (input) => lowestOrderValue = input,
                        validator: (input) {
                          if (input.isEmpty) {
                            return "Transaction amount cannot be empty";
                          }
                          if (double.parse(input) < 0) {
                            return "Set a reasonable amount for lowest transaction";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            labelText:
                            "Lowest Amount That Could Be Bought In ${getUserCurrency(blackMarketRate.country.toString())}",
                            labelStyle: TextStyle(
                                fontFamily: 'avenir',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF45C2DA))),
                            prefixIcon: Icon(Icons.download_outlined, color: Colors.grey,)),
                      ),

                      SizedBox(height: 5.0,),

                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          "Transfer fees would be charged for ETH and USDT",
                          style: TextStyle(
                              color: Theme.of(context).hintColor,
                              fontFamily: "Popins",
                              fontSize: 11.0),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
              ),

            SizedBox(height: 20.0,),

            Container(
              height: 50.0,
              //color: Theme.of(context).primaryColor,
              child: GestureDetector(
                onTap: () {
                  if (validateAndSave()) {
                    Map payload  = {"asset": valueChoose, "priceSlippage": _priceController.text, "creatorDollarRate": creatorDollarRate.text, "unitsOfCryptoSelectedForTrade": cryptoUnitsChoosen, "highestOrderLimit": highestOrderValue, "lowestOrderLimit": lowestOrderValue, "tradeListedAs": "I WANT TO SELL"};
                    setState(() {
                      isAPICallProcess = true;
                    });
                    APIService apiService = new APIService();
                    apiService.post('p2p/create/', payload).then((value) {
                      setState(() {
                        isAPICallProcess = false;
                      });

                      if (value['message'] != null) {
                        final snackBar = SnackBar(
                          content: Text("Trade Created Successful!"),
                        );
                        scaffoldKey.currentState.showSnackBar(snackBar);

                        Navigator.of(context).push(PageRouteBuilder(pageBuilder: (_, __, ___) => p2pHome(themeBloc: _themeBloc)));
                      } else {
                        final snackBar = SnackBar(
                          content: Text("Error with trade inputs"),
                        );
                        scaffoldKey.currentState.showSnackBar(snackBar);
                      }

                      setState(() {
                        loadData = false;
                      });
                    });
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
                          "Post Ad",
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
      ),
    );
  }

  String getUserInputInFiat(String amount, double price, double dollarRate, String country) {
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

  bool validateBuyAndSave() {
    final form = globalBuyFormKey.currentState; //globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  getUserReceiveAmountInFiat(amount, int fast) {
    if (amount == null) {
      amount = "0";
    }
    final gasFeeInGwei = fast / 10;
    final fastGas =
    double.parse(((25000 * gasFeeInGwei) * 0.000000001).toStringAsFixed(5));
    return double.parse(amount) - fastGas;
  }

  getSelectedCryptoPriceInFiat(String valueChoose) {
    var command = valueChoose;
    switch (command) {
      case 'BTC':
        final btcValue = btcCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate;
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(btcValue) * rate));
        return '$currency $value';
        break;
      case 'LTC':
        final ltcValue = ltcCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate;
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(ltcValue) * rate));
        return '$currency $value';
        break;
      case 'DOGE':
        final dogeValue = dogeCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate;
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(dogeValue) * rate));
        return '$currency $value';
        break;
      case 'ETH':
        final ethValue = ethCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate;
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(ethValue) * rate));
        return '$currency $value';
        break;
      case 'USDT':
        final usdtValue = usdtCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate;
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(usdtValue) * rate));
        return '$currency $value';
        break;
      default:
        return '0';
    }
  }

  getSelectedUserCryptoPriceInFiat(String valueChoose, String text) {
    var command = valueChoose;
    switch (command) {
      case 'BTC':
        final btcValue = btcCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(btcValue) * rate));
        return '$currency $value';
        break;
      case 'LTC':
        final ltcValue = ltcCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(ltcValue) * rate));
        return '$currency $value';
        break;
      case 'DOGE':
        final dogeValue = dogeCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(dogeValue) * rate));
        return '$currency $value';
        break;
      case 'ETH':
        final ethValue = ethCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(ethValue) * rate));
        return '$currency $value';
        break;
      case 'USDT':
        final usdtValue = usdtCryptoValueDetail.quote.uSD.price.toString();
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final currency = getUserCurrency(blackMarketRate.country.toString());
        final formatter = new NumberFormat("#,##0.00", "en_US");
        final value = formatter.format((double.parse(usdtValue) * rate));
        return '$currency $value';
        break;
      default:
        return '0';
    }
  }

  getFiatValueOfCryptoUnits(String valueChoose, String cryptoUnitsChoosen, String text) {
    var command = valueChoose;
    switch (command) {
      case 'BTC':
        final assetUnit = double.parse(cryptoUnitsChoosen);
        final btcValue = btcCryptoValueDetail.quote.uSD.price.toString();
        final assetDollars = double.parse(btcValue) * assetUnit;
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final value = (assetDollars * rate).toStringAsFixed(2);
        return '$value';
        break;
      case 'LTC':
        final assetUnit = double.parse(cryptoUnitsChoosen);
        final ltcValue = ltcCryptoValueDetail.quote.uSD.price.toString();
        final assetDollars = double.parse(ltcValue) * assetUnit;
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final value = (assetDollars * rate).toStringAsFixed(2);
        return '$value';
        break;
      case 'DOGE':
        final assetUnit = double.parse(cryptoUnitsChoosen);
        final dogeValue = dogeCryptoValueDetail.quote.uSD.price.toString();
        final assetDollars = double.parse(dogeValue) * assetUnit;
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final value = (assetDollars * rate).toStringAsFixed(2);
        return '$value';
        break;
      case 'ETH':
        final assetUnit = double.parse(cryptoUnitsChoosen);
        final ethValue = ethCryptoValueDetail.quote.uSD.price.toString();
        final assetDollars = double.parse(ethValue) * assetUnit;
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final value = (assetDollars * rate).toStringAsFixed(2);
        return '$value';
        break;
      case 'USDT':
        final assetUnit = double.parse(cryptoUnitsChoosen);
        final usdtValue = usdtCryptoValueDetail.quote.uSD.price.toString();
        final assetDollars = double.parse(usdtValue) * assetUnit;
        final rate = blackMarketRate.dollarRate * double.parse(text);
        final value = (assetDollars * rate).toStringAsFixed(2);
        return '$value';
        break;
      default:
        return '0';
    }
  }

  String getCreatorDollarRate(String text) {
    final cDollarRate = blackMarketRate.dollarRate * double.parse(text);
    return cDollarRate.toString();
  }

}
