import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'customtext.dart';

class DropDownItem<T> extends StatefulWidget {
  DropDownItem({
    Key? key,
    required this.options,
    required this.onChanged,
    this.inistialValue,
    this.title,
    this.validator,
    this.radius,
    this.hint,
    this.color,
    this.hintColor,
    this.itemAsString,
    this.prefixIcon,
    this.suffixIcon,
  }) : super(key: key);
  List<T> options;
  final String? prefixIcon;
  final T? inistialValue;
  final String Function(T)? itemAsString;
  final String? hint;
  final String? Function(T?)? validator;
  final String? title;
  final double? radius;
  final Color? hintColor;
  final Color? color;
  final String? suffixIcon;
  Function(T) onChanged;

  @override
  State<DropDownItem<T>> createState() => _DropDownItemState<T>();
}

class _DropDownItemState<T> extends State<DropDownItem<T>> {
  TextEditingController controller = TextEditingController();
  double width = 0.0;

  @override
  void initState() {
    controller = TextEditingController(text: widget.inistialValue?.toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(vertical: 22.h, horizontal: 40.3.w),
      height: 65.h,
      color: widget.color ?? Colors.white,
      child: DropdownButtonFormField<T>(
          icon: SizedBox.shrink(),
          itemHeight: 50,
          validator: widget.validator,
          hint: CustomText(
            // weight: FontWeight.w500,
            widget.hint ?? '',
            fontSize: 14.sp,
            color: widget.hintColor ?? Colors.grey,
            fontFamily: 'DINNext',
          ),
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: EdgeInsets.only(
                left: 35.w,
                right: 9.76.w,
              ),
              child: widget.suffixIcon?.toSvg(
                    color: LightThemeColors.inputFieldBorder,
                  ) ??
                  Assets.icons.dropArrow.toSvg(
                      // color: LightThemeColors.inputFieldBorder,
                      ),
            ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                right: 35.w,
                left: 9.76.w,
              ),
              child: widget.prefixIcon?.toSvg(
                color: context.primaryColor,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10.r,
              ),
              borderSide: getborderside(),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.radius?.r ?? 10.r,
              ),
              borderSide: getborderside(),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.radius?.r ?? 10.r,
              ),
              borderSide: getborderside(),
            ),
          ),
          value: widget.inistialValue,
          items: widget.options
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: CustomText(
                      widget.itemAsString?.call(e) ?? e.toString(),
                      color: Colors.black,
                    ),
                  ))
              .toList(),
          onChanged: (s) {
            if (s != null) {
              widget.onChanged.call(s);
            }
          }),
    );
  }
}

BorderSide getborderside() {
  return BorderSide(
    color: LightThemeColors.inputFieldBorder,
  );
}
