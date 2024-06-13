import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/theme/light_theme.dart';

class CustomSliderDots extends StatelessWidget {
  const CustomSliderDots({
    super.key,
    this.indexItem,
    this.length,
  });

  final int? indexItem;
  final int? length;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(length ?? 0, (index) {
        return Padding(
          padding: EdgeInsets.only(left: 3.w),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6.r),
              color:
                  index == indexItem ? LightThemeColors.surface : Colors.white,
            ),
            width: index == indexItem ? 19.w : 8.w,
            height: 6.h,
          ),
        );
      }),
      // [
      // 3.pw,
      // Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(4),
      //     color: Colors.white,
      //   ),
      //   width: 8,
      //   height: 6,
      // ),
      // 3.pw,
      // Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(4),
      //     color: Colors.white,
      //   ),
      //   width: 8,
      //   height: 6,
      // ),
      // 3.pw,
      // Container(
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(4),
      //     color: LightThemeColors.surface,
      //   ),
      //   width: 19,
      //   height: 6,
      // ),
      // ],
    );
  }
}
