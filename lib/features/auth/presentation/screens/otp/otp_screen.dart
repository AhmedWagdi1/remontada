import 'dart:async';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/services/alerts.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/widgets/button_widget.dart';

class OtpScreen extends StatefulWidget {
  final String sendTo;
  final Function(String code) onSubmit;
  final bool? init;
  final VoidCallback onReSend;
  const OtpScreen({
    super.key,
    required this.sendTo,
    required this.onSubmit,
    required this.onReSend,
    this.init,
  });

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool activeBut = false;
  final formKey = GlobalKey<FormState>();
  DateTime target = DateTime.now().add(const Duration(minutes: 5));
  DateTime now = DateTime.now();
  Timer? timer;
  String remainigTime = '02:00';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.init == true) widget.onReSend.call();
      startTimer();
    });
    super.initState();
  }

  void startTimer() {
    target = DateTime.now().add(const Duration(minutes: 2));
    now = DateTime.now();
    timer = Timer.periodic(const Duration(seconds: 1), (s) {
      if (now.isBefore(target)) {
        now = now.add(const Duration(seconds: 1));
        remainigTime =
            '${target.difference(now).inMinutes}:${target.difference(now).inSeconds.remainder(60)}';
        setState(() {});
      } else {
        remainigTime = '';
        timer!.cancel();
      }
      setState(() {});
    });
  }

  TextEditingController otpController = TextEditingController();

  @override
  void dispose() {
    timer!.cancel();
    otpController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppbar(
      //   title: "كود التحقق",
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Form(
              key: formKey,
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
                          LocaleKeys.auth_otp.tr(),
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
                  Container(
                    width: 244,
                    height: 42,
                    child: CustomText(
                        style: TextStyle(
                          color: LightThemeColors.secondaryText,
                        ).s14.medium,
                        align: TextAlign.center,
                        LocaleKeys.auth_description_verification
                            .tr() // fontSize: 14,
                        // c
                        // weight: FontWeight.w500,
                        ),
                  ),
                  13.ph,
                  Container(
                    width: 150,
                    height: 40,
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: LightThemeColors.primary.withOpacity(.09),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: Center(
                      child: CustomText(
                        widget.sendTo,
                        style: TextStyle(
                          color: LightThemeColors.primary,
                        ).s14.bold,
                        // fontSize: 14,
                        // weight: FontWeight.w500,
                      ),
                    ),
                  ),
                  40.ph,
                  SvgPicture.asset(
                    Assets.icons.otp,
                    width: 263.96,
                    height: 270.59,
                  ),
                  36.11.ph,
                  Padding(
                    padding: const EdgeInsets.all(16),
                    // child: Directionality(
                    //   textDirection: TextDirection.ltr,
                    // textDirection: TextDirection.LTR,
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        // androidSmsAutofillMethod:
                        //     AndroidSmsAutofillMethod.smsUserConsentApi,
                        // smsCodeMatcher: PinputConstants.defaultSmsCodeMatcher,
                        length: 5,
                        autofocus: false,
                        // errorText: otpError,
                        // onClipboardFound: (s) {},
                        controller: otpController,
                        defaultPinTheme: PinTheme(
                          // padding: EdgeInsets.only(
                          //   right: 11.w,
                          // ),
                          textStyle: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          width: 48,
                          height: 65,
                          decoration: BoxDecoration(
                            color: LightThemeColors.surface,
                            borderRadius: BorderRadius.circular(33.0),
                            // border: Border.all(
                            //   color: Colors.black,
                            //   width: 1.0,
                            // ),
                            //shape: BoxShape.circle,
                          ),
                        ),
                        followingPinTheme: PinTheme(
                            textStyle: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: context.primaryColor,
                            ),
                            width: 48,
                            height: 65,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: LightThemeColors.border,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(33.0.r),
                              // border: Border.all(
                              //   color: Colors.black,
                              //   width: 1.0,
                              // ),
                              //shape: BoxShape.circle,
                            )),
                        pinAnimationType: PinAnimationType.scale,
                        validator: Utils.valid.defaultValidation,
                        onCompleted: (pin) async {
                          activeBut = true;
                          await widget.onSubmit(pin);
                          otpController.clear();
                        },
                        onChanged: (value) {
                          if (value.length == 6) {
                            activeBut = true;
                            setState(() {});
                          } else {
                            activeBut = false;
                            setState(() {});
                          }
                        },
                      ),
                    ),
                  ),
                  30.ph,
                  ButtonWidget(
                    fontSize: 16,
                    height: 65,
                    radius: 33,
                    child: CustomText(
                      LocaleKeys.auth_check.tr(),
                      fontSize: 16,
                      weight: FontWeight.bold,
                      color: activeBut ? Colors.white : context.primaryColor,
                    ),
                    withBorder: true,
                    buttonColor: activeBut
                        ? context.primaryColor
                        : context.primaryColor.withOpacity(.1),
                    // textColor:,
                    borderColor:
                        activeBut ? context.primaryColor : Colors.transparent,
                    width: double.infinity,
                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    onTap: () async {
                      // Navigator.pushNamed(context, Routes.layout);
                      if (formKey.currentState!.validate()) {
                        if (otpController.text.length < 5) {
                          Alerts.snack(
                            text: "الكود غير صحيح",
                            state: SnackState.failed,
                          );
                        } else {
                          await widget.onSubmit(otpController.text);
                          otpController.clear();
                        }
                      }
                    },
                  ),
                  33.ph,
                  CustomText(
                    LocaleKeys.auth_send_otp.tr(),
                    // fontSize: 16,
                    style: TextStyle(
                      color: LightThemeColors.secondaryText,
                    ).s14.regular,
                    // weight: FontWeight.w600,
                  ),
                  5.ph,
                  remainigTime.isEmpty
                      ? GestureDetector(
                          child: CustomText(
                            style: TextStyle(
                              color: context.primaryColor,
                            ).s14.medium,
                            // fontSize: 16,
                            LocaleKeys.auth_send_otp_again.tr(),
                            // weight: FontWeight.w600,
                          ),
                          onTap: remainigTime.isEmpty
                              ? () async {
                                  widget.onReSend.call();
                                  print('object');
                                  remainigTime = '60';
                                  setState(() {});
                                  startTimer();
                                }
                              : null)
                      : Center(
                          child: CustomText(
                            style: TextStyle(
                              color: context.primaryColor,
                            ).s16.medium,
                            // weight: FontWeight.w600,
                            // fontSize: 16,
                            '$remainigTime ',
                          ),
                        ),
                  35.ph,
                ],
              )),
        ),
      ),
    );
  }
}
