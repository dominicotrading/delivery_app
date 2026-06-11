import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:marocsie/app/modules/notification/controller/notification.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/widgets/error.dart';

class NotificationScreen extends StatelessWidget {
  static const String routeName = '/notification-screen';

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: lightColor,
        title: Text(
          'notifications'.tr,
          style: subTitleStyle(FontWeight.bold),
        ),        
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child:CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return EmptyWidget(emptyMessage:"no_notifications".tr);
        }

        return RefreshIndicator(
          onRefresh: () async {
            controller.currentPage.value = 1;
            await controller.fetchNotifications();
          },
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: controller.notifications.length + 1,
            itemBuilder: (context, index) {
              if (index == controller.notifications.length) {
                if (controller.currentPage.value < controller.totalPages.value) {
                  controller.loadMoreData(); // Load more notifications
                  return Center(child: CircularProgressIndicator());
                } else {
                  return SizedBox(); // No more notifications to load
                }
              }

              final notification = controller.notifications[index];
              final isRead = notification.seen == true;
              final timestamp = notification.timestamp != null
                  ? DateFormat('MMM dd, yyyy - hh:mm a').format(notification.timestamp!)
                  : "Unknown Date";

              return Dismissible(
                key: Key(notification.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (direction) {
                  controller.deleteNotification(notification.id.toString());
                },
                child: Card(
                  margin: EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: Icon(
                      Iconsax.notification,
                      color: isRead ? Colors.grey : primaryColor,
                    ),
                    title: Text(
                      notification.header ?? "No Title",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                        color: isRead ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text(
                          notification.message ?? "No Description",
                          style: TextStyle(
                            fontSize: 14,
                            color: isRead ? Colors.grey : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          timestamp,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    trailing: isRead
                        ? null
                        : IconButton(
                            icon: Icon(Icons.circle, size: 12, color: primaryColor),
                            onPressed: () {
                              controller.markAsRead(notification.id.toString()); // Mark as read
                            },
                          ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}