import 'package:get/get.dart';
import 'package:marocsie/app/modules/delivery/delivery_screen.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:marocsie/app/data/providers/fcm_controller.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/modules/notification/notification_screen.dart';
import 'package:marocsie/app/modules/root/controllers/root_controller.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/modules/home/home_screen.dart';
import 'package:marocsie/app/modules/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marocsie/app/utils/sizes.dart';

class MarocsieRootScreen extends StatefulWidget {
  static const String routeName = '/root-screen';

  const MarocsieRootScreen({super.key});

  @override
  State<MarocsieRootScreen> createState() => _MarocsieRootScreenState();
}

class _MarocsieRootScreenState extends State<MarocsieRootScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final StorageService _storageService = StorageService();
  final NavController navController =
      Get.put(NavController()); // Initialize the controller

  handlePermission() async {
    var permissionStatus = await Permission.notification.status;

    if (!permissionStatus.isGranted) {
      await Permission.notification.request();
    }
  }

  @override
  void initState() {
    if (_storageService.readData("registered") ?? false == false) {
      FcmController().getToken();
      FcmController().registerDevice();
    }
    handlePermission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        backgroundColor: lightColor,
        appBar:  AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  navController.page.value == 0 ? "app_name".tr : navController.page.value == 1 ? "my_deliveries".tr :  "my_profile".tr,
                  style: darkSubTitleStyle(FontWeight.bold),
                ),
                centerTitle: false,
                actions: [
                  IconButton(
                    icon: Icon(Iconsax.notification,color: darkColor,),
                    onPressed: () => Get.toNamed(NotificationScreen.routeName),
                  ),
                  SizedBox(
                    width: screenWidth * 0.01,
                  )
                ],
              ),
        body: navController.page.value == 0
                ? HomeScreen()
                : navController.page.value == 1
                    ? DeliveriesListPage()
                    : navController.page.value == 2                     
                            ? ProfileScreen()
                            : Center(
                                child: Text(
                                    'you are at ${navController.page.value}'),
                              ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              currentIndex: navController.page.value,
              onTap: navController.changeIndex,
              selectedItemColor: primaryColor,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 12),
              showUnselectedLabels: true,
              items: [
                BottomNavigationBarItem(
                  icon: _NavBarIcon(
                    icon: Icons.home_outlined,
                    isActive: navController.page.value == 0,
                  ),
                  activeIcon: _NavBarIcon(
                    icon: Icons.home,
                    isActive: true,
                  ),
                  label: 'home'.tr,
                ),
                BottomNavigationBarItem(
                  icon: _NavBarIcon(
                    icon: Icons.calendar_month_outlined,
                    isActive: navController.page.value == 1,
                  ),
                  activeIcon: _NavBarIcon(
                    icon: Icons.calendar_month,
                    isActive: true,
                  ),
                  label: 'deliveries'.tr,
                ),
                BottomNavigationBarItem(
                  icon: _NavBarIcon(
                    icon: Icons.person_outlined,
                    isActive: navController.page.value == 3,
                  ),
                  activeIcon: _NavBarIcon(
                    icon: Icons.person,
                    isActive: true,
                  ),
                  label: 'my_profile'.tr,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBarIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  const _NavBarIcon({required this.icon, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          icon,
          size: 28,
          color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey,
        ),
        if (isActive)
          Positioned(
            bottom: 0,
            child: Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
      ],
    );
  }
}
