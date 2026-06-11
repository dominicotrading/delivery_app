import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marocsie/app/data/models/customer.dart';
import 'package:marocsie/app/data/repositories/customer_repository.dart';
import 'package:marocsie/app/theme/colors.dart';
import 'package:marocsie/app/theme/fonts.dart';
import 'package:marocsie/app/utils/api_helpers.dart';

class CustomerListScreen extends StatelessWidget {
  static const String routeName = '/customer-list';
  
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerListController());
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),     
      appBar: AppBar(
        title: Text(
          'customers'.tr,
          style: darkSubTitleStyle(FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: primaryColor),
            onPressed: () => controller.refreshCustomers(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: controller.searchController,
              onChanged: controller.onSearchChanged,
              decoration: InputDecoration(
                hintText: 'search_customers'.tr,
                prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          
          // Pagination info - wrapped in Obx to make it reactive
          Obx(() {
            if (controller.totalCount.value > 0) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${controller.totalCount.value} ${'customers_count'.tr}',
                          style: grayNormalTextStyle(FontWeight.w500),
                        ),
                        Text(
                          '${'page_of'.tr} ${controller.currentPage.value} ${'of'.tr} ${controller.totalPages.value}',
                          style: grayNormalTextStyle(FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }
            return const SizedBox.shrink();
          }),
          
          Expanded(
            child: Obx(() => controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : controller.filteredCustomers.isEmpty && controller.searchQuery.value.isEmpty
                    ? _buildEmptyState()
                    : controller.filteredCustomers.isEmpty && controller.searchQuery.value.isNotEmpty
                        ? _buildNoSearchResults()
                        : _buildCustomerList(controller)),
          ),
          
          // Pagination controls - wrapped in Obx to make it reactive
          Obx(() {
            if (controller.totalPages.value > 1 && controller.searchQuery.value.isEmpty) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: controller.hasPreviousPage.value 
                          ? () => controller.fetchCustomers(page: controller.currentPage.value - 1)
                          : null,
                      icon: Icon(
                        Icons.chevron_left, 
                        color: controller.hasPreviousPage.value ? primaryColor : Colors.grey[300],
                        size: 28,
                      ),
                    ),
                    Text(
                      '${'page_of'.tr} ${controller.currentPage.value} ${'of'.tr} ${controller.totalPages.value}',
                      style: grayNormalTextStyle(FontWeight.w500),
                    ),
                    IconButton(
                      onPressed: controller.hasNextPage.value 
                          ? () => controller.fetchCustomers(page: controller.currentPage.value + 1)
                          : null,
                      icon: Icon(
                        Icons.chevron_right, 
                        color: controller.hasNextPage.value ? primaryColor : Colors.grey[300],
                        size: 28,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'no_customers_found'.tr,
            style: darkSubTitleStyle(FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'no_customers_message'.tr,
            style: grayNormalTextStyle(FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'no_search_results'.tr,
            style: darkSubTitleStyle(FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'try_different_search'.tr,
            style: grayNormalTextStyle(FontWeight.normal),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerList(CustomerListController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = controller.filteredCustomers[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () => _showCustomerDetails(context, customer),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Profile image or avatar
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: customer.profileImage != null && customer.profileImage!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                customer.profileImage!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Icon(
                                  Icons.person,
                                  size: 30,
                                  color: primaryColor,
                                ),
                              ),
                            )
                          : Icon(
                              Icons.person,
                              size: 30,
                              color: primaryColor,
                            ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Customer info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${customer.firstName} ${customer.lastName}',
                            style: darkNormalTextStyle(FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            customer.phoneNumber,
                            style: grayNormalTextStyle(FontWeight.normal),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: customer.customerType == 'individual' 
                                      ? Colors.blue[50] 
                                      : Colors.green[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: customer.customerType == 'individual' 
                                        ? Colors.blue[200]! 
                                        : Colors.green[200]!,
                                  ),
                                ),
                                                                   child: Text(
                                     customer.customerType == 'individual' ? 'individual'.tr : 'business'.tr,
                                     style: TextStyle(
                                       color: customer.customerType == 'individual' 
                                           ? Colors.blue[700] 
                                           : Colors.green[700],
                                       fontSize: 11,
                                       fontWeight: FontWeight.w500,
                                     ),
                                   ),
                              ),
                                                             // Location information removed for privacy
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Arrow indicator
                    Icon(
                      Icons.chevron_right,
                      color: Colors.grey[400],
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCustomerDetails(BuildContext context, CustomerData customer) {
    final controller = Get.find<CustomerListController>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomerDetailsModal(customer: customer, controller: controller),
    );
  }
}

class CustomerDetailsModal extends StatelessWidget {
  final CustomerData customer;
  final CustomerListController controller;

  const CustomerDetailsModal({super.key, required this.customer, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header with profile image
          Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Profile image
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: primaryColor.withOpacity(0.3), width: 3),
                  ),
                  child: customer.profileImage != null && customer.profileImage!.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            ApiHelpers.hostUrl + customer.profileImage!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 50,
                              color: primaryColor,
                            ),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: primaryColor,
                        ),
                ),
                
                const SizedBox(height: 16),
                
                // Name and type
                Text(
                  '${customer.firstName} ${customer.lastName}',
                  style: darkSubTitleStyle(FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 8),
                
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: customer.customerType == 'individual' 
                        ? Colors.blue[50] 
                        : Colors.green[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: customer.customerType == 'individual' 
                          ? Colors.blue[200]! 
                          : Colors.green[200]!,
                    ),
                  ),
                  child: Text(
                                         customer.customerType == 'individual' ? 'individual_customer'.tr : 'business_customer'.tr,
                    style: TextStyle(
                      color: customer.customerType == 'individual' 
                          ? Colors.blue[700] 
                          : Colors.green[700],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Details
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                                     _buildDetailSection('contact_information'.tr, [
                    _buildDetailRow(Icons.phone, 'Phone', customer.phoneNumber),
                    if (customer.email != null && customer.email!.isNotEmpty)
                      _buildDetailRow(Icons.email, 'Email', customer.email!),
                  ]),
                  
                  if (customer.customerType == 'individual' && customer.numberOfFamily != 0) ...[
                    const SizedBox(height: 24),
                                         _buildDetailSection('family_information'.tr, [
                       _buildDetailRow(Icons.family_restroom, 'family_members'.tr, '${customer.numberOfFamily}'),
                     ]),
                  ],
                  
                  if (customer.subcity != null || customer.woreda != null || customer.block != null) ...[
                    const SizedBox(height: 24),
                                         _buildDetailSection('location_information'.tr, [
                      if (customer.subcity != null)
                        _buildDetailRow(Icons.location_city, 'Subcity', customer.subcity!),
                      if (customer.woreda != null)
                        _buildDetailRow(Icons.location_on, 'Woreda', customer.woreda!),
                      if (customer.ketena != null)
                        _buildDetailRow(Icons.grid_on, 'Ketena', customer.ketena!),
                      if (customer.block != null)
                        _buildDetailRow(Icons.grid_on, 'Block', customer.block!),
                    ]),
                  ],
                  
                  if (customer.address != null && customer.address!.isNotEmpty) ...[
                    const SizedBox(height: 24),
                                         _buildDetailSection('address'.tr, [
                       _buildDetailRow(Icons.home, 'address'.tr, customer.address!),
                     ]),
                  ],
                  
                  // Coordinates section removed for privacy and security
                  
                  if (customer.customerId.isNotEmpty) ...[
                    const SizedBox(height: 24),
                                         _buildDetailSection('account_information'.tr, [
                       _buildDetailRow(Icons.badge, 'customer_id'.tr, customer.customerId),
                       _buildDetailRow(
                         Icons.calendar_today, 
                         'registered'.tr, 
                         _formatDate(customer.createdAt?.toIso8601String() ?? '')
                       ),
                     ]),
                  ],
                  
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          
          // Pagination controls
          if (controller.totalPages.value > 1) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: controller.hasPreviousPage.value 
                        ? () => controller.fetchCustomers(page: controller.currentPage.value - 1)
                        : null,
                    icon: Icon(Icons.chevron_left, color: controller.hasPreviousPage.value ? primaryColor : Colors.grey[300]),
                  ),
                                     Text(
                     '${'page_of'.tr} ${controller.currentPage.value} ${'of'.tr} ${controller.totalPages.value}',
                     style: grayNormalTextStyle(FontWeight.w500),
                   ),
                  IconButton(
                    onPressed: controller.hasNextPage.value 
                        ? () => controller.fetchCustomers(page: controller.currentPage.value + 1)
                        : null,
                    icon: Icon(Icons.chevron_right, color: controller.hasNextPage.value ? primaryColor : Colors.grey[300]),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: darkNormalTextStyle(FontWeight.w600),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: darkNormalTextStyle(FontWeight.normal),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }
}

class CustomerListController extends GetxController {
  final CustomerRepository customerRepository = CustomerRepository();
  final searchController = TextEditingController();
  
  var customers = <CustomerData>[].obs;
  var filteredCustomers = <CustomerData>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var currentPage = 1.obs;
  var hasNextPage = false.obs;
  var hasPreviousPage = false.obs;
  var totalPages = 1.obs;
  var totalCount = 0.obs;
  
  @override
  void onInit() {
    super.onInit();
    fetchCustomers();
  }
  
  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
  
  Future<void> fetchCustomers({int page = 1, bool refresh = false}) async {
    try {
      if (refresh) {
        currentPage.value = 1;
        page = 1;
        customers.clear();
        searchQuery.value = '';
        searchController.clear();
      }
      
      isLoading.value = true;
      var response = await customerRepository.getCustomers(page: page, pageSize: 10);
      
      if (!response['error']) {
        List<CustomerData> newCustomers = response['data'];
        
        // Always replace the list when fetching a specific page (not appending)
        customers.value = newCustomers;
        
        // Apply search filter if there's an active search query
        if (searchQuery.value.isEmpty) {
          filteredCustomers.value = List.from(newCustomers);
        } else {
          // Re-apply search filter on the new customers
          searchCustomers(searchQuery.value);
        }
        
        // Update pagination info
        if (response['pagination'] != null) {
          var pagination = response['pagination'];
          print('Pagination data: $pagination'); // Debug log
          
          // Extract pagination values with fallbacks
          currentPage.value = pagination['current_page'] ?? pagination['page'] ?? page;
          hasNextPage.value = pagination['has_next'] ?? (pagination['next'] != null && pagination['next'].toString().isNotEmpty);
          hasPreviousPage.value = pagination['has_previous'] ?? (pagination['previous'] != null && pagination['previous'].toString().isNotEmpty);
          totalPages.value = pagination['total_pages'] ?? pagination['num_pages'] ?? 1;
          totalCount.value = pagination['total_count'] ?? pagination['count'] ?? newCustomers.length;
          
          print('Parsed pagination - Page: ${currentPage.value}, Total: ${totalPages.value}, HasNext: ${hasNextPage.value}, HasPrev: ${hasPreviousPage.value}');
        } else {
          // If no pagination data, set defaults based on current page
          print('No pagination data in response');
          currentPage.value = page;
          // If we got fewer customers than pageSize, we're on the last page
          hasNextPage.value = newCustomers.length >= 5;
          hasPreviousPage.value = page > 1;
          // Estimate total pages (this is a fallback)
          totalPages.value = hasNextPage.value ? page + 1 : page;
          totalCount.value = newCustomers.length;
        }
      } else {
        Get.snackbar(
          'Error',
          response['message'] ?? 'Failed to fetch customers',
          backgroundColor: errorColor,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        backgroundColor: errorColor,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadNextPage() async {
    if (hasNextPage.value && !isLoading.value) {
      await fetchCustomers(page: currentPage.value + 1);
    }
  }
  
  void searchCustomers(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      // When search is cleared, show current page customers
      filteredCustomers.value = List.from(customers);
    } else {
      // Filter customers from current page only
      // Note: For full search across all pages, you would need to implement server-side search
      filteredCustomers.value = customers.where((customer) {
        return customer.firstName.toLowerCase().contains(query.toLowerCase()) ||
               customer.lastName.toLowerCase().contains(query.toLowerCase()) ||
               customer.phoneNumber.contains(query) ||
               (customer.email != null && customer.email!.toLowerCase().contains(query.toLowerCase())) ||
               (customer.customerId.toLowerCase().contains(query.toLowerCase()));
      }).toList();
    }
  }
  
  void refreshCustomers() {
    fetchCustomers(refresh: true);
  }

  void onSearchChanged(String query) {
    searchCustomers(query);
  }
}
