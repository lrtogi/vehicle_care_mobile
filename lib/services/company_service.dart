import 'dart:convert';
import 'package:http/http.dart' show Client;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/models/company_model.dart';
import 'package:vehicle_care_2/services/auth.dart';

class CompanyService {
  Client _client = Client();
  Auth _auth = Auth();
  final storage = new FlutterSecureStorage();

  Future<CompanyModel> getCompany(String search) async {
    String? token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "company/search",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'search': search});
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return CompanyModel.fromJson(_data['data']);
      } else {
        throw Exception("Failed get Data");
      }
    } catch (e) {
      print(e);
      return CompanyModel.fromJson([]);
    }
  }

  Future getWorkerData() async {
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "company/getWorkerData",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'customer_id': customer_id});
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

  Future removeApplication(String worker_id) async {
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "company/removeApplication",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'customer_id': customer_id, 'worker_id': worker_id});
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

  Future registerToCompany(String company_id) async {
    String? token = await storage.read(key: 'token');
    var customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "company/workerRegister",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'customer_id': customer_id, 'company_id': company_id});
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
}
