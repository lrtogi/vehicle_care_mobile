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

class JobService extends ChangeNotifier {
  Client _client = Client();
  Auth _auth = Auth();
  final storage = new FlutterSecureStorage();
  JobListModel jobListModel;

  Future searchJob(String company_id, String date, String vehicle_id) async {
    String token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "job/search", headers: {
        'Authorization': 'Bearer ' + token
      }, body: {
        'company_id': company_id,
        'date': date,
        'vehicle_id': vehicle_id
      });
      final _data = jsonDecode(_response.body);
      if (_data['result']) {
        this.jobListModel = JobListModel.fromJson(_data);
        this.notifyListeners();
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

  Future getWorkerJobList() async {
    String token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "job/getJob",
          headers: {'Authorization': 'Bearer ' + token});
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

  Future checkJob(String transaction_id) async {
    String token = await storage.read(key: 'token');
    var _url = BaseUrl.url;
    try {
      var _response = await _client.post(_url + "job/checkJob",
          headers: {'Authorization': 'Bearer ' + token},
          body: {'transaction_id': transaction_id});
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
