import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flocalbrand_mobile_shipper/config/router.dart';
import 'package:flocalbrand_mobile_shipper/config/themes/custom_themes/text_theme.dart';
import 'package:flocalbrand_mobile_shipper/features/order/cubit/order_cubit.dart';
import 'package:flocalbrand_mobile_shipper/features/order/dto/order_dto.dart';
import 'package:flocalbrand_mobile_shipper/screens/home/empty.dart';
import 'package:flocalbrand_mobile_shipper/screens/widgets/buttons/icon_button.dart';
import 'package:flocalbrand_mobile_shipper/screens/widgets/screens/empty_screen.dart';
import 'package:go_router/go_router.dart';

class ShippingTab extends StatefulWidget {
  const ShippingTab({Key? key}) : super(key: key);

  @override
  State<ShippingTab> createState() => _ShippingTabState();
}

class _ShippingTabState extends State<ShippingTab> {
  bool _isLoading = false;
  bool _isEmpty = false;
  List<OrderDto>? orders;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    context.read<OrderCubit>().getShippingOrders();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderCubit, OrderState>(
      listener: (context, state) {
        if (state is GetShippingOrdersInprogress) {
          setState(() {
            _isLoading = true;
            _isEmpty = false; // Reset empty state when loading starts
          });
        } else if (state is GetShippingOrdersSuccess) {
          setState(() {
            orders = state.orders;
            _isLoading = false;
            _isEmpty = orders!.isEmpty; // Check if orders list is empty
          });
        } else if (state is GetShippingOrdersEmpty) {
          setState(() {
            _isLoading = false;
            _isEmpty = true;
          });
        } else {
          setState(() {
            _isLoading = false;
            _isEmpty = false; // Reset empty state on other states
          });
        }
      },
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_isEmpty) {
      return const EmptyOrder();
    } else if (orders == null || orders!.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return RefreshIndicator(
        onRefresh: _fetchOrders,
        child: ListView.builder(
          itemCount: orders!.length,
          itemBuilder: (BuildContext context, int index) {
            final OrderDto order = orders![index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                contentPadding: EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: FaIcon(
                      FontAwesomeIcons.box,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                title: Text(
                  'Order #${order.orderId.toString()}',
                  style: FTextTheme.light.headlineSmall,
                ),
                subtitle: Text(
                  'Order Date: ${order.orderDate}',
                  style: FTextTheme.light.displaySmall,
                ),
                trailing: const CustomIconButton(
                  icon: FontAwesomeIcons.arrowRight,
                ),
                onTap: () {
                  context.push(RouteName.order, extra: order.orderId);
                },
              ),
            );
          },
        ),
      );
    }
  }
}
