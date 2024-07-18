import 'dart:io';

import 'package:flocalbrand_mobile_shipper/screens/widgets/buttons/rounded_outlined_button.dart';
import 'package:flocalbrand_mobile_shipper/screens/widgets/snackbar/snackbar_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flocalbrand_mobile_shipper/config/router.dart';
import 'package:flocalbrand_mobile_shipper/config/themes/custom_themes/text_theme.dart';
import 'package:flocalbrand_mobile_shipper/features/order/cubit/order_cubit.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_details_dto.dart';
import 'package:flocalbrand_mobile_shipper/screens/widgets/appbars/custom_appbar.dart';
import 'package:flocalbrand_mobile_shipper/screens/widgets/buttons/rounded_elevated_button.dart';
import 'package:flocalbrand_mobile_shipper/util/price_util.dart';
import 'package:go_router/go_router.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key, required this.id}) : super(key: key);
  final int id;

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isLoading = false;
  String orderStatus = "prepared"; // Initial status
  OrderDetailsDto? orderDetails;
  XFile? _proofOfDeliveryImage;
  final ImagePicker _picker = ImagePicker();

  void _updateOrderStatus() async {
    switch (orderStatus) {
      case 'Prepared':
        orderStatus = 'ShipperReceived';
        break;
      case 'ShipperReceived':
        orderStatus = 'InTransit';
        break;
      case 'Shipping':
        orderStatus = 'Delivered';
        break;
    }
    try {
      await context
          .read<OrderCubit>()
          .updateOrderStatus(widget.id, orderStatus);
    } catch (e) {
      // Handle error
      print('Failed to update order status: $e');
    }
  }

  Future<void> _uploadProofOfDelivery() async {
    if (_proofOfDeliveryImage == null) {
      SnackbarUtil.showSnackbarError(
          context, 'Please take a photo as proof of delivery',
          paddingBottom: 100);
      return;
    }
    try {
      // Implement upload logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulate upload delay
      orderStatus = 'completed';
      await context
          .read<OrderCubit>()
          .updateOrderToDelivered(widget.id, _proofOfDeliveryImage);
      setState(() {});
    } catch (e) {
      // Handle error
      print('Failed to upload proof of delivery: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _proofOfDeliveryImage = pickedFile;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<OrderCubit>().getOrderDetails(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is GetOrderDetailsInprogress) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is GetOrderDetailsSuccess) {
          setState(() {
            orderDetails = state.orderDetails;
            _isLoading = false;
            orderStatus = orderDetails?.currentStatus ?? orderStatus;
          });
        } else if (state is UpdateOrderStatusSuccess) {
          print('Order status updated successfully');
          SnackbarUtil.showSnackbarSuccess(
              context, 'Order status updated successfully',
              paddingBottom: 100);
        } else if (state is UpdateOrderStatusFailure) {
          print('Failed to update order status');
          SnackbarUtil.showSnackbarError(
              context, 'Failed to update order status',
              paddingBottom: 100);
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : orderDetails == null
                ? const Center(child: Text('Loading...'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomAppbar(
                          title: 'View Order #${orderDetails!.orderId}',
                          textTheme: textTheme,
                          onPressed: () {
                            context.read<OrderCubit>().getPreparedOrders();
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Product List',
                            style: FTextTheme.light.displayMedium,
                          ),
                        ),
                        Container(
                          height: 250,
                          child: CustomScrollView(
                            slivers: [
                              SliverPadding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0),
                                sliver: SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                      final productOrder =
                                          orderDetails!.details[index];
                                      return Card(
                                        margin:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: ListTile(
                                          leading: Image.network(
                                              productOrder.product.imageUrl),
                                          title: Text(
                                              productOrder.product.productName),
                                          subtitle: Text(
                                              'Quantity: ${productOrder.quantity}\nPrice: ${PriceUtil.formatPrice(productOrder.price.toInt())}'),
                                        ),
                                      );
                                    },
                                    childCount: orderDetails!.details.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Info Details',
                                  style: textTheme.headlineMedium),
                              SizedBox(height: 16),
                              Text(
                                  'Order Date: ${orderDetails!.orderDate.toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 8),
                              Text(
                                  'Delivery Address: ${orderDetails!.customer.address}',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 8),
                              Text(
                                  'Total Price: ${PriceUtil.formatPrice(orderDetails!.totalAmount.toInt())}',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 16),
                              Divider(),
                              SizedBox(height: 16),
                              Text('Customer Details',
                                  style: textTheme.headlineMedium),
                              SizedBox(height: 16),
                              Text('Name: ${orderDetails!.customer.fullName}',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 8),
                              Text('Email: ${orderDetails!.customer.email}',
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 8),
                              Text('Phone: ${orderDetails!.customer.phone}',
                                  style: TextStyle(fontSize: 16)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30, left: 16, right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (orderStatus == 'Prepared')
                                RoundedElevatedButton(
                                    title: 'SHIPPER RECEIVED',
                                    onPressed: _updateOrderStatus),
                              if (orderStatus == 'ShipperReceived')
                                RoundedElevatedButton(
                                  onPressed: _updateOrderStatus,
                                  title: 'SHIPPING NOW',
                                ),
                              if (orderStatus == 'InTransit') ...[
                                if (_proofOfDeliveryImage != null)
                                  Image.file(
                                    File(_proofOfDeliveryImage!.path),
                                    height: 200,
                                  ),
                                const SizedBox(height: 10),
                                RoundedOutlinedButton(
                                  onPressed: _pickImage,
                                  title: 'TAKE DELIVERY PHOTO',
                                ),
                                const SizedBox(height: 10),
                                RoundedElevatedButton(
                                  onPressed: _uploadProofOfDelivery,
                                  title: 'FINISH ORDER',
                                ),
                              ],
                              if (orderStatus == 'completed')
                                const Center(
                                  child: Text('Order Completed',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green)),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
