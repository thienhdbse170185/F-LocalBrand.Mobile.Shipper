class CustomerDto {
  final String userName;
  final String fullName;
  final String email;
  final String image;
  final String phone;
  final String address;
  final DateTime? registrationDate;
  final String status;
  final String? deviceId;

  CustomerDto({
    required this.userName,
    required this.fullName,
    required this.email,
    required this.image,
    required this.phone,
    required this.address,
    this.registrationDate,
    required this.status,
    this.deviceId,
  });

  factory CustomerDto.fromJson(Map<String, dynamic> json) {
    return CustomerDto(
      userName: json['userName'],
      fullName: json['fullName'],
      email: json['email'],
      image: json['image'],
      phone: json['phone'],
      address: json['address'],
      registrationDate: json['registrationDate'] != null
          ? DateTime.parse(json['registrationDate'])
          : null,
      status: json['status'],
      deviceId: json['deviceId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'fullName': fullName,
      'email': email,
      'image': image,
      'phone': phone,
      'address': address,
      'registrationDate': registrationDate?.toIso8601String(),
      'status': status,
      'deviceId': deviceId,
    };
  }
}
