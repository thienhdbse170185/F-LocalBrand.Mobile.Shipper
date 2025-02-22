import 'package:flocalbrand_mobile_shipper/screens/widgets/buttons/back_button.dart';
import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({
    super.key,
    required this.title,
    this.trailing,
    required this.textTheme,
    this.hasBack = true,
    this.onPressed,
  });

  final String title;
  final TextTheme textTheme;
  final Widget? trailing;
  final bool hasBack;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Stack(
        children: [
          Center(
            child: Text(
              title,
              style: textTheme.headlineMedium,
            ),
          ),
          if (hasBack)
            Positioned(
              left: 20,
              top: 0,
              bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: CustomBackButton(
                  onPressed: () {
                    onPressed?.call();
                  },
                ),
              ),
            ),
          Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerRight,
              child: trailing ?? Container(),
            ),
          ),
        ],
      ),
    );
  }
}
