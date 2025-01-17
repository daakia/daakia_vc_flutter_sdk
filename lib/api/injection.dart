import 'package:daakia_vc_flutter_sdk/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'api_client.dart';

final apiClient = RestClient(setDio());

final apiClientTranslate = RestClient(setTranslateDio());

Dio setDio() {
  final dio = Dio();
  dio.options.baseUrl = Constant.RELEASE
      ? 'https://api.daakia.co.in/v2.0/'
      : 'https://stag-api.daakia.co.in/v2.0/';
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: !Constant.RELEASE,
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

Dio setTranslateDio() {
  final dio = Dio();
  dio.options.baseUrl = Constant.RELEASE
      ? 'https://translation-api.daakia.co.in/'
      : 'https://stg-translation-api.daakia.co.in/';
  dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
      enabled: !Constant.RELEASE,
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
