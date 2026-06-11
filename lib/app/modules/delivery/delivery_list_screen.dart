import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/data/models/delivery.dart';
import 'package:marocsie/app/modules/delivery/controller/delivery_controller.dart';
import 'package:marocsie/app/modules/delivery/delivery_detail_screen.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';

class DeliveryListScreen extends StatefulWidget {
  final int scheduleId;
  const DeliveryListScreen({super.key, required this.scheduleId});

  @override
  State<DeliveryListScreen> createState() => _DeliveryListScreenState();
}

class _DeliveryListScreenState extends State<DeliveryListScreen> {
  final DeliveryController controller = Get.put(DeliveryController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch deliveries when this screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDeliveriesForSchedule(widget.scheduleId);
    });
    
    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (controller.hasMoreDeliveries && !controller.isLoadingMore.value) {
        controller.loadMoreDeliveries();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('deliveries'.tr, style: subTitleStyle(FontWeight.bold)),
        backgroundColor: primaryColor,
        foregroundColor: whiteColor,
        elevation: 0,
      ),
      backgroundColor: lightColor,
      body: Obx(() {
        if (controller.isDeliveriesLoading.value && controller.deliveriesList.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: primaryColor));
        }
        
        if (controller.deliveriesError.isNotEmpty && controller.deliveriesList.isEmpty) {
          return _buildErrorWidget();
        }
        
        if (controller.deliveriesList.isEmpty) {
          return _buildEmptyWidget();
        }
        
        return RefreshIndicator(
          onRefresh: () => controller.fetchDeliveriesForSchedule(widget.scheduleId),
          color: primaryColor,
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: controller.deliveriesList.length + (controller.hasMoreDeliveries ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == controller.deliveriesList.length) {
                return _buildLoadingMoreWidget();
              }
              
              final delivery = controller.deliveriesList[index];
              return _buildDeliveryCard(delivery);
            },
          ),
        );
      }),
    );
  }

  Widget _buildDeliveryCard(Delivery delivery) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: whiteColor,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => Get.to(() => DeliveryDetailScreen(delivery: delivery)),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with customer info and status
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 20,
                    child: Text(
                      delivery.customerName.isNotEmpty ? delivery.customerName[0] : 'C',
                      style: TextStyle(color: whiteColor, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          delivery.customerName,
                          style: darkNormalTextStyle(FontWeight.bold),
                        ),
                        Text(
                          delivery.customerPhone,
                          style: grayNormalTextStyle(FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusChip(delivery.deliveryStatus),
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
              
              // Product info
              Row(
                children: [
                  Icon(Icons.inventory, color: primaryColor, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${delivery.totalItems} ${'items'.tr}',
                      style: grayNormalTextStyle(FontWeight.normal),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Total price and date
              Row(
                children: [
                  Icon(Icons.calendar_today, color: primaryColor, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _formatDateTime(delivery.createdAt),
                    style: grayNormalTextStyle(FontWeight.normal),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${delivery.totalPrice} ${'etb_currency'.tr}',
                      style: primaryNormalTextStyle(FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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
        color = warningColor;
        label = 'in_progress'.tr;
        break;
      case 'completed' || 'delivered':
        color = successColor;
        label = 'delivered'.tr;
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

  Widget _buildLoadingMoreWidget() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Column(
          children: [
            const CircularProgressIndicator(color: primaryColor),
            const SizedBox(height: 8),
            Text(
              'loading_more_deliveries'.tr,
              style: grayNormalTextStyle(FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: errorColor),
          const SizedBox(height: 16),
          Text('error_loading_deliveries'.tr, style: darkTitleStyle(FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            controller.deliveriesError.value,
            style: grayNormalTextStyle(FontWeight.normal),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => controller.fetchDeliveriesForSchedule(widget.scheduleId),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
            child: Text('retry'.tr, style: lightButtonTextStyle(FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delivery_dining_outlined, size: 64, color: grayColor),
          const SizedBox(height: 16),
          Text('no_deliveries_found'.tr, style: darkTitleStyle(FontWeight.bold)),
          const SizedBox(height: 8),
          Text(
            'no_deliveries_message'.tr,
            style: grayNormalTextStyle(FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatDateTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateTime;
    }
  }
} 