import 'package:flocalbrand_mobile_shipper/config/themes/custom_themes/text_theme.dart';
import 'package:flocalbrand_mobile_shipper/features/order/cubit/order_cubit.dart';
import 'package:flocalbrand_mobile_shipper/features/user/bloc/user_cubit.dart';
import 'package:flocalbrand_mobile_shipper/screens/home/prepared_tab.dart';
import 'package:flocalbrand_mobile_shipper/screens/home/recieved_tab.dart';
import 'package:flocalbrand_mobile_shipper/screens/home/shipping.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().getUserInfo();
    context.read<OrderCubit>().getPreparedOrders();
    context.read<OrderCubit>().getRecievedOrders();
    context.read<OrderCubit>().getShippingOrders();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              children: [
                BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                  if (state is GetUserInfoSuccess) {
                    return SizedBox(
                      width: 400,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Good evening,',
                                  style: FTextTheme.light.headlineSmall,
                                ),
                                Text(state.user.username),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: colorScheme.onInverseSurface,
                            ),
                            child: Stack(
                              alignment: Alignment.topRight,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: const FaIcon(
                                    FontAwesomeIcons.solidBell,
                                    size: 28,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: colorScheme.onInverseSurface,
                                        width: 1.0,
                                      ),
                                    ),
                                    child: const SizedBox(
                                      width: 2,
                                      height: 2,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 2.0,
                              ),
                            ),
                            child: ClipOval(
                              child: Image(
                                image: NetworkImage(state.user.image),
                                height: 48,
                                width: 48,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NEW ORDERS',
                  style: FTextTheme.light.headlineMedium,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    height: 750,
                    child: DefaultTabController(
                      length: 3,
                      initialIndex: 0,
                      animationDuration: Duration(milliseconds: 400),
                      child: Scaffold(
                        appBar: PreferredSize(
                          preferredSize: const Size.fromHeight(40),
                          child: Column(
                            children: [
                              TabBar(
                                tabs: const [
                                  Tab(text: 'Prepared'),
                                  Tab(text: 'Recieved'),
                                  Tab(text: 'Shipping'),
                                ],
                                labelColor: colorScheme.primary,
                                unselectedLabelColor: Colors.grey,
                                indicatorColor: colorScheme.primary,
                                labelStyle: textTheme.displayMedium,
                              ),
                            ],
                          ),
                        ),
                        body: const TabBarView(
                          children: [
                            Center(child: PreparedTab()),
                            Center(child: RecievedTab()),
                            Center(child: ShippingTab()),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
