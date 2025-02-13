import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_cubit.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_states.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../auth/domain/model/auth_model.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../home/domain/model/home_model.dart';
import '../widgets/hour_filed_widget.dart';

class CreateMatchScreen extends StatefulWidget {
  const CreateMatchScreen({
    super.key,
    this.id,
  });
  final String? id;
  @override
  State<CreateMatchScreen> createState() => _CreateMatchScreenState();
}

class _CreateMatchScreenState extends State<CreateMatchScreen> {
  MatchModel matchModel = MatchModel();
  TextEditingController playgroundcontroller = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController peroid = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyMatchesCubit()
        ..getMatchDetails(widget.id ?? "", makeRequest: widget.id != null),
      child: BlocConsumer<MyMatchesCubit, MyMatchesState>(
        listener: (context, state) {
          if (state is MatchDetailsLoaded) {
            matchModel = state.matchModel;
            playgroundcontroller.text = matchModel.playGround ?? "";
            date.text = matchModel.date ?? "";
            number.text = matchModel.subscribers?.split("/").last ?? "";
            peroid.text = matchModel.duration ?? "";
            text.text = matchModel.durations_text ?? "";
            price.text = (matchModel.amount ?? "").replaceAll(
              "ر.س",
              "",
            );
            description.text = matchModel.details ?? "";
            // MyMatchesCubit.get(context).request.playgroundId = matchModel.pla;
          }
        },
        builder: (context, state) {
          final cubit = MyMatchesCubit.get(context);
          return LoadingAndError(
            isLoading: state is MatchDetailsLoading,
            isError: state is MatchDetailsFailed,
            child: Scaffold(
              appBar: AppBar(
                leading: Transform.scale(
                  scale: .5,
                  child: BackWidget(),
                ),
                title: CustomText(
                  widget.id != null ? "تعديل الفترة" : "إضافة فترة جديدة",
                  color: context.primaryColor,
                  fontSize: 22,
                  weight: FontWeight.w700,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: cubit.formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomText(
                          widget.id != null
                              ? ""
                              : "قم بإضافة معلومات فترة جديدة",
                          fontSize: 16,
                          color: LightThemeColors.textSecondary,
                        ),
                        40.ph,
                        CustomAutoCompleteTextField<Location>(
                          controller: playgroundcontroller,
                          // contentPadding: EdgeInsets.only(
                          //   bottom: 20,
                          // ),
                          padding: EdgeInsets.only(
                            bottom: 20,
                          ),
                          // controller: location,
                          validator: Utils.valid.defaultValidation,

                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: 35,
                              left: 9.76,
                            ),
                            child: SvgPicture.asset(
                              "playground_button".svg(),
                            ),
                          ),
                          // c: context.primaryColor,
                          hint: "اختر الملعب",
                          function: (p0) async {
                            return (await locator<AuthRepository>()
                                        .getPlaygrounds())
                                    ?.playgrounds ??
                                [];
                          },
                          itemAsString: (p0) => p0.name ?? "",
                          localData: true,
                          showLabel: false,
                          showSufix: true,
                          // radius: 33,
                          // options: List.generate(cubit.getlocations()., (index) => null),
                          onChanged: (val) {
                            cubit.request.playgroundId = val.id.toString();
                            // edit.locationId = val.id;
                          },
                        ),
                        TextFormFieldWidget(
                          controller: date,
                          onSaved: (value) {
                            cubit.request.date = value;
                          }, // register.email = value,
                          // controller: email,
                          validator: Utils.valid.defaultValidation,
                          prefixIcon: "clender".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "تاريخ المباراة",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        12.ph,
                        TextFormFieldWidget(
                          controller: number,

                          onSaved: (value) {
                            cubit.request.subscribers_quantity = value;
                          }, // register.email = value,
                          // controller: email,
                          validator: Utils.valid.defaultValidation,
                          prefixIcon: "clender".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "عدد المشتركين",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        12.ph,
                        HpurFieldWidget(
                          title: "بداية الفترة",
                          onTimeChanged: (hour, minute) {
                            cubit.request.statrtTime = "$hour:$minute";
                          },
                        ),
                        12.ph,
                        HpurFieldWidget(
                          title: "نهاية الفترة",
                          onTimeChanged: (hour, minute) {
                            cubit.request.endTime = "$hour:$minute";
                          },
                        ),
                        // TextFormFieldWidget(
                        //   onSaved: (value) {
                        //     cubit.request.date = value;
                        //   }, // register.email = value,
                        //   // controller: email,
                        //   validator: Utils.valid.emailValidation,
                        //   prefixIcon: "clender".svg(),
                        //   hintSize: 16,
                        //   borderRadius: 33,
                        //   hintText: "توقيت المباراة",
                        //   hintColor: LightThemeColors.textPrimary,
                        //   activeBorderColor: LightThemeColors.inputFieldBorder,
                        // ),
                        12.ph,
                        TextFormFieldWidget(
                          controller: peroid,

                          onSaved: (value) {
                            cubit.request.duration = value;
                          }, // register.email = value,
                          // controller: email,
                          validator: Utils.valid.defaultValidation,
                          prefixIcon: "clock".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "مدة المباراة",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        12.ph,
                        TextFormFieldWidget(
                          controller: text,

                          onSaved: (value) {
                            cubit.request.durationTetx = value;
                          }, // register.email = value,
                          // controller: email,
                          validator: Utils.valid.defaultValidation,
                          prefixIcon: "clock".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "نص المدة",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        12.ph,
                        TextFormFieldWidget(
                          controller: price,

                          onSaved: (value) {
                            cubit.request.amount = value;
                          }, // register.email = value,
                          // controller: email,
                          validator: Utils.valid.defaultValidation,
                          prefixIcon: "wallet".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "السعر للفرد",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        12.ph,
                        TextFormFieldWidget(
                          controller: description,

                          maxLines: 6,
                          minLines: 6,
                          onSaved: (value) {
                            cubit.request.details = value;
                          }, // register.email = value,
                          // controller: email,
                          validator: Utils.valid.defaultValidation,
                          // prefixIcon: Assets.icons.email,
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "اضافة تفاصيل نصية",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        20.ph,
                        ButtonWidget(
                          onTap: () {
                            if (cubit.formKey.currentState!.validate()) {
                              cubit.formKey.currentState?.save();
                              if (widget.id != null) {
                                cubit.request.isUpdate = true;
                              }
                              cubit.createMatches(
                                id: matchModel.id.toString(),
                              );
                            }
                          },
                          radius: 33,
                          title: "إضافة الفترة",
                        ),
                        20.ph,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
