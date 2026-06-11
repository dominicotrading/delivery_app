class Customer {
  final int? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String customerType;
  final int numberOfFamily;
  final String? address;
  final int? ketenaId;
  final String? houseNo;
  final double? latitude;
  final double? longitude;
  final int? subcityId;
  final int? woredaId;
  final int? blockId;
  final String? profileImage;
  final List<String>? additionalFiles;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.email,
    this.customerType = 'individual',
    this.numberOfFamily = 0,
    this.address,
    this.ketenaId,
    this.houseNo,
    this.latitude,
    this.longitude,
    this.subcityId,
    this.woredaId,
    this.blockId,
    this.profileImage,
    this.additionalFiles,
    this.createdAt,
    this.updatedAt,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'],
      customerType: json['customer_type'] ?? 'individual',
      numberOfFamily: json['number_of_family'] ?? 0,
      address: json['address'],
      ketenaId: json['ketena_id'],
      houseNo: json['house_no'],
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      subcityId: json['subcity_id'],
      woredaId: json['woreda_id'],
      blockId: json['block_id'],
      profileImage: json['profile_image'],
      additionalFiles: json['additional_files'] != null
          ? List<String>.from(json['additional_files'] as List)
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'customer_type': customerType,
      'number_of_family': numberOfFamily,
      'address': address,
      'ketena_id': ketenaId,
      'house_no': houseNo,
      'latitude': latitude,
      'longitude': longitude,
      'subcity_id': subcityId,
      'woreda_id': woredaId,
      'block_id': blockId,
      'profile_image': profileImage,
      'additional_files': additionalFiles,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  Customer copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? phoneNumber,
    String? email,
    String? customerType,
    int? numberOfFamily,
    String? address,
    int? ketenaId,
    String? houseNo,
    double? latitude,
    double? longitude,
    int? subcityId,
    int? woredaId,
    int? blockId,
    String? profileImage,
    List<String>? additionalFiles,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      customerType: customerType ?? this.customerType,
      numberOfFamily: numberOfFamily ?? this.numberOfFamily,
      address: address ?? this.address,
      ketenaId: ketenaId ?? this.ketenaId,
      houseNo: houseNo ?? this.houseNo,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      subcityId: subcityId ?? this.subcityId,
      woredaId: woredaId ?? this.woredaId,
      blockId: blockId ?? this.blockId,
      profileImage: profileImage ?? this.profileImage,
      additionalFiles: additionalFiles ?? this.additionalFiles,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class LocationData {
  final int id;
  final String name;
  final String? code;
  final int? parentId;
  final List<LocationData>? children;

  LocationData({
    required this.id,
    required this.name,
    this.code,
    this.parentId,
    this.children,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      code: json['code'],
      parentId: json['parent_id'],
      children: json['children'] != null
          ? (json['children'] as List<dynamic>)
              .map((item) => LocationData.fromJson(item))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'parent_id': parentId,
      'children': children?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'LocationData(id: $id, name: $name)';
}



class CustomerListModel {
  final List<Customer> customers;
  final Map<String, dynamic> pagination;

  CustomerListModel({
    required this.customers,
    required this.pagination,
  });
}

class CustomerData {
  final int id;
  final String customerId;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String? email;
  final String customerType;
  final int numberOfFamily;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? subcity;
  final String? woreda;
  final String? ketena;
  final String? block;
  final String? profileImage;
  final List<String>? additionalFiles;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CustomerData({
    required this.id,
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    this.email,
    this.customerType = 'individual',
    this.numberOfFamily = 0,
    this.address,
    this.latitude,
    this.longitude,
    this.subcity,
    this.woreda,
    this.ketena,
    this.block,
    this.profileImage,
    this.additionalFiles,
    this.createdAt,
    this.updatedAt,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      id: json['id'],
      customerId: json['customer_id'],
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      email: json['email'],
      customerType: json['customer_type'] ?? 'individual',
      numberOfFamily: json['number_of_family'] ?? 0,
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      subcity: json['subcity'],
      woreda: json['woreda'],
      ketena: json['ketena'],
      block: json['block'],
      profileImage: json['profile_image_url'],
      additionalFiles: json['additional_files'] != null
          ? List<String>.from(json['additional_files'] as List)
          : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'customer_type': customerType,
      'number_of_family': numberOfFamily,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'subcity': subcity,
      'woreda': woreda,
      'ketena':ketena,
      'block': block,
      'profile_image': profileImage,
      'additional_files': additionalFiles,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}