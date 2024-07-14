import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';
import 'package:remontada/features/player_details/presentation/widgets/item_widget.dart';
import 'package:remontada/features/profile/cubit/edit_states.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/shared/widgets/network_image.dart';

import '../../../../shared/back_widget.dart';
import '../../cubit/edit_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user = Utils.user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditCubit(),
      child: BlocConsumer<EditCubit, EditState>(
        listener: (context, state) {
          if (state is ProfileLoaded) user = state.user;
        },
        builder: (context, state) {
          final cubit = EditCubit.get(context);
          return Scaffold(
            // appBar: CustomAppbar(
            //   title: "الملف الشخصي",
            // ),
            body: Stack(
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
                                LocaleKeys.profile.tr(),
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
                          "showing_profile_details".tr(),
                          fontSize: 16,
                          weight: FontWeight.w500,
                          color: LightThemeColors.secondaryText,
                        ),
                        28.ph,
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.background,
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(0, 0),
                                color: Colors.black.withOpacity(.15),
                                blurRadius: 30,
                              ),
                            ],
                          ),
                          child:
                              user.user?.image != null && user.user?.image != ''
                                  ? ClipOval(
                                      // clipBehavior: Clip.hardEdge,
                                      child: NetworkImagesWidgets(
                                        user.user?.image ?? "",
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Assets.images.profile_image.image(
                                      fit: BoxFit.contain,
                                    ),
                        ),
                        13.ph,
                        CustomText(
                          style: TextStyle(
                            color: LightThemeColors.black,
                          ).s20.bold,
                          user.user?.name ?? "",
                          // fontSize: 20,
                          // weight: FontWeight.w600,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Assets.icons.playLocation.toSvg(),
                            // SvgPicture.asset(
                            //     color: context.primaryColor, "wallet".svg()),
                            5.27.pw,
                            CustomText(
                              style: TextStyle(
                                color: context.primaryColor,
                              ).s18.regular,
                              user.user?.location ?? "",
                              // fontSize: 18,
                              // weight: FontWeight.w500,
                            ),
                          ],
                        ),
                        38.ph,
                        PlayerDetailsWidget(
                          icon: Assets.icons.calling,
                          title: LocaleKeys.auth_hint_phone.tr(),
                          subtitle: user.user?.phone ?? "",
                        ),
                        PlayerDetailsWidget(
                          icon: Assets.icons.email,
                          title: LocaleKeys.auth_hint_email.tr(),
                          subtitle: user.user?.email ?? "",
                        ),
                        PlayerDetailsWidget(
                          icon: Assets.icons.fieldLocation,
                          title: LocaleKeys.city.tr(),
                          subtitle: user.user?.city ?? "",
                        ),
                        23.ph,
                        ButtonWidget(
                          onTap: () => Navigator.pushNamed(
                            context,
                            Routes.editProfile,
                            arguments: EditScreenArgs(
                              onSubmit: (val) async {
                                final res = await cubit.confirmRequest(val);
                                if (res == true) {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    Routes.LayoutScreen,
                                    (route) => false,
                                  );
                                }
                              },
                              user: user,
                              edit: (edit) async {
                                return await cubit.editprofile(edit);
                              },
                            ),
                          ),
                          height: 65,
                          radius: 33,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "wallet".svg(),
                                color: context.background,
                              ),
                              5.5.pw,
                              CustomText(
                                "edit_button".tr(),
                                fontSize: 16,
                                weight: FontWeight.bold,
                                color: context.background,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: Container(
              color: context.background,
              // height: 100.h,
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
