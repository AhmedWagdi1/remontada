import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/player_details/cubit/player_details_cubit.dart';
import 'package:remontada/features/player_details/cubit/player_details_states.dart';
import 'package:remontada/features/player_details/presentation/widgets/item_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/loadinganderror.dart';
import 'package:remontada/shared/widgets/network_image.dart';

import '../../../../core/Router/Router.dart';
import '../../../../shared/back_widget.dart';

class PlayerDetails extends StatefulWidget {
  final String? id;
  const PlayerDetails({
    super.key,
    this.id,
  });

  @override
  State<PlayerDetails> createState() => _PlayerDetailsState();
}

class _PlayerDetailsState extends State<PlayerDetails> {
  Subscriber? playerdetails;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PlayerDetailsCubit()..getPlayerDetails(widget.id ?? ""),
      child: BlocConsumer<PlayerDetailsCubit, PlayerDetailsState>(
        listener: (context, state) {
          if (state is PlayerDetailsLoaded) playerdetails = state.playerdetails;
        },
        builder: (context, state) {
          return Scaffold(
            // appBar: CustomAppbar(
            //   title: "تفاصيل اللاعب",
            // ),
            body: LoadingAndError(
              isError: state is PlayerDetailsFailed,
              isLoading: state is PlayerDetailsLoading,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                      ),
                      width: double.infinity,
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
                                  LocaleKeys.player_details.tr(),
                                  style: TextStyle(
                                    color: context.primaryColor,
                                  ).s26.heavy,
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
                          CustomText(
                            style: TextStyle(
                              color: LightThemeColors.secondaryText,
                            ).s16.medium,
                            LocaleKeys.player_details_sub.tr(),
                            // fontSize: 14.sp,
                            // weight: FontWeight.w500,
                          ),
                          28.ph,
                          Container(
                            width: 80,
                            height: 80,
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
                            child: playerdetails?.image != null &&
                                    playerdetails?.image != ""
                                ? ClipOval(
                                    child: NetworkImagesWidgets(
                                      fit: BoxFit.cover,
                                      playerdetails?.image ?? "",
                                    ),
                                  )
                                : Assets.images.profile_image
                                    .image(fit: BoxFit.cover),
                          ),
                          13.ph,
                          CustomText(
                            playerdetails?.name ?? "",
                            fontSize: 20,
                            weight: FontWeight.w600,
                            color: LightThemeColors.black,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                color: context.primaryColor,
                                Assets.icons.playLocation,
                              ),
                              5.27.pw,
                              CustomText(
                                playerdetails?.location ?? "",
                                fontSize: 18,
                                weight: FontWeight.w500,
                                color: context.primaryColor,
                              ),
                            ],
                          ),
                          38.ph,
                          // PlayerDetailsWidget(
                          //   function: () {
                          //     // LauncherHelper.makeCall(
                          //     //     playerdetails?.phone ?? "");
                          //   },
                          //   icon: Assets.icons.calling,
                          //   title: LocaleKeys.auth_hint_phone.tr(),
                          //   subtitle: playerdetails?.phone ?? "",
                          // ),
                          PlayerDetailsWidget(
                            function: () {
                              Navigator.pushNamed(context, Routes.MapScreen,
                                  arguments: PositionArgs("", ""));
                            },
                            icon: Assets.icons.fieldLocation,
                            title: LocaleKeys.city.tr(),
                            subtitle: playerdetails?.city ?? "",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Container(
              color: context.background,
              height: 104,
              width: double.infinity,
              child: SvgPicture.asset(
                fit: BoxFit.fill,
                "login_bottom".svg("images"),
              ),
            ),
          );
        },
      ),
    );
  }
}
