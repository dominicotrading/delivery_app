import 'package:get/get.dart';
import 'package:marocsie/app/data/controllers/language_controller.dart';
import 'package:marocsie/app/data/repositories/auth.dart';
import 'package:marocsie/app/modules/auth/controllers/auth_controller.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileSettingPage extends StatefulWidget {
  static const String routeName = '/profile-settings';
  const ProfileSettingPage({super.key});

  @override
  State<ProfileSettingPage> createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        title: Text('settings'.tr, style: subTitleStyle(FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Language Settings Card
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
                        child: const Icon(Icons.language, color: primaryColor),
                      ),
                      title: Text('language'.tr, style: darkNormalTextStyle(FontWeight.bold)),
                      subtitle: Text('change_app_language'.tr, style: grayNormalTextStyle(FontWeight.normal)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: 16),
                      onTap: () => _showLanguageDialog(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Account Settings Card
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
                          color: errorColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(CupertinoIcons.trash, color: errorColor),
                      ),
                      title: Text('delete_account'.tr, style: darkNormalTextStyle(FontWeight.bold)),
                      subtitle: Text('permanently_delete_account'.tr, style: grayNormalTextStyle(FontWeight.normal)),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, color: primaryColor, size: 16),
                      onTap: () => _showDeleteAccountDialog(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('language'.tr, style: darkTitleStyle(FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text('English', style: darkNormalTextStyle(FontWeight.normal)),
              value: 'en_US',
              groupValue: Get.find<LanguageController>().language,
              activeColor: primaryColor,
              onChanged: (value) {
                if (value != null) {
                  Get.find<LanguageController>().changeLanguage(value);
                  Get.back();
                }
              },
            ),
            RadioListTile<String>(
              title: Text('አማርኛ', style: darkNormalTextStyle(FontWeight.normal)),
              value: 'am_ET',
              groupValue: Get.find<LanguageController>().language,
              activeColor: primaryColor,
              onChanged: (value) {
                if (value != null) {
                  Get.find<LanguageController>().changeLanguage(value);
                  Get.back();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(color: errorColor)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('delete_account'.tr, style: darkTitleStyle(FontWeight.bold)),
        content: Text(
          'delete_account_confirmation'.tr,
          style: darkNormalTextStyle(FontWeight.normal),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(color: errorColor)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              AuthRepository().deleteAccount().then((resp) {
                if (resp['error'] == false) {
                  Get.find<AuthController>().logout();
                }
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: errorColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('delete'.tr, style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }
}
