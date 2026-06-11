class DeliveryDashboard {
  int? delivered;
  int? failed;
  int? pending;
  List<RecentDeliveries>? recentDeliveries;

  DeliveryDashboard(
      {this.delivered, this.failed, this.pending, this.recentDeliveries});

  DeliveryDashboard.fromJson(Map<String, dynamic> json) {
    delivered = json['delivered'];
    failed = json['failed'];
    pending = json['pending'];
    if (json['recent_deliveries'] != null) {
      recentDeliveries = <RecentDeliveries>[];
      json['recent_deliveries'].forEach((v) {
        recentDeliveries!.add(new RecentDeliveries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivered'] = this.delivered;
    data['failed'] = this.failed;
    data['pending'] = this.pending;
    if (this.recentDeliveries != null) {
      data['recent_deliveries'] =
          this.recentDeliveries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RecentDeliveries {
  int? id;
  int? customer;
  String? customerName;
  String? customerId;
  String? customerPhone;
  List<DeliveryItems>? deliveryItems;
  int? totalItems;
  String? totalPrice;
  String? subcityName;
  String? woredaName;
  String? blockName;
  int? deliveryGuy;
  String? deliveryGuyName;
  String? deliveryStatus;
  bool? deliveryStarted;
  String? deliveryStartedAt;
  bool? delivered;
  String? deliveredAt;
  bool? failed;
  String? failedAt;
  String? failureReason;
  String? notes;
  String? createdAt;
  String? updatedAt;

  RecentDeliveries(
      {this.id,
      this.customer,
      this.customerName,
      this.customerId,
      this.customerPhone,
      this.deliveryItems,
      this.totalItems,
      this.totalPrice,
      this.subcityName,
      this.woredaName,
      this.blockName,
      this.deliveryGuy,
      this.deliveryGuyName,
      this.deliveryStatus,
      this.deliveryStarted,
      this.deliveryStartedAt,
      this.delivered,
      this.deliveredAt,
      this.failed,
      this.failedAt,
      this.failureReason,
      this.notes,
      this.createdAt,
      this.updatedAt});

  RecentDeliveries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    customerName = json['customer_name'];
    customerId = json['customer_id'];
    customerPhone = json['customer_phone'];
    if (json['delivery_items'] != null) {
      deliveryItems = <DeliveryItems>[];
      json['delivery_items'].forEach((v) {
        deliveryItems!.add(new DeliveryItems.fromJson(v));
      });
    }
    totalItems = json['total_items'];
    totalPrice = json['total_price'];
    subcityName = json['subcity_name'];
    woredaName = json['woreda_name'];
    blockName = json['block_name'];
    deliveryGuy = json['delivery_guy'];
    deliveryGuyName = json['delivery_guy_name'];
    deliveryStatus = json['delivery_status'];
    deliveryStarted = json['delivery_started'];
    deliveryStartedAt = json['delivery_started_at'];
    delivered = json['delivered'];
    deliveredAt = json['delivered_at'];
    failed = json['failed'];
    failedAt = json['failed_at'];
    failureReason = json['failure_reason'];
    notes = json['notes'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['customer_name'] = this.customerName;
    data['customer_id'] = this.customerId;
    data['customer_phone'] = this.customerPhone;
    if (this.deliveryItems != null) {
      data['delivery_items'] =
          this.deliveryItems!.map((v) => v.toJson()).toList();
    }
    data['total_items'] = this.totalItems;
    data['total_price'] = this.totalPrice;
    data['subcity_name'] = this.subcityName;
    data['woreda_name'] = this.woredaName;
    data['block_name'] = this.blockName;
    data['delivery_guy'] = this.deliveryGuy;
    data['delivery_guy_name'] = this.deliveryGuyName;
    data['delivery_status'] = this.deliveryStatus;
    data['delivery_started'] = this.deliveryStarted;
    data['delivery_started_at'] = this.deliveryStartedAt;
    data['delivered'] = this.delivered;
    data['delivered_at'] = this.deliveredAt;
    data['failed'] = this.failed;
    data['failed_at'] = this.failedAt;
    data['failure_reason'] = this.failureReason;
    data['notes'] = this.notes;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class DeliveryItems {
  int? id;
  int? customerAllocationId;
  String? productName;
  String? productCode;
  String? quantity;
  int? unit;
  String? allocationQuantity;
  String? allocationUnit;
  String? unitPrice;
  String? totalPrice;
  String? createdAt;
  String? updatedAt;

  DeliveryItems(
      {this.id,
      this.customerAllocationId,
      this.productName,
      this.productCode,
      this.quantity,
      this.unit,
      this.allocationQuantity,
      this.allocationUnit,
      this.unitPrice,
      this.totalPrice,
      this.createdAt,
      this.updatedAt});

  DeliveryItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customerAllocationId = json['customer_allocation_id'];
    productName = json['product_name'];
    productCode = json['product_code'];
    quantity = json['quantity'];
    unit = json['unit'];
    allocationQuantity = json['allocation_quantity'];
    allocationUnit = json['allocation_unit'];
    unitPrice = json['unit_price'];
    totalPrice = json['total_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer_allocation_id'] = this.customerAllocationId;
    data['product_name'] = this.productName;
    data['product_code'] = this.productCode;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['allocation_quantity'] = this.allocationQuantity;
    data['allocation_unit'] = this.allocationUnit;
    data['unit_price'] = this.unitPrice;
    data['total_price'] = this.totalPrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
