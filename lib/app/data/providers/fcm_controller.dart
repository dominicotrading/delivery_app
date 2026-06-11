// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:marocsie/app/data/providers/notification_controller.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/utils/api_helpers.dart';

class FcmController {
  StorageService storageService = StorageService();

  getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) async {
      print(token);
      storageService.saveData("fcmToken", token!);
    });
  }

  registerDevice() async {
    await getToken();
    String deviceType = "android";

    if (Platform.isAndroid) {
      deviceType = "android";
    } else if (Platform.isIOS) {
      deviceType = "ios";
    }
    final data = {
      "token": storageService.readData("fcmToken"),
      "device_type": deviceType,
    };
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;

      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storageService.readData("accessToken")}"
      };
      final response =
          await ApiHelpers.dio.post("/api/auth/add-device/", data: data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        storageService.saveData("registered", true);
      }
    } on DioException catch (e) {
      print(e);
    }
  }

  listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      
      Map<String, dynamic> messageData = jsonDecode(message.data['data']);
      print(messageData);
 

   if (messageData["payload_type"] == "profile-viewed") {
        NotificationController.showProfileNotification({
          'title': message.notification!.title,
          "body": message.notification!.body,
          'id': 3,
          'payload_type': messageData['payload_type'],
        });
      } else if (messageData["payload_type"] == "profile-liked") {
        NotificationController.showProfileNotification({
          'title': message.notification!.title,
          "body": message.notification!.body,
          'id': 2,
          'payload_type': messageData['payload_type'],
        });
      } else if (messageData["payload_type"] == "profile-shortlist") {
        NotificationController.showProfileNotification({
          'title': message.notification!.title,
          "body": message.notification!.body,
          'id': 15,
          'payload_type': messageData['payload_type'],
        });
      } else if (messageData["payload_type"] == "credit-transfered") {
        NotificationController.showProfileNotification({
          'title': message.notification!.title,
          "body": message.notification!.body,
          'id': 4,
          'payload_type': messageData['payload_type'],
        });
      } else if (messageData['payload_type'] == "ads") {
        NotificationController.showAdNotification({
          "title": message.notification!.title,
          "body": message.notification!.body,
          "ad_gif": message.notification!.android!.imageUrl
        });
      }else if(messageData['payload_type'] == "appointment-booked"){
        NotificationController.showProfileNotification({
      "id": 25,
      "title": message.notification!.title,
      "body": message.notification!.body,
      'payload_type': messageData['payload_type'],
    });
      }else if(messageData['payload_type'] == "appointment-replied"){
        NotificationController.showProfileNotification({
      "id": 25,
      "title": message.notification!.title,
      "body": message.notification!.body,
      'payload_type': messageData['payload_type'],
    });
      }else if(messageData['payload_type'] == "appointment-reminder"){
        NotificationController.showProfileNotification({
      "id": 96,
      "title": message.notification!.title,
      "body": message.notification!.body,
      'payload_type': messageData['payload_type'],
    });
      }else if(messageData['payload_type'] == "pill-reminder"){
        NotificationController.showProfileNotification({
      "id": 96,
      "title": message.notification!.title,
      "body": message.notification!.body,
      'payload_type': messageData['payload_type'],
    });
      }else if(messageData['payload_type'] == "prescription-created"){
        NotificationController.showProfileNotification({
      "id": 96,
      "title": message.notification!.title,
      "body": message.notification!.body,
      'payload_type': messageData['payload_type'],
    });}else if(messageData['payload_type'] == "appointment-rescheduled"){
        NotificationController.showProfileNotification({
      "id": 98,
      "title": message.notification!.title,
      "body": message.notification!.body,
      'payload_type': messageData['payload_type'],
    });}else if(messageData['payload_type'] == "appointment-cancelled"){
        NotificationController.showProfileNotification({
      "id": 98,
      "title": message.notification!.title,
      "body": message.notification!.body,
      'payload_type': messageData['payload_type'],
    });}
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      handleFcmNotificationAction(message);
    });
  }

  //handle firebase notification actions from background and terminated state.
  handleFcmNotificationAction(RemoteMessage message) {
    if (message.data.containsKey("data")) {
      Map<String, dynamic> messageData = jsonDecode(message.data['data']);
      if (messageData['payload_type'] == "chat-detail") {
        Map<String, dynamic> chatInfo = {
          '_id': messageData['senderInfo']["_id"].toString(),
          'code_name': messageData['senderInfo']["code_name"].toString(),
          'avatar': messageData['senderInfo']["avatar"].toString(),
          'is_online': true,
          'last_login': messageData['senderInfo']["last_login"].toString(),
          'userId': messageData['senderInfo']["userId"].toString(),
        };
      
      }
    }
  }

  getUserFcmDevice(userID) async {
    try {
      ApiHelpers.dio.options.contentType = Headers.jsonContentType;

      ApiHelpers.dio.options.headers = {
        "Authorization": "Bearer ${storageService.readData("accessToken")}"
      };
      final response = await ApiHelpers.dio.get("/api/auth/get-device/$userID");
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data['token'];
      }
    } on DioException catch (e) {
      return e.response!.statusMessage;
    }
  }

  sendPushMessage(sendto, Map<String, dynamic> message, notification) async {
    try {
      const urlPath = "/fcm/send";
      FcmApiHelpers.dio.options.contentType = Headers.jsonContentType;
      FcmApiHelpers.dio.options.headers = {
        "Authorization":
            "key=AAAAAswZLgc:APA91bE2yrRibAb7svEyBGvmUoh1vb3FLj-6fEPmqbzRFxlGJ2ZQsiMqH-IqYS4oEqKnLSDz1-FhiWwxtEVReNOjp4O6IvPnEIZieHPqp8PO6fcWSkUUjVZzGiQjfJ9tG1AQbV9wXBjN"
      };
      final response = await FcmApiHelpers.dio.post(
        urlPath,
        data: jsonEncode(
          <String, dynamic>{
            'notification': notification,
            'priority': 'high',
            'data': message,
            "to": sendto,
          },
        ),
      );
    } catch (e) {}
  }
}
