// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioError dioError) {
    print("Dio Request URI:............... ${dioError.requestOptions.uri}");
    switch (dioError.type) {
      case DioErrorType.cancel:
        message = "Your request was cancelled";
        break;
      case DioErrorType.connectionTimeout:
        message = "Connection timeout please connect to the internet";
        break;
      case DioErrorType.unknown:
        message = "Connection failed please connect to the internet";
        break;
      case DioErrorType.receiveTimeout:
        message = "Receive timeout please connect to the internet";
        break;
      case DioErrorType.badResponse:
        message = _handleError(
            dioError.response!.statusCode!, dioError.response!.data);
        break;
      case DioErrorType.sendTimeout:
        message = "Send timeout due to internet connection";
        break;
      default:
        message = "Something went wrong, contact support team";
        break;
    }
  }

  late String message;

  String _handleError(int statusCode, dynamic error) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 404:
        return error["message"];
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message;
}
