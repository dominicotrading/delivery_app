import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:marocsie/app/modules/delivery/delivery_detail_screen.dart';
import 'package:marocsie/app/modules/root/controllers/root_controller.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/widgets/error.dart';

class DeliverySearchResultWidget extends StatelessWidget {
  const DeliverySearchResultWidget({
    super.key,
    required this.navController,
  });

  final NavController navController;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Results
        Expanded(
          child: Obx(() {
            if (navController.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (navController.hasError.value) {
              return DataErrorWidget(
                  errorMessage: navController.errorMessage.value.isBlank!
                      ? "Failed to load search results"
                      : navController.errorMessage.value,
                  onRetry: () {});
            }

            if (navController.searchResultsList.isEmpty) {
              return EmptyWidget(emptyMessage: "no results found");
            }

            return ListView.builder(
              padding: EdgeInsets.all(0),
              itemCount: navController.searchResultsList.length,
              itemBuilder: (context, index) {
                final delivery = navController.searchResultsList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: whiteColor,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: InkWell(
                    onTap: () =>
                        Get.to(() => DeliveryDetailScreen(delivery: delivery)),
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
                                  delivery.customerName.isNotEmpty
                                      ? delivery.customerName[0]
                                      : 'C',
                                  style: TextStyle(
                                      color: whiteColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      delivery.customerName,
                                      style:
                                          darkNormalTextStyle(FontWeight.bold),
                                    ),
                                    Text(
                                      delivery.customerPhone,
                                      style: grayNormalTextStyle(
                                          FontWeight.normal),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Location info
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  color: primaryColor, size: 18),
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
                              Icon(Icons.inventory,
                                  color: primaryColor, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '${delivery.totalItems} items',
                                  style: grayNormalTextStyle(FontWeight.normal),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Total price and date
                          Row(
                            children: [
                              Icon(Icons.calendar_today,
                                  color: primaryColor, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat.yMMMd()
                                    .format(DateTime.parse(delivery.createdAt)),
                                style: grayNormalTextStyle(FontWeight.normal),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${delivery.totalPrice} ETB',
                                  style:
                                      primaryNormalTextStyle(FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
