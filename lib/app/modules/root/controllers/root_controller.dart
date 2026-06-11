import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/data/repositories/customers.dart';
import 'package:marocsie/app/modules/home/controllers/home_controller.dart';

class NavController extends GetxController {
  var page = 0.obs; // Observable variable for selected index
  var toggleSearch = false.obs;
  TextEditingController searchController = TextEditingController();
  final StorageService _storageService = StorageService();
  var searchText = "".obs;
  final RxBool isLoading = false.obs; // Loading state
  final RxBool hasError = false.obs; // Error state
  final errorMessage = "".obs;

  Rx<DeliveryResponse> searchResults = Rx<DeliveryResponse>(
    DeliveryResponse(count: 0, next: null, previous: null, results: [])
  );
  var searchResultsList = <Delivery>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  void startSearch() {
    toggleSearch.value = true;
  }

  void stopSearch() {
    toggleSearch.value = false;
    searchController.clear();
    searchText.value = "";
  }

  void changeIndex(int index) {
    page.value = index; // Update the selected index
    toggleSearch.value = false; // Exit search mode when changing pages
    searchController.clear();
    searchText.value = '';
    searchResultsList.clear();
    switch (page.value) {
      case 0:
        if (_storageService.readData('user_type') == 'ROLE_CONSULTANT') {
          Get.find<DashboardHomeController>().fetchDashboardCount();
        } else {
        }
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        // Get.find<ProfileController>().fetchCurrentUser();
        break;
    } //
  }

  Future<void> searchDelivery(String query) async {
    if (query.isEmpty) {
      searchResultsList.clear(); // Clear results if the query is empty
      return;
    }

    isLoading.value = true;
    hasError.value = false;

    try {
      final response = await UserServices()
          .searchDelivery(query); // Replace with your API call

      if (response['error'] == false) {
        
        final DeliveryListResponse data = response['data'];
        searchResultsList.value = data.results;
      } else {
        hasError.value = true;
        errorMessage.value = response['message'];
        // Get.snackbar("Error", "Failed to fetch search results");
      }
    } catch (e) {
      hasError.value = true;
      Get.snackbar("Error", "Something went wrong");
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSearchMode() {
    toggleSearch.toggle();
    if (!toggleSearch.value) {
      searchController.clear(); // Clear search text when exiting search mode
      searchText.value = '';
      errorMessage.value = '';
      searchResultsList.clear(); // Clear search results
    }
  }

}
