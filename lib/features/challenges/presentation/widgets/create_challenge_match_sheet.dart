import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';

import 'package:remontada/features/my_matches/cubit/myMatches_cubit.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_states.dart';
import '../../../../core/services/app_events.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/dropdown.dart';
import 'package:remontada/shared/widgets/edit_text_widget.dart';
import 'package:remontada/shared/widgets/autocomplate.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';

import '../../../home/domain/model/home_model.dart';
import '../../../home/cubit/home_cubit.dart';

class CreateChallengeMatchSheet extends StatefulWidget {
  const CreateChallengeMatchSheet({super.key});

  @override
  State<CreateChallengeMatchSheet> createState() => _CreateChallengeMatchSheetState();
}

class _CreateChallengeMatchSheetState extends State<CreateChallengeMatchSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  TextEditingController playgroundcontroller = TextEditingController();
  TextEditingController date = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();
  TextEditingController period = TextEditingController();
  TextEditingController text = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MyMatchesCubit(),
      child: BlocConsumer<MyMatchesCubit, MyMatchesState>(
        listener: (context, state) {
          if (state is CreateMatchSuccess) {
            Navigator.pop(context);
            // Notify other parts of the app to refresh matches listings
            try {
              AppEvents.matchesRefresh.value++;
            } catch (_) {}
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم إنشاء مباراة التحدي بنجاح'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = MyMatchesCubit.get(context);
          
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: LightThemeColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.close,
                          color: LightThemeColors.primary,
                        ),
                      ),
                    ),
                    16.pw,
                    CustomText(
                      'إضافة فترة لماتش تحدى جديد',
                      fontSize: 18,
                      weight: FontWeight.bold,
                      color: LightThemeColors.primary,
                    ),
                  ],
                ),
                24.ph,
                
                // Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Match Type Dropdown (only challenge)
                          DropDownItem<String>(
                            options: const ['challenge'],
                            inistialValue: 'challenge',
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
                              return 'تحدي';
                            },
                            validator: (v) => (v == null || v.isEmpty)
                                ? LocaleKeys.valid_requiredField.tr()
                                : null,
                            onChanged: (val) {
                              cubit.request.type = val;
                            },
                          ),
                          12.ph,
                          
                          // Playground Selection
                          CustomAutoCompleteTextField<PlayGroundModel>(
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
                              final homeCubit = HomeCubit();
                              final playgrounds = await homeCubit.getplayground();
                              return playgrounds?.playgrounds ?? [];
                            },
                            itemAsString: (p0) => p0.name ?? "",
                            localData: true,
                            showLabel: false,
                            showSufix: true,
                            onChanged: (val) {
                              cubit.request.playgroundId = val.id?.toString();
                            },
                          ),
                          12.ph,
                          
                          // Date
                          TextFormFieldWidget(
                            readOnly: true,
                            onTap: () async {
                              final pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                              );
                              if (pickedDate != null) {
                                date.text = DateFormat('yyyy-MM-dd', 'en_US').format(pickedDate);
                              }
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
                          12.ph,
                          
                          // Number of subscribers
                          TextFormFieldWidget(
                            controller: number,
                            type: TextInputType.number,
                            onSaved: (value) {
                              cubit.request.subscribers_quantity = value;
                            },
                            validator: (value) {
                              if (value?.isEmpty == true) {
                                return LocaleKeys.valid_requiredField.tr();
                              }
                              if (int.parse(value ?? "0") > 30) {
                                return "لا يمكن ان يكون عدد المشتركين اكبر من 30";
                              }
                              return null;
                            },
                            prefixIcon: "clender".svg(),
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: "عدد المشتركين",
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor: LightThemeColors.inputFieldBorder,
                          ),
                          12.ph,
                          
                          // Start Time
                          TextFormFieldWidget(
                            readOnly: true,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                if (value != null) {
                                  String minute = value.minute.toString().length == 1
                                      ? "0${value.minute}"
                                      : value.minute.toString();
                                  startTime.text = "${value.hour}:$minute";
                                }
                              });
                            },
                            onSaved: (value) => cubit.request.statrtTime = value,
                            controller: startTime,
                            validator: Utils.valid.defaultValidation,
                            prefixIcon: "clock".svg(),
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: "بداية الفترة",
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor: LightThemeColors.inputFieldBorder,
                          ),
                          12.ph,
                          
                          // End Time
                          TextFormFieldWidget(
                            readOnly: true,
                            onTap: () {
                              showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now(),
                              ).then((value) {
                                if (value != null) {
                                  String minute = value.minute.toString().length == 1
                                      ? "0${value.minute}"
                                      : value.minute.toString();
                                  endTime.text = "${value.hour}:$minute";
                                }
                              });
                            },
                            onSaved: (value) => cubit.request.endTime = value,
                            controller: endTime,
                            validator: Utils.valid.defaultValidation,
                            prefixIcon: "clock".svg(),
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: "نهاية الفترة",
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor: LightThemeColors.inputFieldBorder,
                          ),
                          12.ph,
                          
                          // Duration
                          TextFormFieldWidget(
                            controller: period,
                            type: TextInputType.number,
                            onSaved: (value) {
                              cubit.request.duration = value;
                            },
                            validator: Utils.valid.defaultValidation,
                            prefixIcon: "clock".svg(),
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: "مدة المباراة",
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor: LightThemeColors.inputFieldBorder,
                          ),
                          12.ph,
                          
                          // Duration Text
                          TextFormFieldWidget(
                            controller: text,
                            onSaved: (value) {
                              cubit.request.durationTetx = value;
                            },
                            validator: Utils.valid.defaultValidation,
                            prefixIcon: "clock".svg(),
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: "نص المدة",
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor: LightThemeColors.inputFieldBorder,
                          ),
                          12.ph,
                          
                          // Price
                          TextFormFieldWidget(
                            controller: price,
                            type: TextInputType.number,
                            onSaved: (value) {
                              cubit.request.amount = value;
                            },
                            validator: Utils.valid.defaultValidation,
                            prefixIcon: "wallet".svg(),
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: "السعر للفرد",
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor: LightThemeColors.inputFieldBorder,
                          ),
                          12.ph,
                          
                          // Description
                          TextFormFieldWidget(
                            controller: description,
                            maxLines: 6,
                            minLines: 6,
                            onSaved: (value) {
                              cubit.request.details = value;
                            },
                            validator: Utils.valid.defaultValidation,
                            hintSize: 16,
                            borderRadius: 33,
                            hintText: "اضافة تفاصيل نصية",
                            hintColor: LightThemeColors.textPrimary,
                            activeBorderColor: LightThemeColors.inputFieldBorder,
                          ),
                          20.ph,
                          
                          // Submit Button
                          ButtonWidget(
                            onTap: state is CreateMatchLoading
                                ? null
                                : () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState?.save();
                                      // Debug: print request before submission
                                      try {
                                        print('\n[CreateChallengeMatchSheet] Submitting request: ' + cubit.request.toMap().toString());
                                      } catch (_) {
                                        print('[CreateChallengeMatchSheet] Submitting request: ' + cubit.request.toString());
                                      }
                                      print('[CreateChallengeMatchSheet] Calling cubit.createMatches()');
                                      cubit.createMatches();
                                    }
                                  },
                            radius: 33,
                            title: state is CreateMatchLoading
                                ? "جاري الإنشاء..."
                                : "إنشاء مباراة التحدي",
                            buttonColor: state is CreateMatchLoading
                                ? Colors.grey
                                : LightThemeColors.primary,
                          ),
                          20.ph,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}