import 'package:marocsie/app/modules/auth/controllers/auth_controller.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/sizes.dart';
import 'package:marocsie/app/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/modules/auth/widgets/auth_app_bar.dart';
import 'package:marocsie/app/widgets/app_logo.dart';
import 'package:marocsie/app/widgets/textfield.dart';

class SignInScreen extends StatelessWidget {
  static const String routeName = "/sign-in";

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AuthAppBar(
        title: "sign_in".tr,
      ),
      body: Obx(() => SafeArea(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // App Logo
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: screenHeight * 0.05),
                    child: const AppLogo(size: 0.6),
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Welcome Section
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "welcome_back".tr,
                        style: primaryTitleStyle(FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "sign_in_subtitle".tr,
                        style: grayNormalTextStyle(FontWeight.normal),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // Sign In Form Card
                Card(
                  color: whiteColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Custom Phone Input Field
                        const SizedBox(height: 8),
                        MarocsiePhoneInputField(
                          label: "phone_number".tr,
                          hintText: "phone_hint".tr,
                          onChanged: (value) {},
                          controller: authController.phoneController,
                        ),
                        const SizedBox(height: 24),

                        // Sign In Button
                        authController.buttonLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(color: primaryColor),
                              )
                            : MarocsieElevatedButton(
                                buttonText: "sign_in".tr,
                                onPressed: () => authController.login(),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.03), 
              ],
            ),
          ),
        ),
      )),
    );
  }
}