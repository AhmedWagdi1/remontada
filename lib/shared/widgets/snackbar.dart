import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import '../../core/extensions/all_extensions.dart';

import '../../core/services/alerts.dart';

class SnackDesgin extends StatelessWidget {
  const SnackDesgin({
    super.key,
    required this.text,
    this.state = SnackState.success,
  });

  final String text;
  final SnackState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          state == SnackState.success
              ? Lottie.asset(
                  "assets/json/success.json",
                  width: 30.w,
                  height: 30.w,
                )
              : Lottie.asset(
                  "assets/json/error.json",
                  width: 30.w,
                  height: 30.w,
                ),
          10.w.horizontalSpace,
          text.text(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            textAlign: TextAlign.start,
            fontSize: 14.sp,
          ),
        ],
      ).setContainerToView(
        color: state == SnackState.success ? context.colorScheme.primary : context.colorScheme.error,
        margin: 20.w,
        radius: 8.r,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
    );
  }
}
