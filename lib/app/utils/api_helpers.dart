import 'package:dio/dio.dart';

class ApiHelpers {
  static const String transportsHeader = 'transports';
  static const String webSocketOption = 'websocket';
  static const String pollingOption = 'polling';

  static String hostUrl = "https://marocsie.dominicotrading.com";
  // static String hostUrl = "http://192.168.188.105:8000";

  static BaseOptions dioOptions = BaseOptions(
      baseUrl: hostUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 40), // 10 seconds
      receiveTimeout: const Duration(seconds: 60) // 10 seconds
      );
  static Dio dio = Dio(dioOptions);
}

class FcmApiHelpers {
  static const String transportsHeader = 'transports';
  static const String webSocketOption = 'websocket';
  static const String pollingOption = 'polling';
  static String hostUrl = "https://fcm.googleapis.com";

  static BaseOptions dioOptions = BaseOptions(
      baseUrl: hostUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 10), // 10 seconds
      receiveTimeout: const Duration(seconds: 10) // 10 seconds
      );
  static Dio dio = Dio(dioOptions);
}
