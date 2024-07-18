import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flocalbrand_mobile_shipper/features/order/data/order_repository.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_details_dto.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_dto.dart';
import 'package:image_picker/image_picker.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit(this.orderRepository) : super(OrderInitial());
  final OrderRepository orderRepository;

  Future<void> getPreparedOrders() async {
    emit(GetPreparedOrdersInprogress());
    try {
      final result = await orderRepository.getOrdersByStatus('Prepared');
      if (result.isNotEmpty) {
        emit(GetPreparedOrdersSuccess(orders: result));
      } else {
        emit(GetPreparedOrdersEmpty());
      }
    } catch (e) {
      emit(GetPreparedOrdersFailure());
    }
  }

  Future<void> getRecievedOrders() async {
    emit(GetShipperReceivedOrdersInprogress());
    try {
      final result = await orderRepository.getOrdersByStatus('ShipperReceived');
      if (result.isNotEmpty) {
        emit(GetShipperReceivedOrdersSuccess(orders: result));
      } else {
        emit(GetShipperReceivedOrdersEmpty());
      }
    } catch (e) {
      emit(GetShipperReceivedOrdersFailure());
    }
  }

  Future<void> getShippingOrders() async {
    emit(GetShippingOrdersInprogress());
    try {
      final result = await orderRepository.getOrdersByStatus('InTransit');
      if (result.isNotEmpty) {
        emit(GetShippingOrdersSuccess(orders: result));
      } else {
        emit(GetShippingOrdersEmpty());
      }
    } catch (e) {
      emit(GetShippingOrdersFailure());
    }
  }

  Future<void> getOrderDetails(int id) async {
    emit(GetOrderDetailsInprogress());
    try {
      final result = await orderRepository.getOrderDetails(id);
      emit(GetOrderDetailsSuccess(orderDetails: result));
    } catch (e) {
      emit(GetOrderDetailsFailure());
    }
  }

  Future<void> updateOrderStatus(int id, String status) async {
    emit(UpdateOrderStatusInprogress());
    try {
      await orderRepository.updateOrderStatus(id, status);
      emit(UpdateOrderStatusSuccess());
    } catch (e) {
      emit(UpdateOrderStatusFailure());
      rethrow;
    }
  }

  Future<void> updateOrderToDelivered(int id, XFile? image) async {
    emit(UpdateOrderStatusInprogress());
    try {
      await orderRepository.updateOrderToDelivered(id, image);
      emit(UpdateOrderStatusSuccess());
    } catch (e) {
      emit(UpdateOrderStatusFailure());
      rethrow;
    }
  }
}
