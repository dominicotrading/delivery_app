import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/data/models/notification.dart';
import 'package:marocsie/app/data/providers/storage.dart';
import 'package:marocsie/app/data/repositories/notification_services.dart';

class NotificationController extends GetxController {
  final notifications = <InAppNotification>[].obs; // Observable list of doctors

  final StorageService storageService = StorageService();
  final NotificationServices _notificationService = NotificationServices();
  
  var isLoading = false.obs;
  var buttonLoading = false.obs;
  var hasError = false.obs;
  final currentPage = 1.obs; // Current page
  final totalPages = 1.obs; // Total pages
  var nextPageUrl = RxnString();
  var previousPageUrl = RxnString();
  
  @override
  void onInit() {
    fetchNotifications();
    super.onInit();
  }

  Future<void> fetchNotifications({bool loadMore = false}) async {
    if (isLoading.value) return;

    try {
      if (!loadMore) {
        isLoading(true);
      }
      var response = await _notificationService.getNotifications(currentPage.value);
      hasError.value = response['error'] ?? false;
      print(response);
      if (response['error'] == false) {
        // Parse paginated notification response
        final data = response['data'] ?? response; // fallback if 'data' is not used
        final results = data['results'] ?? [];
        final List<InAppNotification> fetched = results.map<InAppNotification>((n) => InAppNotification.fromJson(n)).toList();
        if (loadMore) {
          notifications.addAll(fetched);
          notifications.refresh();
        } else {
          notifications.value = fetched;
          notifications.refresh();
        }
        // Pagination
        currentPage.value = data['current'] ?? (data['next'] != null ? currentPage.value + 1 : 1);
        totalPages.value = (data['count'] != null && data['results'] != null && data['results'].isNotEmpty)
          ? ((data['count'] / data['results'].length).ceil())
          : 1;
        nextPageUrl.value = data['next'];
        previousPageUrl.value = data['previous'];
      }
    } finally {
      isLoading(false);
    }
  }

  // Mark a notification as read
  void markAsRead(String notificationId) {
    print("notificationId: $notificationId");
    final notification = notifications.firstWhere(
      (n) => n.id.toString() == notificationId);
    print("notification: $notification");
    _notificationService.updateNotification(notificationId);    
    if (notifications.isNotEmpty) {
      notification.seen = true;
      notifications.refresh(); // Update the UI
    }
  }

  // Mark all notifications as read
  void markAllAsRead() {
    _notificationService.setUnseenNotificationStatus();
    for (var notification in notifications) {
      notification.seen= true;
    }
    notifications.refresh(); // Update the UI
  }


    // Load more doctors
  void loadMoreData() {
    if (currentPage.value < totalPages.value) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
      currentPage.value++; // Increment page number
        fetchNotifications(loadMore: true); // Fetch more doctors
      });
    }
  }

  // Refresh doctors list
  Future<void> refreshAmbulance() async {
    currentPage.value = 1; // Reset to the first page
   fetchNotifications();
  }

  Future<void> deleteNotification(String notificationId) async {
    buttonLoading.value = true;
    try {
      final response = await _notificationService.deleteNotification(notificationId);
      if (response != null && response['error'] == false) {
        notifications.removeWhere((n) => n.id.toString() == notificationId);
        notifications.refresh();
      }
    } finally {
      buttonLoading.value = false;
    }
  }
}