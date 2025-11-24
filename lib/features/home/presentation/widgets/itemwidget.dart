import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/resources/gen/assets.gen.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_details_repo.dart';
import 'package:remontada/features/matchdetails/presentaion/screens/matchDetails_screen.dart';
import 'package:remontada/features/my_matches/cubit/myMatches_cubit.dart';
import 'package:remontada/shared/widgets/button_widget.dart';
import 'package:remontada/shared/widgets/customtext.dart';

import '../../../../core/Router/Router.dart';
import '../../domain/model/home_model.dart';

class ItemWidget extends StatefulWidget {
  const ItemWidget({
    super.key,
    this.ismymatch = false,
    this.isreserved,
    this.isHomeGroupe = false,
    this.matchModel,
    this.delete,
    this.isSupervisor,
    this.cubit,
    this.cubitt,
  });
  final MatchModel? matchModel;
  final bool? ismymatch;
  final bool? isHomeGroupe;
  final bool? isreserved;
  final bool? isSupervisor;
  final HomeCubit? cubit;
  final MyMatchesCubit? cubitt;
  final VoidCallback? delete;

  @override
  State<ItemWidget> createState() => _ItemWidgetState();
}

class _ItemWidgetState extends State<ItemWidget> {
  bool _isPastMatch(MatchModel? match) {
    if (match == null) return false;
    // Prefer dateDate fields if available
    String? date = match.dateDate?.date ?? match.date;
    String? endTime =
        match.dateDate?.end_time ?? match.endTime ?? match.startTime ?? match.start;
    if (date == null || endTime == null) return false;

    // The date format from API is likely not YYYY-MM-DD. Let's try to handle DD-MM-YYYY.
    String isoDate;
    final dateParts = date.split('-');
    if (dateParts.length == 3) {
      // Assuming DD-MM-YYYY and converting to YYYY-MM-DD.
      // This is safer for DateTime.tryParse.
      isoDate = "${dateParts[2]}-${dateParts[1]}-${dateParts[0]}";
    } else {
      isoDate = date; // Hope for the best with the original string
    }

    final dateTimeString = "$isoDate $endTime";
    DateTime? matchEnd;
    try {
      matchEnd = DateTime.tryParse(dateTimeString);
      // Some APIs may return time without seconds; try adding :00
      if (matchEnd == null && endTime.split(':').length == 2) {
        matchEnd = DateTime.tryParse("$isoDate ${endTime}:00");
      }
    } catch (_) {
      matchEnd = null;
    }

    if (matchEnd == null) {
      // For debugging purposes, let's see what we are trying to parse.
      // In a real app, you might want a more robust logging solution.
      print(
          "DEBUG: Failed to parse datetime string: '$dateTimeString' from original date '$date' and time '$endTime'");
      return false;
    }
    return DateTime.now().isAfter(matchEnd);
  }

  SubScribersModel? subscribers;
  MatchDetailsRepo matchDetailsRepo = locator<MatchDetailsRepo>();

  void onreturn() async {
    await widget.cubit?.getHomeData(
      playgrounds: [],
      data: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        log(widget.isHomeGroupe.toString());

        await Navigator.pushNamed(
          context,
          Routes.matchDetails,
          arguments: MatchDetailsArgs(
            id: widget.matchModel?.id ?? 1,
            isMymatch: widget.ismymatch,
          ),
        );
        print(widget.isHomeGroupe);
        //  widget.ismymatch ?? false ? await widget.cubitt?.getMymatches() :
        widget.isHomeGroupe == true
            ? await widget.cubit?.getGroupeMatches(
                playgrounds: [],
                data: [],
              )
            : await widget.cubit?.getHomeData(
                playgrounds: [],
                data: [],
              );
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: 10,
          right: 5,
          left: 5,
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: 21,
            bottom: 14.27,
            right: 15.82,
            left: 15.82,
          ),
          decoration: BoxDecoration(
            color: context.background,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                // spreadRadius: -4,
                offset: Offset(0, 0),
                blurRadius: 30,
                color: LightThemeColors.black.withOpacity(.13),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constrains) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            width: 16.82,
                            height: 16.82,
                            Assets.icons.arena,
                          ),
                          6.36.pw,
                          Container(
                            // height: 20.h,
                            width: constrains.maxWidth >= 600 ? 200 : 140,
                            child: CustomText(
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: LightThemeColors.black,
                              ).s16.bold,
                              // color: context.primaryColor,
                              // weight: FontWeight.w600,
                              widget.matchModel?.playGround ?? "",
                              // fontSize: 16.sp,
                            ),
                          )
                        ],
                      ),
                      11.ph,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            width: 16.82,
                            height: 16.82,
                            "clender".svg("icons"),
                          ),
                          6.36.pw,
                          Container(
                            child: CustomText(
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: LightThemeColors.black,
                              ).s14.medium,
                              // overflow: TextOverflow.ellipsis,

                              // weight: FontWeight.w400,
                              widget.matchModel?.date ?? "",
                              // fontSize: 14.sp,
                            ),
                          )
                        ],
                      ),
                      11.ph,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            width: 16.82,
                            height: 16.82,
                            "clock".svg("icons"),
                          ),
                          6.36.pw,
                          Container(
                            child: CustomText(
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: LightThemeColors.black,
                              ).s14.medium,
                              // overflow: TextOverflow.ellipsis,
                              // color: LightThemeColors.secondaryText,
                              // weight: FontWeight.w400,
                              widget.matchModel?.start ?? "",
                              // fontSize: 14.sp,
                            ),
                          )
                        ],
                      ),
                      11.ph,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            width: 16.82,
                            height: 16.82,
                            "wallet".svg("icons"),
                          ),
                          6.36.pw,
                          Container(
                            child: CustomText(
                              style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: LightThemeColors.pricecolor,
                              ).s14.bold,
                              // weight: FontWeight.w600,
                              widget.matchModel?.price ??
                                  " ${LocaleKeys.rs.tr()}",
                              // fontSize: 14.sp,
                            ),
                          )
                        ],
                      ),
                      if (widget.isSupervisor == true)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: GestureDetector(
                            onTap: () {
                              Alerts.bottomSheet(
                                context,
                                child: MatchResultSheet(
                                    matchId: widget.matchModel!.id.toString()),
                              );
                            },
                            child: ButtonWidget(
                              height: 40,
                              radius: 12,
                              onTap: null,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.edit_note,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  8.pw,
                                  CustomText(
                                    'add_match_result'.tr(),
                                    fontSize: 14,
                                    color: Colors.white,
                                    weight: FontWeight.w600,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                31.pw,
                Expanded(
                  flex: widget.isSupervisor == true ? 2 : 6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 9.ph,
                      widget.isSupervisor == true
                          ? Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      Routes.CreateMatchScreen,
                                      arguments:
                                          widget.matchModel?.id.toString() ??
                                              "",
                                    );
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: context.primaryColor,
                                    size: 20,
                                  ),
                                ),
                                20.pw,
                                GestureDetector(
                                  onTap: widget.delete,
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          : widget.isHomeGroupe == true
                              ? Container(
                                  height: 30,
                                  width: 95,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      22,
                                    ),
                                    color:
                                        widget.matchModel?.is_reserved == true
                                            ? Colors.red.withOpacity(.3)
                                            : Colors.green.withOpacity(
                                                .3,
                                              ),
                                  ),
                                  child: Center(
                                    child: CustomText(
                                      widget.matchModel?.is_reserved == true
                                          ? "محجوز"
                                          : "متاح للحجز",
                                      color:
                                          widget.matchModel?.is_reserved == true
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                )
                              : ButtonWidget(
                                  onTap: () async {
                                    final res =
                                        await matchDetailsRepo.getSubscribers(
                                            widget.matchModel?.id.toString() ??
                                                "");
                                    if (res != null)
                                      this.subscribers =
                                          SubScribersModel.fromMap(res);
                                    if (Utils.token == "") {
                                      Alerts.bottomSheet(context,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 25),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: ButtonWidget(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                      context,
                                                      Routes.LoginScreen,
                                                    ),
                                                    child: CustomText(
                                                      weight: FontWeight.w600,
                                                      fontSize: 16,
                                                      "تسجيل الدخول",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                                15.pw,
                                                Expanded(
                                                  child: ButtonWidget(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                      context,
                                                      Routes.RegisterScreen,
                                                    ),
                                                    child: CustomText(
                                                      weight: FontWeight.w600,
                                                      fontSize: 16,
                                                      " انشاء حساب",
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ));
                                    } else {
                                      showPlayersheet(
                                        matchmodel: widget.matchModel,
                                        context,
                                        subscribers: this.subscribers,
                                      );
                                    }
                                  },
                                  radius: 14,
                                  width: 186,
                                  height: 28,
                                  buttonColor: LightThemeColors.surface,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        width: 16.54,
                                        height: 16.54,
                                        Assets.icons.tshirt,
                                        color: context.background,
                                      ),
                                      3.87.pw,
                                      CustomText(
                                        style: TextStyle(
                                          color: LightThemeColors.background,
                                        ).s13.regular,
                                        "المشتركين",
                                        // fontSize: 12.sp,
                                        // weight: FontWeight.w400,
                                        // color: LightThemeColors.background,
                                      ),
                                      2.87.pw,
                                      CustomText(
                                        "${widget.matchModel?.constSub ?? ''} / ",
                                        // fontSize: 13,
                                        // weight: FontWeight.w400,

                                        style: TextStyle(
                                          color: LightThemeColors.background,
                                        ).s13.regular,
                                      ),
                                      CustomText(
                                        widget.matchModel?.actualSub ?? "",
                                        // fontSize: 12.sp,
                                        // weight: FontWeight.w400,
                                        // color: LightThemeColors.black,
                                        style: TextStyle(
                                          color: LightThemeColors.black,
                                        ).s14.medium,
                                      ),
                                    ],
                                  ),
                                ),
                      // ButtonWidget(
                      //   width: 110.w,
                      //   height: 22.h,
                      //   buttonColor: LightThemeColors.surface,
                      // ),
                      50.79.ph,
                      IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            Routes.matchDetails,
                            arguments: MatchDetailsArgs(
                              id: widget.matchModel?.id ?? 1,
                              isMymatch: widget.ismymatch,
                            ),
                          );
                          print(widget.isHomeGroupe);
                          //  widget.ismymatch ?? false ? await widget.cubitt?.getMymatches() :
                          widget.isHomeGroupe == true
                              ? await widget.cubit?.getGroupeMatches(
                                  playgrounds: [],
                                  data: [],
                                )
                              : await widget.cubit?.getHomeData(
                                  playgrounds: [],
                                  data: [],
                                );
                        },
                        icon: SvgPicture.asset(
                          width: 45.94,
                          height: 45.94,
                          "forowrdButton".svg("icons"),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MatchResultSheet extends StatefulWidget {
  final String matchId;
  const MatchResultSheet({Key? key, required this.matchId}) : super(key: key);

  @override
  State<MatchResultSheet> createState() => _MatchResultSheetState();
}

class _MatchResultSheetState extends State<MatchResultSheet> {
  bool _isLoading = true;
  dynamic _participantsData;
  dynamic _matchResults;
  String? _error;

  final _team1GoalsController = TextEditingController();
  final _team2GoalsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final repo = locator<MatchDetailsRepo>();

      print("Fetching team match participants for match ID: ${widget.matchId}");
      final participants = await repo.getTeamMatchParticipants(widget.matchId);
      print("Team Match Participants Response: $participants");

      print("Fetching team match results for match ID: ${widget.matchId}");
      final results = await repo.getTeamMatchResults(widget.matchId);
      print("Team Match Results Response: $results");

      // Prefill goals if data exists
      if (results != null && results['data'] != null) {
        final data = results['data'] as List?;
        if (data != null && data.isNotEmpty) {
          // Prefill team 1 goals
          if (data.length > 0 && data[0]['goals'] != null) {
            _team1GoalsController.text = data[0]['goals'].toString();
          }
          // Prefill team 2 goals
          if (data.length > 1 && data[1]['goals'] != null) {
            _team2GoalsController.text = data[1]['goals'].toString();
          }
        }
      }

      if (mounted) {
        setState(() {
          _isLoading = false;
          _participantsData = participants;
          _matchResults = results;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = e.toString();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final team1Name = _participantsData?['data']?['match']?['team1']?['name'] ?? 'Team 1';
    final team2Name = _participantsData?['data']?['match']?['team2']?['name'] ?? 'Team 2';
    final team1Id = _participantsData?['data']?['match']?['team1']?['id'];
    final team2Id = _participantsData?['data']?['match']?['team2']?['id'];

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error'))
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('add_match_result'.tr(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      30.ph,
                      TextFormField(
                        controller: _team1GoalsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '${'goals_for'.tr()} $team1Name',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required'.tr();
                          }
                          if (int.tryParse(value) == null) {
                            return 'invalid_number'.tr();
                          }
                          return null;
                        },
                      ),
                      20.ph,
                      TextFormField(
                        controller: _team2GoalsController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: '${'goals_for'.tr()} $team2Name',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'required'.tr();
                          }
                          if (int.tryParse(value) == null) {
                            return 'invalid_number'.tr();
                          }
                          return null;
                        },
                      ),
                      40.ph,
                      ButtonWidget(
                        title: 'submit'.tr(),
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            if (team1Id == null || team2Id == null) {
                              Alerts.snack(
                                text: "خطأ في تحميل بيانات الفرق",
                                state: SnackState.failed,
                              );
                              return;
                            }

                            final repo = locator<MatchDetailsRepo>();
                            final team1Goals = int.parse(_team1GoalsController.text);
                            final team2Goals = int.parse(_team2GoalsController.text);

                            final success = await repo.setTeamMatchResult(
                              matchId: widget.matchId,
                              results: [
                                {"team_id": team1Id, "goals": team1Goals},
                                {"team_id": team2Id, "goals": team2Goals},
                              ],
                            );

                            if (success == true && mounted) {
                              Navigator.pop(context);
                            }
                          }
                        },
                      ),
                      20.ph,
                    ],
                  ),
                ),
    );
  }
}
