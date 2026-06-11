// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/modules/delivery/controller/delivery_controller.dart';
import 'package:marocsie/app/modules/delivery/delivery_list_screen.dart';
import 'package:marocsie/app/modules/delivery/delivery_schedule_detail.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/widgets/textfield.dart';

class DeliveriesListPage extends StatelessWidget {
  const DeliveriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final DeliveryController controller = Get.put(DeliveryController());

    return Scaffold(
      backgroundColor: lightColor,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }

        if (controller.hasError.value) {
          // Wrap error state in RefreshIndicator
          return RefreshIndicator(
            onRefresh: () => controller.fetchDeliverySchedules(refresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                      const SizedBox(height: 100),
                Icon(Icons.error_outline, size: 64, color: errorColor),
                const SizedBox(height: 16),
                Text(
                  'error_loading_deliveries'.tr,
                  style: darkTitleStyle(FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: grayNormalTextStyle(FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchDeliverySchedules(refresh: true),
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text('retry'.tr, style: lightButtonTextStyle(FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (controller.deliveries.isEmpty) {
          // Wrap empty state in RefreshIndicator
          return RefreshIndicator(
            onRefresh: () => controller.fetchDeliverySchedules(refresh: true),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                      const SizedBox(height: 100),
                Icon(Icons.delivery_dining_outlined, size: 64, color: grayColor),
                const SizedBox(height: 16),
                Text(
                  'no_deliveries_found'.tr,
                  style: darkTitleStyle(FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'there_are_no_deliveries'.tr,
                  style: grayNormalTextStyle(FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => controller.fetchDeliverySchedules(refresh: true),
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.deliveries.length + (controller.hasMoreDeliveries ? 1 : 0),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              if (index == controller.deliveries.length) {
                // Load more indicator
                if (controller.isLoadingMore.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(color: primaryColor),
                    ),
                  );
                } else {
                  // Load more button
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () => controller.loadMoreDeliveries(),
                        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                        child: Text('load_more'.tr, style: lightButtonTextStyle(FontWeight.bold)),
                      ),
                    ),
                  );
                }
              }

              final delivery = controller.deliveries[index];
              return _buildDeliveryCard(delivery, controller);
            },
          ),
        );
      }),
    );
  }

  Widget _buildDeliveryCard(DeliverySchedule delivery, DeliveryController controller) {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with schedule info and status
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${'schedule'.tr} #${delivery.id}',
                        style: darkTitleStyle(FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('MMM dd, yyyy').format(DateTime.parse(delivery.dateFormatted)),
                      style: grayNormalTextStyle(FontWeight.normal),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Location info
            Row(
              children: [
                Icon(Icons.location_on, color: primaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${delivery.subcityName} - ${delivery.woredaName}',
                    style: darkNormalTextStyle(FontWeight.w600),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Products summary
            Row(
              children: [
                Icon(Icons.inventory, color: primaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _getProductsSummaryText(delivery),
                    style: grayNormalTextStyle(FontWeight.normal),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Delivery person and allocations
            Row(
              children: [
                Icon(Icons.person, color: primaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    delivery.deliveryGuyName,
                    style: grayNormalTextStyle(FontWeight.normal),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${delivery.totalAllocations} ${'allocations'.tr}',
                    style: primaryNormalTextStyle(FontWeight.w600),
                  ),
                ),
              ],
            ),
            
            // Notes if available
            if (delivery.notes != null && delivery.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.note, color: primaryColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      delivery.notes!,
                      style: grayNormalTextStyle(FontWeight.normal),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.to(() => DeliveryScheduleDetailPage(delivery: delivery));
                    },
                    icon: const Icon(Icons.info_outline, size: 18),
                    label: Text('view_details'.tr, style: lightButtonTextStyle(FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: whiteColor,
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
                    onPressed: () {
                      Get.to(() => DeliveryListScreen(scheduleId: delivery.id));
                    },
                    icon: const Icon(Icons.list_alt, size: 18),
                    label: Text('deliveries'.tr, style: primaryButtonTextStyle(FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
      ),
    );
  }

  Widget _buildStatusChip(String status, String displayText) {
    Color chipColor;
    Color textColor = whiteColor;

    switch (status.toLowerCase()) {
      case 'completed':
        chipColor = successColor;
        break;
      case 'pending':
        chipColor = warningColor;
        break;
      case 'in_progress':
        chipColor = primaryColor;
        break;
      case 'cancelled':
        chipColor = errorColor;
        break;
      default:
        chipColor = grayColor;
        textColor = darkColor;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getProductsSummaryText(DeliverySchedule delivery) {
    if (delivery.productsSummary.isEmpty) {
      return 'no_products'.tr;
    }
    
    final productNames = delivery.productsSummary.map((p) => p.name).toList();
    if (productNames.length <= 2) {
      return productNames.join(', ');
    } else {
      return '${productNames.take(2).join(', ')} +${productNames.length - 2} ${'more_products'.tr}';
    }
  }

  void _showFilterDialog(BuildContext context, DeliveryController controller) {
    String selectedStatus = controller.selectedStatus.value;
    String selectedDate = controller.selectedDate.value;

    Get.dialog(
      AlertDialog(
        backgroundColor: whiteColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('filter_deliveries'.tr, style: darkTitleStyle(FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status filter
            DropdownButtonFormField<String>(
              value: selectedStatus.isEmpty ? null : selectedStatus,
              decoration: InputDecoration(
                labelText: 'status'.tr,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: [
                DropdownMenuItem(value: '', child: Text('all_statuses'.tr)),
                DropdownMenuItem(value: 'pending', child: Text('pending'.tr)),
                DropdownMenuItem(value: 'in_progress', child: Text('in_progress'.tr)),
                DropdownMenuItem(value: 'completed', child: Text('completed'.tr)),
                DropdownMenuItem(value: 'cancelled', child: Text('cancelled'.tr)),
              ],
              onChanged: (value) => selectedStatus = value ?? '',
            ),
            const SizedBox(height: 16),
            // Date filter
            MarocsieTextInputWidget(
              label: '${'date'.tr} (YYYY-MM-DD)',
              hintText: 'date_format_hint'.tr,
              controller: TextEditingController(text: selectedDate),
              onChanged: (value) => selectedDate = value,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(color: errorColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            onPressed: () {
              Get.back();
              if (selectedStatus != controller.selectedStatus.value) {
                controller.filterByStatus(selectedStatus);
              }
              if (selectedDate != controller.selectedDate.value) {
                controller.filterByDate(selectedDate);
              }
            },
            child: Text('apply'.tr, style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }
} 