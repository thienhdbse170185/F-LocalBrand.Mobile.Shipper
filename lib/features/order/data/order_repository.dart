import 'package:flocalbrand_mobile_shipper/features/order/data/order_api_client.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_details_dto.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_dto.dart';
import 'package:image_picker/image_picker.dart';

class OrderRepository {
  final OrderApiClient orderApiClient;

  const OrderRepository({required this.orderApiClient});

  Future<List<OrderDto>> getOrdersByStatus(String status) async {
    try {
      return orderApiClient.getOrdersByStatus(status);
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderDetailsDto> getOrderDetails(int id) async {
    try {
      return orderApiClient.getOrderDetails(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateOrderStatus(int id, String status) async {
    try {
      return orderApiClient.updateOrderStatus(id, status);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateOrderToDelivered(int id, XFile? image) async {
    try {
      return orderApiClient.updateOrderToDelivered(id, image);
    } catch (e) {
      rethrow;
    }
  }
}
