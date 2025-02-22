import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton(
      {super.key, required this.title, required this.onPressed, this.padding});

  final String title;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          padding:
              padding ?? EdgeInsets.symmetric(horizontal: 64, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 4,
          shadowColor: Colors.grey,
        ),
        child: Text(
          title,
          style: textTheme.displayMedium?.copyWith(color: Colors.white),
        ));
  }
}
