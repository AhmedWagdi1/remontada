import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
    this.contentPadding,
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
  final EdgeInsets? contentPadding;
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
      // height: 65.h,
      decoration: BoxDecoration(
        color: widget.color ?? context.background,
        borderRadius: BorderRadius.circular(
          33,
        ),
      ),

      child: DropdownButtonFormField<T>(

          // padding: EdgeInsets.symmetric(
          //   vertical: 22.h,
          //   horizontal: 40.3.w,
          // ),
          // menuMaxHeight: 65.h,
          icon: SizedBox.shrink(),
          itemHeight: 65,
          validator: widget.validator,
          // hint: CustomText(
          //   // align: TextAlign.center,
          //   // weight: FontWeight.w500,
          //   widget.hint ?? '',

          // ),
          decoration: InputDecoration(
            hintStyle: TextStyle(
              fontSize: 14,
              color: widget.hintColor ?? Colors.grey,
              fontFamily: 'DINNext',
            ),
            hintText: widget.hint,
            contentPadding: widget.contentPadding ??
                EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: 40.3,
                ),
            constraints: BoxConstraints(
              maxHeight: 65,
              // minHeight: 65.h,
            ),
            suffixIcon: Padding(
                padding: EdgeInsets.only(
                  left: 35,
                  right: 9.76,
                ),
                child: widget.suffixIcon?.toSvg(
                      width: 21.88,
                      height: 21.88,
                      color: LightThemeColors.inputFieldBorder,
                    ) ??
                    SvgPicture.asset(
                      Assets.icons.dropArrow,
                      height: 21.88,
                      width: 21.88,
                    )
                // Assets.icons.dropArrow.toSvg(
                //   fit: BoxFit.contain,
                //   width: 21.88.w,
                //   height: 21.88.h,
                //   // color: LightThemeColors.inputFieldBorder,
                // ),
                ),
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                right: 35,
                left: 9.76,
              ),
              child: SvgPicture.asset(
                width: 21.6,
                height: 21.6,
                widget.prefixIcon ?? "",
                color: context.primaryColor,
              ),
              //  widget.prefixIcon?.toSvg(
              //   width: 21.6,
              //   height: 21.6,

              // ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                10,
              ),
              borderSide: getborderside(),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.radius ?? 10,
              ),
              borderSide: getborderside(),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(
                widget.radius ?? 10,
              ),
              borderSide: getborderside(),
            ),
          ),
          value: widget.inistialValue,
          items: widget.options
              .map((e) => DropdownMenuItem(
                    value: e,
                    child: CustomText(
                      style: TextStyle(
                        color: Colors.black,
                      ).s14,
                      widget.itemAsString?.call(e) ?? e.toString(),
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
