// lib/routes/app_routes.dart
import 'package:flutter/material.dart';
import 'package:marocsie/app/modules/auth/otp_verification.dart';
import 'package:marocsie/app/modules/auth/sign_in.dart';
import 'package:marocsie/app/modules/customer/customer_registration_screen.dart';
import 'package:marocsie/app/modules/customer/customer_list_screen.dart';
import 'package:marocsie/app/modules/delivery/delivery_schedule_detail.dart';
import 'package:marocsie/app/modules/notification/notification_screen.dart';
import 'package:marocsie/app/modules/privacy_policy/privacy_policy_screen.dart';
import 'package:marocsie/app/modules/profile/profile_page.dart';
import 'package:marocsie/app/modules/profile/settings_page.dart';
import 'package:marocsie/app/modules/profile/about_us_page.dart';
import 'package:marocsie/app/modules/root/root_screen.dart';
import 'package:get/get.dart';
import 'package:marocsie/middleware/auth_middleware.dart'; 

class AppRoutes {

  static List<GetPage> routes = [
    GetPage(
          name: '/',
          page: () => Container(), // Dummy, middleware redirects
          middlewares: [AuthMiddleware()],
        ),
    GetPage(
      name: MarocsieRootScreen.routeName,
      page: () => const MarocsieRootScreen(),
    ),
    GetPage(
      name: SignInScreen.routeName,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: OtpVerificationScreen.routeName,
      page: () => OtpVerificationScreen(),
    ),
    GetPage(
      name: ProfileUpdateScreen.routeName,
      page: () => const ProfileUpdateScreen(),
    ),
    GetPage(
      name: ProfileSettingPage.routeName,
      page: () => const ProfileSettingPage(),
    ),
    GetPage(
      name: AboutUsPage.routeName,
      page: () => const AboutUsPage(),
    ), 
    GetPage(
      name: NotificationScreen.routeName,
      page: () =>  NotificationScreen(),
    ), 
    GetPage(name: PrivacyPolicyScreen.routeName, page: ()=> PrivacyPolicyScreen()),
    GetPage(
      name: DeliveryScheduleDetailPage.routeName,
      page: () => DeliveryScheduleDetailPage(delivery: Get.arguments),
    ),
    GetPage(
      name: CustomerRegistrationScreen.routeName,
      page: () => CustomerRegistrationScreen(),
    ),
    GetPage(
      name: CustomerListScreen.routeName,
      page: () => CustomerListScreen(),
    ),
  ];
}
