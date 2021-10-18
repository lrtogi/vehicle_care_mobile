import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/services/auth.dart';

class ProfileService {
  Client _client = Client();
  Auth _auth = Auth();
  final storage = new FlutterSecureStorage();

  Future<Map> getProfile() async {
    String? token = await storage.read(key: 'token');
    var _customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "getProfile",
          headers: {'Authorization': 'Bearer ' + token!});
      final _data = jsonDecode(_response.body);
//            print(_data);
      return _data;
    } catch (e) {
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      return _data;
    }
  }

  Future<Map> saveProfile(Map data) async {
    String? token = await storage.read(key: 'token');
    var _customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "saveProfile",
          headers: {'Authorization': 'Bearer ' + token!}, body: data);
      final _data = jsonDecode(_response.body);
      print(_data);
      if (_data['result']) {
        return {'result': true, 'message': _data['message']};
      } else {
        return {'result': false, 'message': _data['message']};
      }
    } catch (e) {
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      print(e);
      return _data;
    }
  }

  Future<Map> getVehicle() async {
    String? token = await storage.read(key: 'token');
    var _customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      print(_customer_id);
      var _result;
      var _response = await _client.post(_url + "vehicle/getAll",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'customer_id': _customer_id});
      final _data = jsonDecode(_response.body);
      print("cek data $_data");
      if (_data['data'].length > 0) {
        _result = {"result": true, "data": _data};
      } else {
        _result = {"result": false, "message": "No data vehicle"};
        print(_result);
      }
      return _result;
    } catch (e) {
      print(e.toString());
      var _errorMessage = {"result": false, "message": "Failed get data"};
      return _errorMessage;
    }
  }

  Future<Map> getVehicleDetail(String customer_vehicle_id) async {
    String? token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _result;
      var _response = await _client.post(_url + "vehicle/getVehicleDetail",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'customer_vehicle_id': customer_vehicle_id});
      final _data = jsonDecode(_response.body);
      print(_data);
      if (_data['result']) {
        _result = {"result": true, "data": _data['data']};
      } else {
        _result = {"result": true, "data": _data['data']};
      }
      return _result;
    } catch (e) {
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      print(e);
      return _data;
    }
  }

  Future<Map> saveVehicle(Map data) async {
    String? token = await storage.read(key: 'token');
    var _customer_id = await storage.read(key: 'customer_id');
    data['customer_id'] = _customer_id;
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "vehicle/save",
          headers: {'Authorization': 'Bearer ' + token!}, body: data);
      final _data = jsonDecode(_response.body);
      print(_data);
      if (_data['result']) {
        return {'result': true, 'message': _data['message']};
      } else {
        return {'result': false, 'message': _data['message']};
      }
    } catch (e) {
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      print(e);
      return _data;
    }
  }

  Future<Map> deleteVehicle(String customer_vehicle_id) async {
    String? token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "vehicle/delete",
          headers: {'Authorization': 'Bearer ' + token!},
          body: {'customer_vehicle_id': customer_vehicle_id});
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        return {'result': true, 'message': _data['message']};
      } else {
        return {'result': false, 'message': _data['message']};
      }
    } catch (e) {
      var _data = {
        "result": false,
        "message": "An error occured, please check your connection"
      };
      print(e);
      return _data;
    }
  }

  Future<Map> getVehicleType() async {
    String? token = await storage.read(key: 'token');
    var _customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    try {
      var _result;
      var _response = await _client.post(_url + "vehicle/getType",
          headers: {'Authorization': 'Bearer ' + token!});
      final _data = jsonDecode(_response.body);
      if (_data['data'].length > 0) {
        _result = {"result": true, "data": _data};
        print(_result);
      } else {
        _result = {"result": false, "message": "No data vehicle"};
        print(_result);
      }
      return _result;
    } catch (e) {
      print(e.toString());
      var _errorMessage = {"result": false, "message": "Failed get data"};
      return _errorMessage;
    }
  }
}
