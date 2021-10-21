import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' show Client;
import 'package:http/http.dart' as http;
import 'package:vehicle_care_2/constant/url.dart';
import 'package:vehicle_care_2/services/auth.dart';
import 'package:async/async.dart';
import 'package:dio/dio.dart' as dio;

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

  Future<Map> saveVehicle(String customer_vehicle_id, String vehicle_name,
      String police_number, String vehicle_id, File picture) async {
    var _dio = dio.Dio();
    String? token = await storage.read(key: 'token');
    var _customer_id = await storage.read(key: 'customer_id');
    var _url = BaseUrl.url;
    File _image = picture;
    try {
      String fileName = _image == null ? "" : _image.path.split('/').last;
      dio.FormData formData = dio.FormData.fromMap({
        "customer_vehicle_id": customer_vehicle_id,
        "vehicle_photo_url": _image == null
            ? ""
            : await dio.MultipartFile.fromFile(_image.path, filename: fileName),
        "vehicle_name": vehicle_name,
        "police_number": police_number,
        "customer_id": _customer_id,
        "vehicle_id": vehicle_id
      });
      var _response = await _dio.post(_url + "vehicle/save",
          data: formData,
          options: dio.Options(
            headers: {'Authorization': 'Bearer ' + token!},
          ));
      print(_response.data);
      // var uri = Uri.parse(BaseUrl.url + "vehicle/save");
      // // open a bytestream
      // var stream =
      //     new http.ByteStream(DelegatingStream.typed(picture.openRead()));
      // // get file length
      // var length = await picture.length();
      // var request = await http.MultipartRequest("POST", uri);
      // request.headers.addAll({
      //   'Authorization': 'Bearer ' + token!,
      // });
      // var multipartFile = new http.MultipartFile(
      //     'vehicle_photo_url', picture.openRead(), length);
      // request.files.add(multipartFile);
      // request.fields['vehicle_name'] = vehicle_name;
      // request.fields['police_number'] = police_number;
      // request.fields['vehicle_id'] = vehicle_id;
      // request.fields['customer_id'] = _customer_id;
      // http.Response _response =
      //     await http.Response.fromStream(await request.send());
      var _data = _response.data;
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

  Future<Map> getCompany() async {
    String? token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _result;
      var _response = await _client.post(_url + "getCompanyList",
          headers: {'Authorization': 'Bearer ' + token!});
      final _data = jsonDecode(_response.body);
      if (_data['data'].length > 0) {
        _result = {"result": true, "data": _data['data']};
      } else {
        _result = {"result": false, "message": "No company list"};
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
