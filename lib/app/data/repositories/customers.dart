import 'package:dio/dio.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/utils/api_helpers.dart';
import 'package:marocsie/app/utils/dio_exceptions.dart';

class UserServices {
  final StorageService storageService = StorageService();

  // Helper method to set headers
  void _setHeaders() {
    ApiHelpers.dio.options.contentType = Headers.jsonContentType;
    ApiHelpers.dio.options.headers = {
      "Authorization": "Bearer ${storageService.readData("accessToken")}"
    };
  }

  // Helper method to handle Dio errors
  Map<String, dynamic> _handleDioError(DioException e) {
    print(e);
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
 
    Future<Map<String, dynamic>> searchDelivery(query) async {
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.get("/api/v1/product/deliveries/search_deliveries/?q=$query");
      print("searchDelivery response: ${response.data}");

      return {  
        "error": false,
        "data": DeliveryListResponse.fromJson(response.data),
      };
    } on DioException catch (e) {
      print("DioException something went wrong: $e");
      return _handleDioError(e);
    }
  }


  Future<Map<String, dynamic>> sendDeliveryNotification(formData) async {
    try {
      _setHeaders();

      final response = await ApiHelpers.dio.post(
        "/api/v1/customers/delivery-schedules/send-notifications-sms/",
        data: formData,
      );
      print(response.data);

      return {
        "error": false,
        "data": response.data,
        "message": "Delivery notification sent successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to send delivery notification"
        };
      } else {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return {
          "error": true,
          "message": errorMessage.toString(),
        };
      }
    }
  }
 
}