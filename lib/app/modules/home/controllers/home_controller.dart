// ignore_for_file: deprecated_member_use

import 'package:get/get.dart';
import 'package:marocsie/app/data/models/dashboard.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/data/repositories/auth.dart';

class DashboardHomeController extends GetxController {
  final StorageService storageService = StorageService();
  final AuthRepository _userServices = AuthRepository();
  
  var isLoading = true.obs;
  var buttonLoading = false.obs;
  var hasError = false.obs;
  var isEmpty = false.obs;
  var errorMessage = "".obs;
  Rx<DeliveryDashboard> dashboardData = Rx<DeliveryDashboard>(DeliveryDashboard());

  
  @override
  void onInit() {
    fetchDashboardCount();
    super.onInit();
  }

  void fetchDashboardCount() async {
    print("Calling fetch dashboard>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.. <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    try {
      isLoading(true);
      var response = await _userServices.getDashboardCount();
      hasError.value = response['error'];
      if(response['error'] == false){
        dashboardData.value = response['data'];
      }else{
        errorMessage.value = response['message'];
      }
    } finally {
      isLoading(false);
    }
  }

   Future <Map<String,dynamic>> refreshDashboardCount() async {
    print("refreshing dashboard>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.. <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
    try {
      isLoading(true);
      var response = await _userServices.getDashboardCount();
      hasError.value = response['error'];
      dashboardData.value = response['data'];
      return response;
    } finally {
      isLoading(false);
    }
  }
  
}
