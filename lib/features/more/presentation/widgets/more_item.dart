import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/more/presentation/widgets/customSwitch.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class MoreItem extends StatefulWidget {
  const MoreItem({
    super.key,
    this.icon,
    this.title,
    this.ontap,
  });
  final String? icon;
  final String? title;
  final VoidCallback? ontap;

  @override
  State<MoreItem> createState() => _MoreItemState();
}

class _MoreItemState extends State<MoreItem> {
  bool switched = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.title == "الملف الشخصي") {
          Navigator.pushNamed(
            context,
            Routes.profileDetails,
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 10.h,
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 21.w,
            // vertical: 10.h,
          ),
          // width: 341.w,
          height: 54.h,
          decoration: BoxDecoration(
            color: context.background,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                offset: Offset.zero,
                blurRadius: 30,
                color: LightThemeColors.black.withOpacity(
                  .1,
                ),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    (widget.icon ?? "location").svg(),
                    width: 25.w,
                    height: 25.h,
                    color: widget.title == "تسجيل الخروج"
                        ? LightThemeColors.red
                        : LightThemeColors.black,
                  ),
                  15.pw,
                  CustomText(
                    widget.title ?? "الملف الشخصي",
                    color: widget.title == "تسجيل الخروج"
                        ? LightThemeColors.red
                        : LightThemeColors.black,
                    fontSize: 14,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
              widget.title == "التحكم بالإشعارات"
                  ? CustomSwitch(
                      value: switched,
                      onChanged: (val) {
                        switched = val;
                        setState(() {});
                      },
                    )
                  : IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset(
                        "forowrdButton".svg(),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
