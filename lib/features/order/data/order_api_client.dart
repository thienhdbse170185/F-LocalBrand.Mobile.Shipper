import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_details_dto.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_dto.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class OrderApiClient {
  final Dio dio;

  OrderApiClient(this.dio);

  Future<List<OrderDto>> getOrdersByStatus(String status) async {
    try {
      final response =
          await dio.get('/order/order-history-status?Status=$status');
      return (response.data['result']['orders'] as List)
          .map((e) => OrderDto.fromJson(e))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderDetailsDto> getOrderDetails(int id) async {
    try {
      final response = await dio.get('/order/$id/details');
      if (response.statusCode == 200) {
        return OrderDetailsDto.fromJson(response.data['result']);
      }
      return OrderDetailsDto.fromJson({});
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateOrderStatus(int id, String status) async {
    try {
      final response =
          await dio.put('/order/$id/status', data: {'status': status});
      if (response.statusCode == 200) {
        return response.data['success'] as bool;
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }

  Future<bool> updateOrderToDelivered(int id, XFile? image) async {
    try {
      FormData formData = FormData.fromMap({
        'ImageUrl': await MultipartFile.fromFile(image!.path,
            filename: image!.name, contentType: MediaType('image', 'jpeg'))
      });
      final response =
          await dio.put('/order/$id/status-delivers', data: formData);
      if (response.statusCode == 200) {
        return response.data['success'] as bool;
      }
    } catch (e) {
      rethrow;
    }
    return false;
  }
}
