
import 'package:dio/dio.dart';

import '../utils/constants.dart';
import 'api_client.dart';

final apiClient = RestClient(Dio());

Dio setupDioHeaders() {
  final dio = Dio();
  dio.options.headers = {
    "Platform": Constant.PLATFORM,
    "App-Id": Constant.APP_ID,
  };
  return dio;
}