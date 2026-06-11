import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/modules/delivery/controller/delivery_controller.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/widgets/message_type_selector.dart';

class MessageTypeController extends GetxController {
  var selectedType = MessageType.reminder.obs;
}

class DeliveryScheduleDetailPage extends StatelessWidget {
  static const String routeName = '/delivery-schedule-detail';
  final DeliverySchedule delivery;
  final DeliveryController deliveryController = Get.find<DeliveryController>();
  
  DeliveryScheduleDetailPage({super.key, required this.delivery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${'delivery_schedule'.tr} #${delivery.id}', style: subTitleStyle(FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        elevation: 0,
      ),
      backgroundColor: lightColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(),
            const SizedBox(height: 10),
            
            // Location Information Card
            _buildLocationCard(),
            const SizedBox(height: 10),
            
            // Products Information Card
            _buildProductsCard(),
            const SizedBox(height: 10),
            
            // Notes Card (if available)
            if (delivery.notes != null && delivery.notes!.isNotEmpty) ...[
              _buildNotesCard(),
              const SizedBox(height: 10),
            ],
            
            // Timeline Card
            _buildTimelineCard(),
            
            // Add bottom padding to account for bottom app bar
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(),
    );
  }

  Widget _buildHeaderCard() {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${delivery.totalDeliveries} ${'deliveries_scheduled'.tr}',
                        style: darkSubTitleStyle(FontWeight.bold),
                      ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, color: primaryColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  DateFormat.yMMMd().format(DateTime.parse(delivery.dateFormatted)),
                  style: darkNormalTextStyle(FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildLocationCard() {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'location_information'.tr,
              style: darkSubTitleStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.location_on, color: primaryColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'subcity'.tr,
                        style: grayNormalTextStyle(FontWeight.normal),
                      ),
                      Text(
                        delivery.subcityName,
                        style: darkNormalTextStyle(FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.location_city, color: primaryColor, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'woreda'.tr,
                        style: grayNormalTextStyle(FontWeight.normal),
                      ),
                      Text(
                        delivery.woredaName,
                        style: darkNormalTextStyle(FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductsCard() {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${'products'.tr} (${delivery.productsSummary.length})',
              style: darkSubTitleStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...delivery.productsSummary.map((product) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Icon(Icons.inventory, color: primaryColor, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: darkNormalTextStyle(FontWeight.w600),
                        ),
                        Text(
                          '${'code'.tr}: ${product.code}',
                          style: grayNormalTextStyle(FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${product.quantity} ${product.unit}',
                    style: grayNormalTextStyle(FontWeight.normal),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }


  Widget _buildNotesCard() {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'notes'.tr,
              style: darkSubTitleStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: lightColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                delivery.notes!,
                style: grayNormalTextStyle(FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard() {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'timeline'.tr,
              style: darkSubTitleStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem(
              'created'.tr,
              delivery.createdAt,
              Icons.add_circle,
              primaryColor,
            ),
            if (delivery.startedAt != null)
              _buildTimelineItem(
                'started'.tr,
                delivery.startedAt!,
                Icons.play_circle,
                warningColor,
              ),
            if (delivery.finishedAt != null)
              _buildTimelineItem(
                'finished'.tr,
                delivery.finishedAt!,
                Icons.check_circle,
                successColor,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, String date, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: darkNormalTextStyle(FontWeight.w600),
                ),
                Text(
                  _formatDateTime(date),
                  style: grayNormalTextStyle(FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: primaryNormalTextStyle(FontWeight.bold),
        ),
        Text(
          label,
          style: grayNormalTextStyle(FontWeight.normal),
        ),
      ],
    );
  }

  // ignore: unused_element
  Widget _buildStatusChip(String status, String displayText) {
    Color color;
    switch (status.toLowerCase()) {
      case 'completed':
        color = successColor;
        break;
      case 'pending':
        color = warningColor;
        break;
      case 'in_progress':
        color = primaryColor;
        break;
      case 'cancelled':
        color = errorColor;
        break;
      default:
        color = grayColor;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        displayText,
        style: TextStyle(
          color: whiteColor,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return DateFormat.yMMMd().format(date);
    } catch (e) {
      return dateTime;
    }
  }

  Widget _buildBottomAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Start Delivery Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _handleStartDelivery(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'start'.tr,
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Notify Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _showNotifyDialog(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: warningColor,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'notify'.tr,
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              
              // Mark Undelivered Button
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: () => _handleMarkUndelivered(),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: errorColor,
              //       padding: const EdgeInsets.symmetric(vertical: 12),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     // icon: Icon(Iconsax.close_circle, color: whiteColor, size: 18),
              //     child: Text(
              //       'undelivered'.tr,
              //       style: TextStyle(
              //         color: whiteColor,
              //         fontWeight: FontWeight.w600,
              //         fontSize: 14,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStartDelivery() {
    // Generate a confirmation code (you can replace this with your actual logic)
    
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.8,
            maxWidth: Get.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.local_shipping, color: whiteColor, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'start_delivery'.tr,
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'start_delivery_confirmation'.tr,
                        style: darkNormalTextStyle(FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      
                      // Confirmation steps
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '📋 Confirmation Steps:',
                              style: darkNormalTextStyle(FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            _buildStepItem('1', 'verify_items_loaded'.tr),
                            _buildStepItem('2', 'check_quantities'.tr),
                            _buildStepItem('3', 'confirm_items_secured'.tr),
                            _buildStepItem('4', 'share_confirmation_code'.tr),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Confirmation code section
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: successColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: successColor.withOpacity(0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.qr_code, color: successColor, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'confirmation_code'.tr,
                                  style: TextStyle(
                                    color: successColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'share_code_instruction'.tr,
                              style: grayNormalTextStyle(FontWeight.normal),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: whiteColor,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: successColor.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      delivery.confirmationCode,
                                      style: TextStyle(
                                        color: successColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 2,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Implement copy to clipboard
                                      Get.snackbar(
                                        'code_copied'.tr,'code_copied_message'.tr,
                                        backgroundColor: successColor,
                                        colorText: whiteColor,
                                        duration: const Duration(seconds: 2),
                                      );
                                    },
                                    icon: Icon(Icons.copy, color: successColor, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Important note
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: warningColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: warningColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.info_outline, color: warningColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'code_sharing_confirmation'.tr,
                                style: TextStyle(
                                  color: warningColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(color: errorColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'ok'.tr,
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: grayNormalTextStyle(FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotifyDialog() async {
    // Show loading dialog
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: primaryColor),
              const SizedBox(height: 16),
              Text(
                'loading_blocks'.tr,
                style: darkNormalTextStyle(FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    try {
      // Fetch blocks from API using controller
      final result = await deliveryController.getBlocksForSchedule(delivery.id);
      
      // Close loading dialog
      Get.back();
      
      if (result['error'] == false) {
        final List<BlockData> blocks = result['data'];
        
        // Show blocks selection dialog
        _showBlocksSelectionDialog(blocks);
      } else {
        Get.snackbar(
          'error'.tr,
          result['message'] ?? 'failed_to_load_blocks'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      // Close loading dialog
      Get.back();
      
      Get.snackbar(
        'error'.tr,
        '${'failed_to_load_blocks'.tr}: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _showBlocksSelectionDialog(List<BlockData> blocks) {
    final RxList<int> selectedBlocks = <int>[].obs;
    final RxBool selectAll = false.obs;
    final MessageTypeController messageTypeController = Get.put(MessageTypeController());
    
    Get.dialog(
      Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.8,
            maxWidth: Get.width * 0.9,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: warningColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.notifications_active, color: whiteColor, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'send_notifications'.tr,
                        style: TextStyle(
                          color: whiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'select_blocks_instruction'.tr,
                        style: darkNormalTextStyle(FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      
                      // Select All Option
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: primaryColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Obx(() => Checkbox(
                              value: selectAll.value,
                              onChanged: (value) {
                                selectAll.value = value ?? false;
                                if (selectAll.value) {
                                  selectedBlocks.value = blocks.map((block) => block.id).toList();
                                } else {
                                  selectedBlocks.clear();
                                }
                              },
                              activeColor: primaryColor,
                            )),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'select_all_blocks'.tr,
                                    style: darkNormalTextStyle(FontWeight.bold),
                                  ),
                                  Text(
                                    'notify_all_customers'.tr,
                                    style: grayNormalTextStyle(FontWeight.normal),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${blocks.length} blocks',
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Blocks List
                      Text(
                        'individual_blocks'.tr,
                        style: darkNormalTextStyle(FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      
                      ...blocks.map((block) => _buildBlockItem(
                        block,
                        selectedBlocks,
                        selectAll,
                        blocks,
                      )).toList(),
                      
                      const SizedBox(height: 16),
                      
                      // Summary
                      Obx(() => Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: successColor.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: successColor.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info_outline, color: successColor, size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                selectedBlocks.isEmpty 
                                    ? 'no_blocks_selected'.tr
                                    : '${selectedBlocks.length} block${selectedBlocks.length == 1 ? '' : 's'} selected - ${_getTotalCustomers(blocks, selectedBlocks)} customers will be notified',
                                style: TextStyle(
                                  color: successColor,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                      Text('message_type'.tr, style: darkNormalTextStyle(FontWeight.w600)),
                      Obx(() => MessageTypeSelector(
                        selectedType: messageTypeController.selectedType.value,
                        onChanged: (value) {
                          messageTypeController.selectedType.value = value;
                        },
                      )),
                    ],
                  ),
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text(
                          'cancel'.tr,
                          style: TextStyle(color: errorColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Obx(() => ElevatedButton(
                        onPressed: selectedBlocks.isEmpty ? null : () {
                          Get.back();
                          _sendNotifications(selectedBlocks, blocks, messageTypeController.selectedType.value.name);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: selectedBlocks.isEmpty ? grayColor : warningColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text(
                          'send_notifications'.tr,
                          style: TextStyle(
                            color: whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBlockItem(
    BlockData block,
    RxList<int> selectedBlocks,
    RxBool selectAll,
    List<BlockData> allBlocks,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: lightColor),
      ),
      child: Row(
        children: [
          Obx(() => Checkbox(
            value: selectedBlocks.contains(block.id),
            onChanged: (value) {
              if (value ?? false) {
                selectedBlocks.add(block.id);
              } else {
                selectedBlocks.remove(block.id);
              }
              // Update select all state
              selectAll.value = selectedBlocks.length == allBlocks.length;
            },
            activeColor: primaryColor,
          )),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  block.name,
                  style: darkNormalTextStyle(FontWeight.w600),
                ),
                Text(
                  '${block.customerCount} customers',
                  style: grayNormalTextStyle(FontWeight.normal),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${block.customerCount}',
              style: TextStyle(
                color: primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalCustomers(List<BlockData> blocks, List<int> selectedBlockIds) {
    return blocks
        .where((block) => selectedBlockIds.contains(block.id))
        .fold(0, (sum, block) => sum + block.customerCount);
  }

  void _sendNotifications(List<int> selectedBlocks, List<BlockData> blocks, String messageType) async {
    final totalCustomers = _getTotalCustomers(blocks, selectedBlocks);
    final typeLabel = messageType == MessageType.reminder
        ? 'reminder'.tr
        : 'cancellation'.tr;

    // Show loading dialog
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    try {
      await deliveryController.sendDeliveryNotification({
        'block_ids': selectedBlocks,
        'message_type': messageType,
        'delivery_schedule_id': delivery.id,
      });
      Get.back(); // Dismiss loading
    Get.snackbar(
              'notifications_sent'.tr,
        '$typeLabel notifications sent to $totalCustomers customers in ${selectedBlocks.length} block${selectedBlocks.length == 1 ? '' : 's'}',
      backgroundColor: successColor,
      colorText: whiteColor,
      duration: const Duration(seconds: 4),
    );
    } catch (e) {
      Get.back(); // Dismiss loading
      Get.snackbar(
        'notification_failed'.tr,
                  'notification_failed_message'.tr,
        backgroundColor: errorColor,
        colorText: whiteColor,
        duration: const Duration(seconds: 4),
      );
    }
  }

  // void _handleMarkUndelivered() {
  //   Get.dialog(
  //     AlertDialog(
  //       title: Text('mark_as_undelivered'.tr, style: darkTitleStyle(FontWeight.bold)),
  //       content: Text(
  //                     'mark_undelivered_confirmation'.tr,
  //         style: grayNormalTextStyle(FontWeight.normal),
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Get.back(),
  //                             child: Text('cancel'.tr, style: TextStyle(color: grayColor)),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             Get.back();
  //             // TODO: Implement mark undelivered logic
  //             Get.snackbar(
  //               'marked_as_undelivered'.tr,
  //                                 'delivery_marked_undelivered'.tr,
  //               backgroundColor: errorColor,
  //               colorText: whiteColor,
  //               duration: const Duration(seconds: 3),
  //             );
  //           },
  //           style: ElevatedButton.styleFrom(backgroundColor: errorColor),
  //                             child: Text('mark'.tr, style: TextStyle(color: whiteColor)),
  //         ),
  //       ],
  //     ),
  //   );
  // }
} 