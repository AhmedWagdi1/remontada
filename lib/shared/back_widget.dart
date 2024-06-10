import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackWidget extends StatelessWidget {
  BackWidget({
    super.key,
    this.onBack,
    this.color,
    this.icon,
    this.size,
  });
  final VoidCallback? onBack;
  final Color? color;
  final IconData? icon;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (onBack != null) {
          onBack?.call();
        } else {
          Navigator.pop(context);
        }
      },
      icon: Transform.scale(
        scale: 1.1,
        child: SvgPicture.asset(
          height: 24,
          width: 24,
          "assets/icons/back_arrow.svg",
        ),
      ),
    );
  }
}
