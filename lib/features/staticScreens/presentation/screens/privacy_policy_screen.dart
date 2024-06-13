import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/staticScreens/presentation/widgets/widgets.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 18.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              80.ph,
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: BackWidget(),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      // width: 140,
                      child: CustomText(
                        color: context.primaryColor,
                        weight: FontWeight.w800,
                        align: TextAlign.center,
                        "سياسة الخصوصية والاستخدام",
                        fontSize: 19.sp,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
              44.ph,
              Column(
                children: List.generate(
                  6,
                  (index) => PrivacyWidget(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
