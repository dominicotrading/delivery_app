import 'package:get/get.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/data/repositories/customers.dart';
import 'package:marocsie/app/data/repositories/delivery.dart';
// import 'package:marocsie/app/modules/delivery/delivery_list_screen.dart';

class DeliveryController extends GetxController {
  final DeliveryRepository _deliveryRepository = DeliveryRepository();
  
  // Observable variables
  var isLoading = true.obs;
  var isRefreshing = false.obs;
  var isLoadingMore = false.obs;
  var hasError = false.obs;
  var errorMessage = "".obs;
  
  // Blocks loading state
  var isBlocksLoading = false.obs;
  var blocksError = "".obs;
  
  // Data variables
  Rx<DeliveryResponse> deliveryResponse = Rx<DeliveryResponse>(
    DeliveryResponse(count: 0, next: null, previous: null, results: [])
  );
  Rx<List<BlockData>> blocksList = Rx<List<BlockData>>([]);
  Rx<PaginationInfo> paginationInfo = Rx<PaginationInfo>(
    PaginationInfo(
      count: 0,
      next: null,
      previous: null,
      currentPage: 1,
      totalPages: 1,
      pageSize: 10,
    )
  );
  
  // Filter variables
  var selectedStatus = "".obs;
  var selectedDate = "".obs;
  var currentPage = 1.obs;
  var pageSize = 10.obs;
  
  // Confirmation variables
  var isConfirmingQR = false.obs;
  var isConfirmingSMS = false.obs;
  var isSendingOTP = false.obs;
  var qrCode = "".obs;
  var smsOTP = "".obs;
  
  // Deliveries for a schedule
  var isDeliveriesLoading = false.obs;
  var deliveriesError = "".obs;
  var deliveriesList = <Delivery>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchDeliverySchedules();
  }
  
  /// Fetch delivery schedules with current filters
  Future<void> fetchDeliverySchedules({bool refresh = false}) async {
    try {
      if (refresh) {
        isRefreshing(true);
        currentPage.value = 1;
      } else {
        isLoading(true);
      }
      
      hasError(false);
      errorMessage("");
      
      final response = await _deliveryRepository.getDeliverySchedules(
        page: currentPage.value,
        pageSize: pageSize.value,
        status: selectedStatus.value.isNotEmpty ? selectedStatus.value : null,
        date: selectedDate.value.isNotEmpty ? selectedDate.value : null,
      );
      
      if (response['error'] == false) {
        deliveryResponse.value = response['data'];
        paginationInfo.value = response['pagination'];
      } else {
        hasError(true);
        errorMessage(response['message']);
      }
    } catch (e) {
      hasError(true);
      errorMessage("Failed to fetch delivery schedules: $e");
    } finally {
      isLoading(false);
      isRefreshing(false);
    }
  }
  
  /// Load more delivery schedules (pagination)
  Future<void> loadMoreDeliveries() async {
    if (paginationInfo.value.next != null && !isLoadingMore.value) {
      try {
        isLoadingMore(true);
        currentPage.value++;
        
        final response = await _deliveryRepository.getDeliverySchedules(
          page: currentPage.value,
          pageSize: pageSize.value,
          status: selectedStatus.value.isNotEmpty ? selectedStatus.value : null,
          date: selectedDate.value.isNotEmpty ? selectedDate.value : null,
        );
        
        if (response['error'] == false) {
          // Append new results to existing list
          final newResponse = response['data'] as DeliveryResponse;
          final updatedResults = [...deliveryResponse.value.results, ...newResponse.results];
          
          deliveryResponse.value = DeliveryResponse(
            count: newResponse.count,
            next: newResponse.next,
            previous: newResponse.previous,
            results: updatedResults,
          );
          
          paginationInfo.value = response['pagination'];
        } else {
          // Revert page number if failed
          currentPage.value--;
          hasError(true);
          errorMessage(response['message']);
        }
      } catch (e) {
        currentPage.value--;
        hasError(true);
        errorMessage("Failed to load more deliveries: $e");
      } finally {
        isLoadingMore(false);
      }
    }
  }
  
  /// Filter deliveries by status
  void filterByStatus(String status) {
    selectedStatus.value = status;
    currentPage.value = 1;
    fetchDeliverySchedules();
  }
  
  /// Filter deliveries by date
  void filterByDate(String date) {
    selectedDate.value = date;
    currentPage.value = 1;
    fetchDeliverySchedules();
  }
  
  /// Clear all filters
  void clearFilters() {
    selectedStatus.value = "";
    selectedDate.value = "";
    currentPage.value = 1;
    fetchDeliverySchedules();
  }
  
  /// Fetch single delivery schedule by ID
  Future<DeliverySchedule?> getDeliveryById(int id) async {
    try {
      final response = await _deliveryRepository.getDeliveryScheduleById(id);
      
      if (response['error'] == false) {
        return response['data'] as DeliverySchedule;
      } else {
        hasError(true);
        errorMessage(response['message']);
        return null;
      }
    } catch (e) {
      hasError(true);
      errorMessage("Failed to fetch delivery details: $e");
      return null;
    }
  }
  
  /// Update delivery status
  Future<bool> updateDeliveryStatus(int id, String status, {String? notes}) async {
    try {
      final response = await _deliveryRepository.updateDeliveryStatus(id, status, notes: notes);
      
      if (response['error'] == false) {
        // Update the delivery in the current list
        final updatedDelivery = response['data'] as DeliverySchedule;
        final currentResults = deliveryResponse.value.results;
        final index = currentResults.indexWhere((d) => d.id == id);
        
        if (index != -1) {
          currentResults[index] = updatedDelivery;
          deliveryResponse.refresh();
        }
        
        return true;
      } else {
        hasError(true);
        errorMessage(response['message']);
        return false;
      }
    } catch (e) {
      hasError(true);
      errorMessage("Failed to update delivery status: $e");
      return false;
    }
  }
  
  /// Confirm delivery with QR code
  Future<bool> confirmDeliveryWithQR(
    int deliveryId,
    String qrCode, {
    List<Map<String, dynamic>>? selectedItems,
    double? locationX,
    double? locationY,
    String? paymentMethod,
  }) async {
    try {
      isConfirmingQR(true);
      final response = await _deliveryRepository.confirmDeliveryWithQR(
        deliveryId,
        qrCode,
        selectedItems: selectedItems,
        locationX: locationX,
        locationY: locationY,
        paymentMethod: paymentMethod,
      );
      if (response['error'] == false) {
        await fetchDeliverySchedules(refresh: true);
        return true;
      } else {
        hasError(true);
        errorMessage(response['message']);
        return false;
      }
    } catch (e) {
      hasError(true);
      errorMessage("Failed to confirm delivery with QR: $e");
      return false;
    } finally {
      isConfirmingQR(false);
    }
  }
  
  /// Send SMS OTP for delivery confirmation
  Future<bool> sendDeliveryOTP(int deliveryId) async {
    try {
      isSendingOTP(true);
      final response = await _deliveryRepository.sendDeliveryOTP(deliveryId);
      
      if (response['error'] == false) {
        return true;
      } else {
        hasError(true);
        errorMessage(response['message']);
        return false;
      }
    } catch (e) {
      hasError(true);
      errorMessage("Failed to send OTP: $e");
      return false;
    } finally {
      isSendingOTP(false);
    }
  }

  // Future<bool> sendDeliverySMS(int deliveryId) async {
  //   try {
  //     isSendingOTP(true);
  //     final response = await _deliveryRepository.sendDeliverySMS(deliveryId);
  //   }
  // }

  /// Confirm delivery with SMS OTP
  Future<bool> confirmDeliveryWithSMS(
    int deliveryId,
    String otp, {
    List<Map<String, dynamic>>? selectedItems,
    double? locationX,
    double? locationY,
    String? paymentMethod,
  }) async {
    try {
      isConfirmingSMS(true);
      final response = await _deliveryRepository.confirmDeliveryWithSMS(
        deliveryId,
        otp,
        selectedItems: selectedItems,
        locationX: locationX,
        locationY: locationY,
        paymentMethod: paymentMethod,
      );
      if (response['error'] == false) {
        await fetchDeliverySchedules(refresh: true);
        return true;
      } else {
        hasError(true);
        errorMessage(response['message']);
        return false;
      }
    } catch (e) {
      hasError(true);
      errorMessage("Failed to confirm delivery with SMS: $e");
      return false;
    } finally {
      isConfirmingSMS(false);
    }
  }
 
  
  /// Check if there are more deliveries to load
  bool get hasMoreDeliveries => paginationInfo.value.next != null;
  
  /// Get current delivery list
  List<DeliverySchedule> get deliveries => deliveryResponse.value.results;
  
  /// Get total count
  int get totalCount => deliveryResponse.value.count;
  
  Future<void> fetchDeliveriesForSchedule(int scheduleId, {int page = 1, int pageSize = 10}) async {
    try {
      isDeliveriesLoading(true);
      deliveriesError("");
      final response = await _deliveryRepository.getDeliveriesForSchedule(
        scheduleId: scheduleId,
        page: page,
        pageSize: pageSize,
      );
      if (response['error'] == false) {
        final DeliveryListResponse data = response['data'];
        deliveriesList.value = data.results;
      } else {
        deliveriesError(response['message']);
      }
    } catch (e) {
      deliveriesError("Failed to fetch deliveries: $e");
    } finally {
      isDeliveriesLoading(false);
    }
  }

  Future<Map<String, dynamic>> getBlocksForSchedule(int scheduleId) async {
    try {
      isBlocksLoading(true);
      blocksError("");
      final response = await _deliveryRepository.getBlocksForSchedule(scheduleId);
      if (response['error'] == false) {
        blocksList.value = response['data'];
        return {
          'error': false,
          'data': response['data'],
          'message': 'blocks_fetched_successfully'.tr
        };
      } else {
        blocksError(response['message']);
        return {
          'error': true,
          'message': response['message']
        };
      }
    } catch (e) {
      blocksError("Failed to fetch blocks: $e");
      return {
        'error': true,
        'message': "${'failed_to_fetch_blocks'.tr}: $e"
      };
    } finally {
      isBlocksLoading(false);
    }
  }

  Future<Map<String, dynamic>> sendDeliveryNotification(formData) async {
    try {
      final response = await UserServices().sendDeliveryNotification(formData);
      if (response['error'] == false) {
        return {
          'error': false,
          'data': response['data'],
          'message': 'delivery_notification_sent_successfully'.tr
        };
      } else {
        return {
          'error': true,
          'message': response['message']
        };
      }
    } catch (e) {
      return {
        'error': true,
        'message': "${'failed_to_send_delivery_notification'.tr}: $e"
      };
    }
  }
}
