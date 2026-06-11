import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/modules/delivery/controller/delivery_controller.dart';
import 'package:marocsie/app/modules/delivery/qr_scanner_screen.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/modules/delivery/controller/delivery_detail_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:marocsie/app/widgets/payment_method_selector.dart';

class DeliveryDetailScreen extends StatelessWidget {
  final Delivery delivery;
  
  DeliveryDetailScreen({super.key, required this.delivery});


    final DeliveryController controller = Get.put(DeliveryController());
    final DeliveryDetailController detailController = Get.put(DeliveryDetailController());

  @override
  Widget build(BuildContext context) {
    
    // Initialize selections only once
    if (detailController.itemSelections.isEmpty) {
      detailController.initialize(delivery.deliveryItems);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${'delivery'.tr} #${delivery.id}', style: subTitleStyle(FontWeight.bold)),
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
            
            // Customer Information Card
            _buildCustomerCard(),
            const SizedBox(height: 10),
            
            // Location Information Card
            _buildLocationCard(),
            const SizedBox(height: 10),
            
            // Delivery Items Card
            _buildDeliveryItemsCard(detailController),
            const SizedBox(height: 10),
            
            // Delivery Status Card
            _buildStatusCard(),
            const SizedBox(height: 10),
              
            // Timeline Card
            _buildTimelineCard(),
            const SizedBox(height: 80), // Add bottom padding for bottom app bar
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomAppBar(controller, detailController),
    );
  }

  Widget _buildBottomAppBar(DeliveryController controller, DeliveryDetailController detailController) {
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
      padding: const EdgeInsets.all(16),
      child: delivery.deliveryStatus != 'delivered' ? SafeArea(
        child: Row(
          children: [
            // QR Confirm Button 
            Expanded(
              child: Obx(() => ElevatedButton.icon(
                onPressed: detailController.selectedCount > 0
                    ? () => _showQRConfirmDialog(controller, detailController)
                    : null,
                icon: const Icon(Icons.qr_code_scanner, size: 20, color: whiteColor),
                label: Text('qr_confirm'.tr, style: lightButtonTextStyle(FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: whiteColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )),
            ),
            const SizedBox(width: 12),
            
            // SMS Confirm Button
            Expanded(
              child: Obx(() => OutlinedButton.icon(
                onPressed: detailController.selectedCount > 0
                    ? () => _showSMSConfirmDialog(controller, detailController)
                    : null,
                icon: const Icon(Icons.sms_outlined, size: 20),
                label: Text('sms_confirm'.tr, style: primaryButtonTextStyle(FontWeight.w600)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )),
            ),
          ],
        ),
      ):const SizedBox.shrink(),
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
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'delivery_details'.tr,
                        style: darkNormalTextStyle(FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${'delivery'.tr} #${delivery.id}',
                        style: primaryNormalTextStyle(FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(delivery.deliveryStatus),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.calendar_today, color: primaryColor, size: 20),
                const SizedBox(width: 12),
                Text(
                  _formatDateTime(delivery.createdAt),
                  style: darkNormalTextStyle(FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerCard() {
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
              'customer_information'.tr,
              style: darkNormalTextStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 25,
                  child: Text(
                    delivery.customerName.isNotEmpty ? delivery.customerName[0] : 'C',
                    style: TextStyle(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        delivery.customerName,
                        style: darkNormalTextStyle(FontWeight.w600),
                      ),
                      Text(
                        '${'customer_id'.tr}: ${delivery.customerId}',
                        style: grayNormalTextStyle(FontWeight.normal),
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
              style: darkNormalTextStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildLocationItem('subcity'.tr, delivery.subcityName, Icons.location_city),
            const SizedBox(height: 12),
            _buildLocationItem('woreda'.tr, delivery.woredaName, Icons.location_on),
            const SizedBox(height: 12),
            _buildLocationItem('block'.tr, delivery.blockName, Icons.home),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: grayNormalTextStyle(FontWeight.normal),
              ),
              Text(
                value,
                style: darkNormalTextStyle(FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryItemsCard(DeliveryDetailController detailController) {
    return Card(
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${'items_count'.tr} (${detailController.itemSelections.length})',
                  style: darkNormalTextStyle(FontWeight.bold),
                ),
                const Spacer(),
                Obx(() {
                  final total = detailController.selectedTotal;
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${'total_etb'.tr}: ${total.toStringAsFixed(2)} ETB',
                      style: primaryNormalTextStyle(FontWeight.w600),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            Obx(() => Column(
              children: List.generate(
                detailController.itemSelections.length,
                (index) => _buildDeliveryItem(detailController, index),
              ),
            )),
            const SizedBox(height: 8),
            Obx(() {
              final selectedCount = detailController.selectedCount;
              return Text(
                '$selectedCount item(s) selected for confirmation',
                style: grayNormalTextStyle(FontWeight.normal),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryItem(DeliveryDetailController detailController, int index) {
    final selection = detailController.itemSelections[index];
    final item = selection.item;
    final maxQty = double.parse(item.quantity).toInt();
    return selection.quantity.value == 1
        ? Dismissible(
            key: ValueKey(item.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: errorColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.delete, color: whiteColor),
                  const SizedBox(width: 8),
                  Text('remove'.tr, style: lightButtonTextStyle(FontWeight.bold)),
                ],
              ),
            ),
            onDismissed: (_) => detailController.removeItem(index),
            child: _buildItemRow(detailController, index, selection, item, maxQty),
          )
        : _buildItemRow(detailController, index, selection, item, maxQty);
  }

  Widget _buildItemRow(DeliveryDetailController detailController, int index, DeliveryItemSelection selection, DeliveryItem item, int maxQty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: grayColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox
          Obx(() => Checkbox(
            value: selection.selected.value,
            onChanged: (val) => detailController.selectItem(index, val ?? false),
          )),
          const SizedBox(width: 8),
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      item.productName,
                      style: darkNormalTextStyle(FontWeight.w600),
                    ),
                    const Spacer(),
                    Text(
                      '${'code'.tr}: ${item.productCode}',
                      style: grayNormalTextStyle(FontWeight.normal),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildItemDetail('unit_price'.tr, '${item.unitPrice} ETB')),
                    Expanded(child: _buildItemDetail('total_etb'.tr, '${(double.tryParse(item.unitPrice)! * selection.quantity.value).toStringAsFixed(2)} ETB')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${'quantity'.tr}:', style: grayNormalTextStyle(FontWeight.normal)),
                    const SizedBox(width: 8),
                    // Quantity stepper
                    Obx(() => Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: selection.quantity.value > 1
                              ? () => detailController.changeQuantity(index, selection.quantity.value - 1)
                              : null,
                        ),
                        Text(
                          selection.quantity.value.toString(),
                          style: darkNormalTextStyle(FontWeight.w600),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: selection.quantity.value < maxQty
                              ? () => detailController.changeQuantity(index, selection.quantity.value + 1)
                              : null,
                        ),
                      ],
                    )),
                    // const SizedBox(width: 8),
                    // Text('/ $maxQty', style: grayNormalTextStyle(FontWeight.normal)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: grayNormalTextStyle(FontWeight.normal),
        ),
        Text(
          value,
          style: primaryNormalTextStyle(FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildStatusCard() {
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
              'delivery_status'.tr,
              style: darkNormalTextStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.person, color: primaryColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'delivery_personnel'.tr,
                        style: grayNormalTextStyle(FontWeight.normal),
                      ),
                      Text(
                        delivery.deliveryGuyName,
                        style: darkNormalTextStyle(FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildStatusItem('started'.tr, delivery.deliveryStarted, delivery.deliveryStartedAt),
                const SizedBox(width: 16),
                _buildStatusItem('delivered'.tr, delivery.delivered, delivery.deliveredAt),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem(String label, bool isCompleted, String? timestamp) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: grayNormalTextStyle(FontWeight.normal),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.pending,
                color: isCompleted ? successColor : warningColor,
                size: 20,
              ),
              const SizedBox(width: 8),
                              Text(
                  isCompleted ? 'yes'.tr : 'no'.tr,
                style: TextStyle(
                  color: isCompleted ? successColor : warningColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          if (timestamp != null) ...[
            const SizedBox(height: 4),
            Text(
              _formatDateTime(timestamp),
              style: grayNormalTextStyle(FontWeight.normal),
            ),
          ],
        ],
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
              style: darkNormalTextStyle(FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildTimelineItem('scheduled'.tr, delivery.createdAt, Icons.add_circle, primaryColor),
            if (delivery.deliveryStartedAt != null)
              _buildTimelineItem('started'.tr, delivery.deliveryStartedAt!, Icons.play_circle, warningColor),
            if (delivery.deliveredAt != null)
              _buildTimelineItem('delivered'.tr, delivery.deliveredAt!, Icons.check_circle, successColor),
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

  void _showQRConfirmDialog(DeliveryController controller, DeliveryDetailController detailController) {
    final selectedItems = detailController.itemSelections.where((s) => s.selected.value).toList();
    final Rx<PaymentMethod> paymentMethod = PaymentMethod.cash.obs;
    Get.dialog(
      AlertDialog(
        title: Text('delivery_confirmation'.tr, style: darkTitleStyle(FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedItems.isNotEmpty) ...[
                Text('${'selected_items'.tr}:', style: darkNormalTextStyle(FontWeight.bold)),
                const SizedBox(height: 8),
                Column(
                        children: selectedItems.map((selection) {
                          final item = selection.item;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.productName, style: darkNormalTextStyle(FontWeight.w600)),
                                      Text('${'code'.tr}: ${item.productCode}', style: grayNormalTextStyle(FontWeight.normal)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${'quantity'.tr}: ${selection.quantity.value}', style: primaryNormalTextStyle(FontWeight.bold)),
                                    Text('${(double.tryParse(item.unitPrice)! * selection.quantity.value).toStringAsFixed(2)} ETB', style: darkNormalTextStyle(FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    ,
                const SizedBox(height: 16),
              ],
              Text(
                'scan_qr_instruction'.tr,
                style: grayNormalTextStyle(FontWeight.normal),
              ),
              const SizedBox(height: 16),
              Text('${'payment_method'.tr}:', style: darkNormalTextStyle(FontWeight.bold)),
              Obx(() => Row(
                children: [
                  Radio<PaymentMethod>(
                    value: PaymentMethod.cash,
                    groupValue: paymentMethod.value,
                    onChanged: (method) => paymentMethod.value = method!,
                  ),
                  Text('cash'.tr),
                  Radio<PaymentMethod>(
                    value: PaymentMethod.bank,
                    groupValue: paymentMethod.value,
                    onChanged: (method) => paymentMethod.value = method!,
                  ),
                  Text('bank'.tr),
                ],
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(color: errorColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              // Get location before proceeding
              final position = await _getCurrentLocationWithDialog(Get.context!);
              if (position == null) return;
              Get.back();
              
              _openQRScanner(controller, detailController, paymentMethod.value, position);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text('scan_qr'.tr, style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }

  void _showSuccessConfirmation(String method) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent back button
        child: Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    Icons.check_circle,
                    color: successColor,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                Text(
                  'delivery_confirmation'.tr,
                  style: darkTitleStyle(FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                
                // Subtitle
                Text(
                  'delivery_location_verified'.tr,
                  style: grayNormalTextStyle(FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                
                // Success details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: successColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: successColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, color: successColor, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${'confirmed_at'.tr} ${DateTime.now().toString().substring(11, 16)}',
                            style: TextStyle(
                              color: successColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.location_on, color: successColor, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'delivery_location_verified'.tr,
                              style: TextStyle(
                                color: successColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back(); // Close success dialog
                      Get.back(); // Navigate back to previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: successColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'done'.tr,
                      style: TextStyle(
                        color: whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
 

  void _openQRScanner(DeliveryController controller, DeliveryDetailController detailController, PaymentMethod paymentMethod, Position? position) {
    final selectedItems = detailController.selectedItems;
    Get.to(() => QRScannerScreen(
      onQRCodeScanned: (String qrData) async {
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(color: primaryColor),
          ),
          barrierDismissible: false,
        );
        final success = await controller.confirmDeliveryWithQR(
          delivery.id,
          qrData,
          selectedItems: selectedItems,
          locationX: position?.latitude,
          locationY: position?.longitude,
          paymentMethod: paymentMethod == PaymentMethod.cash ? 'cash' : 'bank',
        );
        Get.back();
        if (success) {
          _showSuccessConfirmation('qr_code'.tr);
        } else {
          Get.snackbar(
            'confirmation_failed'.tr,
            controller.errorMessage.value.isNotEmpty 
                ? controller.errorMessage.value 
                : 'failed_to_confirm_qr'.tr,
            backgroundColor: errorColor,
            colorText: whiteColor,
            duration: const Duration(seconds: 4),
          );
        }
      },
    ));
  }

  void _showSMSConfirmDialog(DeliveryController controller, DeliveryDetailController detailController) {
    final selectedItems = detailController.itemSelections.where((s) => s.selected.value).toList();
    final Rx<PaymentMethod> paymentMethod = PaymentMethod.cash.obs;

    Get.dialog(
      AlertDialog(
        title: Text('sms_confirmation'.tr, style: darkTitleStyle(FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedItems.isNotEmpty) ...[
                Text('${'selected_items'.tr}:', style: darkNormalTextStyle(FontWeight.bold)),
                const SizedBox(height: 8),
               Column(
                        children: selectedItems.map((selection) {
                          final item = selection.item;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(item.productName, style: darkNormalTextStyle(FontWeight.w600)),
                                      Text('${'code'.tr}: ${item.productCode}', style: grayNormalTextStyle(FontWeight.normal)),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${'quantity'.tr}: ${selection.quantity.value}', style: primaryNormalTextStyle(FontWeight.bold)),
                                    Text('${(double.tryParse(item.unitPrice)! * selection.quantity.value).toStringAsFixed(2)} ETB', style: darkNormalTextStyle(FontWeight.w600)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      )
                    ,
                const SizedBox(height: 16),
                const SizedBox(height: 16),
              ],
              Text(
                'sms_otp_instruction'.tr,
                style: grayNormalTextStyle(FontWeight.normal),
              ),
              Text('${'payment_method'.tr}:', style: darkNormalTextStyle(FontWeight.bold)),
              Obx(() => Row(
                children: [
                  Radio<PaymentMethod>(
                    value: PaymentMethod.cash,
                    groupValue: paymentMethod.value,
                    onChanged: (method) => paymentMethod.value = method!,
                  ),
                  Text('cash'.tr),
                  Radio<PaymentMethod>(
                    value: PaymentMethod.bank,
                    groupValue: paymentMethod.value,
                    onChanged: (method) => paymentMethod.value = method!,
                  ),
                  Text('bank'.tr),
                ],
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(color: errorColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              final position = await _getCurrentLocationWithDialog(Get.context!);
              if (position == null) return;
              Get.back();
              _sendSMSOTP(controller, selectedItems, paymentMethod.value, position);
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text('send_sms'.tr, style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }

  void _sendSMSOTP(DeliveryController controller, List selectedItems, PaymentMethod paymentMethod, Position? position) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(color: primaryColor),
      ),
      barrierDismissible: false,
    );
    final otpSent = await controller.sendDeliveryOTP(delivery.id);
    Get.back();
    if (otpSent) {
      _showSMSCodeDialog(controller, selectedItems, paymentMethod, position);
    } else {
      Get.snackbar(
        'otp_send_failed'.tr,
        controller.errorMessage.value.isNotEmpty 
            ? controller.errorMessage.value 
                          : 'failed_to_send_otp'.tr,
        backgroundColor: errorColor,
        colorText: whiteColor,
        duration: const Duration(seconds: 4),
      );
    }
  }

  void _showSMSCodeDialog(DeliveryController controller, List selectedItems, PaymentMethod paymentMethod, Position? position) {
    final TextEditingController otpController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text('enter_confirmation_code'.tr, style: darkTitleStyle(FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'enter_otp_instruction'.tr,
              style: grayNormalTextStyle(FontWeight.normal),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: InputDecoration(
                hintText: 'enter_6_digit_code'.tr,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: '',
              ),
              style: darkNormalTextStyle(FontWeight.normal),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr, style: TextStyle(color: errorColor)),
          ),
          ElevatedButton(
            onPressed: () async {
              final otp = otpController.text.trim();
              if (otp.length == 6) {
                Get.back();
                Get.dialog(
                  const Center(
                    child: CircularProgressIndicator(color: primaryColor),
                  ),
                  barrierDismissible: false,
                );
                final success = await controller.confirmDeliveryWithSMS(
                  delivery.id,
                  otp,
                  selectedItems: detailController.selectedItems,
                  locationX: position?.latitude,
                  locationY: position?.longitude,
                  paymentMethod: paymentMethod == PaymentMethod.cash ? 'cash' : 'bank',
                );
                Get.back();
                if (success) {
                  _showSuccessConfirmation('sms_code'.tr);
                } else {
                  Get.snackbar(
                    'confirmation_failed'.tr,
                    controller.errorMessage.value.isNotEmpty 
                        ? controller.errorMessage.value 
                        : 'failed_to_confirm_code'.tr,
                    backgroundColor: errorColor,
                    colorText: whiteColor,
                    duration: const Duration(seconds: 4),
                  );
                }
              } else {
                Get.snackbar(
                  'invalid_code'.tr,
                                      'enter_6_digit_code_error'.tr,
                  backgroundColor: errorColor,
                  colorText: whiteColor,
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text('verify'.tr, style: TextStyle(color: whiteColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;
    
    switch (status.toLowerCase()) {
      case 'pending':
        color = warningColor;
        label = 'pending'.tr;
        break;
      case 'in_progress':
        color = primaryColor;
        label = 'in_progress'.tr;
        break;
      case 'completed':
        color = successColor;
        label = 'completed'.tr;
        break;
      case 'cancelled':
        color = errorColor;
        label = 'cancelled'.tr;
        break;
      default:
        color = grayColor;
        label = status;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
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
      // return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateTime;
    }
  }

  Future<Position?> _getCurrentLocationWithDialog(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Get.snackbar('location_disabled'.tr, 'enable_location_services'.tr, backgroundColor: errorColor, colorText: whiteColor);
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('location_denied'.tr, 'location_permission_required'.tr, backgroundColor: errorColor, colorText: whiteColor);
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
              Get.snackbar('location_denied'.tr, 'location_permission_denied'.tr, backgroundColor: errorColor, colorText: whiteColor);
      return null;
    }

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      final position = await Geolocator.getCurrentPosition();
      Get.back();
      return position;
    } catch (e) {
      Get.back();
      Get.snackbar('location_error'.tr, 'could_not_get_location'.tr, backgroundColor: errorColor, colorText: whiteColor);
      return null;
    }
  }
} 