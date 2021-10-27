import 'dart:convert';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;

class PaymentService extends ChangeNotifier {
  Client _client = Client();
  Auth _auth = Auth();
  final storage = new FlutterSecureStorage();

  Future getPaymentList(String transaction_id) async {
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "paymentMobile/getList",
          headers: {'Authorization': 'Bearer ' + token!},
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

  Future getDetailPayment(String payment_id) async {
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(
          _url + "paymentMobile/getDetailPayment",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'customer_id': customer_id, 'payment_id': payment_id});
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
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(
          _url + "paymentMobile/getDetailTransaction",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'transaction_id': transaction_id});
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

  Future<Map> savePayment(String payment_id, String transaction_id,
      String total_payment, File file) async {
    print(total_payment);
    var _dio = dio.Dio();
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    File _image = file;
    try {
      String fileName = _image == null ? "" : _image.path.split('/').last;
      dio.FormData formData = dio.FormData.fromMap({
        "payment_id": payment_id,
        "file": _image == null
            ? ""
            : await dio.MultipartFile.fromFile(_image.path, filename: fileName),
        "transaction_id": transaction_id,
        "total_payment": total_payment
      });
      var _response = await _dio.post(_url + "paymentMobile/save",
          data: formData,
          options: dio.Options(
            headers: {'Authorization': 'Bearer ' + token!},
          ));
      var _data = _response.data;
      if (_data['result']) {
        return {'result': true, 'message': _data['message']};
      } else {
        return {'result': false, 'message': _data['message']};
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
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "transactionMobile/delete",
          headers: {'Authorization': 'Bearer ' + token!},
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
