import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/edit_text_widget.dart';

import '../../../../../core/app_strings/locale_keys.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';
import '../../../domain/request/auth_request.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phone = TextEditingController();
  // TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthRequest authRequest = AuthRequest();
  @override
  void dispose() {
    phone.dispose();
    // password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if (state is NeedRegister) {
            Navigator.pushNamed(
              context,
              Routes.RegisterScreen,
            );
          }
        },
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          return Scaffold(
              // backgroundColor: context.background,
              // appBar: AppBar(
              //   centerTitle: true,
              //   elevation: 0,
              //   backgroundColor: Colors.transparent,
              //   leadingWidth: 80,
              //   // toolbarHeight: 80,
              //   leading: BackWidget(
              //     size: 20,
              //   ),
              //   title: CustomText(
              //     'تسجيل الدخول',
              //     fontSize: 18,
              //     color: context.primaryColor,
              //     weight: FontWeight.w700,
              //   ),
              // ),
              body: Container(
            color: context.background,
            child: Stack(
              // alignment: Alignment.topCenter,
              children: [
                Container(
                  // height: 811,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(
                        "Splash".png("images"),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // top: 10,
                  right: 0,
                  left: 0,
                  bottom: 100,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          101.ph,
                          SvgPicture.asset(
                            width: 118,
                            height: 97.81,
                            Assets.icons.logo,
                          ),
                          33.1.ph,
                          Container(
                            height: 510,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(69),
                                topRight: Radius.circular(
                                  69,
                                ),
                              ),
                              color: context.background,
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              child: Column(
                                children: [
                                  66.ph,
                                  CustomText(
                                    // weight: FontWeight.bold,
                                    // fontFamily: "DINNext",
                                    style: TextStyle(
                                      color: LightThemeColors.textPrimary,
                                    ).s24.heavy,
                                    // fontSize: 24.sp,
                                    LocaleKeys.auth_login.tr(),
                                  ),
                                  4.ph,
                                  CustomText(
                                    // weight: FontWeight.bold,
                                    // fontFamily: "DINNext",
                                    // fontSize: 16.sp,
                                    style: TextStyle(
                                      color: LightThemeColors.secondaryText,
                                    ).s16.medium,
                                    LocaleKeys.auth_description_login.tr(),
                                  ),
                                  35.ph,
                                  TextFormFieldWidget(
                                    prefixIcon: Assets.icons.calling,
                                    onSaved: (value) =>
                                        authRequest.phone = value,
                                    borderRadius: 33,
                                    hintText: LocaleKeys.auth_hint_phone.tr(),
                                    hintColor: LightThemeColors.textPrimary,
                                    activeBorderColor:
                                        LightThemeColors.inputFieldBorder,
                                    type: TextInputType.phone,
                                  ),
                                  26.ph,
                                  ButtonWidget(
                                    onTap: () async {
                                      if (formKey.currentState?.validate() ??
                                          false) {
                                        formKey.currentState?.save();
                                        final res = await cubit.login(
                                            loginRequestModel: authRequest);
                                        if (res == true) {
                                          phone.clear();
                                          Navigator.pushNamed(
                                            context,
                                            Routes.OtpScreen,
                                            arguments: OtpArguments(
                                              sendTo: authRequest.phone ?? "",
                                              onSubmit: (value) async {
                                                authRequest.code = value;
                                                final res =
                                                    await cubit.sendCode(
                                                        phone:
                                                            authRequest.phone ??
                                                                "",
                                                        code:
                                                            authRequest.code ??
                                                                "");
                                                if (res == true) {
                                                  Alerts.snack(
                                                    text:
                                                        "تم تسجيل الدخول بنجاح",
                                                    state: SnackState.success,
                                                  );
                                                  Navigator
                                                      .pushNamedAndRemoveUntil(
                                                          context,
                                                          Routes.LayoutScreen,
                                                          (route) => false);
                                                }
                                              },
                                              onReSend: () async {
                                                await cubit.resendCode(
                                                    authRequest.phone ?? "");
                                              },
                                              init: false,
                                            ),
                                          );
                                        }
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
                                  40.ph,
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.RegisterScreen,
                                      );
                                    },
                                    child: CustomText(
                                      LocaleKeys.auth_havnot_account.tr(),
                                      style: TextStyle(
                                        color: LightThemeColors.secondaryText,
                                      ).s16.medium,

                                      // fontSize: 16.sp,
                                      // weight: FontWeight.w600,
                                    ),
                                  ),
                                  15.ph,
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        Routes.LayoutScreen,
                                      );
                                    },
                                    child: CustomText(
                                      "تخطي",
                                      style: TextStyle(
                                        color: LightThemeColors.secondaryText,
                                      ).s16.medium,

                                      // fontSize: 16.sp,
                                      // weight: FontWeight.w600,
                                    ),
                                  ),
                                  100.ph,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      // CustomText(
                      //   'قم بإدخال بياناتك لتسجيل الدخول',
                      //   fontSize: 14,
                      //   color: Colors.black,
                      //   weight: FontWeight.w300,
                      // ),
                      // 40.ph,
                      // SvgPicture.asset(
                      //   "login".svg("icons"),
                      //   width: 212,
                      //   height: 212,
                      // ),
                      // 50.ph,
                      // /*  TextFormFieldWidget(
                      //   backgroundColor: AppColors.primary.withOpacity(.04),
                      //   // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //   type: TextInputType.phone,
                      //   prefixIcon: Icon(
                      //     Icons.phone_outlined,
                      //     color: AppColors.primary,
                      //   ),
                      //   hintText: 'رقم الجوال',
                      //   hintColor: Color(0xff001F6E),

                      //   password: false,
                      //   validator: (v) => Utils.valid.defaultValidation(v),
                      //   controller: phone,
                      //   borderRadius: 33,
                      // ), */
                      // TextFormFieldWidget(
                      //   backgroundColor: context.primaryColor.withOpacity(.04),
                      //   // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //   type: TextInputType.emailAddress,
                      //   prefixIcon: "emailiconpath",
                      //   hintText: 'البريد الالكتروني',
                      //   hintColor: Color(0xff001F6E),

                      //   password: false,
                      //   // validator: (v) => Utils.valid.emailValidation(v),
                      //   controller: email,
                      //   borderRadius: 33,
                      // ),
                      // 20.ph,
                      // TextFormFieldWidget(
                      //   hintColor: Color(0xff001F6E),
                      //   backgroundColor: context.primaryColor.withOpacity(.04),
                      //   // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //   type: TextInputType.visiblePassword,
                      //   prefixIcon: "",
                      //   hintText: 'كلمة المرور',
                      //   password: true,
                      //   // validator: (v) => Utils.valid.validatePassword(v),
                      //   controller: password,
                      //   borderRadius: 33,
                      // ),
                      // 30.ph,

                      // TextButtonWidget(
                      //     text: 'هل نسيت كلمة المرور ؟',
                      //     size: 14,
                      //     color: context.secondaryColor,
                      //     // weight: w300,
                      //     function: () {
                      //       Navigator.pushNamed(
                      //           context, Routes.forget_passScreen);
                      //     }),

                      // 30.ph,
                      // ButtonWidget(
                      //   title: 'تسجيل الدخول',
                      //   withBorder: true,
                      //   buttonColor: context.primaryColor,
                      //   textColor: Colors.white,
                      //   borderColor: context.primaryColor,
                      //   width: double.infinity,
                      //   fontSize: 18,
                      //   fontweight: FontWeight.bold,
                      //   // padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   onTap: () async {
                      //     AuthRequest registerModel = AuthRequest(
                      //       password: password.text,
                      //       email: email.text,
                      //     );
                      //     FocusScope.of(context).unfocus();
                      //     if (formKey.currentState!.validate()) {
                      //       final response = await cubit.login(
                      //           loginRequestModel: registerModel);
                      //       if (response == true) {
                      //         Navigator.pushNamedAndRemoveUntil(context,
                      //             Routes.LayoutScreen, (route) => false);
                      //       } else if (response == false) {
                      //         // Alerts.snack(
                      //         //     text: 'You have to activate your account'
                      //         //         .tr(),
                      //         //     state: SnackState.failed);
                      //         // Navigator.pushNamed(
                      //         //   context,
                      //         //   Routes.OtpScreen,
                      //         //   arguments: OtpArguments(
                      //         //       sendTo: email.text,
                      //         //       onSubmit: (s) async {
                      //         //         registerModel.code = s;
                      //         // final res = await cubit.activate(
                      //       //     registerRequestModel: registerModel);

                      //         //         if (res == true) {
                      //         //           Navigator.pushNamedAndRemoveUntil(
                      //         //               context,
                      //         //               Routes.LayoutScreen,
                      //         //               (route) => false);
                      //         //         }
                      //         //       },
                      //         //       onReSend: () async {
                      //         //         await cubit.resenCode(
                      //         //             email: registerModel.email ?? '');
                      //         //       },
                      //         //       init: false),
                      //         // );
                      //       }
                      //     }
                      //   },
                      // ),
                      // 20.ph,
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     CustomText(
                      //       "ليس لديك حساب ؟",
                      //       fontSize: 14,
                      //       color: context.primaryColor,
                      //       weight: FontWeight.w400,
                      //     ),
                      //     8.pw,
                      //     TextButtonWidget(
                      //         text: "حساب جديد",
                      //         // fontSize: 14,
                      //         // padding: const EdgeInsets.symmetric(horizontal: 15),
                      //         color: context.primaryColor,
                      //         // weight: w300,
                      //         function: () {
                      //           Navigator.pushReplacementNamed(
                      //               context, Routes.RegisterScreen);
                      //         }),
                      //   ],
                      // ),
                      // 20.ph,
                      // ButtonWidget(
                      //   title: 'الدخول كزائر',
                      //   withBorder: true,
                      //   buttonColor: Colors.white,
                      //   textColor: context.primaryColor,
                      //   borderColor: context.primaryColor,
                      //   width: double.infinity,

                      //   // padding: const EdgeInsets.symmetric(horizontal: 15),
                      //   onTap: () async {
                      //     Navigator.pushNamed(
                      //       context,
                      //       Routes.LayoutScreen,
                      //     );
                      //   },
                      // ),
                      // // signupBtn(context),
                      // 20.ph,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  left: 0,
                  // width: double.infinity,
                  bottom: 0,
                  child: Container(
                    color: context.background,
                    height: 104,
                    width: double.infinity,
                    child: SvgPicture.asset(
                      fit: BoxFit.fill,
                      "login_bottom".svg("images"),
                    ),
                  ),
                ),
              ],
            ),
          ));
        },
      ),
    );
  }
}
