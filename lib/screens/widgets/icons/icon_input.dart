import 'package:flocalbrand_mobile_shipper/screens/widgets/inputs/inline_input.dart';
import 'package:flutter/material.dart';

class IconInput extends StatelessWidget {
  const IconInput({super.key, required this.icon});

  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return InlineInput(
      height: 32,
      width: 56,
      inlineWidget: icon,
    );
  }
}
