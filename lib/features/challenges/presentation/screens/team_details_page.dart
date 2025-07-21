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
          body: const TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: Text(LocaleKeys.team_details_info)),
              Center(child: Text(LocaleKeys.team_details_members)),
              Center(child: Text(LocaleKeys.team_details_join)),
              Center(child: Text(LocaleKeys.team_details_transfer)),
              Center(child: Text(LocaleKeys.team_details_chat)),
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
              tabs: const [
                Tab(icon: Icon(Icons.info), text: LocaleKeys.team_details_info),
                Tab(icon: Icon(Icons.groups), text: LocaleKeys.team_details_members),
                Tab(icon: Icon(Icons.person_add), text: LocaleKeys.team_details_join),
                Tab(icon: Icon(Icons.transfer_within_a_station), text: LocaleKeys.team_details_transfer),
                Tab(icon: Icon(Icons.chat), text: LocaleKeys.team_details_chat),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
