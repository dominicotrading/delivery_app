// ignore_for_file: depend_on_referenced_packages

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marocsie/app/data/controllers/main_controller.dart';
import 'package:marocsie/app/data/providers/fcm_controller.dart';
import 'package:marocsie/app/data/providers/notification_controller.dart';
import 'package:marocsie/app/routes/app_routes.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/translations/app_translations.dart';
import 'package:marocsie/app/data/controllers/language_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (kDebugMode) {
    print("Handling a background message Data in Data: ${message.data}");
  }

  // NotificationLifeCycle notificationLifeCycle =
  //     await AwesomeNotifications().getAppLifeCycle();

  // Map<String, dynamic> messageData = jsonDecode(message.data['data']);

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationController.initializeLocalNotifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FcmController().listenFCM();
  await GetStorage.init(); // Initialize storage
  
  Get.put(LanguageController()); // Initialize language controller
  runApp(MyApp());
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyAppController());
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }  

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Forward the lifecycle state to the controller
    Get.find<MyAppController>().didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Marocsie Delivery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primarySwatchColor),
        useMaterial3: true,
        fontFamily: 'lato',
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme)
      ),
      translations: AppTranslations(), // Add translations
      locale: Get.find<LanguageController>().language == 'en_US' 
          ? const Locale('en', 'US')
          : const Locale('am', 'ET'),
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: '/',
      getPages: AppRoutes.routes,
      initialBinding: AppBindings()
    );
  }
}
 