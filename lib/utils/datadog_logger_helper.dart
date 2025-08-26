import 'package:daakia_vc_flutter_sdk/service/daakia_vc_datadog_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

enum DatadogLogLevel { debug, info, warn, error }

class DatadogLoggerHelper {
  static void saveDatadogLog({
    required DatadogLogLevel level,
    required String message,
    required RequestOptions? requestOptions,
    required DioException? dioException,
    dynamic payload,
  }) {

    if (message.isEmpty) message = "Something";

    final data = <String, Object?>{
      'endpoint': requestOptions?.path,
      'method': requestOptions?.method,
      if (payload != null) 'payload': payload,
      if (dioException?.response?.data != null) 'response': dioException?.response?.data,
    };

    try {
      switch (level) {
        case DatadogLogLevel.debug:
          DaakiaVcDatadogService.logDebug(message, attributes: data);
          break;
        case DatadogLogLevel.info:
          DaakiaVcDatadogService.logInfo(message, attributes: data);
          break;
        case DatadogLogLevel.warn:
          DaakiaVcDatadogService.logWarning(message, attributes: data);
          break;
        case DatadogLogLevel.error:
          DaakiaVcDatadogService.logError(message, dioException, dioException?.stackTrace, data);
          break;
      }
    } catch (error) {
      debugPrint("Datadog fallback log [$level]: $message - $data");
    }
  }
}
