import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marocsie/app/modules/auth/controllers/auth_controller.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/sizes.dart';
import 'package:marocsie/app/widgets/buttons.dart';
import 'package:marocsie/app/modules/auth/widgets/auth_app_bar.dart';
import 'package:pinput/pinput.dart';
import 'package:marocsie/app/widgets/app_logo.dart';

class OtpVerificationScreen extends StatelessWidget {
  static const String routeName = "/otp-verification";

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    String maskedPhone = authController.phoneController.text.toString().replaceRange(0, authController.phoneController.text.toString().length - 4, "*" * (authController.phoneController.text.toString().length - 4));
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AuthAppBar(
        title: "verify".tr,
      ),
      body: SafeArea(
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

                // Header Section
                Center(
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "verification_code".tr,
                        style: primaryTitleStyle(FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.05),

                // OTP Input Card
                Card(
                  color: whiteColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Phone Number Display
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(Iconsax.message, size: 20, color: primaryColor),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  Get.locale?.languageCode == 'am' 
                                    ? "በስልክ ቁጥር $maskedPhone ላይ በኤስኤምኤስ የተላከውን አንድ ጊዜ ፒን ያስገቡ"
                                    : "Enter the one time PIN sent to a phone number $maskedPhone via sms",
                                  style: TextStyle(
                                    color: primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // OTP Input
                        Pinput(
                          length: 6,
                          controller: authController.pinController,
                          defaultPinTheme: PinTheme(
                            width: 48,
                            height: 48,
                            textStyle: darkNormalTextStyle(FontWeight.bold),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryColor.withOpacity(0.2)),
                            ),
                          ),
                          focusedPinTheme: PinTheme(
                            width: 48,
                            height: 48,
                            textStyle: darkNormalTextStyle(FontWeight.bold),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryColor),
                              boxShadow: [
                                BoxShadow(
                                  color: primaryColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                          submittedPinTheme: PinTheme(
                            width: 48,
                            height: 48,
                            textStyle: darkNormalTextStyle(FontWeight.bold),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: primaryColor),
                            ),
                          ),
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          showCursor: true,
                          onCompleted: (pin) => authController.verifyOTP(),
                        ),
                        const SizedBox(height: 24),

                        // Resend Code Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "didnt_receive_code".tr,
                              style: grayNormalTextStyle(FontWeight.normal),
                            ),
                            TextButton(
                              onPressed: () => authController.resendOTP(),
                              child: Text(
                                "resend_code".tr,
                                style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Verify Button
                        Obx(() => authController.buttonLoading.value
                          ? const Center(
                              child: CircularProgressIndicator(color: primaryColor),
                            )
                          : MarocsieElevatedButton(
                              buttonText: "verify".tr,
                              onPressed: () => authController.verifyOTP(),
                            ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 