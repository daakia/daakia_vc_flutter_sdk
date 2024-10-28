import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/constants.dart';
import 'api_client.dart';

final apiClient = RestClient(setDioWithLog());

Dio setupDioHeaders() {
  final dio = Dio();
  dio.options.headers = {
    "Platform": Constant.PLATFORM,
    "App-Id": Constant.APP_ID,
  };
  return dio;
}

Dio setDioWithLog() {
  final dio = Dio();
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: kDebugMode,
      filter: (options, args) {
        // don't print requests with uris containing '/posts'
        if (options.path.contains('/posts')) {
          return false;
        }
        // don't print responses with unit8 list data
        return !args.isResponse || !args.hasUint8ListData;
      }));
  return dio;
}
