// lib/middleware/auth_middleware.dart
import 'package:get_storage/get_storage.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/modules/auth/sign_in.dart';
import 'package:marocsie/app/modules/root/root_screen.dart';

class AuthMiddleware extends GetMiddleware {

  final storageService = StorageService();

  @override
  RouteSettings? redirect(String? route) {
    // Example: Check if user is logged in
    // If not logged in, redirect to login page
    // bool isLoggedIn = storageService.readData('loggedIn') ?? false; // Replace with actual logic
    // if () {
    //   return const RouteSettings(name: SignInScreen.routeName);
    // }
    // return null;
      final box = GetStorage();

    print(">>>>>Login AuthMiddleWare Info: ${storageService.isFirstTime()}");
    print(">>>>>Login AuthMiddleWare Info with Box: ${box.read('isFirstTime')}");
    print(">>>>>Login AuthMiddleWare Info with Box: ${box.read('loggedIn')}");
    print(">>>>>Login AuthMiddleWare User Info with Box: ${box.read('full_name')}");

    // if (storageService.readData('isFirstTime')) {
    //   return RouteSettings(name: MarocsieLandingScreen.routeName);
    // } else 
    if (!storageService.isLoggedIn()) {
      return RouteSettings(name: SignInScreen.routeName);
    }
    return RouteSettings(name: MarocsieRootScreen.routeName);
  }
}
