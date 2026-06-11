
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/data/providers/fcm_controller.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/global/constants.dart';
class MyAppController extends GetxController with WidgetsBindingObserver {
  // Add your observable variables and methods here
  final storageService = StorageService();
  late StreamSubscription connSubscription;

  @override
  void onInit() {
    super.onInit();
    FirebaseMessaging.instance.getInitialMessage().then(
        (message) => {
          if(message != null)FcmController().handleFcmNotificationAction(message)
        });
    WidgetsBinding.instance.addObserver(this); // Add observer for lifecycle events
    if (!appInBg) {
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    connSubscription.cancel();
    super.onClose();
  }

  // Add other lifecycle methods if needed


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    final isResumed = state == AppLifecycleState.resumed;
    final isOnBackground = state == AppLifecycleState.paused;
    if (isOnBackground) {
        appInBg = true;
    }

    if (isResumed) {
        appInBg = false;
    }
  }



 
 


}