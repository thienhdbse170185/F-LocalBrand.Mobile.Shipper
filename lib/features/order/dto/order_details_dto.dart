import 'package:flocalbrand_mobile_shipper/features/customer/dto/customer_dto.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/product_order_dto.dart';

class OrderDetailsDto {
  final int orderId;
  final int customerId;
  final DateTime orderDate;
  final double totalAmount;
  final String currentStatus;
  final String statusHistory;
  final List<ProductOrderDto> details;
  final CustomerDto customer;

  OrderDetailsDto({
    required this.orderId,
    required this.customerId,
    required this.orderDate,
    required this.totalAmount,
    required this.currentStatus,
    required this.statusHistory,
    required this.details,
    required this.customer,
  });

  factory OrderDetailsDto.fromJson(Map<String, dynamic> json) {
    return OrderDetailsDto(
      orderId: json['orderId'],
      customerId: json['customerId'],
      orderDate: DateTime.parse(json['orderDate']),
      totalAmount: json['totalAmount'].toDouble(),
      currentStatus: json['currentStatus'],
      statusHistory: json['statusHistory'],
      details: (json['details'] as List)
          .map((detail) => ProductOrderDto.fromJson(detail))
          .toList(),
      customer: CustomerDto.fromJson(json['customerInfo']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'customerId': customerId,
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'currentStatus': currentStatus,
      'statusHistory': statusHistory,
      'details': details.map((detail) => detail.toJson()).toList(),
      'customerInfo': customer.toJson(),
    };
  }
}
