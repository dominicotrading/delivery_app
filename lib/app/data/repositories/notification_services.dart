// ignore_for_file: prefer_const_constructors

import 'package:dio/dio.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/utils/api_helpers.dart';
import 'package:marocsie/app/utils/dio_exceptions.dart';

class NotificationServices {
  // INapp notifications
  final storageService = StorageService();

    // Helper method to set headers
  void _setHeaders() {
    ApiHelpers.dio.options.contentType = Headers.jsonContentType;
    ApiHelpers.dio.options.headers = {
      "Authorization": "Bearer ${storageService.readData("accessToken")}"
    };
  }

  // Helper method to handle Dio errors
  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      return {
        "error": true,
        "message": e.response?.data["message"].toString(),
      };
    } else {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return {
        "error": true,
        "message": errorMessage,
      };
    }
  }

  Future getNotifications(pageNum) async {
    try {
     _setHeaders();
      final response = await ApiHelpers.dio.get(
        "/api/v1/notification/list/?page=$pageNum",
      );
      print("Response Data $response");
      return {"error": false, "data": response.data};
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future setUnseenNotificationStatus() async {
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.get(
        "/api/notify/unseen/",
      );
      print(response.data);
      if (response.data != null) {
        storageService.saveData("notify-unseen", response.data["unseen"]);
      } else {
        storageService.saveData("notify-unseen", false);
      }
    } on DioException {
      storageService.saveData("notify-unseen", false);
    }
  }

  Future getUnseenNotifications() async {
    print("unseen notifications requested===============================");
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.get(
        "/api/notify/unseen-count/",
      );
      return {"count": response.data["unseen"]};
    } on DioException catch (e) {
      return {"count": 0,"error": e.message};
    }
  }

  Future updateNotification(id) async {
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.post(
        "/api/v1/notification/mark-read/$id/",
      );

      return {
        "error": false,
        "data": response.data
      };
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }

  Future deleteNotification(id) async {
    try {
     _setHeaders();
      final response = await ApiHelpers.dio.post(
        "/api/v1/notification/delete/$id/",
      );

      return {
        "error": false,
        "message": response.data["message"]
      };
    } on DioException catch (e) {
      _handleDioError(e);
    }
  }
}
