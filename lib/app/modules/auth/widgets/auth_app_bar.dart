import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/data/controllers/language_controller.dart';
import 'package:marocsie/app/theme/fonts.dart';

class AuthAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? additionalActions;

  const AuthAppBar({
    Key? key,
    required this.title,
    this.additionalActions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(title, style: subTitleStyle(FontWeight.bold)),
      centerTitle: true,
      backgroundColor: primaryColor,
      actions: [
        IconButton(
          icon: Icon(Icons.language, color: Colors.white),
          onPressed: () {
            final languageController = Get.find<LanguageController>();
            Get.dialog(
              AlertDialog(
                title: Text('Select Language'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text('English'),
                      onTap: () {
                        languageController.changeLanguage('en');
                        Get.back();
                      },
                    ),
                    ListTile(
                      title: Text('አማርኛ'),
                      onTap: () {
                        languageController.changeLanguage('am');
                        Get.back();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
} 