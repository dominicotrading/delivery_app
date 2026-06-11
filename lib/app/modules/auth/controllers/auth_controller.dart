// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/data/repositories/auth.dart';
import 'package:marocsie/app/modules/auth/otp_verification.dart';
import 'package:marocsie/app/modules/auth/sign_in.dart';
import 'package:marocsie/app/modules/root/root_screen.dart';
import 'package:marocsie/app/theme/colors.dart';

class AuthController extends GetxController {
  final StorageService storageService = StorageService();
  final AuthRepository authService = AuthRepository();

  var isLoading = true.obs;
  var buttonLoading = false.obs;
  var loginType = 'phone'.obs;
  var phoneNumber = ''.obs;
  var fullName = ''.obs;
  var isChecked = false.obs;

  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final pinController = TextEditingController();
  final numYearController = TextEditingController();
  final ageController = TextEditingController();
  final otpController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
  }
 
  void verifyOTP() async {
    print("Verifying Pin Controller ${pinController.value.text}");

    if (pinController.value.text.isEmpty ||
        pinController.value.text.length != 6) {
      Get.snackbar(
        "Error",
        "Invalid One Time Password",
        backgroundColor: errorColor,
        colorText: lightColor,
      );
      return;
    }

    buttonLoading.value = true;

    try {
      // Simulate API Call
      await Future.delayed(Duration(seconds: 2));
      var response = await authService.verifyAccount(pinController.value.text, phoneController.value.text);
      print("Verified Response ${response}");
      // Navigate to OTP screen
      if (response['error']) {
        Get.snackbar("Login Failed", response['message'],
            backgroundColor: errorColor, colorText: lightColor);
      } else {
        Get.snackbar("Login Success", "Successfully logged in",
            backgroundColor: successColor, colorText: lightColor);
        storageService.saveData("accessToken", response["accessToken"]);
        storageService.saveData("loggedIn", true);
        storageService.saveData("full_name", response['full_name']);
        storageService.saveData("phone_number", response['phone_number']);
        storageService.saveData('profile_image', response['avatar']);
        Get.offAllNamed(MarocsieRootScreen.routeName);
      }
    } catch (e) {
      print("VerifyOTP failed: $e");
      Get.snackbar("Login Failed", "Something went wrong",
          backgroundColor: errorColor, colorText: lightColor);
    } finally {
      buttonLoading.value = false;
    }
  }


  void login() async {

    if (phoneController.value.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Phone number is required",
        backgroundColor: errorColor,
        colorText: lightColor,
      );
      return;
    }
     

    buttonLoading.value = true;

    try {
      var formData = phoneController.value.text;
      print("User Phone Number: ${formData}");
      var response = await authService.login(formData);
      
      print("Authentication user account Response: ${response}");
      if (response['error']) {
        Get.snackbar("Authentication Failed", response['message'],
            backgroundColor: errorColor, colorText: lightColor);
      } else {
        storageService.saveData('user-id', response['userId']);
        Get.toNamed(
            "${OtpVerificationScreen.routeName}?phone_number= phoneController.value.text&userid=${response['userId']}&login_type=${loginType.value}");
      }
    } catch (e) {
      print("Authentication Error: $e");
      Get.snackbar("Authentication Failed", "Something went wrong",
          backgroundColor: errorColor, colorText: lightColor);
    } finally {
      buttonLoading.value = false;
    }
  }

  void resendOTP() async {
    buttonLoading.value = true;

    try {
      // Simulate API Call
      await Future.delayed(Duration(seconds: 2));
      var response = await authService.resendOTP();
      // Navigate to OTP screen
      if (response['error']) {
        Get.snackbar("OTP Resend failed", response['message'],
            backgroundColor: errorColor, colorText: lightColor);
      } else {
        Get.snackbar("Login Success", response['message'],
            backgroundColor: successColor, colorText: lightColor);
      }
    } catch (e) {
      Get.snackbar("Login Failed", "Something went wrong",
          backgroundColor: errorColor, colorText: lightColor);
    } finally {
      buttonLoading.value = false;
    }
  }

// Logout function
  void logout() {
    print("Logout Authenticated User..............");
    storageService.clearStorage();
    Get.offAllNamed(SignInScreen.routeName); // Redirect to login page
  }


  @override
  void onClose() {
    otpController.dispose();
    super.onClose();
  }
}
