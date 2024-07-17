import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/more/domain/contact_request.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/edit_text_widget.dart';

import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/resources/gen/assets.gen.dart';
import '../../../../core/theme/light_theme.dart';
import '../../../../shared/back_widget.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key, this.contact});
  final Function(ContactRequest)? contact;

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  ContactRequest request = ContactRequest();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController message = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ProfileAppbar(
      //   title: LocaleKeys.contactUs.tr(),

      body: SizedBox(
        width: double.infinity,
        child: Form(
          key: formkey,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // 47.0.ph,
              // const HeaderIcon(icon: 'profile_contact'),
              // 11.4.spacev,
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
                        "contactUs".tr(),
                        fontSize: 26,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                ],
              ),
              60.0.ph,

              TextFormFieldWidget(
                controller: name,
                validator: Utils.valid.defaultValidation,
                onSaved: (value) => request.name = value,
                prefixIcon: Assets.icons.name,
                // onSaved: (value) =>
                // authRequest.phone = value,
                // hintSize: FontSize.s14,
                borderRadius: 33,
                hintText: LocaleKeys.auth_hint_name.tr(),
                hintColor: LightThemeColors.textPrimary,
                activeBorderColor: LightThemeColors.inputFieldBorder,
                // contentPadding:
                //     EdgeInsetsDirectional.symmetric(
                //   vertical: 22.w,
                // ),
                // hintSize: FontSize.s16,
                // borderRadius: 33.r,
                // hintText: "    رقم الجوال",
                // hintColor: LightThemeColors.textPrimary,
                // activeBorderColor:
                //     LightThemeColors.inputFieldBorder,
              ),
              15.0.ph,
              TextFormFieldWidget(
                controller: email,
                validator: Utils.valid.emailValidation,
                onSaved: (value) => request.email = value,
                prefixIcon: Assets.icons.email,
                // onSaved: (value) =>
                //     authRequest.phone = value,
                // hintSize: FontSize.s14,
                borderRadius: 33,
                hintText: LocaleKeys.email.tr(),
                hintColor: LightThemeColors.textPrimary,
                activeBorderColor: LightThemeColors.inputFieldBorder,
                // contentPadding:
                //     EdgeInsetsDirectional.symmetric(
                //   vertical: 22.w,
                // ),
                // hintSize: FontSize.s16,
                // borderRadius: 33.r,
                // hintText: "    رقم الجوال",
                // hintColor: LightThemeColors.textPrimary,
                // activeBorderColor:
                //     LightThemeColors.inputFieldBorder,
              ),
              15.0.ph,
              TextFormFieldWidget(
                controller: phone,
                validator: Utils.valid.phoneValidation,
                onSaved: (value) => request.phone = value,
                prefixIcon: Assets.icons.calling,
                // onSaved: (value) =>
                //     authRequest.phone = value,
                // hintSize: FontSize.s14,
                borderRadius: 33,
                hintText: LocaleKeys.auth_hint_phone.tr(),
                hintColor: LightThemeColors.textPrimary,
                activeBorderColor: LightThemeColors.inputFieldBorder,
                // contentPadding:
                //     EdgeInsetsDirectional.symmetric(
                //   vertical: 22.w,
                // ),
                // hintSize: FontSize.s16,
                // borderRadius: 33.r,
                // hintText: "    رقم الجوال",
                // hintColor: LightThemeColors.textPrimary,
                // activeBorderColor:
                //     LightThemeColors.inputFieldBorder,
              ),
              15.ph,
              TextFormFieldWidget(
                controller: message,
                validator: (value) {
                  if (value!.trim().isEmpty) {
                    return "هذا الحقل مطلوب";
                  } else if (value.trim().length <= 10) {
                    return "يجب ان يكون الرسالة اكثر من 10 حروف";
                  }
                  return null;
                },
                onSaved: (value) => request.message = value,
                maxLines: 10,

                // prefixIcon: Assets.icons.calling,
                // onSaved: (value) =>
                //     authRequest.phone = value,
                // hintSize: FontSize.s14,
                borderRadius: 33,
                hintText: LocaleKeys.auth_hint_message.tr(),
                hintColor: LightThemeColors.textPrimary,
                activeBorderColor: LightThemeColors.inputFieldBorder,
              ),
              60.7.ph,
              ButtonWidget(
                onTap: () async {
                  if (formkey.currentState?.validate() ?? false) {
                    formkey.currentState?.save();
                    await widget.contact!(request);
                    name.clear();
                    email.clear();
                    phone.clear();
                    message.clear();
                  }
                },
                height: 65,
                radius: 33,
                // gradient: LightThemeColors.buttonColor,
                child: CustomText(
                  LocaleKeys.auth_enter.tr(),
                  style: TextStyle(
                    color: context.scaffoldBackgroundColor,
                  ).s18.bold,
                  // fontSize: 18.sp,
                ),
              ),

              32.0.ph,
            ],
          ),
        ),
      ).paddingHorizontal(30),
    );
  }
}
