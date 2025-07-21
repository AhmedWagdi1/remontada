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
              // Info tab content.
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: const [
                    _TopBar(),
                    SizedBox(height: 16),
                    _TeamSummaryCard(),
                    SizedBox(height: 16),
                    _AchievementsSection(),
                    SizedBox(height: 16),
                    _DetailedStatsSection(),
                  ],
                ),
              ),
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

/// Top bar showing settings icon, team name and forward arrow.
class _TopBar extends StatelessWidget {
  /// Creates a const [_TopBar].
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.settings, color: darkBlue),
          Text(
            'ريـمونتادا',
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: darkBlue),
        ],
      ),
    );
  }
}

/// Card displaying a summary about the team.
class _TeamSummaryCard extends StatelessWidget {
  /// Creates a const [_TeamSummaryCard].
  const _TeamSummaryCard();

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.sports_soccer, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          const Text(
            'ريـمونتادا',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'فريق يبحث عن التحديات و الصراعات الكوراوويه',
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _TeamStatItem(number: '10', label: 'اللاعبين'),
              _TeamStatItem(number: '15', label: 'المباريات'),
              _TeamStatItem(number: '12', label: 'الانتصارات'),
            ],
          ),
        ],
      ),
    );
  }
}

/// Simple column displaying a number with a label.
class _TeamStatItem extends StatelessWidget {
  /// Stat number to display.
  final String number;

  /// Label for the stat.
  final String label;

  /// Creates a const [_TeamStatItem].
  const _TeamStatItem({required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

/// Section showing the achievements and badges for the team.
class _AchievementsSection extends StatelessWidget {
  /// Creates a const [_AchievementsSection].
  const _AchievementsSection();

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            Text(
              'الأوسمة والإنجازات',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: darkBlue,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.emoji_events, color: darkBlue),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: const [
            _Badge(label: 'ذهبي', color: Colors.amber, count: '5x', icon: Icons.emoji_events),
            _Badge(label: 'فضي', color: Colors.grey, count: '3x', icon: Icons.emoji_events),
            _Badge(label: 'برونزي', color: Colors.brown, count: '2x', icon: Icons.emoji_events),
            _Badge(label: 'أسطوري', color: Colors.deepPurple, count: '1x', icon: Icons.emoji_events),
            _Badge(label: 'بلاتيني', color: Colors.blueGrey, count: '1x', icon: Icons.emoji_events),
          ],
        ),
      ],
    );
  }
}

/// Widget representing a single badge with color and count.
class _Badge extends StatelessWidget {
  /// Badge label.
  final String label;

  /// Background color for the badge.
  final Color color;

  /// Count string to display.
  final String count;

  /// Icon to show inside the badge.
  final IconData icon;

  /// Creates a const [_Badge].
  const _Badge({
    required this.label,
    required this.color,
    required this.count,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(width: 4),
          Text(
            count,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

/// Section showing detailed statistics in a 2x2 grid.
class _DetailedStatsSection extends StatelessWidget {
  /// Creates a const [_DetailedStatsSection].
  const _DetailedStatsSection();

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            Text(
              'الإحصائيات المفصلة',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: darkBlue,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.insert_chart, color: darkBlue),
          ],
        ),
        const SizedBox(height: 8),
        Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(
            height: 200,
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: const [
                _StatTile(
                  icon: Icons.emoji_events,
                  value: '12',
                  label: 'الانتصارات',
                  backgroundColor: Color(0xFFE1F3E2),
                  textColor: Colors.green,
                ),
                _StatTile(
                  icon: Icons.sports_soccer,
                  value: '15',
                  label: 'المباريات',
                  backgroundColor: Color(0xFFE1F0FB),
                  textColor: Colors.blue,
                ),
                _StatTile(
                  icon: Icons.trending_down,
                  value: '1',
                  label: 'الهزائم',
                  backgroundColor: Color(0xFFFDEAEA),
                  textColor: Colors.red,
                ),
                _StatTile(
                  icon: Icons.swap_horiz,
                  value: '2',
                  label: 'التعادل',
                  backgroundColor: Color(0xFFFFF4D9),
                  textColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Tile used within [_DetailedStatsSection] to show a single stat value.
class _StatTile extends StatelessWidget {
  /// Icon to display inside the tile.
  final IconData icon;

  /// Numerical value for the stat.
  final String value;

  /// Label describing the stat.
  final String label;

  /// Background color of the tile.
  final Color backgroundColor;

  /// Text and icon color used inside the tile.
  final Color textColor;

  /// Creates a const [_StatTile].
  const _StatTile({
    required this.icon,
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: textColor),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(color: textColor),
            ),
          ],
        ),
      ),
    );
  }
}
