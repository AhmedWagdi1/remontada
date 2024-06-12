import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppbar({
    super.key,
    this.title,
  });
  final String? title;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 80,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      leadingWidth: 60,
      // toolbarHeight: 80,
      leading: BackWidget(),
      title: CustomText(
        title ?? '',
        fontSize: 24.sp,
        color: context.primaryColor,
        weight: FontWeight.w800,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
