// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/matchdetails/cubit/matchdetails_cubit.dart';
import 'package:remontada/features/matchdetails/cubit/matchdetails_states.dart';
import 'package:remontada/shared/widgets/autocomplate.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/resources/gen/assets.gen.dart';
import '../../../../core/services/alerts.dart';
import '../../../../shared/back_widget.dart';
import '../../../../shared/widgets/customtext.dart';
import '../../../../shared/widgets/network_image.dart';
import '../widgets/item_bottomshet.dart';

class PlayersScreenSupervisor extends StatefulWidget {
  const PlayersScreenSupervisor({
    super.key,
    this.id,
  });
  final String? id;

  @override
  State<PlayersScreenSupervisor> createState() =>
      _PlayersScreenSupervisorState();
}

class _PlayersScreenSupervisorState extends State<PlayersScreenSupervisor> {
  SubScribersModel subScribersModel = SubScribersModel();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MatchDetailsCubit()..getSubscribers(widget.id ?? "", isloading: true),
      child: BlocConsumer<MatchDetailsCubit, MatchDetailsState>(
        listener: (context, state) {
          if (state is MatchDetailsLoaded) {
            subScribersModel = state.subScribers;
          }
          if (state is RefreshState) {
            MatchDetailsCubit.get(context)
                .getSubscribers(widget.id ?? "", isloading: false);
          }
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            body: LoadingAndError(
              isLoading: state is SubScribersLoading,
              isError: state is SubScribersFailed,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CustomText(
                                  "المشتركين",
                                  style: TextStyle(
                                    color: context.primaryColor,
                                  ).s24.heavy,
                                  // fontSize: 26,
                                  // weight: FontWeight.bold,
                                  // color: context.colorScheme.primary,
                                ),
                                10.ph,
                                CustomText(
                                  "قائمة المشتركين لتحديد الحضور",
                                  style: TextStyle(
                                    color: LightThemeColors.textSecondary,
                                  ).s14.light,
                                  // fontSize: 26,
                                  // weight: FontWeight.bold,
                                  // color: context.colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 12,
                            // bottom: 0,
                            child: BackWidget(),
                          ),
                        ],
                      ),
                      35.ph,
                      if (subScribersModel.subscribers
                              ?.where((e) => e.presence == false)
                              .length !=
                          0)
                        Align(
                          alignment: Alignment.topRight,
                          child: CustomText(
                            "في انتظار التأكيد",
                            color: LightThemeColors.surface,
                            fontSize: 20,
                            weight: FontWeight.w600,
                          ),
                        ),
                      25.ph,
                      ...List.generate(
                          subScribersModel.subscribers
                                  ?.where((e) => e.presence == false)
                                  .length ??
                              0, (i) {
                        final player = subScribersModel.subscribers
                            ?.where((e) => e.presence == false)
                            .toList()[i];
                        return PlayerBottomSheet(
                          subscriber: player,
                          endIcon: ButtonWidget(
                            height: 45,
                            onTap: () => showApsencesheet(
                              context,
                              player,
                              (val) => MatchDetailsCubit.get(context).apcense(
                                id: player?.id.toString(),
                                paymentMethod: val,
                              ),
                            ),
                            radius: 33,
                            // width: 60,
                            title: "تأكيد اللاعب",
                          ),
                        );
                      }),
                      20.ph,
                      if (subScribersModel.subscribers
                              ?.where((e) => e.presence == true)
                              .length !=
                          0)
                        Align(
                          alignment: Alignment.topRight,
                          child: CustomText(
                            "تم تاكيد حضورهم",
                            color: Colors.green,
                            fontSize: 20,
                            weight: FontWeight.w600,
                          ),
                        ),
                      25.ph,
                      ...List.generate(
                          subScribersModel.subscribers
                                  ?.where((e) => e.presence == true)
                                  .length ??
                              0, (i) {
                        final player = subScribersModel.subscribers
                            ?.where((e) => e.presence == true)
                            .toList()[i];
                        return PlayerBottomSheet(
                          subscriber: player,
                          // endIcon: ButtonWidget(
                          //   height: 45,
                          //   radius: 33,
                          //   // width: 60,
                          //   title: "تأكيد اللاعب",
                          // ),
                        );
                      })
                    ],
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

showApsencesheet(
  BuildContext context,
  Subscriber? subscriber,
  Function(String? mthod)? appsence,
) {
  String method = "";
  Alerts.bottomSheet(
    // height: 623.h,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(114),
        topRight: Radius.circular(36),
      ),
    ),
    context,
    child: Container(
      width: double.infinity,
      height: 400,
      padding: EdgeInsets.only(
        right: 18,
        left: 18,
        top: 50,
        // bottom: 24.h,
      ),
      decoration: BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(
            "تأكيد اللاعب",
            weight: FontWeight.w700,
            fontSize: 18,
            color: context.primaryColor,
          ),
          CustomText(
            "قم بتأكيد حضور هذا اللاعب",
            weight: FontWeight.w500,
            fontSize: 16,
            color: LightThemeColors.textSecondary,
          ),
          15.ph,
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: context.background,
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 0),
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 30,
                    ),
                  ],
                ),
                child: subscriber?.image != null && subscriber?.image != ""
                    ? ClipOval(
                        child: NetworkImagesWidgets(
                          fit: BoxFit.cover,
                          subscriber?.image ?? "",
                        ),
                      )
                    : Assets.images.profile_image.image(
                        fit: BoxFit.cover,
                      ),
              ),
              10.pw,
              Column(
                children: [
                  CustomText(
                    subscriber?.name ?? "",
                    color: LightThemeColors.black,
                    weight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  10.ph,
                  Row(
                    children: [
                      SvgPicture.asset(
                        "play_location".svg(),
                      ),
                      5.pw,
                      CustomText(
                        color: LightThemeColors.textPrimary,
                        fontSize: 14,
                        weight: FontWeight.w600,
                        "${subscriber?.location ?? ""}",
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          16.ph,
          CustomAutoCompleteTextField<PaymentMethod>(
            // prefixIcon: SvgPicture.asset(
            //   "cleander_button".svg(),
            // ),
            hint: "تحديد طريقة الدفع",
            itemAsString: (p0) => p0.key ?? "",
            showSufix: true,
            onChanged: (val) {
              method = val.value ?? "";
            },
            function: (val) => [
              PaymentMethod(key: "كاش", value: "cash"),
              PaymentMethod(key: "كوبون", value: "coupon"),
              PaymentMethod(key: "سيجنال", value: "sigenal"),
            ],
          ),
          10.ph,
          ButtonWidget(
            onTap: () {
              Navigator.pop(context);
              appsence?.call(
                method,
              );
            },
            radius: 33,
            title: LocaleKeys.confirm.tr(),
          )
        ],
      ),
    ),
  );
}

class PaymentMethod {
  String? value;
  String? key;
  PaymentMethod({
    this.value,
    this.key,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'value': value,
      'key': key,
    };
  }

  factory PaymentMethod.fromMap(Map<String, dynamic> map) {
    return PaymentMethod(
      value: map['value'] != null ? map['value'] as String : null,
      key: map['key'] != null ? map['key'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PaymentMethod.fromJson(String source) =>
      PaymentMethod.fromMap(json.decode(source) as Map<String, dynamic>);
}
