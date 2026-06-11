class DeliveryResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<DeliverySchedule> results;

  DeliveryResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory DeliveryResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
          ?.map((item) => DeliverySchedule.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }
}

class DeliverySchedule {
  final int id;
  final String date;
  final String dateFormatted;
  final int woreda;
  final String woredaName;
  final String subcityName;
  final List<WoredaAllocation> woredaAllocations;
  final int totalAllocations;
  final int totalCustomerAllocations;
  final List<ProductSummary> productsSummary;
  final int deliveryGuy;
  final String deliveryGuyName;
  final String? notes;
  final String status;
  final String statusDisplay;
  final int totalDeliveries;
  final int processedDeliveries;
  final int createdCount;
  final int skippedCount;
  final String? startedAt;
  final String? finishedAt;
  final String createdAt;
  final String confirmationCode;

  DeliverySchedule({
    required this.id,
    required this.date,
    required this.dateFormatted,
    required this.woreda,
    required this.woredaName,
    required this.subcityName,
    required this.woredaAllocations,
    required this.totalAllocations,
    required this.totalCustomerAllocations,
    required this.productsSummary,
    required this.deliveryGuy,
    required this.deliveryGuyName,
    this.notes,
    required this.status,
    required this.statusDisplay,
    required this.totalDeliveries,
    required this.processedDeliveries,
    required this.createdCount,
    required this.skippedCount,
    this.startedAt,
    this.finishedAt,
    required this.createdAt,
    required this.confirmationCode,
  });

  factory DeliverySchedule.fromJson(Map<String, dynamic> json) {
    return DeliverySchedule(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      dateFormatted: json['date_formatted'] ?? '',
      woreda: json['woreda'] ?? 0,
      woredaName: json['woreda_name'] ?? '',
      subcityName: json['subcity_name'] ?? '',
      woredaAllocations: (json['woreda_allocations'] as List<dynamic>?)
          ?.map((item) => WoredaAllocation.fromJson(item))
          .toList() ?? [],
      totalAllocations: json['total_allocations'] ?? 0,
      totalCustomerAllocations: json['total_customer_allocations'] ?? 0,
      productsSummary: (json['products_summary'] as List<dynamic>?)
          ?.map((item) => ProductSummary.fromJson(item))
          .toList() ?? [],
      deliveryGuy: json['delivery_guy'] ?? 0,
      deliveryGuyName: json['delivery_guy_name'] ?? '',
      notes: json['notes'],
      status: json['status'] ?? '',
      statusDisplay: json['status_display'] ?? '',
      totalDeliveries: json['total_deliveries'] ?? 0,
      processedDeliveries: json['processed_deliveries'] ?? 0,
      createdCount: json['created_count'] ?? 0,
      skippedCount: json['skipped_count'] ?? 0,
      startedAt: json['started_at'],
      finishedAt: json['finished_at'],
      createdAt: json['created_at'] ?? '',
      confirmationCode: json['confirmation_code'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'date_formatted': dateFormatted,
      'woreda': woreda,
      'woreda_name': woredaName,
      'subcity_name': subcityName,
      'woreda_allocations': woredaAllocations.map((item) => item.toJson()).toList(),
      'total_allocations': totalAllocations,
      'total_customer_allocations': totalCustomerAllocations,
      'products_summary': productsSummary.map((item) => item.toJson()).toList(),
      'delivery_guy': deliveryGuy,
      'delivery_guy_name': deliveryGuyName,
      'notes': notes,
      'status': status,
      'status_display': statusDisplay,
      'total_deliveries': totalDeliveries,
      'processed_deliveries': processedDeliveries,
      'created_count': createdCount,
      'skipped_count': skippedCount,
      'started_at': startedAt,
      'finished_at': finishedAt,
      'created_at': createdAt,
    };
  }
}

class WoredaAllocation {
  final int id;
  final int product;
  final String productName;
  final String productCode;
  final String quantity;
  final int unit;
  final String unitSymbol;
  final String allocationDate;
  final String status;
  final int customerCount;

  WoredaAllocation({
    required this.id,
    required this.product,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unit,
    required this.unitSymbol,
    required this.allocationDate,
    required this.status,
    required this.customerCount,
  });

  factory WoredaAllocation.fromJson(Map<String, dynamic> json) {
    return WoredaAllocation(
      id: json['id'] ?? 0,
      product: json['product'] ?? 0,
      productName: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      quantity: json['quantity'] ?? '',
      unit: json['unit'] ?? 0,
      unitSymbol: json['unit_symbol'] ?? '',
      allocationDate: json['allocation_date'] ?? '',
      status: json['status'] ?? '',
      customerCount: json['customer_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product,
      'product_name': productName,
      'product_code': productCode,
      'quantity': quantity,
      'unit': unit,
      'unit_symbol': unitSymbol,
      'allocation_date': allocationDate,
      'status': status,
      'customer_count': customerCount,
    };
  }
}

class ProductSummary {
  final int id;
  final String name;
  final String code;
  final double quantity;
  final String unit;

  ProductSummary({
    required this.id,
    required this.name,
    required this.code,
    required this.quantity,
    required this.unit,
  });

  factory ProductSummary.fromJson(Map<String, dynamic> json) {
    return ProductSummary(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'] ?? '',
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }
}

// New Delivery models based on the provided JSON structure
class DeliveryListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Delivery> results;

  DeliveryListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory DeliveryListResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryListResponse(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List<dynamic>?)
          ?.map((item) => Delivery.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }
}

class Delivery {
  final int id;
  final int customer;
  final String customerName;
  final String customerPhone;
  final String customerId;
  final List<DeliveryItem> deliveryItems;
  final int totalItems;
  final String totalPrice;
  final String subcityName;
  final String woredaName;
  final String blockName;
  final int deliveryGuy;
  final String deliveryGuyName;
  final String deliveryStatus;
  final bool deliveryStarted;
  final String? deliveryStartedAt;
  final bool delivered;
  final String? deliveredAt;
  final String notes;
  final String createdAt;
  final String updatedAt;

  Delivery({
    required this.id,
    required this.customer,
    required this.customerName,
    required this.customerPhone,
    required this.customerId,
    required this.deliveryItems,
    required this.totalItems,
    required this.totalPrice,
    required this.subcityName,
    required this.woredaName,
    required this.blockName,
    required this.deliveryGuy,
    required this.deliveryGuyName,
    required this.deliveryStatus,
    required this.deliveryStarted,
    this.deliveryStartedAt,
    required this.delivered,
    this.deliveredAt,
    required this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Delivery.fromJson(Map<String, dynamic> json) {
    return Delivery(
      id: json['id'] ?? 0,
      customer: json['customer'] ?? 0,
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerId: json['customer_id'] ?? '',
      deliveryItems: (json['delivery_items'] as List<dynamic>?)
          ?.map((item) => DeliveryItem.fromJson(item))
          .toList() ?? [],
      totalItems: json['total_items'] ?? 0,
      totalPrice: json['total_price'] ?? '0.00',
      subcityName: json['subcity_name'] ?? '',
      woredaName: json['woreda_name'] ?? '',
      blockName: json['block_name'] ?? '',
      deliveryGuy: json['delivery_guy'] ?? 0,
      deliveryGuyName: json['delivery_guy_name'] ?? '',
      deliveryStatus: json['delivery_status'] ?? '',
      deliveryStarted: json['delivery_started'] ?? false,
      deliveryStartedAt: json['delivery_started_at'],
      delivered: json['delivered'] ?? false,
      deliveredAt: json['delivered_at'],
      notes: json['notes'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer': customer,
      'customer_name': customerName,
      'delivery_items': deliveryItems.map((item) => item.toJson()).toList(),
      'total_items': totalItems,
      'total_price': totalPrice,
      'subcity_name': subcityName,
      'woreda_name': woredaName,
      'block_name': blockName,
      'delivery_guy': deliveryGuy,
      'delivery_guy_name': deliveryGuyName,
      'delivery_status': deliveryStatus,
      'delivery_started': deliveryStarted,
      'delivery_started_at': deliveryStartedAt,
      'delivered': delivered,
      'delivered_at': deliveredAt,
      'notes': notes,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class DeliveryItem {
  final int id;
  final int customerAllocationId;
  final String productName;
  final String productCode;
  final String quantity;
  final int unit;
  final String allocationQuantity;
  final String allocationUnit;
  final String unitPrice;
  final String totalPrice;
  final String createdAt;
  final String updatedAt;

  DeliveryItem({
    required this.id,
    required this.customerAllocationId,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unit,
    required this.allocationQuantity,
    required this.allocationUnit,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DeliveryItem.fromJson(Map<String, dynamic> json) {
    return DeliveryItem(
      id: json['id'] ?? 0,
      customerAllocationId: json['customer_allocation_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productCode: json['product_code'] ?? '',
      quantity: json['quantity'] ?? '0.00',
      unit: json['unit'] ?? 0,
      allocationQuantity: json['allocation_quantity'] ?? '0.00',
      allocationUnit: json['allocation_unit'] ?? '',
      unitPrice: json['unit_price'] ?? '0.00',
      totalPrice: json['total_price'] ?? '0.00',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_allocation_id': customerAllocationId,
      'product_name': productName,
      'product_code': productCode,
      'quantity': quantity,
      'unit': unit,
      'allocation_quantity': allocationQuantity,
      'allocation_unit': allocationUnit,
      'unit_price': unitPrice,
      'total_price': totalPrice,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class PaginationInfo {
  final int count;
  final String? next;
  final String? previous;
  final int currentPage;
  final int totalPages;
  final int pageSize;

  PaginationInfo({
    required this.count,
    this.next,
    this.previous,
    required this.currentPage,
    required this.totalPages,
    required this.pageSize,
  });

  factory PaginationInfo.fromResponse(DeliveryResponse response) {
    final currentPage = _extractPageFromUrl(response.next ?? response.previous ?? '') ?? 1;
    final totalPages = (response.count / 10).ceil(); // Assuming default page size of 10
    
    return PaginationInfo(
      count: response.count,
      next: response.next,
      previous: response.previous,
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: 10,
    );
  }

  factory PaginationInfo.fromDeliveryListResponse(DeliveryListResponse response) {
    final currentPage = _extractPageFromUrl(response.next ?? response.previous ?? '') ?? 1;
    final totalPages = (response.count / 10).ceil(); // Assuming default page size of 10
    
    return PaginationInfo(
      count: response.count,
      next: response.next,
      previous: response.previous,
      currentPage: currentPage,
      totalPages: totalPages,
      pageSize: 10,
    );
  }

  static int? _extractPageFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final pageParam = uri.queryParameters['page'];
      return pageParam != null ? int.parse(pageParam) : 1;
    } catch (e) {
      return 1;
    }
  }

  factory PaginationInfo.fromJson(Map<String, dynamic> json) {
    return PaginationInfo(
      count: json['count'] ?? 0,
      next: json['next'],
      previous: json['previous'],
      currentPage: json['current_page'] ?? 1,
      totalPages: json['total_pages'] ?? 1,
      pageSize: json['page_size'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'current_page': currentPage,
      'total_pages': totalPages,
      'page_size': pageSize,
    };
  }
}


class BlockData {
  final int id;
  final String name;
  final int customerCount;

  BlockData({
    required this.id,
    required this.name,
    required this.customerCount,
  });

  factory BlockData.fromJson(Map<String, dynamic> json) {
    return BlockData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      customerCount: json['customer_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'customer_count': customerCount,
    };
  }
}