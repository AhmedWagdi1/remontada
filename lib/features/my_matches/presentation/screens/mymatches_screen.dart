import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/presentation/widgets/itemwidget.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_cubit.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_states.dart';
import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';

import '../../../../core/resources/gen/assets.gen.dart';

class MyMatchesScreen extends StatefulWidget {
  const MyMatchesScreen({super.key});

  @override
  State<MyMatchesScreen> createState() => _MyMatchesScreenState();
}

class _MyMatchesScreenState extends State<MyMatchesScreen> {
  MyMatches myMatches = MyMatches();
  bool thereData = true;
  Widget getnoMatchesBody() {
    return Container(
      width: double.infinity,
      child: Stack(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              70.ph,
              CustomText(
                LocaleKeys.my_matches.tr(),
                fontSize: 28,
                weight: FontWeight.w800,
                color: context.primaryColor,
              ),
              5.ph,
              CustomText(
                fontSize: 16,
                weight: FontWeight.w500,
                LocaleKeys.my_matches_subtitles.tr(),
                color: LightThemeColors.secondaryText,
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.images.no_matches.image(
                width: 124.0,
                height: 90,
              ),
              20.ph,
              CustomText(
                LocaleKeys.no_matches.tr(),
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
              4.ph,
              CustomText(
                LocaleKeys.havnot_matches.tr(),
                fontSize: 16,
                weight: FontWeight.w500,
                color: LightThemeColors.secondaryText,
              ),
            ],
          ),
          1.ph,
        ],
      ),
    );
  }

  getMatchesBody(MyMatches myMatches) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          70.ph,
          CustomText(
            LocaleKeys.my_matches.tr(),
            fontSize: 26,
            weight: FontWeight.w800,
            color: context.primaryColor,
          ),
          5.ph,
          CustomText(
            fontSize: 14,
            weight: FontWeight.w500,
            LocaleKeys.my_matches_subtitles.tr(),
            color: LightThemeColors.secondaryText,
          ),
          30.ph,
          Expanded(
            child: ListView.builder(
              itemCount: myMatches.matches?.length ?? 0,
              itemBuilder: (context, index) => ItemWidget(
                
                matchModel: myMatches.matches?[index],
                ismymatch: true,
              ),
            ),
          ),
          SizedBox(
            height: 129.29,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      // AppBar(
      //   leading: SizedBox(),
      //   title: CustomText(
      //     "مبارياتي",
      //     fontSize: 26.sp,
      //     weight: FontWeight.w800,
      //     color: context.primaryColor,
      //   ),
      // ),
      body: BlocProvider(
          create: (context) => MyMatchesCubit()..getMymatches(),
          child: BlocConsumer<MyMatchesCubit, MyMatchesState>(
            listener: (context, state) {
              if (state is MyMatchesLoaded) myMatches = state.mymatches;
            },
            builder: (context, state) {
              return LoadingAndError(
                isLoading: state is MyMatchesLoading,
                isError: state is MyMatchesFailed,
                child: myMatches.matches?.isNotEmpty ?? false
                    ? getMatchesBody(myMatches)
                    : getnoMatchesBody(),
              );
            },
          )),
    );
  }
}
