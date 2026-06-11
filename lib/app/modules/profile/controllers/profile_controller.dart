// ignore_for_file: deprecated_member_use, constant_identifier_names

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/data/models/user.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/data/repositories/auth.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final StorageService storageService = StorageService();
  final AuthRepository authService = AuthRepository();
  var profileImage =
      Rx<File?>(null); // Observable to store the selected image file

  Rx<User> currentUser = Rx<User>(User());

  var isLoading = true.obs;
  var buttonLoading = false.obs;
  var isEditing = false.obs;
  var uploadLoading = false.obs;
  var selectedGender = "Male".obs;

  final phoneController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();
  final aboutController = TextEditingController();

  //Professional documents
  Rx<FilePickerResult?> resultId = Rx<FilePickerResult?>(null);
  Rx<FilePickerResult?> resultLicense = Rx<FilePickerResult?>(null);
  Rx<FilePickerResult?> resultEduDocument = Rx<FilePickerResult?>(null);
  Rx<FilePickerResult?> resultCertificate = Rx<FilePickerResult?>(null);

  Rx<File?> fileId = Rx<File?>(null);
  Rx<File?> fileLicense = Rx<File?>(null);
  Rx<File?> fileEduDocument = Rx<File?>(null);
  Rx<File?> fileCertificate = Rx<File?>(null);

  Rx<bool> idEmpty = false.obs;
  Rx<bool> licenseEmpty = false.obs;
  Rx<bool> eduEmpty = false.obs;

  // file update variables
  Rx<FilePickerResult?> fileResult = Rx<FilePickerResult?>(null);
  Rx<File?> updatedFile = Rx<File?>(null);
  Rx<bool> fileEmpty = false.obs;
  Rx<Document?> documentToUpdate = Rx<Document?>(null);
  final TextEditingController rateController = TextEditingController();


  @override
  void onInit() {
    fetchCurrentUser();
    super.onInit();
  }

  updateEditing(){
    isEditing.value =!isEditing.value;
  }
  setDocsEmpty(){
    fileResult = Rx<FilePickerResult?>(null);
    updatedFile = Rx<File?>(null);
    fileEmpty = false.obs;
    documentToUpdate = Rx<Document?>(null);
  }

  Future<void> fetchCurrentUser() async {
    try {
      isLoading(true);
      var response = await authService.getCurrentUser();
      print("Current User Response: ${response}");
      if (response['error'] == false) {
        currentUser.value = response['data'];
        firstNameController.text = currentUser.value.firstName!;
        lastNameController.text = currentUser.value.lastName!;
        phoneController.text = currentUser.value.phoneNumber!;
        emailController.text = currentUser.value.email!;
        selectedGender.value = currentUser.value.gender!;
        storageService.saveData(
            'profile_image', currentUser.value.profileImage);
        storageService.saveData('first_name', currentUser.value.firstName!);
        storageService.saveData('last_name', currentUser.value.lastName!);
        storageService.saveData('phone_number', currentUser.value.phoneNumber!);
        storageService.saveData('email', currentUser.value.email!);
        storageService.saveData('gender', currentUser.value.gender!);
      } else {
        firstNameController.text = storageService.readData('first_name');
        lastNameController.text = storageService.readData('last_name');
        phoneController.text = storageService.readData('phone_number');
        emailController.text = storageService.readData('email') ?? '';
        selectedGender.value = storageService.readData('gender') ?? 'Male';
        Get.snackbar("Error", response['message'],
            backgroundColor: errorColor, colorText: lightColor);
        return;
      }
    } finally {
      isLoading(false);
    }
  }


  void setGender(String gender) {
    selectedGender.value = gender;
  }

  void updatePersonalDetail() async {
    if (phoneController.value.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Phone number is required",
        backgroundColor: errorColor,
        colorText: lightColor,
      );
      return;
    }

    if (firstNameController.value.text.isEmpty) {
      Get.snackbar("Error", "First Name is required",
          backgroundColor: errorColor, colorText: lightColor);
      return;
    }

    buttonLoading.value = true;

    try {
      // Simulate API Call
      await Future.delayed(Duration(seconds: 2));
      var response = await authService.updateAccount({
        'phone_number': phoneController.value.text,
        'first_name': firstNameController.value.text,
        'last_name': lastNameController.value.text,
        'email': emailController.value.text,
        "gender": selectedGender.value,
      });

      print("Update user peronal account Response: ${response}");
      // Navigate to OTP screen
      if (response['error']) {
        Get.snackbar(" Failed", response['message'],
            backgroundColor: errorColor, colorText: lightColor);
      } else {
        storageService.saveData("first_name", firstNameController.text);
        storageService.saveData("last_name", lastNameController.text);
        storageService.saveData("phone_number", phoneController.text);
        storageService.saveData("gender", selectedGender.value);
        storageService.saveData('email', emailController.text);

        Get.snackbar("Success", response['message'],
            backgroundColor: successColor, colorText: lightColor);
      }
    } catch (e) {
      Get.snackbar("Failed", "Something went wrong",
          backgroundColor: errorColor, colorText: lightColor);
    } finally {
      buttonLoading.value = false;
    }
  }

  // Function to pick an image
  void pickImage({required ImageSource source}) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
      showImagePreviewDialog(); // Show the preview modal after selecting the image
    }
  }

  // Function to upload the image (calls your API service)
  void uploadProfileImage() async {
    if (profileImage.value != null) {
      buttonLoading.value = true;
      try {
        var response = await authService
            .updateProfileImage({'profile_image': profileImage.value!});
        if (response['error'] == false) {
          storageService.saveData('profile_image', response['profile_image']);
        }
        Get.snackbar("Success", "Profile image updated successfully",backgroundColor: successColor,colorText: lightColor);
      } catch (e) {
        Get.snackbar("Error", "Failed to update profile image",backgroundColor: errorColor,colorText: lightColor);
      }
      buttonLoading.value = false;
    } else {
      Get.snackbar("Error", "No image selected");
    }
  }
 

  // Function to show the image preview dialog
  void showImagePreviewDialog() {
    Get.dialog(
      AlertDialog(
        title: Text("Preview Image"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(profileImage.value!), // Preview the selected image
            SizedBox(height: 10),
            Text("Do you want to save this as your profile picture?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(); // Close dialog
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // Close dialog
              uploadProfileImage(); // Upload image
            },
            child: Text("Save"),
          ),
        ],
      ),
      barrierDismissible: false, // Prevent closing by tapping outside
    );
  }


  
}
