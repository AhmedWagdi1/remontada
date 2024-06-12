import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class BottomSheetItem extends StatefulWidget {
  const BottomSheetItem({
    super.key,
    this.title,
  });
  final String? title;

  @override
  State<BottomSheetItem> createState() => _BottomSheetItemState();
}

class _BottomSheetItemState extends State<BottomSheetItem> {
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        isActive = true;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 5.h,
          horizontal: 5.w,
        ),
        width: 182.w,
        height: 42.h,
        decoration: BoxDecoration(
          color: isActive ? LightThemeColors.surface : context.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: isActive ? Colors.transparent : LightThemeColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            isActive ? SvgPicture.asset("") : SvgPicture.asset(""),
            CustomText(
              weight: FontWeight.w400,
              widget.title ?? "",
              fontSize: 12.sp,
              color: isActive ? context.background : LightThemeColors.black,
            ),
          ],
        ),
      ).paddingBottom(5.5.h),
    );
  }
}
