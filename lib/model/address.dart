class Address {
  int? addressId;
  String? address;
  String? addressLabel;
  String? name;
  String? phoneNumber;
  String? email;
  String?district;
  int? provinceId;
  int? districtId;
  int? subDistrictId;
  String? postalCode;
  double? lat;
  double? long;
  String? addressMap;
  String? npwp;
  String? npwpFile;
  bool primary;

  Address({
     this.addressId,
    this.address,
    this.addressLabel,
    this.name,
    this.phoneNumber,
    this.email,
    this.district,
    this.provinceId,
    this.districtId,
    this.subDistrictId,
    this.postalCode,
    this.lat,
    this.long,
    this.addressMap,
    this.npwp,
    this.npwpFile,
    this.primary = false,
  });

  // Factory method for creating an Address instance from JSON
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['address_id']??0,
      address: json['address'] as String?,
      addressLabel: json['address_label'] as String?,
      name: json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      provinceId: json['province_id'] as int?,
      districtId: json['district_id'] as int?,
      subDistrictId: json['sub_district_id'] as int?,
      postalCode: json['postal_code'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      long: (json['long'] as num?)?.toDouble(),
      addressMap: json['address_map'] as String?,
      npwp: json['npwp'] as String?,
      npwpFile: json['npwp_file'] as String?,
      district: json['sub_district_name']as String?,
      primary:json['is_primary']??false
    );
  }

  // Convert an Address instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'address_label': addressLabel,
      'name': name,
      'phone_number': phoneNumber,
      'email': email,
      'province_id': provinceId,
      'district_id': districtId,
      'sub_district_id': subDistrictId,
      'postal_code': postalCode,
      'lat': lat,
      'long': long,
      'address_map': addressMap,
      'npwp': npwp,
      'npwp_file': npwpFile,
      'is_primary':primary
    };
  }
}
