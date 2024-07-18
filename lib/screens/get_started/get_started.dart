import 'package:flocalbrand_mobile_shipper/config/router.dart';
import 'package:flocalbrand_mobile_shipper/config/themes/custom_themes/index.dart';
import 'package:flocalbrand_mobile_shipper/screens/widgets/buttons/rounded_outlined_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GetStartedScreen extends StatefulWidget {
  const GetStartedScreen({super.key});

  @override
  State<GetStartedScreen> createState() => _GetStartedScreenState();
}

class _GetStartedScreenState extends State<GetStartedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 72, left: 36, right: 36),
        child: Column(
          children: [
            Image(
              image: AssetImage('assets/images/Saly-22.png'),
              height: 280,
              width: 280,
            ),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Text(
                      'Hi, there!',
                      style: FTextTheme.light.titleSmall,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0),
                    child: Text(
                      'Enjoy your experience with F-LocalBrand',
                      style: FTextTheme.light.displayMedium,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: EdgeInsets.only(top: 36),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(RouteName.login);
                    },
                    child: Text('LOGIN AS SHIPPER',
                        style: FTextTheme.light.headlineSmall
                            ?.copyWith(color: Colors.white, fontSize: 14)),
                  ),
                )),
            const Padding(
                padding: EdgeInsets.only(top: 36),
                child: Text('© 2024 F-LocalBrand'))
          ],
        ),
      ),
    );
  }
}
