import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customAppbar.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/dropdown.dart';
import 'package:remontada/shared/widgets/edit_text_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "تعديل بياناتي",
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomText(
                  "يمكنك تعديل بياناتك الشخصية",
                  fontSize: 14,
                  weight: FontWeight.w500,
                  color: LightThemeColors.secondaryText,
                ),
                21.ph,
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset.zero,
                        blurRadius: 30,
                        color: LightThemeColors.black.withOpacity(.2),
                      ),
                    ],
                    color: LightThemeColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                18.ph,
                Container(
                  width: 202.w,
                  height: 36.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33.r),
                    color: context.primaryColor.withOpacity(.07),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: SvgPicture.asset(
                          "wallet".svg(),
                          color: context.primaryColor,
                        ),
                      ),
                      9.12.pw,
                      CustomText(
                        "تغيير الصورة الشخصية",
                        fontSize: 14,
                        weight: FontWeight.w500,
                        color: context.primaryColor,
                      )
                    ],
                  ),
                ),
                21.ph,
                TextFormFieldWidget(
                  hintSize: 16.sp,
                  borderRadius: 33,
                  hintText: "ادخل الاسم",
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.ph,
                TextFormFieldWidget(
                  hintSize: 16.sp,
                  borderRadius: 33,
                  hintText: "رقم الجوال",
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.ph,
                TextFormFieldWidget(
                  hintSize: 16.sp,
                  borderRadius: 33,
                  hintText: "البريد الالكتروني",
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.ph,
                DropDownItem<String>(
                  hintColor: context.primaryColor,
                  hint: "      اختر المدينة",
                  radius: 33,
                  options: [
                    "item1",
                    "item2",
                    "item3",
                    "item4",
                  ],
                  onChanged: (val) {},
                ),
                10.ph,
                DropDownItem<String>(
                  hintColor: context.primaryColor,
                  hint: "      اختر موقعك المفضل بالملعب",
                  radius: 33,
                  options: [
                    "item1",
                    "item2",
                    "item3",
                    "item4",
                  ],
                  onChanged: (val) {},
                ),
                21.ph,
                ButtonWidget(
                  onTap: () {},
                  height: 65,
                  child: CustomText(
                    "حفظ التعديلات",
                    fontSize: 16,
                    weight: FontWeight.w800,
                    color: context.background,
                  ),
                  radius: 33,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
