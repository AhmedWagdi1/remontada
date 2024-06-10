import 'package:flutter/material.dart';

enum TextStyleEnum {
  normal,
  title,
  caption,
}

class CustomText extends StatelessWidget {
  TextStyle getTextStyle(TextStyleEnum textStyleEnum,
      {Color? color,
      double? fontSize,
      double? height,
      String? fontFamily,
      TextOverflow? overflow,
      TextDecoration? decoration,
      FontWeight? weight}) {
    switch (textStyleEnum) {
      case TextStyleEnum.title:
        return const TextStyle(
                fontSize: 25,
                fontFamily: "DINNext",
                fontWeight: FontWeight.w500)
            .copyWith(
                decoration: decoration,
                color: color ?? Colors.black,
                height: height,
                fontWeight: weight,
                fontSize: fontSize,
                overflow: overflow ?? TextOverflow.visible,
                fontFamily: fontFamily ?? "DINNext");
      case TextStyleEnum.caption:
        return const TextStyle(
                fontSize: 14,
                fontFamily: "DINNext",
                fontWeight: FontWeight.w300)
            .copyWith(
                decoration: decoration,
                color: color ?? Colors.black,
                fontWeight: weight,
                height: height,
                fontSize: fontSize,
                overflow: overflow ?? TextOverflow.visible,
                fontFamily: fontFamily ?? "DINNext");

      default:
        return const TextStyle(
                fontSize: 14,
                fontFamily: "DINNext",
                fontWeight: FontWeight.w400)
            .copyWith(
                decoration: decoration,
                color: color ?? Colors.black,
                height: height,
                fontWeight: weight,
                fontSize: fontSize,
                overflow: overflow ?? TextOverflow.visible,
                fontFamily: fontFamily ?? "DINNext");
    }
  }

  const CustomText(
    this.text, {
    Key? key,
    this.textStyleEnum,
    this.color,
    this.fontSize,
    this.weight,
    this.fontFamily,
    this.align,
    this.height,
    this.style,
    this.decoration,
    this.overflow,
    this.maxLine,
  }) : super(key: key);
  final String text;
  final TextStyleEnum? textStyleEnum;
  final Color? color;
  final double? fontSize;
  final double? height;
  final String? fontFamily;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final TextAlign? align;
  final FontWeight? weight;
  final TextStyle? style;
  final int? maxLine;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align ?? TextAlign.start,
      maxLines: maxLine,
      style: style ??
          getTextStyle(textStyleEnum ?? TextStyleEnum.normal,
              color: color,
              height: height,
              fontSize: fontSize,
              fontFamily: fontFamily ?? 'DINNext',
              overflow: overflow,
              decoration: decoration,
              weight: weight),
    );
  }
}
