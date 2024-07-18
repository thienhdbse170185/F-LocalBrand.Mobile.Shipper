import 'package:flocalbrand_mobile_shipper/features/auth/bloc/auth_bloc.dart';
import 'package:flocalbrand_mobile_shipper/screens/auth/forgot_pw/forgot_pw.dart';
import 'package:flocalbrand_mobile_shipper/screens/auth/login/login.dart';
import 'package:flocalbrand_mobile_shipper/screens/get_started/get_started.dart';
import 'package:flocalbrand_mobile_shipper/screens/home/home.dart';
import 'package:flocalbrand_mobile_shipper/screens/order/order.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RouteName {
  static const String home = '/';
  static const String login = '/login';
  static const String getStarted = '/get-started';
  static const String forgotPw = '/forgot-pw';
  static const String order = '/order';

  static const publicRoutes = [
    login,
    forgotPw,
    getStarted,
  ];
}

final router = GoRouter(
  redirect: (context, state) {
    if (RouteName.publicRoutes.contains(state.fullPath)) {
      return null;
    }
    if (context.read<AuthBloc>().state is AuthAuthenticateSuccess) {
      return null;
    }
    return RouteName.getStarted;
  },
  routes: [
    GoRoute(
        path: RouteName.getStarted,
        builder: (context, state) {
          return const GetStartedScreen();
        }),
    GoRoute(
        path: RouteName.login,
        builder: (context, state) {
          return const LoginScreen();
        }),
    GoRoute(
        path: RouteName.forgotPw,
        builder: (context, state) {
          return const ForgotPasswordScreen();
        }),
    GoRoute(
        path: RouteName.home,
        builder: (context, state) {
          return const HomeScreen();
        }),
    GoRoute(
        path: RouteName.order,
        builder: (context, state) {
          final int id = state.extra as int;
          return OrderScreen(
            id: id,
          );
        })
  ],
);
