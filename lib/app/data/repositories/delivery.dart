// ignore_for_file: prefer_interpolation_to_compose_strings

import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/utils/api_helpers.dart';
import 'package:marocsie/app/utils/dio_exceptions.dart';

class DeliveryRepository {
  static String baseUrl = ApiHelpers.hostUrl;
  final StorageService storage = StorageService();
  Map<String, dynamic> responseData = {};

  /// Fetch delivery schedules with pagination
  Future<Map<String, dynamic>> getDeliverySchedules({
    int page = 1,
    int pageSize = 10,
    String? status,
    String? date,
  }) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };

      // Build query parameters
      Map<String, dynamic> queryParams = {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      if (date != null && date.isNotEmpty) {
        queryParams['date'] = date;
      }

      final response = await ApiHelpers.dio.get(
        "/api/v1/product/deliveries/",
        queryParameters: queryParams,
      );

      final deliveryResponse = DeliveryResponse.fromJson(response.data);
      final paginationInfo = PaginationInfo.fromResponse(deliveryResponse);

      return responseData = {
        "error": false,
        "data": deliveryResponse,
        "pagination": paginationInfo,
        "message": "Delivery schedules fetched successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to fetch delivery schedules"
        };
      } else {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return responseData = {
          "error": true,
          "message": errorMessage.toString(),
        };
      }
    }
  }

  /// Fetch delivery schedule by ID
  Future<Map<String, dynamic>> getDeliveryScheduleById(int id) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };

      final response = await ApiHelpers.dio.get(
        "/api/v1/product/delivery-schedules/$id/",
      );

      final deliverySchedule = DeliverySchedule.fromJson(response.data);

      return responseData = {
        "error": false,
        "data": deliverySchedule,
        "message": "Delivery schedule fetched successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to fetch delivery schedule"
        };
      } else {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return responseData = {
          "error": true,
          "message": errorMessage.toString(),
        };
      }
    }
  }

  /// Update delivery schedule status
  Future<Map<String, dynamic>> updateDeliveryStatus(
    int id, 
    String status, 
    {String? notes}
  ) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };

      Map<String, dynamic> updateData = {
        "status": status,
      };

      if (notes != null && notes.isNotEmpty) {
        updateData["notes"] = notes;
      }

      final response = await ApiHelpers.dio.patch(
        "/api/v1/product/delivery-schedules/$id/",
        data: jsonEncode(updateData),
      );

      final updatedDelivery = DeliverySchedule.fromJson(response.data);

      return responseData = {
        "error": false,
        "data": updatedDelivery,
        "message": "Delivery status updated successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to update delivery status"
        };
      } else {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return responseData = {
          "error": true,
          "message": errorMessage.toString(),
        };
      }
    }
  }

  /// Confirm delivery with QR code
  Future<Map<String, dynamic>> confirmDeliveryWithQR(
    int deliveryId,
    String qrCode, {
    List<Map<String, dynamic>>? selectedItems,
    double? locationX,
    double? locationY,
    String? paymentMethod,
  }) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}" 
      };

      final data = {
        "delivery_id": deliveryId,
        "qr_code": qrCode,
      };
      if (selectedItems != null) {
        data["items"] = selectedItems
            .map((item) => {
                  "id": item["id"],
                  "quantity": int.tryParse(item["quantity"].toString()) ?? 1,
                })
            .toList();
      }
      if (locationX != null) data["location_x"] = locationX;
      if (locationY != null) data["location_y"] = locationY;
      if (paymentMethod != null) data["payment_method"] = paymentMethod;
      print("Request Data to confirm delivery with QR: $data");
      final response = await ApiHelpers.dio.post(
        "/api/v1/product/deliveries/$deliveryId/confirm_delivery_qr/",
        data: data,
      );

      return responseData = {
        "error": false,
        "data": response.data,
        "message": "Delivery confirmed successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to confirm delivery"
        };
      } else {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return responseData = {
          "error": true,
          "message": errorMessage.toString(),
        };
      }
    }
  }

  /// Confirm delivery with SMS OTP
  Future<Map<String, dynamic>> confirmDeliveryWithSMS(
    int deliveryId,
    String otp, {
    List<Map<String, dynamic>>? selectedItems,
    double? locationX,
    double? locationY,
    String? paymentMethod,
  }) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}" 
      };

      final Map<String, dynamic> data = {
        "delivery_id": deliveryId,
        "sms_code": otp,
      };

      if (selectedItems != null) {
        data["items"] = selectedItems
            .map((item) => {
                  "id": item["id"],
                  "quantity": int.tryParse(item["quantity"].toString()) ?? 1,
                })
            .toList();
      }
      if (locationX != null) data["location_x"] = locationX;
      if (locationY != null) data["location_y"] = locationY;
      if (paymentMethod != null) data["payment_method"] = paymentMethod;
      print("Request Data to confirm delivery with SMS: $data");
      final response = await ApiHelpers.dio.post(
        "/api/v1/product/deliveries/$deliveryId/confirm_delivery_sms_code/",
        data: data,
      );

      return responseData = {
        "error": false,
        "data": response.data,
        "message": "Delivery confirmed successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to confirm delivery"
        };
      } else {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return responseData = {
          "error": true,
          "message": errorMessage.toString(),
        };
      }
    }
  }

  /// Send SMS OTP for delivery confirmation
  Future<Map<String, dynamic>> sendDeliveryOTP(int deliveryId) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };

      final response = await ApiHelpers.dio.post(
        "/api/v1/product/deliveries/$deliveryId/create_delivery_code/",
      );

      return responseData = {
        "error": false,
        "data": response.data,
        "message": "OTP sent successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to send OTP"
        };
      } else {
        final errorMessage = DioExceptions.fromDioError(e).toString();
        return responseData = {
          "error": true,
          "message": errorMessage.toString(),
        };
      }
    }
  }

  /// Fetch deliveries for a given schedule
  Future<Map<String, dynamic>> getDeliveriesForSchedule({
    required int scheduleId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer "+storage.readData("accessToken")
      };
      final response = await ApiHelpers.dio.get(
        "/api/v1/product/deliveries/$scheduleId/deliveries/",
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
        },
      );
      return {
        "error": false,
        "data": DeliveryListResponse.fromJson(response.data),
        "message": "Deliveries fetched successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to fetch deliveries"
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

  /// Fetch blocks for a given delivery schedule
  Future<Map<String, dynamic>> getBlocksForSchedule(int scheduleId) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };

      final response = await ApiHelpers.dio.get(
        "/api/v1/customers/delivery-schedules/$scheduleId/blocks/",
      );
      print(response.data);

      // Parse the response data
      List<dynamic> blocksData = response.data;
      List<BlockData> blocks = [];
      blocksData.forEach((block) {
        blocks.add(BlockData.fromJson(block));
      });

      return {
        "error": false,
        "data": blocks,
        "message": "Blocks fetched successfully"
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return {
          "error": true,
          "message": e.response?.data["message"]?.toString() ?? "Failed to fetch blocks"
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