import 'package:dio/dio.dart';
import 'api_client.dart';

final apiClient = RestClient(setDio());

Dio setDio() {
  final dio = Dio();
  dio.options.baseUrl = 'https://stag-api.daakia.co.in/v2.0/';
  return dio;
}
