import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
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
      // appBar: CustomAppbar(
      //   title: "تعديل بياناتي",
      // ),
      body: SingleChildScrollView(
        child: Form(
          key: formkey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                80.ph,
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: double.infinity,
                      // height: 40.h,
                    ),
                    Positioned(
                      // top: 0,
                      child: CustomText(
                        "تعديل بياناتي",
                        style: TextStyle(
                          color: context.primaryColor,
                        ).s24.heavy,
                        // fontSize: 26,
                        // weight: FontWeight.bold,
                        // color: context.colorScheme.primary,
                      ),
                    ),
                    Positioned(
                      right: 0,
                      // bottom: 0,
                      child: BackWidget(),
                    ),
                  ],
                ),
                5.ph,
                CustomText(
                  style: TextStyle(
                    color: LightThemeColors.secondaryText,
                  ).s14.medium,
                  "يمكنك تعديل بياناتك الشخصية",
                  // fontSize: 14,
                  // weight: FontWeight.w500,
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
                        color: LightThemeColors.black.withOpacity(.15),
                      ),
                    ],
                    color: context.background,
                    shape: BoxShape.circle,
                  ),
                  child: Assets.images.profile_image.image(
                    fit: BoxFit.contain,
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
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Assets.icons.photo_camera.toSvg(
                          width: 17,
                          height: 15.44,
                          color: context.primaryColor,
                        ),
                        5.pw,
                        CustomText(
                          "تغيير الصورة الشخصية",
                          style: TextStyle(
                            color: context.primaryColor,
                          ).s14.medium,
                          // fontSize: 14,
                          // weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ).onTap(() {},
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(33)),
                21.ph,
                TextFormFieldWidget(
                  prefixIcon: Assets.icons.name,
                  hintSize: 16,
                  borderRadius: 33,
                  hintText: "ادخل الاسم",
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.h.ph,
                TextFormFieldWidget(
                  prefixIcon: Assets.icons.calling,
                  hintSize: 16,
                  borderRadius: 33,
                  hintText: "رقم الجوال",
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.h.ph,
                TextFormFieldWidget(
                  prefixIcon: Assets.icons.email,
                  hintSize: 16,
                  borderRadius: 33,
                  hintText: "البريد الالكتروني",
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.h.ph,
                DropDownItem<String>(
                  prefixIcon: Assets.icons.fieldLocation,
                  hintColor: context.primaryColor,
                  hint: "اختر المدينة",
                  radius: 33,
                  options: [
                    "item1",
                    "item2",
                    "item3",
                    "item4",
                  ],
                  onChanged: (val) {},
                ),
                10.h.ph,
                DropDownItem<String>(
                  prefixIcon: Assets.icons.playLocation,
                  hintColor: context.primaryColor,
                  hint: "اختر موقعك المفضل بالملعب",
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
                35.ph,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
