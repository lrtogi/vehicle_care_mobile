// @dart = 2.9

import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' show Client;
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/models/job_list_model.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:async/async.dart';

class TransactionService extends ChangeNotifier {
  Client _client = Client();
  Auth _auth = Auth();
  final storage = new FlutterSecureStorage();

  Future getListTransaction(String flag) async {
    String token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "transactionMobile/getListData",
          headers: {'Authorization': 'Bearer ' + token},
          body: {'customer_id': customer_id, 'flag': flag});
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return _data;
      } else {
        var _result = {'result': false, 'message': 'Failed to retrieve data'};
        return _result;
      }
    } catch (e) {
      print(e);
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      return _data;
    }
  }

  Future getPackage(String company_id, String customer_vehicle_id) async {
    String token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "package/search", headers: {
        'Authorization': 'Bearer ' + token
      }, body: {
        'company_id': company_id,
        'customer_vehicle_id': customer_vehicle_id
      });
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return _data;
      } else {
        var _result = {'result': false, 'message': 'Failed to retrieve data'};
        return _result;
      }
    } catch (e) {
      print(e);
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      return _data;
    }
  }

  Future getDetailPackage(String package_id) async {
    String token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "package/getDetail", headers: {
        'Authorization': 'Bearer ' + token
      }, body: {
        'package_id': package_id,
      });
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return _data;
      } else {
        var _result = {'result': false, 'message': 'Failed to retrieve data'};
        return _result;
      }
    } catch (e) {
      print(e);
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      return _data;
    }
  }

  Future getDetailTransaction(String transaction_id) async {
    String token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "transactionMobile/getData",
          headers: {'Authorization': 'Bearer ' + token},
          body: {'customer_id': customer_id, 'transaction_id': transaction_id});
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return _data;
      } else {
        var _result = {'result': false, 'message': 'Failed to retrieve data'};
        return _result;
      }
    } catch (e) {
      print(e);
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      return _data;
    }
  }

  Future<Map> saveTransaction(String transaction_id, String customer_vehicle_id,
      String package_id, String order_date, String company_id) async {
    String token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response =
          await _client.post(_url + "transactionMobile/save", headers: {
        'Authorization': 'Bearer ' + token
      }, body: {
        'company_id': company_id,
        'customer_id': customer_id,
        'transaction_id': transaction_id,
        'customer_vehicle_id': customer_vehicle_id,
        'package_id': package_id,
        'order_date': order_date
      });
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return _data;
      } else {
        var _result = {'result': false, 'message': _data['message']};
        return _result;
      }
    } catch (e) {
      print(e);
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      return _data;
    }
  }

  Future deleteTransaction(String transaction_id) async {
    String token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "transactionMobile/delete",
          headers: {'Authorization': 'Bearer ' + token},
          body: {'customer_id': customer_id, 'transaction_id': transaction_id});
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return _data;
      } else {
        var _result = {'result': false, 'message': 'Failed to retrieve data'};
        return _result;
      }
    } catch (e) {
      print(e);
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      return _data;
    }
  }
}
