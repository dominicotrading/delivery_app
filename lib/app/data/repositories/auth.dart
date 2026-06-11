import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:marocsie/app/data/models/user.dart';
import 'package:mime_type/mime_type.dart';
import 'package:marocsie/app/data/models/dashboard.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/utils/api_helpers.dart';
import 'package:marocsie/app/utils/dio_exceptions.dart';

class AuthRepository {
  static String baseUrl = ApiHelpers.hostUrl;
    final StorageService storage = StorageService();

  Map<String, dynamic> responseData = {};


  Future updateAccount(userInfo) async {
    try {
      print("userInfo: ${userInfo}");
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };
      final response = await ApiHelpers.dio
          .put("/api/v1/auth/profile/update/", data: jsonEncode(userInfo));

      return responseData = {
        "error": false,
        "message": response.data["message"]
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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

 
  Future updateProfileImage(docsInfo) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Content-Type": "multipart/form-data",
        "Authorization": "Bearer ${storage.readData("accessToken")}",
      };

      String fileName = docsInfo["profile_image"].path.split('/').last;
      String? mimeType = mime(fileName);
      String? mimee = mimeType?.split('/')[0];
      String type = mimeType!.split('/')[1];

      FormData formData = FormData.fromMap({
        "profile_image": await MultipartFile.fromFile(
            docsInfo['profile_image'].path,
            filename: fileName,
            contentType: MediaType(mimee!, type)),
      });

      final response = await ApiHelpers.dio
          .put("/api/v1/auth/profile/image/", data: formData);
      print("response ${response.data}");
      return responseData = {
        "error": false,
        "profile_image": response.data['profile_image'],
        "message": response.data["message"]
      };
    } on DioError catch (e) {
      print("Error response ${e.response}");

      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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

  Future resendOTP() async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      final response = await ApiHelpers.dio.get(
          "/api/auth/resend-otp/${storage.readData("user-id")}/");

      return responseData = {
        "userId": response.data["data"]["user_id"],
        "error": false,
        "message": response.data["message"]
      };
    } on DioError catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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

  Future login(phoneNumber) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      final response = await ApiHelpers.dio.get("/api/v1/auth/otp-auth/$phoneNumber/");
      return responseData = {
        "userId": response.data["userid"],
        "error": false,
        "phonenumber": response.data["phone_number"],
        "message": response.data["message"]
      };
    } on DioException catch (e) { 
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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

  Future verifyAccount(otp, phoneNumber) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      final formdata = {
        "otp": otp,
        "userid": storage.readData("user-id")
      };
      print("formdata $formdata");
      print("Sending phonenumber: $phoneNumber");
      final response = await ApiHelpers.dio.post("/api/v1/auth/otp-auth/$phoneNumber/", data: formdata);
      print("Verify OTP Response: $response");
      return responseData = {"accessToken": response.data["access_token"],
        "userId": response.data["user_id"],
        "full_name": '${response.data["first_name"]} ${response.data["last_name"]}',
        "phone_number": response.data["phone_number"],
        'avatar':response.data["profile_image"],
        "error": false,
      };
    } on DioException catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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

 

Future getCurrentUser() async {
  // List<ClientInfo> myclients = [];
  // var myClients = [];
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };
      final response = await ApiHelpers.dio.get("/api/v1/auth/profile/");
      print(" >>>>>>>>>>>>>>>>>>>>>>>>>>>Current User ${response.data}");
      if (response.statusCode == 200 && response.data != null) {
        return {'error':false,'data':currentUserFromJson(response.data)}; // Ensure it's a JSON string if needed
      }

      return {"error": true, "message": "Unexpected response from server"};
       
    } on DioException catch (e) {
      print("get dashboard profile in service error: $e -------------------------------------------------------------------");
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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



  Future deleteAccount() async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };
      final response = await ApiHelpers.dio.delete("/api/auth/delete/");
      return responseData = {
        "error": false,
        "message": response.data["message"]
      };
    } on DioError catch (e) {
      if (e.response != null) {
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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
 

  Future getDashboardCount() async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;
      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storage.readData("accessToken")}"
      };
      final response = await ApiHelpers.dio.get("/api/v1/product/report/today/");
      print("get dashboard count response: ${response.headers}");
      print("get dashboard count response: ${response.statusCode}");
      print("get dashboard count response: ${response.requestOptions.uri}");
      print("get dashboard count response: ${response.requestOptions.headers}");
      print("get dashboard count response: ${response.data}");
      if (response.statusCode == 200 && response.data != null) {
       final dashboardData = DeliveryDashboard.fromJson(response.data);
        return {'error':false,'data':dashboardData}; // Ensure it's a JSON string if needed
      }

      return {"error": true, "message": "Unexpected response from server"};
       
    } on DioException catch (e) {
      if (e.response != null) {
        print("get dashboard count error: ${e.response?.headers}");
        print("get dashboard count status code: ${e.response?.statusCode}");
        print("get dashboard count uri: ${e.response?.requestOptions.uri}");
        print("get dashboard count headers: ${e.response?.requestOptions.headers}");
        print("get dashboard count data: ${e.response?.data}");
        return responseData = {
          "error": true,
          "message": e.response?.data["message"].toString()
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
}
