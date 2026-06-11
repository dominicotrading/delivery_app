import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/modules/customer/controllers/customer_registration_controller.dart';
import 'package:marocsie/app/data/models/customer.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/location_service.dart';


class CustomerRegistrationScreen extends StatelessWidget {
  static const String routeName = '/customer-registration';
  
  CustomerRegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerRegistrationController());
    
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        title: Text(
          'register_customer'.tr,
          style: darkSubTitleStyle(FontWeight.w600),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildCustomerTypeSelector(controller),
                  const SizedBox(height: 24),
                  _buildBasicInfoSection(controller),
                  const SizedBox(height: 24),
                  _buildLocationSection(controller),
                  const SizedBox(height: 24),
                  _buildImageSection(controller),
                  const SizedBox(height: 24),
                  _buildAdditionalFilesSection(controller),
                  const SizedBox(height: 24),
                  _buildSubmitButton(controller),
                  const SizedBox(height: 20),
                ],
              ),
            )),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.1), primaryColor.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.person_add, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'new_customer_registration'.tr,
                  style: darkSubTitleStyle(FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'register_customer_subtitle'.tr,
                  style: grayNormalTextStyle(FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerTypeSelector(CustomerRegistrationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'customer_type'.tr,
          style: darkNormalTextStyle(FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                controller,
                'individual',
                'individual'.tr,
                Icons.person,
                'personal_customer'.tr,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTypeOption(
                controller,
                'organization',
                'business'.tr,
                Icons.business,
                'business_customer'.tr,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption(
    CustomerRegistrationController controller,
    String type,
    String title,
    IconData icon,
    String subtitle,
  ) {
    return Obx(() => GestureDetector(
      onTap: () => controller.setCustomerType(type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: controller.customerType.value == type
              ? primaryColor.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: controller.customerType.value == type
                ? primaryColor
                : Colors.grey.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: controller.customerType.value == type
                  ? primaryColor
                  : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: controller.customerType.value == type
                    ? primaryColor
                    : darkColor,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildBasicInfoSection(CustomerRegistrationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'basic_information'.tr,
          style: darkSubTitleStyle(FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        // First Name
        _buildCustomTextField(
          controller: controller.firstNameController,
          hintText: 'first_name_hint'.tr,
          labelText: 'first_name'.tr,
          prefixIcon: Icons.person_outline,
          errorText: controller.nameError.value.isNotEmpty ? controller.nameError.value : null,
        ),
        const SizedBox(height: 16),
        
        // Last Name
        _buildCustomTextField(
          controller: controller.lastNameController,
          hintText: 'last_name_hint'.tr,
          labelText: 'last_name'.tr,
          prefixIcon: Icons.person_outline,
          errorText: controller.nameError.value.isNotEmpty ? controller.nameError.value : null,
        ),
        const SizedBox(height: 16),
        
        // Phone Number
        _buildCustomTextField(
          controller: controller.phoneController,
          hintText: 'phone_number_hint'.tr,
          labelText: 'phone'.tr,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          errorText: controller.phoneError.value.isNotEmpty ? controller.phoneError.value : null,
        ),
        const SizedBox(height: 16),
        
        // Email (Optional)
        _buildCustomTextField(
          controller: controller.emailController,
          hintText: 'email_address_hint'.tr,
          labelText: 'email'.tr,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          errorText: controller.emailError.value.isNotEmpty ? controller.emailError.value : null,
        ),        
        const SizedBox(height: 16),
        _buildCustomTextField(
          controller: controller.houseNoController,
          hintText: 'house_no'.tr,
          labelText: 'house_no_label'.tr,
          prefixIcon: Icons.house_outlined,
          maxLines: 1,
        ),
        const SizedBox(height: 16),
        
        // Number of Families (Only for individual customers)
        Obx(() => controller.customerType.value == 'individual'
            ? Column(
                children: [
                  _buildCustomTextField(
                    controller: controller.numberOfFamilyController,
                    hintText: 'number_of_families_hint'.tr,
                    labelText: 'number_of_families'.tr,
                    prefixIcon: Icons.family_restroom,
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                ],
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
    TextInputType? keyboardType,
    String? errorText,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: darkNormalTextStyle(FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null ? errorColor : Colors.grey.withOpacity(0.3),
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: darkNormalTextStyle(FontWeight.normal),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: grayNormalTextStyle(FontWeight.normal),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText,
            style: TextStyle(color: errorColor, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildLocationSection(CustomerRegistrationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'location_information'.tr,
          style: darkSubTitleStyle(FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
                  // Current Location Status
          Obx(() => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: controller.currentPosition.value != null
                  ? successColor.withOpacity(0.1)
                  : errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: controller.currentPosition.value != null
                    ? successColor
                    : errorColor,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      controller.currentPosition.value != null
                          ? Icons.location_on
                          : Icons.location_off,
                      color: controller.currentPosition.value != null
                          ? successColor
                          : errorColor,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        controller.currentPosition.value != null
                            ? 'location_captured'.tr
                            : 'location_not_available'.tr,
                        style: TextStyle(
                          color: controller.currentPosition.value != null
                              ? successColor
                              : errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (controller.locationLoading.value)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else if (controller.currentPosition.value == null)
                      IconButton(
                        onPressed: controller.getCurrentLocation,
                        icon: Icon(Icons.refresh, color: errorColor),
                      ),
                  ],
                ),
                if (controller.currentPosition.value != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${'latitude'.tr}: ${controller.currentPosition.value!.latitude.toStringAsFixed(6)}, '
                    '${'longitude'.tr}: ${controller.currentPosition.value!.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  FutureBuilder<String>(
                    future: LocationService.getShortLocationName(
                      controller.currentPosition.value!.latitude,
                      controller.currentPosition.value!.longitude,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Row(
                          children: [
                            SizedBox(
                              width: 12,
                              height: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'getting_location'.tr,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        );
                      }
                      
                      if (snapshot.hasError) {
                        return Text(
                          'error_getting_location'.tr,
                          style: TextStyle(
                            color: errorColor,
                            fontSize: 12,
                          ),
                        );
                      }
                      
                      final locationName = snapshot.data ?? 'unknown_location'.tr;
                      return Text(
                        '${'location'.tr}: $locationName',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: controller.getCurrentLocation,
                        icon: Icon(Icons.my_location, color: Colors.white, size: 18),
                        label: Text('current_location'.tr, style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: controller.pickLocationManually,
                        icon: Icon(Icons.location_searching, color: primaryColor, size: 18),
                        label: Text('pick_location'.tr, style: TextStyle(color: primaryColor)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
        
        if (controller.locationError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.locationError.value,
            style: TextStyle(color: errorColor, fontSize: 12),
          ),
        ],
        
        const SizedBox(height: 16),
        
        // Subcity Selection
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _buildLocationDropdown(
                'subcity'.tr,
                controller.subcities,
                controller.selectedSubcity,
                controller.subcitiesLoading,
                (subcity) => controller.setSelectedSubcity(subcity),
                'subcity_hint'.tr,
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              onPressed: controller.fetchSubcities,
              icon: Icon(Icons.refresh, color: primaryColor, size: 30),
              tooltip: 'refresh_subcities'.tr,
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Woreda Selection
        Obx(() => controller.selectedSubcity.value != null
            ? _buildLocationDropdown(
                'woreda'.tr,
                controller.woredas,
                controller.selectedWoreda,
                controller.woredasLoading,
                (woreda) => controller.setSelectedWoreda(woreda),
                'woreda_hint'.tr,
              )
            : const SizedBox.shrink()),
        
        if (controller.selectedSubcity.value != null) ...[
          const SizedBox(height: 16),
        ],
        // Ketena Selection
        Obx(() => controller.selectedWoreda.value != null
            ? _buildLocationDropdown(
                'ketena_label'.tr,
                controller.ketenas,
                controller.selectedKetena,
                controller.ketenasLoading,
                (ketena) => controller.setSelectedKetena(ketena),
                'ketena_label'.tr,
              )
            : const SizedBox.shrink()),

        // Block Selection
        Obx(() => controller.selectedKetena.value != null
            ? _buildLocationDropdown(
                'block'.tr,
                controller.blocks,
                controller.selectedBlock,
                controller.blocksLoading,
                (block) => controller.setSelectedBlock(block),
                'block_hint'.tr,
              )
            : const SizedBox.shrink()),
      ],
    );
  }

  Widget _buildLocationDropdown(
    String label,
    RxList<dynamic> items,
    Rx<dynamic> selectedValue,
    RxBool isLoading,
    Function(dynamic) onChanged,
    String hint,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: darkNormalTextStyle(FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Obx(() {
            // Ensure we don't have duplicate items
            final uniqueItems = items.toSet().toList();
            
            return DropdownButtonFormField<LocationData>(
              value: selectedValue.value,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: InputBorder.none,
                hintText: hint,
                hintStyle: grayNormalTextStyle(FontWeight.normal),
              ),
              items: uniqueItems.map((item) {
                return DropdownMenuItem<LocationData>(
                  key: ValueKey(item.id),
                  value: item,
                  child: Text(
                    item.name,
                    style: darkNormalTextStyle(FontWeight.normal),
                  ),
                );
              }).toList(),
              onChanged: isLoading.value ? null : onChanged,
              isExpanded: true,
              validator: (value) {
                if (value == null) {
                  return 'Please select a ${label.toLowerCase().replaceAll('*', '')}';
                }
                return null;
            },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildImageSection(CustomerRegistrationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'customer_photo'.tr,
          style: darkSubTitleStyle(FontWeight.bold),
        ),
        const SizedBox(height: 16),
        
        Obx(() => controller.selectedImage.value != null
            ? _buildImagePreview(controller)
            : _buildImagePicker(controller)),
            
        if (controller.imageError.value.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            controller.imageError.value,
            style: TextStyle(color: errorColor, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildImagePicker(CustomerRegistrationController controller) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'take_customer_photo'.tr,
            style: darkNormalTextStyle(FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'customer_photo_help'.tr,
            style: grayNormalTextStyle(FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: controller.pickImageFromCamera,
            icon: Icon(Icons.camera_alt, color: Colors.white),
            label: Text('take_photo'.tr, style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(CustomerRegistrationController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.file(
              controller.selectedImage.value!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.pickImageFromCamera,
                    icon: Icon(Icons.camera_alt, color: Colors.white, size: 20),
                    label: Text('retake'.tr, style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.removeImage,
                    icon: Icon(Icons.delete, color: errorColor, size: 20),
                    label: Text('remove_photo'.tr, style: TextStyle(color: errorColor)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: errorColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAdditionalFilesSection(CustomerRegistrationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'additional_documents'.tr,
          style: darkSubTitleStyle(FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'additional_documents_help'.tr,
          style: grayNormalTextStyle(FontWeight.normal),
        ),
        const SizedBox(height: 16),
        
        // File picker buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: controller.pickAdditionalFileFromCamera,
                icon: Icon(Icons.camera_alt, color: primaryColor, size: 20),
                label: Text('take_photo'.tr, style: TextStyle(color: primaryColor)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Display additional files
        Obx(() => controller.additionalFiles.isEmpty
            ? _buildEmptyAdditionalFiles()
            : _buildAdditionalFilesList(controller)),
      ],
    );
  }
  
  Widget _buildEmptyAdditionalFiles() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.file_copy_outlined,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'no_additional_documents'.tr,
            style: grayNormalTextStyle(FontWeight.w600),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'no_additional_documents_help'.tr,
            style: grayNormalTextStyle(FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildAdditionalFilesList(CustomerRegistrationController controller) {
    return Column(
      children: [
        for (int i = 0; i < controller.additionalFiles.length; i++)
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.file(
                    controller.additionalFiles[i],
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                                             Expanded(
                         child:                             Text(
                              '${'document'.tr} ${i + 1}',
                              style: darkNormalTextStyle(FontWeight.w500),
                            ),
                       ),
                      IconButton(
                        onPressed: () => controller.removeAdditionalFile(i),
                        icon: Icon(Icons.delete_outline, color: errorColor, size: 20),
                        tooltip: 'remove_document'.tr,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        
        // Clear all button
        if (controller.additionalFiles.isNotEmpty) ...[
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: controller.clearAdditionalFiles,
            icon: Icon(Icons.clear_all, color: errorColor, size: 20),
            label: Text('clear_all'.tr, style: TextStyle(color: errorColor)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              side: BorderSide(color: errorColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ],
    );
  }


  Widget _buildSubmitButton(CustomerRegistrationController controller) {
    return SizedBox(
      width: double.infinity,
      child: Obx(() => ElevatedButton(
        onPressed: controller.isSubmitting.value
            ? null
            : controller.submitCustomerRegistration,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
        ),
        child: controller.isSubmitting.value
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'registering_customer'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              )
            : Text('register_customer'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      )),
    );
  }
}
