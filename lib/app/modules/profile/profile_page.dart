import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:marocsie/app/modules/notification/notification_screen.dart';
import 'package:marocsie/app/modules/profile/controllers/profile_controller.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/api_helpers.dart';
import 'package:marocsie/app/utils/sizes.dart';
import 'package:marocsie/app/widgets/buttons.dart';
import 'package:marocsie/app/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static const String routeName = '/profile-page';
  const ProfileUpdateScreen({super.key});

  @override
  State<ProfileUpdateScreen> createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  final ProfileController profileController = Get.put(ProfileController());
  final StorageService storageService = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        title: Text('my_profile'.tr, style: subTitleStyle(FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.notification),
            onPressed: () => Get.toNamed(NotificationScreen.routeName),
          ),
          SizedBox(width: screenWidth * 0.01),
        ],
      ),
      body: Obx(() {
        if (profileController.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }
        return RefreshIndicator(
          onRefresh: () => profileController.fetchCurrentUser(),
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Profile Image Card
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
                                  backgroundImage: profileController.profileImage.value != null
                                      ? FileImage(profileController.profileImage.value!) as ImageProvider
                                      : CachedNetworkImageProvider(
                                          storageService.readData('profile_image') != null ? ApiHelpers.hostUrl + storageService.readData('profile_image') :  "https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png",
                                        ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: whiteColor, width: 2),
                                    boxShadow: [
                                      BoxShadow(
                                        color: primaryColor.withOpacity(0.3),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () => _showImagePickerBottomSheet(),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: whiteColor,
                                      size: 18,
                                    ),
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
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Personal Information Card
                  Card(
                    color: whiteColor,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('personal_information'.tr, style: primarySubTitleStyle(FontWeight.bold)),
                          const SizedBox(height: 16),
                          MarocsieTextInputWidget(
                            label: 'first_name'.tr,
                            hintText: 'first_name'.tr,
                            onChanged: () {},
                            controller: profileController.firstNameController,
                          ),
                          const SizedBox(height: 16),
                          MarocsieTextInputWidget(
                            label: 'last_name'.tr,
                            hintText: 'last_name'.tr,
                            onChanged: () {},
                            controller: profileController.lastNameController,
                          ),
                          const SizedBox(height: 16),
                          MarocsieTextInputWidget(
                            label: 'email_address'.tr,
                            hintText: 'example_email'.tr,
                            onChanged: () {},
                            controller: profileController.emailController,
                          ),
                          const SizedBox(height: 16),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                            child:Text('gender'.tr, style: darkNormalTextStyle(FontWeight.bold))),
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                            child:Row(
                            children: [
                              Radio<String>(
                                value: 'male'.tr,
                                groupValue: profileController.selectedGender.value,
                                onChanged: (value) => profileController.setGender(value!),
                                fillColor: MaterialStateProperty.all(primaryColor),
                              ),
                              Text('male'.tr, style: darkNormalTextStyle(FontWeight.normal)),
                              Radio<String>(
                                value: 'female'.tr,
                                groupValue: profileController.selectedGender.value,
                                onChanged: (value) => profileController.setGender(value!),
                                fillColor: MaterialStateProperty.all(primaryColor),
                              ),
                              Text('female'.tr, style: darkNormalTextStyle(FontWeight.normal)),
                            ],
                          )),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                 

                  // Save Button
                  profileController.buttonLoading.value
                      ? const Center(child: CircularProgressIndicator(color: primaryColor))
                      : MarocsieElevatedButton(
                          buttonText: 'save'.tr,
                          onPressed: () => profileController.updatePersonalDetail(),
                        ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  void _showImagePickerBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: const BoxDecoration(
          color: whiteColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildImagePickerOption(
              icon: Icons.photo_library,
              label: 'gallery'.tr,
              onTap: () {
                Get.back();
                profileController.pickImage(source: ImageSource.gallery);
              },
            ),
            _buildImagePickerOption(
              icon: Icons.camera_alt,
              label: 'camera'.tr,
              onTap: () {
                Get.back();
                profileController.pickImage(source: ImageSource.camera);
              },
            ),
          ],
        ),
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  Widget _buildImagePickerOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: primaryColor, size: 30),
          const SizedBox(height: 8),
          Text(label, style: darkNormalTextStyle(FontWeight.normal)),
        ],
      ),
    );
  }
}