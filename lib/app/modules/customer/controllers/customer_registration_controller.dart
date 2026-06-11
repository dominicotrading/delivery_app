import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marocsie/app/data/models/customer.dart';
import 'package:marocsie/app/data/repositories/customer_repository.dart';
import 'package:marocsie/app/theme/colors.dart';

class CustomerRegistrationController extends GetxController {
  final CustomerRepository customerRepository = CustomerRepository();
  
  // Form controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final numberOfFamilyController = TextEditingController();
  final addressController = TextEditingController();
  final houseNoController = TextEditingController();
  final notesController = TextEditingController();
  
  // Observable variables
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var customerType = 'individual'.obs;
  var selectedImage = Rx<File?>(null);
  var additionalFiles = <File>[].obs;
  var currentPosition = Rx<Position?>(null);
  var locationLoading = false.obs;
  
  // Location data
  var subcities = <LocationData>[].obs;
  var woredas = <LocationData>[].obs;
  var blocks = <LocationData>[].obs;
  var ketenas = <LocationData>[].obs;

  // Selected location values
  var selectedSubcity = Rx<LocationData?>(null);
  var selectedWoreda = Rx<LocationData?>(null);
  var selectedBlock = Rx<LocationData?>(null);
  var selectedKetena = Rx<LocationData?>(null);

  // Loading states for location data
  var subcitiesLoading = false.obs;
  var woredasLoading = false.obs;
  var blocksLoading = false.obs;
  var ketenasLoading = false.obs;

  // Error messages
  var nameError = ''.obs;
  var phoneError = ''.obs;
  var emailError = ''.obs;
  var locationError = ''.obs;
  var imageError = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    fetchSubcities();
  }
  
  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    numberOfFamilyController.dispose();
    addressController.dispose();
    houseNoController.dispose();
    notesController.dispose();
    super.onClose();
  }
  
  // Get current location
  Future<void> getCurrentLocation() async {
    try {
      locationLoading.value = true;
      locationError.value = '';
      
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          locationError.value = 'Location permission denied';
          return;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        locationError.value = 'Location permissions are permanently denied';
        return;
      }
      
      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      currentPosition.value = position;
      locationError.value = '';
    } catch (e) {
      locationError.value = 'Failed to get location: $e';
    } finally {
      locationLoading.value = false;
    }
  }

  // Pick location manually (for testing or when GPS is not available)
  void pickLocationManually() {
    // For now, we'll use a simple dialog to input coordinates
    // In a real app, you might want to integrate with a map picker
    Get.dialog(
      AlertDialog(
        title: Text('Enter Location Coordinates'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Latitude',
                hintText: 'e.g., 9.1450',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                // Store latitude temporarily
              },
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Longitude',
                hintText: 'e.g., 40.4897',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (value) {
                // Store longitude temporarily
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // For now, set a default location
              currentPosition.value = Position(
                latitude: 9.1450,
                longitude: 40.4897,
                timestamp: DateTime.now(),
                accuracy: 0,
                altitude: 0,
                heading: 0,
                speed: 0,
                speedAccuracy: 0,
                altitudeAccuracy: 0,
                headingAccuracy: 0,
              );
              locationError.value = '';
              Get.back();
            },
            child: Text('Set Default Location'),
          ),
        ],
      ),
    );
  }
  
  // Fetch subcities
  Future<void> fetchSubcities() async {
    try {
      print('Fetching subcities...');
      subcitiesLoading.value = true;
      
      // Clear current selections when refreshing
      clearLocationSelections();
      
      var response = await customerRepository.getSubcities();
      print('Subcity response: $response');
      
      if (!response['error']) {
        print('Subcities loaded from API: ${response['data']}');
        print('Subcities loaded from API: ${response['data'].runtimeType}');
        
        try {
          var data = response['data'] as List<dynamic>;
          subcities.value = data.cast<LocationData>();
          print('Subcities loaded from API: ${subcities.length} items');
        } catch (castError) {
          print('Type casting error: $castError');
          // Fallback to mock data if casting fails
          subcities.value = [];
          print('Using mock subcity data due to casting error');
        }
      } else {
        // For now, add some mock data to test the UI
        subcities.value = [];
        print('Using mock subcity data: ${subcities.length} items');
      }
    } catch (e) {
      print('Error fetching subcities: $e');
      // For now, add some mock data to test the UI
      subcities.value = [];
      print('Using mock subcity data due to error: $e');
    } finally {
      subcitiesLoading.value = false;
      print('Subcities loading finished. Total: ${subcities.length}');
    }
  }
  
  // Fetch woredas by subcity
  Future<void> fetchWoredasBySubcity(int subcityId) async {
    try {
      woredasLoading.value = true;
      woredas.clear();
      selectedWoreda.value = null;
      selectedBlock.value = null;
      blocks.clear();
      
      var response = await customerRepository.getWoredasBySubcity(subcityId);
      
      if (!response['error']) {
        try {
          var data = response['data'] as List<dynamic>;
          woredas.value = data.cast<LocationData>();
        } catch (castError) {
          print('Type casting error for woredas: $castError');
          // Fallback to mock data if casting fails
          woredas.value = [];
        }
      } else {
        // For now, add some mock data to test the UI
        woredas.value = [];
        print('Using mock woreda data for subcity $subcityId');
      }
    } catch (e) {
      // For now, add some mock data to test the UI
      woredas.value = [];
      print('Using mock woreda data due to error: $e');
    } finally {
      woredasLoading.value = false;
    }
  }


  // Fetch ketenas by woreda
  Future<void> fetchKetenasByWoreda(int woredaId) async {
    print("object >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> $woredaId");
    try {
      ketenasLoading.value = true;
      ketenas.clear();
      selectedKetena.value = null;
      
      var response = await customerRepository.getKetenasByWoreda(woredaId);
      
      if (!response['error']) {
        try {
          print("Ketena response data:>>>>>>>>>>>>>>>> ${response['data']}");
          var data = response['data'] as List<dynamic>;
          ketenas.value = data.cast<LocationData>();
        } catch (castError) {
          print('Type casting error for ketenas: $castError');
          // Fallback to mock data if casting fails
          ketenas.value = [];
        }
      } else {
        // For now, add some mock data to test the UI
        ketenas.value = [];
        print('Using mock ketena data for woreda $woredaId');
      }
    } catch (e) {
      // For now, add some mock data to test the UI
      ketenas.value = [];
      print('Using mock ketena data due to error: $e');
    } finally {
      ketenasLoading.value = false;
    }
  }
  
  // Fetch blocks by woreda
  Future<void> fetchBlocksByKetena(int ketenaId) async {
    try {
      blocksLoading.value = true;
      blocks.clear();
      selectedBlock.value = null;
      
      var response = await customerRepository.getBlocksByKetena(ketenaId);
      
      if (!response['error']) {
        try {
          var data = response['data'] as List<dynamic>;
          blocks.value = data.cast<LocationData>();
        } catch (castError) {
          print('Type casting error for blocks: $castError');
          // Fallback to mock data if casting fails
          blocks.value = [];
        }
      } else {
        // For now, add some mock data to test the UI
        blocks.value = [];
        print('Using mock block data for ketena $ketenaId');
      }
    } catch (e) {
      // For now, add some mock data to test the UI
      blocks.value = [];
      print('Using mock block data due to error: $e');
    } finally {
      blocksLoading.value = false;
    }
  }
  
  // Set customer type
  void setCustomerType(String type) {
    customerType.value = type;
    if (type == 'organization') {
      numberOfFamilyController.clear();
    }
  }
  
  // Set selected subcity
  void setSelectedSubcity(LocationData? subcity) {
    selectedSubcity.value = subcity;
    if (subcity != null) {
      fetchWoredasBySubcity(subcity.id);
    } else {
      // Clear dependent selections
      selectedWoreda.value = null;
      selectedBlock.value = null;
      woredas.clear();
      blocks.clear();
    }
  }
  
  // Set selected woreda
  void setSelectedWoreda(LocationData? woreda) {
    selectedWoreda.value = woreda;
    if (woreda != null) {
      fetchKetenasByWoreda(woreda.id);
    }
  }
  
  // Set selected woreda
  void setSelectedKetena(LocationData? ketena) {
    selectedKetena.value = ketena;
    if (ketena != null) {
      fetchBlocksByKetena(ketena.id);
    }
  }
  

  // Set selected block
  void setSelectedBlock(LocationData? block) {
    selectedBlock.value = block;
  }
  
  // Pick image from camera
  Future<void> pickImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        selectedImage.value = File(image.path);
        imageError.value = '';
      }
    } catch (e) {
      imageError.value = 'Failed to pick image: $e';
    }
  }
  

  
  // Remove selected image
  void removeImage() {
    selectedImage.value = null;
    imageError.value = '';
  }
  
  // Pick additional file from camera
  Future<void> pickAdditionalFileFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      
      if (image != null) {
        additionalFiles.add(File(image.path));
      }
    } catch (e) {
      // Handle error silently for additional files
      print('Failed to pick additional file: $e');
    }
  }
  
  // Pick additional file from gallery
  Future<void> pickAdditionalFileFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      
      if (image != null) {
        additionalFiles.add(File(image.path));
      }
    } catch (e) {
      // Handle error silently for additional files
      print('Failed to pick additional file: $e');
    }
  }
  
  // Remove additional file
  void removeAdditionalFile(int index) {
    if (index >= 0 && index < additionalFiles.length) {
      additionalFiles.removeAt(index);
    }
  }
  
  // Clear all additional files
  void clearAdditionalFiles() {
    additionalFiles.clear();
  }
  
  // Validate form
  bool validateForm() {
    bool isValid = true;
    
    // Reset error messages
    nameError.value = '';
    phoneError.value = '';
    emailError.value = '';
    locationError.value = '';
    imageError.value = '';
    
    // Validate first name
    if (firstNameController.text.trim().isEmpty) {
      nameError.value = 'First name is required';
      isValid = false;
    }
    
    // Validate last name
    if (lastNameController.text.trim().isEmpty) {
      nameError.value = 'Last name is required';
      isValid = false;
    }
    
    // Validate phone number
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = 'Phone number is required';
      isValid = false;
    } else if (phoneController.text.trim().length < 10) {
      phoneError.value = 'Please enter a valid phone number';
      isValid = false;
    }
    
    // Validate email (optional but if provided, should be valid)
    if (emailController.text.trim().isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(emailController.text.trim())) {
        emailError.value = 'Please enter a valid email address';
        isValid = false;
      }
    }
    
    // Validate location
    if (selectedSubcity.value == null) {
      locationError.value = 'Please select a subcity';
      isValid = false;
    } else if (selectedWoreda.value == null) {
      locationError.value = 'Please select a woreda';
      isValid = false;
    } else if (selectedBlock.value == null) {
      locationError.value = 'Please select a block';
      isValid = false;
    }
    
    // Validate current location
    if (currentPosition.value == null) {
      locationError.value = 'Unable to get current location. Please try again.';
      isValid = false;
    }
    
    // Validate image
    if (selectedImage.value == null) {
      imageError.value = 'Please take a photo of the customer';
      isValid = false;
    }
    
    // Validate number of families for individual customers
    if (customerType.value == 'individual') {
      if (numberOfFamilyController.text.trim().isEmpty) {
        // This field is optional, so we won't show an error
      } else {
        try {
          int families = int.parse(numberOfFamilyController.text.trim());
          if (families <= 0) {
            numberOfFamilyController.text = '';
          }
        } catch (e) {
          numberOfFamilyController.text = '';
        }
      }
    }
    
    return isValid;
  }
  
  // Submit customer registration
  Future<void> submitCustomerRegistration() async {
    if (!validateForm()) {
      return;
    }
    
    try {
      isSubmitting.value = true;
      
      // Create customer object
      Customer customer = Customer(
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        email: emailController.text.trim().isEmpty ? null : emailController.text.trim(),
        customerType: customerType.value,
        numberOfFamily: customerType.value == 'individual' && numberOfFamilyController.text.trim().isNotEmpty
            ? int.tryParse(numberOfFamilyController.text.trim()) ?? 0
            : 0,
        address: addressController.text.trim().isEmpty ? null : addressController.text.trim(),
        ketenaId: selectedKetena.value?.id,
        houseNo: houseNoController.text.trim().isEmpty ? null : houseNoController.text.trim(),
        latitude: currentPosition.value?.latitude,
        longitude: currentPosition.value?.longitude,
        subcityId: selectedSubcity.value?.id,
        woredaId: selectedWoreda.value?.id,
        blockId: selectedBlock.value?.id,
        profileImage: null, // Will be set after image upload
      );
      
      // Register customer
      var response = await customerRepository.registerCustomer(customer, selectedImage.value, additionalFiles);
      
      if (!response['error']) {
        Get.snackbar(
          'Success',
          response['message'] ?? 'Customer registered successfully',
          backgroundColor: successColor,
          colorText: Colors.white,
        );
        
        // Reset form
        resetForm();
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to register customer',
          backgroundColor: errorColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
  
  // Reset form
  void resetForm() {
    firstNameController.clear();
    lastNameController.clear();
    phoneController.clear();
    emailController.clear();
    numberOfFamilyController.clear();
    addressController.clear();
    houseNoController.clear();
    notesController.clear();
    selectedImage.value = null;
    additionalFiles.clear();
    selectedSubcity.value = null;
    selectedWoreda.value = null;
    selectedBlock.value = null;
    selectedKetena.value = null;
    woredas.clear();
    blocks.clear();
    customerType.value = 'individual';
  }

  // Clear location selections
  void clearLocationSelections() {
    selectedSubcity.value = null;
    selectedWoreda.value = null;
    selectedBlock.value = null;
    selectedKetena.value = null;
    woredas.clear();
    blocks.clear();
    ketenas.clear();
  }
}
