import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';
import 'package:remontada/features/auth/domain/repository/auth_repository.dart';
import 'package:remontada/features/auth/domain/request/auth_request.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/edit_text_widget.dart';

import '../../../../../core/services/alerts.dart';
import '../../../../../core/utils/extentions.dart';
import '../../../../../shared/back_widget.dart';
import '../../../../../shared/widgets/autocomplate.dart';
import '../../../cubit/auth_cubit.dart';
import '../../../cubit/auth_states.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  int? location_id;
  int? area_id;
  final formKey = GlobalKey<FormState>();
  AuthRequest register = AuthRequest();
  List<Locations>? locations;
  List<Areas>? areas;
  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
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
            // backgroundColor: context.scaffoldBackgroundColor,
            // appBar: CustomAppbar(title: "انضم لريمونتادا الان"),
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
            //     "إنشاء حساب جديد",
            //     fontSize: 18,
            //     color: context.primaryColor,
            //     weight: FontWeight.w700,
            //   ),
            // ),
            body: Stack(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: formKey,
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
                                  LocaleKeys.auth_register_new_acc.tr(),
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
                          // ListTile(
                          //   titleAlignment: ListTileTitleAlignment.center,
                          //   contentPadding: EdgeInsets.zero,
                          //   leading: BackWidget(),
                          //   title:
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     BackWidget(),
                          //     CustomText(
                          //       "انضم لريمونتادا الان",
                          //       style: TextStyle(
                          //         color: context.primaryColor,
                          //       ).s24.heavy,
                          //       // fontSize: 26,
                          //       // weight: FontWeight.bold,
                          //       // color: context.colorScheme.primary,
                          //     ),
                          //     41.pw,
                          //   ],
                          // ),
                          10.ph,
                          CustomText(
                            style: TextStyle(
                              color: LightThemeColors.secondaryText,
                            ).s16.medium,
                            // weight: FontWeight.w600,
                            // // fontFamily: "DINNext",
                            // fontSize: 16,
                            LocaleKeys.auth_description_register.tr(),
                          ),
                          30.ph,
                          TextFormFieldWidget(
                            onSaved: (value) => register.name = value,
                            controller: name,
                            validator: Utils.valid.defaultValidation,
                            prefixIcon: Assets.icons.name,
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: LocaleKeys.auth_hint_name.tr(),
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor:
                                LightThemeColors.inputFieldBorder,
                          ),

                          10.ph,
                          // if (!(formKey.currentState?.validate() ?? false))
                          //   20.ph,
                          TextFormFieldWidget(
                            onSaved: (value) => register.phone = value,
                            controller: phone,
                            validator: Utils.valid.phoneValidation,
                            prefixIcon: Assets.icons.calling,
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: LocaleKeys.auth_hint_phone.tr(),
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor:
                                LightThemeColors.inputFieldBorder,
                          ),
                          10.ph,
                          TextFormFieldWidget(
                            onSaved: (value) => register.email = value,
                            controller: email,
                            validator: Utils.valid.emailValidation,
                            prefixIcon: Assets.icons.email,
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: LocaleKeys.auth_hint_email.tr(),
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor:
                                LightThemeColors.inputFieldBorder,
                          ),
                          10.ph,
                          CustomAutoCompleteTextField<Location>(
                            validator: Utils.valid.defaultValidation,

                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                right: 35,
                                left: 9.76,
                              ),
                              child:
                                  SvgPicture.asset(Assets.icons.fieldLocation),
                            ),
                            // c: context.primaryColor,
                            hint: LocaleKeys.auth_hint_choose_city.tr(),
                            function: (p0) async {
                              return (await locator<AuthRepository>()
                                          .getArreasRequest())
                                      ?.areas ??
                                  [];
                            },
                            itemAsString: (p0) => p0.name ?? "item",
                            localData: true,
                            showLabel: false,
                            showSufix: true,
                            // radius: 33,
                            // options: List.generate(cubit.getlocations()., (index) => null),
                            onChanged: (val) {
                              register.area_id = val.id;
                            },
                          ),
                          10.ph,
                          CustomAutoCompleteTextField<Location>(
                            validator: Utils.valid.defaultValidation,

                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                right: 35,
                                left: 9.76,
                              ),
                              child:
                                  SvgPicture.asset(Assets.icons.playLocation),
                            ),
                            // c: context.primaryColor,
                            hint: LocaleKeys
                                .auth_hint_choose_choose_playlocation
                                .tr(),
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
                              register.location_id = val.id;
                            },
                          ),

                          21.ph,
                          ButtonWidget(
                            // height: 80,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();
                                cubit.signUp(registerRequestModel: register);
                                if (state is RegisterSuccessState) {
                                  Navigator.pushNamed(
                                    context,
                                    Routes.OtpScreen,
                                    arguments: OtpArguments(
                                      sendTo: register.phone ?? "",
                                      onSubmit: (value) async {
                                        register.code = value;
                                        final res = await cubit.sendCode(
                                            phone: register.phone ?? "",
                                            code: register.code ?? "");
                                        if (res == true) {
                                          Alerts.snack(
                                              text: "",
                                              state: SnackState.success);
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.LayoutScreen,
                                              (route) => false);
                                        }
                                      },
                                      onReSend: () async {
                                        await cubit
                                            .resendCode(register.phone ?? "");
                                      },
                                    ),
                                  );
                                }
                              }
                            },
                            // height: 65,
                            child: CustomText(
                              style: TextStyle(
                                color: context.background,
                              ).s16.bold,
                              LocaleKeys.auth_create.tr(),
                              // fontSize: 16,
                              // weight: FontWeight.w600,
                            ),
                            radius: 33,
                          ),
                          32.ph,
                          CustomText(
                            style: TextStyle(
                              color: LightThemeColors.secondaryText,
                            ).s16.medium,
                            LocaleKeys.auth_have_an_account.tr(),

                            // fontSize: 16,
                            // weight: FontWeight.w600,
                          ),
                          5.ph,
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 10.5),
                            // height: 21,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  Routes.LoginScreen,
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    style: TextStyle(
                                      color: LightThemeColors.textPrimary,
                                    ).s16.bold,
                                    LocaleKeys.auth_back_to_login.tr(),
                                    // fontSize: 16,
                                    // weight: FontWeight.w600,
                                  ),
                                  8.43.pw,
                                  SvgPicture.asset(
                                    width: 17.59,
                                    height: 15.65,
                                    Assets.icons.signArrow,
                                  ),
                                  // 16.19.pw,
                                ],
                              ),
                            ),
                          ),
                          // 117.h.ph,
                          // MultiSelectDropDown<String>(
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.all(
                          //       Radius.circular(33),
                          //     ),
                          //     side: BorderSide(
                          //       width: 1,
                          //       color: LightThemeColors.border,
                          //     ),
                          //   ),
                          //   items: () {
                          //     return ["item1", "item2", "item3", "item4"];
                          //   },
                          //   itemAsString: (p0) {
                          //     return "ashraf";
                          //   },
                          //   onChange: (val) {},
                          // ),
                        ],
                      ),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       CustomText(
                      //         "قم بإدخال بياناتك لأنشاء حساب جديد",
                      //         fontSize: 14,
                      //         color: Colors.black,
                      //         weight: FontWeight.w300,
                      //       ),
                      //       40.ph,
                      //       SvgPicture.asset(
                      //         "register".svg("icons"),
                      //         width: 212,
                      //         height: 212,
                      //       ),
                      //       50.ph,
                      //       TextFormFieldWidget(
                      //         backgroundColor: context.primaryColor.withOpacity(.04),
                      //         // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //         type: TextInputType.name,
                      //         prefixIcon:"assets/icons/user.svg",
                      //         hintText: 'الإسم',
                      //         password: false,
                      //         onSaved: (e) {},
                      //         validator: (v) => Utils.valid.defaultValidation(v),
                      //         controller: name,
                      //         borderRadius: 33,
                      //       ),
                      //       20.ph,
                      //       TextFormFieldWidget(
                      //         backgroundColor: context.primaryColor.withOpacity(.04),
                      //         // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //         type: TextInputType.emailAddress,
                      //            prefixIcon:"assets/icons/user.svg",
                      //         hintText: 'البريد الإلكترونى',
                      //         password: false,
                      //         validator: (v) => Utils.valid.emailValidation(v),
                      //         controller: email,
                      //         borderRadius: 33,
                      //       ),
                      //       20.ph,
                      //       TextFormFieldWidget(
                      //         backgroundColor: context.primaryColor.withOpacity(.04),
                      //         // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //         type: TextInputType.phone,
                      //             prefixIcon:"assets/icons/user.svg",
                      //         hintText: 'رقم الجوال',
                      //         password: false,
                      //         // validator: (v) => Utils.valid.defaultValidation(v),
                      //         controller: phone,
                      //         borderRadius: 33,
                      //       ),
                      //       20.ph,
                      //       TextFormFieldWidget(
                      //         backgroundColor: context.primaryColor.withOpacity(.04),
                      //         // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //         type: TextInputType.visiblePassword,
                      //          prefixIcon:"assets/icons/user.svg",
                      //         hintText: 'كلمة المرور',
                      //         password: true,
                      //         validator: Utils.valid.passwordValidation,
                      //         controller: password,
                      //         borderRadius: 33,
                      //       ),
                      //       20.ph,
                      //       TextFormFieldWidget(
                      //         backgroundColor: context.primaryColor.withOpacity(.04),
                      //         // padding: const EdgeInsets.symmetric(horizontal: 18),
                      //         type: TextInputType.visiblePassword,
                      //         prefixIcon:"assets/icons/user.svg",
                      //         hintText: 'تأكيد كلمة المرور',
                      //         password: true,
                      //         validator: (v) => Utils.valid
                      //             .confirmPasswordValidation(v, password.text),
                      //         controller: confirmPassword,
                      //         borderRadius: 33,
                      //       ),
                      //       30.ph,

                      //       ButtonWidget(
                      //           title: "إنشاء حساب",
                      //           withBorder: true,
                      //           buttonColor: context.primaryColor,
                      //           textColor: Colors.white,
                      //           borderColor: context.primaryColor,
                      //           width: double.infinity,
                      //           // padding: const EdgeInsets.symmetric(horizontal: 15),
                      //           onTap: () async {
                      //             FocusScope.of(context).unfocus();
                      //             AuthRequest registerRequestModel = AuthRequest(
                      //               name: name.text.trim(),
                      //               email: email.text.trim(),
                      //               password: password.text.trim(),
                      //             );
                      //             if (formKey.currentState!.validate()) {
                      //               final response = await cubit.signUp(
                      //                 registerRequestModel: registerRequestModel,
                      //               );
                      //               if (response == true) {
                      //                 // Navigator.pushNamedAndRemoveUntil(
                      //                 //   context,
                      //                 //   Routes.OtpScreen,
                      //                 // (route) => false,
                      //                 //   arguments: OtpArguments(
                      //                 //     sendTo: phone.text,
                      //                 //     onSubmit: (s) async {
                      //                 //       registerRequestModel.code = s;
                      //                 //       final res = await cubit.activate(
                      //                 //           registerRequestModel: registerRequestModel,);
                      //                 //       if (res == true) {
                      //                 //
                      //                 //         Navigator.pushNamedAndRemoveUntil(context, Routes.LayoutScreen, (route) => false);
                      //                 //       }
                      //                 //
                      //                 //     }, onReSend: ()async {
                      //                 //     await cubit.resenCode(
                      //                 //         mobile: registerRequestModel.mobile ?? '');
                      //                 //   }
                      //                 //   )
                      //                 // );
                      //                 // ignore: use_build_context_synchronously

                      //                 // Navigator.pushNamed(
                      //                 //   context,
                      //                 //   Routes.OtpScreen,
                      //                 //   arguments: OtpArguments(
                      //                 //       sendTo: email.text,
                      //                 //       onSubmit: (s) async {
                      //                 //         registerRequestModel.code = s;
                      //                 //         final res = await cubit.activate(
                      //                 //             registerRequestModel:
                      //                 //                 registerRequestModel);

                      //                 //         if (res == true) {
                      //                 //           Navigator.pushNamedAndRemoveUntil(
                      //                 //               context,
                      //                 //               Routes.LayoutScreen,
                      //                 //               (route) => false);
                      //                 //         }
                      //                 //       },
                      //                 //       onReSend: () async {
                      //                 //         await cubit.resendCode(
                      //                 //             registerRequestModel.email ??
                      //                 //                 '');
                      //                 //       },
                      //                 //       init: false),
                      //                 // );
                      //               }
                      //               // if (response['data']['active'] == true) {
                      //               //   // if (response['data']['type'] == 'client') {
                      //               //   await FBMessging.subscribeToTopic();
                      //               //   // }
                      //               //   context.pushNamedAndRemoveUntil(Routes.layout);
                      //               // } else if (response['data']['active'] == false) {
                      //               //   Navigator.pushNamed(
                      //               //     context,
                      //               //     Routes.otp,
                      //               //     arguments: OtpArguments(
                      //               //         sendTo: phone.text,
                      //               //         onSubmit: (s) async {
                      //               //           final res = await cubit.activate(
                      //               //               mobile: phone.text, code: s);
                      //               //           if (res == true) {
                      //               //             await FBMessging.subscribeToTopic();
                      //               //             context.pushNamedAndRemoveUntil(
                      //               //                 Routes.layout);
                      //               //           }
                      //               //         },
                      //               //         onReSend: () async {
                      //               //           await cubit.resendCode(phone.text);
                      //               //         },
                      //               //         init: false),
                      //               //   );
                      //             }
                      //           }),
                      //       20.ph,

                      //       ButtonWidget(
                      //         title: 'الدخول كزائر',
                      //         withBorder: true,
                      //         buttonColor: Colors.white,
                      //         textColor: context.primaryColor,
                      //         borderColor: context.primaryColor,
                      //         width: double.infinity,

                      //         // padding: const EdgeInsets.symmetric(horizontal: 15),
                      //         onTap: () async {
                      //           Navigator.pushNamed(
                      //             context,
                      //             Routes.LayoutScreen,
                      //           );
                      //         },
                      //       ),
                      //       // signupBtn(context),
                      //       20.ph,
                      //     ],
                      //   ),
                    ),
                  ),
                ),
                // Positioned(
                //   right: 0,
                //   left: 0,
                //   // width: double.infinity,
                //   bottom: 0,
                //   child: Container(
                //     color: context.background,
                //     height: 104,
                //     width: double.infinity,
                //     child: SvgPicture.asset(
                //       fit: BoxFit.fill,
                //       "login_bottom".svg("images"),
                //     ),
                //   ),
                // )
              ],
            ),

            bottomNavigationBar: Container(
              color: context.background,
              height: 104,
              width: double.infinity,
              child: SvgPicture.asset(
                fit: BoxFit.cover,
                "login_bottom".svg("images"),
              ),
            ),
          );
        },
      ),
    );
  }
}
