import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/edit_text_widget.dart';

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
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  AuthRequest authRequest = AuthRequest();
  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = AuthCubit.get(context);
          return Scaffold(
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
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      height: 811,
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

                    Column(
                      children: [
                        101.ph,
                        SvgPicture.asset(
                          "logo".svg("icons"),
                        ),
                        33.1.ph,
                        Container(
                          height: 582,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(69),
                              topRight: Radius.circular(
                                69,
                              ),
                            ),
                            color: LightThemeColors.primaryContainer,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 18,
                            ),
                            child: Column(
                              children: [
                                66.ph,
                                CustomText(
                                  weight: FontWeight.bold,
                                  // fontFamily: "DINNext",
                                  fontSize: 24,
                                  "تسجيل الدخول",
                                  color: LightThemeColors.textPrimary,
                                ),
                                4.ph,
                                CustomText(
                                  weight: FontWeight.bold,
                                  // fontFamily: "DINNext",
                                  fontSize: 16,
                                  "قم بكتابة بيانات حسابك لتسجيل الدخول",
                                  color: LightThemeColors.secondaryText,
                                ),
                                35.ph,
                                TextFormFieldWidget(
                                  contentPadding:
                                      EdgeInsetsDirectional.symmetric(
                                    vertical: 22,
                                  ),
                                  hintSize: 16,
                                  borderRadius: 33,
                                  hintText: "            رقم الجوال",
                                  hintColor: LightThemeColors.textPrimary,
                                  activeBorderColor:
                                      LightThemeColors.inputFieldBorder,
                                ),
                                26.ph,
                                ButtonWidget(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.LayoutScreen,
                                    );
                                  },
                                  height: 65,
                                  radius: 33,
                                  gradient: LightThemeColors.buttonColor,
                                  child: CustomText(
                                    "الدخول",
                                    fontSize: 18,
                                    color: context.colorScheme.onPrimary,
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
                                    "ليس لديك حساب؟",
                                    color: LightThemeColors.secondaryText,
                                    fontSize: 16,
                                    weight: FontWeight.w600,
                                  ),
                                )
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
                    //         //         final res = await cubit.activate(
                    //         //             registerRequestModel: registerModel);

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

                    Positioned(
                      bottom: 0,
                      child: Transform.scale(
                        scale: 1.2,
                        child: SvgPicture.asset(
                          "login_bottom".svg("images"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
