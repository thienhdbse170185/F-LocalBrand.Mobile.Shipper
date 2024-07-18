class OrderDto {
  final int orderId;
  final int customerId;
  final String orderDate;
  final double totalAmount;
  final String orderStatus;

  const OrderDto(this.orderId, this.customerId, this.orderDate,
      this.totalAmount, this.orderStatus);

  Map<String, dynamic> toJson() => {
        'id': orderId,
        'customerId': customerId,
        'orderDate': orderDate,
        'totalAmount': totalAmount,
        'orderStatus': orderStatus
      };

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    return OrderDto(
      json['id'],
      json['customerId'],
      json['orderDate'],
      json['totalAmount'],
      json['orderStatus'],
    );
  }
}
