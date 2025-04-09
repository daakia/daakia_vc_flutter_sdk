import 'package:daakia_vc_flutter_sdk/utils/constants.dart';
import 'package:dio/dio.dart';

import '../model/base_response.dart';
import 'api_client.dart';

final apiClient = RestClient(setDio());

Dio setDio() {
  final dio = Dio();
  dio.options.baseUrl = 'https://api.daakia.co.in/v2.0/';
  return dio;
}

/// Generic API request handler
Future<void> networkRequestHandler<T>({
  required Future<BaseResponse<T>> Function() apiCall,
  Function(T?)? onSuccess,
  Function(String)? onError,
}) async {
  try {
    final response = await apiCall();
    if (response.success == Constant.successResCheckValue) {
      onSuccess?.call(response.data);
    } else {
      onError?.call(response.message ?? "Unknown error occurred.");
    }
  } on DioException catch (dioError) {
    // Handling network or API request errors
    onError?.call(_getDioErrorMessage(dioError));
  } catch (e) {
    // Generic error fallback
    onError?.call("Unexpected error: ${e.toString()}");
  }
}

/// Generic API request handler with message
Future<void> networkRequestHandlerWithMessage<T>({
  required Future<BaseResponse<T>> Function() apiCall,
  Function(BaseResponse<T>?)? onSuccess, // Pass full response
  Function(String)? onError,
}) async {
  try {
    final response = await apiCall();
    if (response.success == Constant.successResCheckValue) {
      onSuccess?.call(response); // Pass full response
    } else {
      onError?.call(response.message ?? "Unknown error occurred.");
    }
  } catch (e) {
    onError?.call("Unexpected error: ${e.toString()}");
  }
}


/// Parses Dio errors into readable messages
String _getDioErrorMessage(DioException dioError) {
  switch (dioError.type) {
    case DioExceptionType.connectionTimeout:
      return "Connection timeout. Please try again.";
    case DioExceptionType.sendTimeout:
      return "Request timed out. Please try again.";
    case DioExceptionType.receiveTimeout:
      return "Server took too long to respond.";
    case DioExceptionType.badResponse:
      return "Server error: ${dioError.response?.statusCode} - ${dioError.response?.statusMessage}";
    case DioExceptionType.cancel:
      return "Request was cancelled.";
    case DioExceptionType.unknown:
    default:
      return "An unexpected error occurred.";
  }
}
