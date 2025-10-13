import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_cubit.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_states.dart';
import '../../../../core/services/app_events.dart';
import 'package:remontada/shared/back_widget.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/Router/Router.dart';
// ...existing imports...
import '../../../../shared/widgets/autocomplate.dart';
import '../../../../shared/widgets/dropdown.dart';
import '../../../../shared/widgets/edit_text_widget.dart';
import '../../../auth/domain/model/auth_model.dart';
import '../../../auth/domain/repository/auth_repository.dart';
import '../../../home/domain/model/home_model.dart';

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
  TextEditingController matchType = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController peroid = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();
  bool _isCompetitive = false; // local UI state: true => competitive, false => friendly
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyMatchesCubit()
        ..getMatchDetails(widget.id ?? "", makeRequest: widget.id != null),
      child: BlocConsumer<MyMatchesCubit, MyMatchesState>(
        listener: (context, state) {
          if (state is CreateMatchSuccess) {
            // Notify other screens to refresh (matches listing)
            try {
              AppEvents.matchesRefresh.value++;
            } catch (_) {}
            Navigator.pushNamedAndRemoveUntil(
              context,
              Routes.LayoutScreen,
              (r) => false,
            );
          } else if (state is CreateMatchFailed) {
            // Show error if Cubit emits failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("فشل في إضافة الفترة. حاول مرة أخرى.")),
            );
          }
          if (state is MatchDetailsLoaded) {
            matchModel = state.matchModel;
            MyMatchesCubit.get(context).request.playgroundId =
                state.matchModel.playground_id.toString();
            playgroundcontroller.text = matchModel.playGround ?? "";
            matchType.text = () {
              switch (matchModel.type) {
                case "group":
                  return "مباراة جماعية";
                case "single":
                  return "مباراة فردية";
                case "challenge":
                  return "مبارة تحدى";
                default:
                  return matchModel.type ?? "";
              }
            }();
            MyMatchesCubit.get(context).request.type = matchModel.type;
            date.text = matchModel.dateDate?.date ?? "";
            number.text = matchModel.subscribers?.split("/").last ?? "";
            peroid.text = matchModel.duration?.toString() ?? "";
            text.text = matchModel.durations_text ?? "";
            price.text = (matchModel.amount ?? "").replaceAll(
              "ر.س",
              "",
            );
            description.text = matchModel.details ?? "";
            startTime.text = matchModel.dateDate?.start_time ?? "";
            endTime.text = matchModel.dateDate?.end_time ?? "";
            final nextIsCompetitive = matchModel.isCompetitive ?? false;
            if (mounted) {
              setState(() {
                _isCompetitive = nextIsCompetitive;
              });
            } else {
              _isCompetitive = nextIsCompetitive;
            }
      MyMatchesCubit.get(context).request.isCompetitive =
        _isCompetitive ? 1 : 0;
          }
        },
        builder: (context, state) {
          final cubit = MyMatchesCubit.get(context);
          cubit.request.isCompetitive ??= _isCompetitive ? 1 : 0;
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
                        SizedBox(height: 40),
                        DropDownItem<String>(
                          options: const ['group', 'single', 'challenge'],
                          inistialValue: cubit.request.type,
                          hint: 'نوع المباراة',
                          prefixIcon: 'playground_button',
                          radius: 33,
                          color: context.formFieldColor,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20,
                          ),
                          hintColor: LightThemeColors.textPrimary,
                          itemAsString: (v) {
                            switch (v) {
                              case 'group':
                                return 'مباراة جماعية';
                              case 'single':
                                return 'مباراة فردية';
                              case 'challenge':
                                return 'مبارة تحدى';
                              default:
                                return v.toString();
                            }
                          },
                          validator: (v) => (v == null || v.isEmpty)
                              ? LocaleKeys.valid_requiredField.tr()
                              : null,
                          onChanged: (val) {
                            setState(() {
                              matchType.text = val;
                              cubit.request.type = val;
                            });
                          },
                        ),
                        SizedBox(height: 12),
                        CustomAutoCompleteTextField<Location>(
                          controller: playgroundcontroller,
                          padding: const EdgeInsets.only(bottom: 20),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.only(
                              right: 35,
                              left: 9.76,
                            ),
                            child: SvgPicture.asset(
                              "playground_button".svg(),
                            ),
                          ),
                          hint: "اختر الملعب",
                          function: (p0) async {
                            final repo = locator<AuthRepository>();
                            final result = await repo.getPlaygrounds();
                            return result?.playgrounds ?? [];
                          },
                          itemAsString: (p0) => p0.name ?? "",
                          localData: true,
                          showLabel: false,
                          showSufix: true,
                          onChanged: (val) {
                            cubit.request.playgroundId = val.id.toString();
                          },
                        ),
                        SizedBox(height: 12),
                        TextFormFieldWidget(
                          readOnly: true,
                          onTap: () {
                            showDatePicker(
                              context: context,
                              firstDate: DateTime(
                                DateTime.now().year,
                              ),
                              lastDate: DateTime(
                                DateTime.now().year + 100,
                              ),
                              locale: Locale('ar', 'EG'),
                            ).then(
                              (pickedDate) {
                                date.text =
                                    DateFormat('yyyy-MM-dd', 'en_US').format(
                                  pickedDate ?? DateTime.now(),
                                );
                              },
                            );
                            setState(() {});
                          },
                          controller: date,
                          onSaved: (value) {
                            cubit.request.date = value;
                          },
                          validator: Utils.valid.defaultValidation,
                          prefixIcon: "clender".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "تاريخ المباراة",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        SizedBox(height: 12),
                        TextFormFieldWidget(
                          controller: number,
                          type: TextInputType.number,
                          onSaved: (value) {
                            cubit.request.subscribers_quantity = value;
                          }, // register.email = value,
                          // controller: email,
                          validator: (value) {
                            if (value?.isEmpty == true) {
                              return LocaleKeys.valid_requiredField.tr();
                            }
                            if (int.parse(value ?? "0") > 30) {
                              return "لا يمكن ان يكون عدد المشتركين اكبر من 30";
                            }

                            return null;
                          },
                          // Utils.valid.defaultValidation,
                          prefixIcon: "clender".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "عدد المشتركين",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        SizedBox(height: 12),
                        TextFormFieldWidget(
                          controller: startTime,
                          readOnly: true,
                          validator: Utils.valid.defaultValidation,
                          onTap: () async {
                            final value = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (value != null) {
                              final minute = value.minute.toString().padLeft(2, '0');
                              startTime.text = '${value.hour}:$minute';
                              cubit.request.statrtTime = startTime.text;
                            }
                          },
                          onSaved: (value) => cubit.request.statrtTime = value,
                          prefixIcon: "clock".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "وقت البداية",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        SizedBox(height: 12),
                        TextFormFieldWidget(
                          controller: endTime,
                          readOnly: true,
                          validator: Utils.valid.defaultValidation,
                          onTap: () async {
                            final value = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (value != null) {
                              final minute = value.minute.toString().padLeft(2, '0');
                              endTime.text = '${value.hour}:$minute';
                              cubit.request.endTime = endTime.text;
                            }
                          },
                          onSaved: (value) => cubit.request.endTime = value,
                          prefixIcon: "clock".svg(),
                          hintSize: 16,
                          borderRadius: 33,
                          hintText: "وقت النهاية",
                          hintColor: LightThemeColors.textPrimary,
                          activeBorderColor: LightThemeColors.inputFieldBorder,
                        ),
                        SizedBox(height: 12),
                        TextFormFieldWidget(
                          controller: peroid,
                          type: TextInputType.number,
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
                        SizedBox(height: 12),
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
                        SizedBox(height: 12),
                        TextFormFieldWidget(
                          controller: price,
                          type: TextInputType.number,
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
                        SizedBox(height: 12),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              LocaleKeys.create_match_is_competitive.tr(),
                              fontSize: 16,
                              weight: FontWeight.w600,
                              color: context.primaryColor,
                            ),
                            Switch(
                              value: _isCompetitive,
                              onChanged: (val) {
                                setState(() {
                                  _isCompetitive = val;
                                });
                                cubit.request.isCompetitive = val ? 1 : 0;
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Builder(
                          builder: (context) {
                            final cubit = MyMatchesCubit.get(context);
                            final isLoading = state is CreateMatchLoading;
                            return ButtonWidget(
                              onTap: isLoading
                                  ? null
                                  : () async {
                                      if (cubit.formKey.currentState!.validate()) {
                                        cubit.formKey.currentState?.save();
                                        cubit.request.isCompetitive = _isCompetitive ? 1 : 0;
                                        if (widget.id != null) {
                                          cubit.request.isUpdate = true;
                                        }
                                        try {
                                          print('\n[CreateMatchScreen] Submitting request: ' + cubit.request.toMap().toString());
                                        } catch (_) {
                                          print('[CreateMatchScreen] Submitting request: ' + cubit.request.toString());
                                        }
                                        print('[CreateMatchScreen] Calling cubit.createMatches(id: ${widget.id ?? matchModel.id})');
                                        bool stateChanged = false;
                                        final subscription = cubit.stream.listen((state) {
                                          if (state is CreateMatchSuccess || state is CreateMatchFailed) {
                                            stateChanged = true;
                                          }
                                        });
                                        cubit.createMatches(
                                          id: widget.id ?? matchModel.id?.toString(),
                                        );
                                        await Future.delayed(const Duration(seconds: 2));
                                        await subscription.cancel();
                                        if (!stateChanged && mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("لم يتم إرسال الطلب. تحقق من الاتصال أو أعد المحاولة.")),
                                          );
                                        }
                                      }
                                    },
                              radius: 33,
                              title: isLoading
                                  ? "جاري الحفظ..."
                                  : (widget.id != null ? "تحديث الفترة" : "إضافة الفترة"),
                              buttonColor: isLoading ? Colors.grey : null,
                            );
                          },
                        ),
                        SizedBox(height: 20),
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
