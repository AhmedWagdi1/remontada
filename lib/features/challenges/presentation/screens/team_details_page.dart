import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import '../../../../core/app_strings/locale_keys.dart';

/// Displays detailed information about a team using a tab bar styled as a
/// bottom navigation bar.
class TeamDetailsPage extends StatelessWidget {
  /// Creates a new [TeamDetailsPage].
  const TeamDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return DefaultTabController(
      length: 5,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.manage_your_team.tr()),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Center(child: Text(LocaleKeys.team_details_info.tr())),
              Center(child: Text(LocaleKeys.team_details_members.tr())),
              Center(child: Text(LocaleKeys.team_details_join.tr())),
              Center(child: Text(LocaleKeys.team_details_transfer.tr())),
              Center(child: Text(LocaleKeys.team_details_chat.tr())),
            ],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: TabBar(
              indicatorColor: darkBlue,
              labelColor: darkBlue,
              unselectedLabelColor: Colors.grey,
              indicatorWeight: 3,
              tabs: [
                Tab(icon: const Icon(Icons.info), text: LocaleKeys.team_details_info.tr()),
                Tab(icon: const Icon(Icons.groups), text: LocaleKeys.team_details_members.tr()),
                Tab(icon: const Icon(Icons.person_add), text: LocaleKeys.team_details_join.tr()),
                Tab(icon: const Icon(Icons.transfer_within_a_station), text: LocaleKeys.team_details_transfer.tr()),
                Tab(icon: const Icon(Icons.chat), text: LocaleKeys.team_details_chat.tr()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
