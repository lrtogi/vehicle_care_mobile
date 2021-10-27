// ignore_for_file: import_of_legacy_library_into_null_safe
// @dart=2.9
import 'dart:convert';

import 'package:http/http.dart' show Client;
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/db/db_helper.dart';
// import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:vehicle_care_2/models/user.dart';
// import 'package:vehicle_care_2/services/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Auth extends ChangeNotifier {
  Client client = new Client();
  DbHelper _dbHelper = DbHelper();

  bool isLoggedIn = false;
  User _user;
  String _token;
  // String _customer_name;
  // String _customer_email;

  bool get authenticated => isLoggedIn;

  User get user => _user;

  String get token => _token;

  // customer() {
  //   return {'customer_name': _customer_name, 'customer_email': _customer_email};
  // }

  final storage = new FlutterSecureStorage();
  final options = IOSOptions(accessibility: IOSAccessibility.first_unlock);

  Future<Map> registration({Map creds}) async {
    try {
      var _result;
      final _response =
          await client.post("${BaseUrl.url}register", body: creds);
      final _responseData = jsonDecode(_response.body);
      print(_responseData);
      if (_responseData['result']) {
        _result = {"result": true, "message": _responseData['message']};
        notifyListeners();
      } else {
        _result = {"result": false, "message": _responseData['message']};
      }
      return _result;
    } catch (e) {
      return {
        'result': false,
        'message': 'An error occured, please check your connection'
      };
    }
  }

  Future<Map> checkLogin({Map creds}) async {
    try {
      var _result;
      final _response = await client.post("${BaseUrl.url}login",
          headers: {'Accept': 'application/json'}, body: creds);
      final _responseData = jsonDecode(_response.body);
      if (_responseData['result']) {
        var token = _responseData['token'].toString();
        _result = {
          "result": true,
          "token": token,
          "message": _responseData['message']
        };
        isLoggedIn = true;
        storeToken(token: token);
        tryToken(token: token);
        notifyListeners();
      } else {
        _result = {"result": false, "message": _responseData['message']};
      }
      return _result;
    } catch (e) {
      print(e);
      var _result = {
        "result": false,
        "message": "An error occurred, please check your connection"
      };
      return _result;
    }
  }

  // void login({Map creds}) async {
  //   print(creds);
  //   Dio.Response response = await dio().post('/login', data: creds);
  //   if (response.data['result'] != true) {
  //     print(json.decode(response.data));
  //     return json.decode(response.data);
  //   } else {
  //     String token = response.data['data']['token'].toString();
  //     this.tryToken(token: token);
  //   }
  // }

  Future<Map> tryToken({String token}) async {
    if (token == null) {
      var _result = {"result": false, "message": "No Token Found"};
      return _result;
    } else {
      try {
        // Dio.Response _response = await dio().get('/user',
        //     options: Dio.Options(headers: {'Authorization': 'Bearer $token'}));
        final _response = await client.get("${BaseUrl.url}user",
            headers: {'Authorization': 'Bearer $token'});
        final _responseData = jsonDecode(_response.body);
        if (_responseData['message'] != null) {
          var _result = {"result": false, "message": _responseData['message']};
          return _result;
        } else {
          this.isLoggedIn = true;
          this._user = User.fromJson(_responseData);
          // SharedPreferences preferences = await SharedPreferences.getInstance();
          // preferences.setString("user_id", _responseData['user_id']);
          // preferences.setString("customer_id", _responseData['customer_id']);
          // preferences.setString(
          //     "customer_name", _responseData['customer_name']);
          // preferences.setString("email", _responseData['email']);
          // _customer_name = _responseData['customer_name'];
          // _customer_email = _responseData['email'];
          storeToken(token: token);
          await storage.write(
              key: 'customer_id', value: _responseData['customer_id']);
          this._token = token;
          var _result = {"result": true, "message": "Token valid"};
          return _result;
        }
      } catch (e) {
        print(e);
        var _result = {"result": false, "message": 'Error while check Token'};
        return _result;
      }
    }
  }

  storeToken({String token}) async {
    await storage.write(key: 'token', value: token);
  }

  logout() async {
    try {
      String token = await storage.read(key: 'token');
      await client.get("${BaseUrl.url}user/revoke",
          headers: {'Authorization': 'Bearer $token'});
      // Dio.Response response = await dio().get('/user/revoke',
      //     options: Dio.Options(headers: {'Authorization': 'Bearer $_token'}));
      deleteToken();
      // SharedPreferences _preferences = await SharedPreferences.getInstance();
      // _preferences.getKeys();
      // for (String key in _preferences.getKeys()) {
      //   _preferences.remove(key);
      // }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  deleteToken() async {
    this._user = User();
    this.isLoggedIn = false;
    this._token = null;
    await storage.delete(key: 'token');
  }
}
