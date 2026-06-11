import 'dart:io';
import 'package:dio/dio.dart';
import 'package:marocsie/app/data/models/customer.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/utils/api_helpers.dart';
import 'package:marocsie/app/utils/dio_exceptions.dart';

class CustomerRepository {
  static String baseUrl = ApiHelpers.hostUrl;
  final StorageService storage = StorageService();

  Map<String, dynamic> responseData = {};

  // Helper method to set headers
  void _setHeaders() {
    ApiHelpers.dio.options.contentType = Headers.jsonContentType;
    ApiHelpers.dio.options.headers = {
      "Authorization": "Bearer ${storage.readData("accessToken")}"
    };
  }

  // Helper method to handle Dio errors
  Map<String, dynamic> _handleDioError(DioException e) {
    if (e.response != null) {
      return {
        "error": true,
        "message": e.response?.data["message"].toString() ?? "Something went wrong",
      };
    } else {
      final errorMessage = DioExceptions.fromDioError(e).toString();
      return {
        "error": true,
        "message": errorMessage,
      };
    }
  }

  // Register a new customer
  Future<Map<String, dynamic>> registerCustomer(Customer customer, File? imageFile, List<File>? additionalFiles) async {
    try {
      _setHeaders();
      
      // Prepare form data
      Map<String, dynamic> formData = customer.toJson();
      
      // Remove fields that shouldn't be sent to the API
      formData.remove('id');
      formData.remove('created_at');
      formData.remove('updated_at');
      formData.remove('profile_image'); // We'll handle this separately

      // Use FormData for multipart request with image
      var dio = ApiHelpers.dio;
      dio.options.contentType = Headers.multipartFormDataContentType;
      
      var requestFormData = FormData.fromMap(formData);
      
      // Add the image file if present
      if (imageFile != null) {
        requestFormData.files.add(MapEntry(
          'profile_image',
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ));
      }
      
      // Add additional files if present
      if (additionalFiles != null && additionalFiles.isNotEmpty) {
        for (int i = 0; i < additionalFiles.length; i++) {
          File file = additionalFiles[i];
          String filename = file.path.split('/').last;
          
          // Add the file
          requestFormData.files.add(MapEntry(
            'additional_files[$i][file]',
            await MultipartFile.fromFile(
              file.path,
              filename: filename,
            ),
          ));
          
          // Add filename metadata
          requestFormData.fields.add(MapEntry(
            'additional_files[$i][filename]',
            filename,
          ));
          
          // Add file type metadata
          String fileExtension = filename.split('.').last.toLowerCase();
          requestFormData.fields.add(MapEntry(
            'additional_files[$i][file_type]',
            fileExtension,
          ));
        }
      }
      print('Request form data: $requestFormData');
      final response = await dio.post(
        "/api/v1/customers/create/",
        data: requestFormData,
      );
      print('Response from customer registration: ${response.data}');
      return {
        "error": false,
        "message": response.data["message"] ?? "Customer registered successfully",
        "data": Customer.fromJson(response.data["data"] ?? response.data),
      };
    } on DioException catch (e) {
      print('Error from customer registration: ${e.response?.data}');
      return _handleDioError(e);
    } catch (e) {
      return {
        "error": true,
        "message": "Something went wrong: $e",
      };
    }
  }

  // Get all subcities
  Future<Map<String, dynamic>> getSubcities() async {
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.get("/api/v1/customers/subcities/");
      print('Subcity response: ${response.data}');
      
      // Handle different API response formats
      List<dynamic> subcitiesList = [];
      
      if (response.data["subcities"] != null) {
        // Format: {success: true, subcities: [...]}
        subcitiesList = response.data["subcities"];
      } else if (response.data["data"] != null) {
        // Format: {error: false, data: [...]}
        subcitiesList = response.data["data"];
      } else if (response.data["results"] != null) {
        // Format: {results: [...]}
        subcitiesList = response.data["results"];
      }
      
      // Convert to LocationData objects
      List<LocationData> locationDataList = subcitiesList
          .map((item) => LocationData.fromJson(item))
          .toList();
      
      print('Parsed subcities: $locationDataList');
      
      return {
        "error": false,
        "data": locationDataList,
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      print('Error parsing subcities: $e');
      return {
        "error": true,
        "message": "Failed to fetch subcities: $e",
      };
    }
  }

  // Get woredas by subcity
  Future<Map<String, dynamic>> getWoredasBySubcity(int subcityId) async {
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.get("/api/v1/customers/subcities/$subcityId/woredas/");
      print('Woreda response for subcity $subcityId: ${response.data}');

      // Handle different API response formats
      List<dynamic> woredasList = [];
      
      if (response.data["woredas"] != null) {
        woredasList = response.data["woredas"];
      } else if (response.data["data"] != null) {
        woredasList = response.data["data"];
      } else if (response.data["results"] != null) {
        woredasList = response.data["results"];
      }
      
      // Convert to LocationData objects
      List<LocationData> locationDataList = woredasList
          .map((item) => LocationData.fromJson(item))
          .toList();
      
      print('Parsed woredas: $locationDataList');
      
      return {
        "error": false,
        "data": locationDataList,
      };
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      print('Error parsing woredas: $e');
      return {
        "error": true,
        "message": "Failed to fetch woredas: $e",
      };
    }
  }

  // Get Ketenas by woreda
  Future<Map<String, dynamic>> getKetenasByWoreda(int woredaId) async {
    print("::::::::::::::::::::::::::::::::::::::::::: $woredaId");
    try {
      print("Before Header: <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<::::::::::::::::::::::::::::>>>>>>>>>>>>");
      _setHeaders();
      print("After Header: <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<::::::::::::::::::::::::::::>>>>>>>>>>>>");
      final response = await ApiHelpers.dio.get("/api/v1/customers/woredas/$woredaId/ketenas/");
      print("AFter Response: <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<::::::::::::::::::::::::::::>>>>>>>>>>>>");
      print('Ketena response for woreda $woredaId: ${response.data}');

      // Handle different API response formats
      List<dynamic> ketenaList = [];
      
      if (response.data["ketenas"] != null) {
        ketenaList = response.data["ketenas"];
      } else if (response.data["data"] != null) {
        ketenaList = response.data["data"];
      } else if (response.data["results"] != null) {
        ketenaList = response.data["results"];
      }
      
      // Convert to LocationData objects
      List<LocationData> locationDataList = ketenaList
          .map((item) => LocationData.fromJson(item))
          .toList();
      
      print('Parsed blocks: $locationDataList');
      
      return {
        "error": false,
        "data": locationDataList,
      };
    } on DioException catch (e) {
      print("DioException<><><><><>: <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<::::::::::::::::::::::::::::>>>>>>>>>>>>: $e");

      return _handleDioError(e);
    } catch (e) {
      print('Error parsing blocks: $e');
      return {
        "error": true,
        "message": "Failed to fetch blocks: $e",
      };
    }
  }

  // Get blocks by woreda
  Future<Map<String, dynamic>> getBlocksByKetena(int ketenaId) async {
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.get("/api/v1/customers/ketenas/$ketenaId/blocks/");
      print('Block response for ketena $ketenaId: ${response.data}');

      // Handle different API response formats
      List<dynamic> blocksList = [];
      
      if (response.data["blocks"] != null) {
        blocksList = response.data["blocks"];
      } else if (response.data["data"] != null) {
        blocksList = response.data["data"];
      } else if (response.data["results"] != null) {
        blocksList = response.data["results"];
      }
      
      // Convert to LocationData objects
      List<LocationData> locationDataList = blocksList
          .map((item) => LocationData.fromJson(item))
          .toList();
      
      print('Parsed blocks: $locationDataList');
      
      return {
        "error": false,
        "data": locationDataList,
      };
    } on DioException catch (e) {
      print("DioException<><><><><Block>: <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<::::::::::::::::::::::::::::>>>>>>>>>>>>: $e");
      return _handleDioError(e);
    } catch (e) {
      print('Error parsing blocks: $e');
      return {
        "error": true,
        "message": "Failed to fetch blocks: $e",
      };
    }
  }

  // Get all customers
  Future<Map<String, dynamic>> getCustomers({int page = 1, int pageSize = 10}) async {
    try {
      _setHeaders();
      final response = await ApiHelpers.dio.get(
        "/api/v1/customers/list/?page=$page&page_size=$pageSize",
      );
      
      print('Customers list response: ${response.data}');

      // Handle the new API response format
      if (response.data["success"] == true && response.data["customers"] != null) {
        List<CustomerData> customers = (response.data["customers"] as List<dynamic>)
            .map((item) => CustomerData.fromJson(item))
            .toList();
            
        // Extract pagination info
        Map<String, dynamic> pagination = response.data["pagination"] ?? {};
        
        return {
          "error": false,
          "data": customers,
          "pagination": pagination,
        };
      } else {
        return {
          "error": true,
          "message": "Invalid response format from server",
        };
      }
    } on DioException catch (e) {
      print('Error fetching customers: ${e.response?.data}');
      return _handleDioError(e);
    } catch (e) {
      return {
        "error": true,
        "message": "Failed to fetch customers: $e",
      };
    }
  }
}
