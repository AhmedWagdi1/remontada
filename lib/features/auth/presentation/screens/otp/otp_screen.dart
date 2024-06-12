import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pinput/pinput.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../../core/extensions/all_extensions.dart';
import '../../../../../core/services/alerts.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../core/utils/utils.dart';
import '../../../../../shared/widgets/button_widget.dart';
import '../../../../../shared/widgets/customAppbar.dart';

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
      appBar: CustomAppbar(
        title: "كود التحقق",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  5.ph,
                  Container(
                    width: 244,
                    height: 42,
                    child: CustomText(
                      align: TextAlign.center,
                      "قم بكتابة كود التحقق المكون من 6 ارقام الذي تم ارساله اليك عبر الجوال",
                      fontSize: 14,
                      color: LightThemeColors.secondaryText,
                      weight: FontWeight.w500,
                    ),
                  ),
                  24.ph,
                  Container(
                    height: 34,
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 22),
                    decoration: BoxDecoration(
                      color: LightThemeColors.primary.withOpacity(.09),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: CustomText(
                      "+966 562609805",
                      color: LightThemeColors.primary,
                      fontSize: 14,
                      weight: FontWeight.w500,
                    ),
                  ),
                  40.ph,
                  SvgPicture.asset(
                    "otp".svg("icons"),
                    width: 212,
                    height: 212,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Pinput(
                        // androidSmsAutofillMethod:
                        //     AndroidSmsAutofillMethod.smsUserConsentApi,
                        // smsCodeMatcher: PinputConstants.defaultSmsCodeMatcher,
                        length: 6,
                        autofocus: false,
                        // errorText: otpError,
                        // onClipboardFound: (s) {},
                        controller: otpController,
                        defaultPinTheme: PinTheme(
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
                              borderRadius: BorderRadius.circular(33.0),
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
                    title: 'تحقق',
                    withBorder: true,
                    buttonColor: activeBut
                        ? context.primaryColor
                        : context.primaryColor.withOpacity(.1),
                    textColor: activeBut ? Colors.white : context.primaryColor,
                    borderColor:
                        activeBut ? context.primaryColor : Colors.transparent,
                    width: double.infinity,
                    // padding: const EdgeInsets.symmetric(horizontal: 15),
                    onTap: () async {
                      // Navigator.pushNamed(context, Routes.layout);
                      if (formKey.currentState!.validate()) {
                        if (otpController.text.length < 4) {
                          Alerts.snack(
                              text: "الكود غير صحيح", state: SnackState.failed);
                        } else {
                          await widget.onSubmit(otpController.text);
                        }
                      }
                    },
                  ),
                  33.ph,
                  CustomText(
                    "لم يتم إستلام كود التحقق ؟",
                    fontSize: 16,
                    weight: FontWeight.w600,
                    color: LightThemeColors.secondaryText,
                  ),
                  5.ph,
                  remainigTime.isEmpty
                      ? GestureDetector(
                          child: CustomText(
                            fontSize: 16,
                            "أرسل الكود مرة أخرى",
                            color: context.primaryColor,
                            weight: FontWeight.w600,
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
                            color: context.primaryColor,
                            weight: FontWeight.w600,
                            fontSize: 16,
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
