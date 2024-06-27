import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/utils/utils.dart';

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
    return GestureDetector(
      onTap: () {
        if (onBack != null) {
          onBack?.call();
        } else {
          Navigator.pop(context);
        }
      },
      child: Transform.flip(
        flipX: Utils.lang == Locale("ar").languageCode,
        child: SvgPicture.asset(
          height: 26,
          width: 26,
          "assets/icons/back_arrow.svg",
        ),
      ),
    );
  }
}
