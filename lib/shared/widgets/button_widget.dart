import 'package:flutter/material.dart';
import 'package:remontada/core/theme/light_theme.dart';

import '../../core/extensions/all_extensions.dart';
import '../../shared/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final String title;
  final String? fontFamily;
  final double width, height, radius;
  final Widget? child;
  final Gradient? gradient;
  final double? fontSize;
  final FontWeight? fontweight;
  final Alignment? alignment;
  final Color? textColor, buttonColor, borderColor;
  final void Function()? onTap;
  final bool withBorder;

  const ButtonWidget({
    super.key,
    this.gradient,
    this.title = "OK",
    this.width = double.infinity,
    this.height = 65.0,
    this.onTap,
    this.fontFamily,
    this.child,
    this.fontSize,
    this.fontweight,
    this.alignment,
    this.textColor = Colors.white,
    this.buttonColor,
    this.borderColor,
    this.withBorder = false,
    this.radius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(
      //   // horizontal: 10,
      //   vertical: 6,
      // ),
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: buttonColor == null ? LightThemeColors.buttonColor : gradient,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            buttonColor ??
                Colors.transparent.withOpacity(
                  0,
                ),
          ),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
          shadowColor: WidgetStateProperty.all<Color>(Colors.white),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: withBorder
                  ? BorderSide(color: borderColor ?? context.secondaryColor)
                  : const BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        child: child ??
            title.text(
              fontWeight: fontweight ?? FontWeight.w400,
              fontSize: fontSize ?? 16,
              fontFamily: fontFamily,
              color: textColor ?? Colors.white,
            ),
      ),
    );
  }
}

class TextButtonWidget extends StatelessWidget {
  TextButtonWidget({
    super.key,
    required this.function,
    required this.text,
    this.fontweight,
    this.color,
    this.size,
    this.fontFamily,
  });
  final Function function;
  final String text;
  final double? size;
  final Color? color;
  final FontWeight? fontweight;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        function();
      },
      child: TextWidget(
        text,
        fontWeight: fontweight ?? FontWeight.w500,
        fontFamily: fontFamily ?? "Sans",
        fontSize: size ?? 16,
        color: color ?? context.secondaryColor,
        //  style: TextStyle(color: AppColors.secondary),
      ),
      // style: TextButton.styleFrom(
      //   elevation: 0,
      //   textStyle: TextStyle(
      //     fontWeight: FontWeight.w600,
      //     fontSize: (width <= 550) ? 13 : 17,
      //   ),
      // ),
    );
  }
}
