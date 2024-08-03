import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/services/media/alert_of_media.dart';
import 'package:remontada/core/services/media/my_media.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';
import 'package:remontada/features/profile/domain/edit_request.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/Router/Router.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../core/utils/utils.dart';
import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../auth/domain/repository/auth_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    this.user,
    this.edit,
    this.onSubmit,
  });
  final User? user;
  final Function(EditRequest edit)? edit;
  final dynamic Function(String)? onSubmit;
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController location = TextEditingController();
  File? image;
  EditRequest edit = EditRequest();
  User? user;

  @override
  void initState() {
    name.text = widget.user?.user?.name ?? "";
    phone.text = widget.user?.user?.phone ?? "";
    email.text = widget.user?.user?.email ?? "";
    city.text = widget.user?.user?.city ?? "";
    location.text = widget.user?.user?.location ?? "";
    edit.areaId = widget.user?.user?.cityId ?? 0;
    edit.locationId = widget.user?.user?.locationId ?? 0;
    super.initState();
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    // city.dispose();
    // location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppbar(
      //   title: "تعديل بياناتي",
      // ),
      body: Padding(
        padding: EdgeInsets.only(
          right: 18,
          left: 18,
          bottom: 20,
          // bottom: 600,
        ),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Form(
                key: formkey,
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
                        // image: DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: FileImage(
                        //     image ?? File(""),
                        //   ),
                        // ),
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
                      child: image != null
                          ? Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(image!),
                                ),
                              ),
                            )
                          : widget.user?.user?.image == ""
                              ? Assets.images.profile_image.image(
                                  fit: BoxFit.contain,
                                )
                              : Container(
                                  width: 96,
                                  height: 96,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          widget.user?.user?.image ?? ""),
                                    ),
                                  ),
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
                    ).onTap(() {
                      Alerts.bottomSheet(
                        context,
                        child: AlertOfMedia(
                          cameraTap: () async {
                            image = await MyMedia.pickImageFromCamera();
                            edit.image = image;
                            Navigator.pop(context);
                            setState(() {});
                          },
                          galleryTap: () async {
                            image = await MyMedia.pickImageFromGallery();
                            edit.image = image;
                            Navigator.pop(context);
                            setState(() {});
                          },
                        ),
                      );
                    },
                        splashColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        borderRadius: BorderRadius.circular(33)),
                    21.ph,
                    TextFormFieldWidget(
                      onSaved: (value) {
                        edit.name = value;
                      }, //register.name = value,
                      controller: name,
                      validator: Utils.valid.defaultValidation,
                      prefixIcon: Assets.icons.name,
                      hintSize: 16,
                      borderRadius: 33,
                      hintText: LocaleKeys.auth_hint_name.tr(),
                      hintColor: LightThemeColors.textPrimary,
                      activeBorderColor: LightThemeColors.inputFieldBorder,
                    ),

                    10.ph,
                    // if (!(formKey.currentState?.validate() ?? false))
                    //   20.ph,
                    TextFormFieldWidget(
                      onSaved: (value) {
                        edit.phone = value;
                      }, //register.phone = value,
                      controller: phone,
                      validator: Utils.valid.phoneValidation,
                      prefixIcon: Assets.icons.calling,
                      hintSize: 16,
                      borderRadius: 33,
                      hintText: LocaleKeys.auth_hint_phone.tr(),
                      hintColor: LightThemeColors.textPrimary,
                      activeBorderColor: LightThemeColors.inputFieldBorder,
                    ),
                    10.ph,
                    TextFormFieldWidget(
                      onSaved: (value) {
                        edit.email = value;
                      }, // register.email = value,
                      controller: email,
                      validator: Utils.valid.emailValidation,
                      prefixIcon: Assets.icons.email,
                      hintSize: 16,
                      borderRadius: 33,
                      hintText: LocaleKeys.auth_hint_email.tr(),
                      hintColor: LightThemeColors.textPrimary,
                      activeBorderColor: LightThemeColors.inputFieldBorder,
                    ),
                    10.ph,
                    CustomAutoCompleteTextField<Location>(
                      colors: LightThemeColors.textSecondary,
                      controller: city,
                      validator: Utils.valid.defaultValidation,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                          right: 35,
                          left: 9.76,
                        ),
                        child: SvgPicture.asset(Assets.icons.fieldLocation),
                      ),
                      // c: context.primaryColor,
                      hint: LocaleKeys.auth_hint_choose_city.tr(),
                      function: (p0) async {
                        return (await locator<AuthRepository>()
                                    .getArreasRequest())
                                ?.areas ??
                            [];
                      },
                      // onSaved: (p0) => ,
                      itemAsString: (p0) => p0.name ?? "item",
                      localData: true,
                      showLabel: false,
                      showSufix: true,
                      // radius: 33,
                      // options: List.generate(cubit.getlocations()., (index) => null),
                      onChanged: (val) {
                        edit.areaId = val.id;
                      },
                    ),
                    10.ph,
                    CustomAutoCompleteTextField<Location>(
                      // contentPadding: EdgeInsets.only(
                      //   bottom: 20,
                      // ),
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      controller: location,
                      validator: Utils.valid.defaultValidation,

                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(
                          right: 35,
                          left: 9.76,
                        ),
                        child: SvgPicture.asset(Assets.icons.playLocation),
                      ),
                      // c: context.primaryColor,
                      hint:
                          LocaleKeys.auth_hint_choose_choose_playlocation.tr(),
                      function: (p0) async {
                        return (await locator<AuthRepository>()
                                    .getlocationRequest())
                                ?.locations ??
                            [];
                      },
                      itemAsString: (p0) => p0.name ?? "",
                      localData: true,
                      showLabel: false,
                      showSufix: true,
                      // radius: 33,
                      // options: List.generate(cubit.getlocations()., (index) => null),
                      onChanged: (val) {
                        edit.locationId = val.id;
                      },
                    ),
                    21.ph,
                    ButtonWidget(
                      onTap: () async {
                        if (formkey.currentState?.validate() ?? false) {
                          formkey.currentState?.save();

                          final res = await widget.edit!(edit);
                          if (res != null) {
                            user = res;
                            if (user?.mobileChanged == true) {
                              Navigator.pushNamed(
                                context,
                                Routes.OtpScreen,
                                arguments: OtpArguments(
                                  sendTo: "",
                                  onSubmit: widget.onSubmit!,
                                  onReSend: () {},
                                ),
                              );
                            } else {
                              Alerts.snack(
                                text: "تم التعديل بنجاح",
                                state: SnackState.success,
                              );
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                context,
                                Routes.profileDetails,
                              );
                            }
                          }
                        }
                      },
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
                    // 200.ph,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
