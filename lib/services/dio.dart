// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:dio/dio.dart';

Dio dio() {
  Dio dio = new Dio();
  print(dio);
// Set default configs
  dio.options.baseUrl = 'http://192.168.18.10/vehiclecare/public/api';
  // dio.options.connectTimeout = 5000; //5s
  // dio.options.receiveTimeout = 3000;

  dio.options.headers['accept'] = 'Application/Json';

  return dio;
}
