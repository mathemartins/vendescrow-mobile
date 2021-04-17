import 'dart:convert';

import 'package:crypto_v2/Helpers/custom_trace.dart';
import 'package:crypto_v2/component/User/UserModel.dart';
import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  ValueNotifier<User> currentUser = new ValueNotifier(User());

  Future<User> register(User user) async {
    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}auth/register/';
    final client = new http.Client();
    final response = await client.post(
      url,
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

  void setCurrentUser(jsonString) async {
    try {
      if (json.decode(jsonString)['data'] != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'current_user', json.encode(json.decode(jsonString)['data']));
      }
    } catch (e) {
      print(CustomTrace(StackTrace.current, message: jsonString).toString());
      throw new Exception(e);
    }
  }

  NetworkImage getUserImage(String imageUrl) {
    return NetworkImage(imageUrl);
  }
}
