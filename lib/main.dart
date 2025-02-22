import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flocalbrand_mobile_shipper/config/http_client.dart';
import 'package:flocalbrand_mobile_shipper/config/router.dart';
import 'package:flocalbrand_mobile_shipper/config/themes/custom_themes/button_theme.dart';
import 'package:flocalbrand_mobile_shipper/config/themes/custom_themes/text_theme.dart';
import 'package:flocalbrand_mobile_shipper/config/themes/material_theme.dart';
import 'package:flocalbrand_mobile_shipper/features/auth/bloc/auth_bloc.dart';
import 'package:flocalbrand_mobile_shipper/features/auth/data/auth_api_client.dart';
import 'package:flocalbrand_mobile_shipper/features/auth/data/auth_local_data_source.dart';
import 'package:flocalbrand_mobile_shipper/features/auth/data/auth_repository.dart';
import 'package:flocalbrand_mobile_shipper/features/order/cubit/order_cubit.dart';
import 'package:flocalbrand_mobile_shipper/features/order/data/order_api_client.dart';
import 'package:flocalbrand_mobile_shipper/features/order/data/order_repository.dart';
import 'package:flocalbrand_mobile_shipper/features/user/bloc/user_cubit.dart';
import 'package:flocalbrand_mobile_shipper/features/user/data/user_api_client.dart';
import 'package:flocalbrand_mobile_shipper/features/user/data/user_local_data_source.dart';
import 'package:flocalbrand_mobile_shipper/features/user/data/user_repository.dart';
import 'package:flocalbrand_mobile_shipper/firebase_options.dart';
import 'package:flocalbrand_mobile_shipper/service/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

final navigatorKey = GlobalKey<NavigatorState>();

// function to listen to background changes
Future _firebaseBackgroundMessage(RemoteMessage message) async {
  if (message.notification != null) {
    print("Some notification Received in background...");
  }
}

// to handle notification on foreground on web platform
void showNotification({required String title, required String body}) {
  showDialog(
    context: navigatorKey.currentContext!,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Ok"))
      ],
    ),
  );
}

Future<void> main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding.ensureInitialized();
  final sf = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await PushNotifications.init();

  if (!kIsWeb) {
    await PushNotifications.localNotiInit();
  }

  // Listen to background notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundMessage);

  // on background notification tapped
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      print("Background Notification Tapped");
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    }
  });

// to handle foreground notifications
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    String payloadData = jsonEncode(message.data);
    print("Got a message in foreground");
    if (message.notification != null) {
      if (kIsWeb) {
        showNotification(
            title: message.notification!.title!,
            body: message.notification!.body!);
      } else {
        PushNotifications.showSimpleNotification(
            title: message.notification!.title!,
            body: message.notification!.body!,
            payload: payloadData);
      }
    }
  });

  PushNotifications.getDeviceToken();

  // for handling in terminated state
  final RemoteMessage? message =
      await FirebaseMessaging.instance.getInitialMessage();

  if (message != null) {
    print("Launched from terminated state");
    Future.delayed(Duration(seconds: 1), () {
      navigatorKey.currentState!.pushNamed("/message", arguments: message);
    });
  }

  runApp(MyApp(
    sharedPreferences: sf,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
              create: (context) => AuthRepository(
                  authApiClient: AuthApiClient(dio),
                  userApiClient: UserApiClient(dio),
                  authLocalDataSource: AuthLocalDataSource(sharedPreferences))),
          RepositoryProvider(
              create: (context) => UserRepository(
                  authLocalDataSource: AuthLocalDataSource(sharedPreferences),
                  userApiClient: UserApiClient(dio),
                  userLocalDataSource: UserLocalDataSource(sharedPreferences))),
          RepositoryProvider(
              create: (context) =>
                  OrderRepository(orderApiClient: OrderApiClient(dio)))
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthBloc(context.read<AuthRepository>()),
            ),
            BlocProvider(
              create: (context) => UserCubit(context.read<UserRepository>()),
            ),
            BlocProvider(
                create: (context) =>
                    OrderCubit(context.read<OrderRepository>()))
          ],
          child: AppContent(),
        ));
  }
}

class AppContent extends StatefulWidget {
  const AppContent({
    super.key,
  });

  @override
  State<AppContent> createState() => _AppContentState();
}

class _AppContentState extends State<AppContent> {
  @override
  Widget build(BuildContext context) {
    final MaterialTheme materialTheme = MaterialTheme(
        FTextTheme.light,
        FButtonTheme.lightElevatedButtonTheme,
        FButtonTheme.lightOutlinedButtonTheme);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'F-LocalBrand',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.light,
      routerConfig: router,
    );
  }
}
