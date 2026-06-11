import 'package:cached_network_image/cached_network_image.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marocsie/app/modules/auth/controllers/auth_controller.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/modules/profile/controllers/profile_controller.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/api_helpers.dart';
import 'package:marocsie/app/utils/sizes.dart';
import 'package:marocsie/app/modules/profile/profile_page.dart';
import 'package:marocsie/app/modules/profile/settings_page.dart';
import 'package:marocsie/app/modules/profile/about_us_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController authController = Get.put(AuthController());
  final ProfileController profileController = Get.put(ProfileController());
  final storageService = StorageService();

  Future<void> _refreshProfile() async {
    await profileController.fetchCurrentUser();
    setState(() {}); // To update the UI if needed
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshProfile,
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Profile Header Card
              Card(
                color: whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      // Profile Image Section
                      Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryColor.withOpacity(0.2), width: 3),
                            ),
                            child: CircleAvatar(
                              radius: screenHeight * 0.045,
                              backgroundImage: CachedNetworkImageProvider(
                                storageService.readData('profile_image') != null ? ApiHelpers.hostUrl + storageService.readData('profile_image') : "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                              ),
                            ),
                          ), 
                        ],
                      ),
                      const SizedBox(width: 16),
                      // User Info Section
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              storageService.readData("full_name") ?? "Unknown User",
                              style: primarySubTitleStyle(FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: grayColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  storageService.readData("phone_number") ?? "251912345678",
                                  style: grayNormalTextStyle(FontWeight.normal),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: InkWell(
                                onTap: () => Get.toNamed(ProfileUpdateScreen.routeName),
                                child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 14,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'edit_profile'.tr,
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Profile Options Card
              Card(
                color: whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          CupertinoIcons.person,
                          color: primaryColor,
                        ),
                      ),
                      title: Text('my_profile'.tr, style: darkNormalTextStyle(FontWeight.bold)),
                      subtitle: Text('update_profile'.tr, style: grayNormalTextStyle(FontWeight.normal)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: 16),
                      onTap: () => Get.toNamed(ProfileUpdateScreen.routeName),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.settings,
                          color: primaryColor,
                        ),
                      ),
                      title: Text('settings'.tr, style: darkNormalTextStyle(FontWeight.bold)),
                      subtitle: Text('app_settings'.tr, style: grayNormalTextStyle(FontWeight.normal)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: 16),
                      onTap: () => Get.toNamed(ProfileSettingPage.routeName),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.info_outline,
                          color: primaryColor,
                        ),
                      ),
                      title: Text('about_us'.tr, style: darkNormalTextStyle(FontWeight.bold)),
                      subtitle: Text('app_information'.tr, style: grayNormalTextStyle(FontWeight.normal)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: 16),
                      onTap: () => Get.toNamed(AboutUsPage.routeName),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Logout Card
              Card(
                color: whiteColor,
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: errorColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.logout,
                      color: errorColor,
                    ),
                  ),
                  title: Text('logout'.tr, style: darkNormalTextStyle(FontWeight.bold)),
                  subtitle: Text('sign_out_account'.tr, style: grayNormalTextStyle(FontWeight.normal)),
                  onTap: () => Get.defaultDialog(
                    title: "confirm".tr,
                    titleStyle: darkTitleStyle(FontWeight.bold),
                    middleText: "are_you_sure".tr,
                    middleTextStyle: darkNormalTextStyle(FontWeight.normal),
                    textConfirm: "yes".tr,
                    textCancel: "no".tr,
                    confirmTextColor: whiteColor,
                    cancelTextColor: errorColor,
                    buttonColor: primaryColor,
                    onConfirm: () => authController.logout(),
                    onCancel: () => Get.back(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
