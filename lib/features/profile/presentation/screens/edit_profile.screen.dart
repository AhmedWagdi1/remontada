import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
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
                        LocaleKeys.edit_button.tr(),
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
                  ).s16.medium,
                  LocaleKeys.edit_sub.tr(),
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
                  width: 202,
                  height: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(33),
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
                          LocaleKeys.edit_profile_photo.tr(),
                          style: TextStyle(
                            color: context.primaryColor,
                          ).s16.medium,
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
                  hintText: LocaleKeys.auth_hint_name.tr(),
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.ph,
                TextFormFieldWidget(
                  prefixIcon: Assets.icons.calling,
                  hintSize: 16,
                  borderRadius: 33,
                  hintText: LocaleKeys.auth_hint_phone.tr(),
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.ph,
                TextFormFieldWidget(
                  prefixIcon: Assets.icons.email,
                  hintSize: 16,
                  borderRadius: 33,
                  hintText: LocaleKeys.auth_hint_email.tr(),
                  hintColor: LightThemeColors.textPrimary,
                  activeBorderColor: LightThemeColors.inputFieldBorder,
                ),
                10.ph,
                DropDownItem<String>(
                  prefixIcon: Assets.icons.fieldLocation,
                  hintColor: context.primaryColor,
                  hint: LocaleKeys.auth_hint_choose_city.tr(),
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
                  prefixIcon: Assets.icons.playLocation,
                  hintColor: context.primaryColor,
                  hint: LocaleKeys.auth_hint_choose_choose_playlocation.tr(),
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
                    LocaleKeys.save_changes.tr(),
                    fontSize: 16,
                    weight: FontWeight.bold,
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
