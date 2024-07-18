part of 'order_cubit.dart';

sealed class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class GetPreparedOrdersInprogress extends OrderState {}

final class GetPreparedOrdersSuccess extends OrderState {
  final List<OrderDto> orders;
  const GetPreparedOrdersSuccess({required this.orders});
}

final class GetPreparedOrdersFailure extends OrderState {}

final class GetPreparedOrdersEmpty extends OrderState {}

final class GetShipperReceivedOrdersInprogress extends OrderState {}

final class GetShipperReceivedOrdersSuccess extends OrderState {
  final List<OrderDto> orders;
  const GetShipperReceivedOrdersSuccess({required this.orders});
}

final class GetShipperReceivedOrdersFailure extends OrderState {}

final class GetShipperReceivedOrdersEmpty extends OrderState {}

final class GetShippingOrdersInprogress extends OrderState {}

final class GetShippingOrdersSuccess extends OrderState {
  final List<OrderDto> orders;
  const GetShippingOrdersSuccess({required this.orders});
}

final class GetShippingOrdersFailure extends OrderState {}

final class GetShippingOrdersEmpty extends OrderState {}

final class GetDeliveredOrdersInprogress extends OrderState {}

final class GetDeliveredOrdersSuccess extends OrderState {
  final List<OrderDto> orders;
  const GetDeliveredOrdersSuccess({required this.orders});
}

final class GetDeliveredOrdersFailure extends OrderState {}

final class GetDeliveredOrdersEmpty extends OrderState {}

final class GetOrderDetailsInprogress extends OrderState {}

final class GetOrderDetailsSuccess extends OrderState {
  final OrderDetailsDto orderDetails;
  const GetOrderDetailsSuccess({required this.orderDetails});
}

final class GetOrderDetailsFailure extends OrderState {}

final class UpdateOrderStatusInprogress extends OrderState {}

final class UpdateOrderStatusSuccess extends OrderState {}

final class UpdateOrderStatusFailure extends OrderState {}

final class UpdateOrderToDeliveryInprogress extends OrderState {}

final class UpdateOrderToDeliverySuccess extends OrderState {}

final class UpdateOrderToDeliveryFailure extends OrderState {}
