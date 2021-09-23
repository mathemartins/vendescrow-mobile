import 'dart:convert';
import 'dart:io';

import 'package:crypto_v2/Helpers/custom_trace.dart';
import 'package:crypto_v2/component/AccountLinkage/AccountLinkageModel.dart';
import 'package:crypto_v2/component/AssetsWallet/EthereumTransferModel.dart';
import 'package:crypto_v2/component/AssetsWallet/OtherAssetTransferModel.dart';
import 'package:crypto_v2/component/News/NewsModel.dart';
import 'package:crypto_v2/component/P2PTrade/MyP2PTransactions.dart';
import 'package:crypto_v2/component/P2PTrade/P2PTradeModel.dart';
import 'package:crypto_v2/component/Transactions/TransactionHistory.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:crypto_v2/component/market/CoinModel.dart';
import 'package:crypto_v2/component/market/FiatListModel.dart';
import 'package:crypto_v2/component/market/LiveCrypto.dart';
import 'package:crypto_v2/component/market/NomicsLiveCryptoData.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  ValueNotifier<User> currentUser = new ValueNotifier(User());

  Future<User> login(User user) async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}auth/';
    Uri uri = Uri.parse(url);
    final client = new http.Client();
    final response = await client.post(uri, body: user.toMap());

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
      setCurrentUser(response.body);
      currentUser.value = User.fromJSON(json.decode(response.body));
      print(currentUser.value.token);
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      print(response.body.runtimeType);
      print(json.decode(response.body).runtimeType);
      currentUser.value = User.fromUnsuccessfulJson(json.decode(response.body));
    }
    return currentUser.value;
  }

  Future<User> register(User user) async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}auth/register/';
    Uri uri = Uri.parse(url);
    final client = new http.Client();
    final response = await client.post(
      uri,
      body: user.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      setCurrentUser(response.body);
      currentUser.value = User.fromJson(json.decode(response.body));
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
    return currentUser.value;
  }

  Future<bool> resetPassword(User user) async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}send_reset_link_email';
    Uri uri = Uri.parse(url);
    final client = new http.Client();
    final response = await client.post(
      uri,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(user.toMap()),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
  }

  Future<void> logout() async {
    currentUser.value = new User();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }

  void setCurrentUser(jsonString) async {
    try {
      if (json.decode(jsonString) != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'current_user', json.encode(json.decode(jsonString)));
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: jsonString).toString());
      throw new Exception(e);
    }
  }

  Future<User> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (currentUser.value.token == null && prefs.containsKey('current_user')) {
      currentUser.value = User.fromJson(json.decode(prefs.get('current_user')));
      currentUser.value.active = true;
    } else {
      currentUser.value.active = false;
    }
    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
    currentUser.notifyListeners();
    return currentUser.value;
  }

  NetworkImage getNetworkImage(String imageUrl) {
    return NetworkImage(imageUrl);
  }

  /// get live crypto changes from coin-market cap
  Future<List<LiveCrypto>> getLiveCryptoData() async {
    final client = new http.Client();

    final String url = '${GlobalConfiguration().getValue('coin_market_cap_api_url')}v1/cryptocurrency/listings/latest';
    final String cmcap_apiToken = '${GlobalConfiguration().getValue('coin_market_cap_api_key')}';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "X-CMC_PRO_API_KEY": "$cmcap_apiToken"
    });

    final liveCrypto = List<LiveCrypto>();

    if (response.statusCode == 200) {
      final liveCryptoJson = json.decode(response.body);
      for (var liveData in liveCryptoJson['data']) {
        liveCrypto.add(LiveCrypto.fromJson(liveData));
      }
    }
    return liveCrypto;
  }


  /// get live crypto changes from vendescrow
  Future<List<Coins>> getLiveCoinsData() async {
    final client = new http.Client();

    final String url = '${GlobalConfiguration().getValue('api_base_url')}coins/';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
    });

    final coins = List<Coins>();

    if (response.statusCode == 200) {
      final coinJson = json.decode(response.body);
      for (var liveData in coinJson) {
        coins.add(Coins.fromJson(liveData));
      }
    }
    return coins;
  }

  /// get live Fiat changes from vendescrow
  Future<List<FiatListModel>> getLiveFiatData() async {
    final client = new http.Client();
    final String url = '${GlobalConfiguration().getValue('api_base_url')}fiat-rates/data/';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
    });

    final fiatData = List<FiatListModel>();

    if (response.statusCode == 200) {
      final fiatDataJson = json.decode(response.body);
      for (var fiatDataInstance in fiatDataJson) {
        fiatData.add(FiatListModel.fromJson(fiatDataInstance));
      }
    }
    return fiatData;
  }

  /// get P2P Sell List changes from vendescrow
  Future<List<P2PTradeModel>> getP2PTradeSellList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final client = new http.Client();
    final String url = '${GlobalConfiguration().getValue('api_base_url')}p2p/sell/';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer $token"
    });

    final p2pData = List<P2PTradeModel>();

    if (response.statusCode == 200) {
      final p2pDataJson = json.decode(response.body);
      for (var p2pDataInstance in p2pDataJson) {
        p2pData.add(P2PTradeModel.fromJson(p2pDataInstance));
      }
    }
    return p2pData;
  }


  /// get P2P Buy List changes from vendescrow
  Future<List<P2PTradeModel>> getP2PTradeBuyList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final client = new http.Client();
    final String url = '${GlobalConfiguration().getValue('api_base_url')}p2p/buy/';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer $token"
    }).catchError((onError) => print(onError));

    final p2pData = List<P2PTradeModel>();

    if (response.statusCode == 200) {
      final p2pDataJson = json.decode(response.body);
      for (var p2pDataInstance in p2pDataJson) {
        p2pData.add(P2PTradeModel.fromJson(p2pDataInstance));
      }
    }
    return p2pData;
  }


  Future<List<P2PTradeModel>> getTradeList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final String url = '${GlobalConfiguration().getValue('api_base_url')}p2p/trade-list/';
    Uri uri = Uri.parse(url);

    return http.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer $token"
    }).then((http.Response response) {
      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        List<P2PTradeModel> dataList = List<P2PTradeModel>.from(parsed.map((i) => P2PTradeModel.fromJson(i)));
        return dataList;
      }
    }).catchError((error){
      return error;
    });
  }

  Future<List<MyTransactions>> getP2PTransactionListPerUser() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final String url = '${GlobalConfiguration().getValue('api_base_url')}p2p/my-transactions/';
    Uri uri = Uri.parse(url);

    return http.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Authorization": "Bearer $token"
    }).then((http.Response response) {
      if (response.statusCode == 200) {
        var parsed = json.decode(response.body);
        List<MyTransactions> dataList = List<MyTransactions>.from(parsed.map((i) => MyTransactions.fromJson(i)));
        return dataList;
      }
    }).catchError((error){
      return error;
    });
  }

  // Future<List<CryptoTransactions>> getTransactionListData() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String token = preferences.getString("token");
  //   final client = new http.Client();
  //   final String url = '${GlobalConfiguration().getValue('api_base_url')}transaction/all/';
  //   Uri uri = Uri.parse(url);
  //   final response = await client.get(uri, headers: {
  //     "Content-Type": "application/json; charset=utf-8",
  //     "Authorization": "Bearer $token"
  //   });
  //
  //   final transactionData = List<CryptoTransactions>();
  //
  //   if (response.statusCode == 200) {
  //     final transactionDataJson = json.decode(response.body);
  //     for (var transactionDataInstance in transactionDataJson) {
  //       transactionData.add(CryptoTransactions.fromJson(transactionDataInstance));
  //     }
  //   }
  //   return transactionData;
  // }

  /// get live crypto details from coin-market cap
  Future getCryptoDetail(String cryptoAsset) async {
    final client = new http.Client();
    final String url = '${GlobalConfiguration().getValue('coin_market_cap_api_url')}v1/cryptocurrency/info?symbol=$cryptoAsset';
    final String cmcap_apiToken = '${GlobalConfiguration().getValue('coin_market_cap_api_key')}';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "X-CMC_PRO_API_KEY": "$cmcap_apiToken"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      var outputData = json.decode(response.body);
      return outputData;
    } else {
      throw Exception('Failed To Load Data From The Internet');
    }
  }

  /// get live crypto value details from coin-market cap
  Future getCryptoValueDetail(String cryptoAsset) async {
    final client = new http.Client();
    final String url = '${GlobalConfiguration().getValue('coin_market_cap_api_url')}v1/cryptocurrency/quotes/latest?symbol=$cryptoAsset';
    final String cmcap_apiToken = '${GlobalConfiguration().getValue('coin_market_cap_api_key')}';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "X-CMC_PRO_API_KEY": "$cmcap_apiToken"
    });

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed To Load Data From The Internet');
    }
  }

  /// Get Eth Gas Fee getEthGasFee
  Future getEthGasFee() async {
    final client = new http.Client();
    final String url = '${GlobalConfiguration().getValue('ethereum_gas_station_url')}?api-key=056800238bee56d03c79cee8f56543807341924a39e4370805475bfd96e7';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {"Content-Type": "application/json; charset=utf-8",});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed To Load Data From The Internet');
    }
  }

  /// get live crypto changes from coin-market cap
  Future<List<NomicsLiveCryptoData>> getNomicsLiveCryptoData() async {
    final client = new http.Client();

    final String url = '${GlobalConfiguration().getValue('nomics_api_base_url')}v1/currencies/ticker';
    final String nomics_apiToken = '${GlobalConfiguration().getValue('nomics_api_key')}';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {
      "Content-Type": "application/json; charset=utf-8",
      "key": "$nomics_apiToken"
    });

    final nomicsLiveCrypto = List<NomicsLiveCryptoData>();

    if (response.statusCode == 200) {
      final nomicsLiveCryptoJson = json.decode(response.body);
      for (var nomicsLiveData in nomicsLiveCryptoJson['data']) {
        nomicsLiveCrypto.add(NomicsLiveCryptoData.fromJson(nomicsLiveData));
      }
    }
    return nomicsLiveCrypto;
  }


  Future<List<News>> getNewsData() async {
    final client = new http.Client();
    final String url = '${GlobalConfiguration().getValue("api_base_url")}posts/';
    Uri uri = Uri.parse(url);
    final response = await client.get(uri, headers: {"Content-Type": "application/json; charset=utf-8",});
    final newsData = List<News>();
    if (response.statusCode == 200) {
      final newsDataJson = json.decode(response.body);
      for (var news in newsDataJson['results']) {
        newsData.add(News.fromJson(news));
      }
    }
    return newsData;
  }


  /// post for news use case
  Future postNewsImageData(String path, Map data) async {
    final String url = '${GlobalConfiguration().getValue('base_url')}$path';
    Uri uri = Uri.parse(url);
    String payload = json.encode(data);
    var response = await http.post(uri, body: payload, headers: {'Content-Type': 'application/json; charset=UTF-8',});
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to retrieve data request');
    }
  }

  Future<EthereumTransferResponseModel> ethereumTransfer(EthereumTransferRequestModel ethereumTransferRequestModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final String url = '${GlobalConfiguration().getValue('api_base_url')}wallet/ethereum/transfer/';
    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: ethereumTransferRequestModel.toJson(), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 400) {
      return EthereumTransferResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed To Post Data');
    }
  }

  Future<OtherAssetTransferResponseModel> otherAssetTransfer(
      OtherAssetTransferRequestModel otherAssetTransferRequestModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final String url = '${GlobalConfiguration().getValue('api_base_url')}wallet/transfer/${otherAssetTransferRequestModel.asset}/';
    Uri uri = Uri.parse(url);

    final response = await http.post(uri, body: otherAssetTransferRequestModel.toJson(), headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 400) {
      return OtherAssetTransferResponseModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed To Post Data');
    }
  }

  /// Activate authorization lock
  Future<AccountLinkage> linkAccount(AccountLinkage accountLinkage) async {
    final String url = '${GlobalConfiguration().getValue('api_base_url')}connect-mono/';
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    Uri uri = Uri.parse(url);
    final response = await http.post(uri, body: accountLinkage.toJson(), headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AccountLinkage.fromJson(json.decode(response.body));
    } else {
      print(CustomTrace(StackTrace.current, message: response.body).toString());
      throw new Exception(response.body);
    }
  }


  /// post for general use case
  Future post(String path, Map data) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final String url = '${GlobalConfiguration().getValue('api_base_url')}$path';
    Uri uri = Uri.parse(url);
    String payload = json.encode(data);
    var response = await http.post(uri, body: payload, headers: {
      'Content-Type': 'application/json; charset=UTF-8',
      "Authorization": "Bearer $token"
    });
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to retrieve data request');
    }
  }

  ///  get for general use case
  Future get(String path) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token");
    final String url = '${GlobalConfiguration().getValue('api_base_url')}$path';
    Uri uri = Uri.parse(url);
    var response = await http.get(uri, headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed To Load Data From The Internet');
    }
  }

}
