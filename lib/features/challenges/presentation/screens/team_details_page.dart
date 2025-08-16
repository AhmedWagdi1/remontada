import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:http/http.dart' as http;
import '../../../../core/app_strings/locale_keys.dart';
import '../../../../core/config/key.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/utils/extentions.dart';
import '../../../../core/utils/Locator.dart';
import '../../../../shared/widgets/network_image.dart';
import '../../../chat/cubit/chat_cubit.dart';
import '../../../chat/cubit/chat_states.dart';
import '../../../chat/domain/repository/chat_repository.dart';
import '../../../chat/domain/request/send_message_request.dart';

/// Finds a member with the given [role] inside the provided [users] list.
Map<String, dynamic>? _findMemberByRole(List<dynamic> users, String role) {
  for (final u in users) {
    if (u is Map<String, dynamic> && u['role'] == role) {
      return u;
    }
  }
  return null;
}

/// Hides middle digits of a phone number with dots for privacy.
String obfuscatePhone(String phone) {
  if (phone.length <= 2) return phone;
  final first = phone[0];
  final last = phone[phone.length - 1];
  return '$first........$last';
}

/// Counts how many users in [users] are marked as active.
int _countActivePlayers(List<dynamic> users) {
  var count = 0;
  for (final u in users) {
    if (u is Map<String, dynamic> && u['active'] == true) {
      count++;
    }
  }
  return count;
}

/// Displays detailed information about a team using a tab bar styled as a
/// bottom navigation bar.
class TeamDetailsPage extends StatefulWidget {
  /// ID of the team to load.
  final int teamId;

  /// Creates a new [TeamDetailsPage].
  const TeamDetailsPage({super.key, required this.teamId});

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  Map<String, dynamic>? _teamData;

  @override
  void initState() {
    super.initState();
    _fetchTeamData();
  }

  /// Fetches the team information from the backend and stores it in [_teamData].
  Future<void> _fetchTeamData() async {
    final url = '${ConstKeys.baseUrl}/team/show/${widget.teamId}';
    final res = await http.get(
      Uri.parse(url),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${Utils.token}',
      },
    );
    if (res.statusCode < 400) {
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['status'] == true) {
        final team = data['data'] as Map<String, dynamic>;
        final users = team['users'] as List<dynamic>? ?? [];
        final leader = _findMemberByRole(users, 'leader');
        final subLeader = _findMemberByRole(users, 'subLeader');
        team['leader'] = leader == null
            ? null
            : {'name': leader['name'], 'phone': leader['mobile']};
        team['sub_leader'] = subLeader == null
            ? null
            : {'name': subLeader['name'], 'phone': subLeader['mobile']};

        final rankings = team['rankings'] as Map<String, dynamic>?;
        team['competitive'] = rankings?['competitive'] as Map<String, dynamic>?;
        setState(() {
          _teamData = team;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return DefaultTabController(
      length: 5,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: Text(LocaleKeys.manage_your_team.tr())),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Info tab content.
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TopBar(
                      teamName: _teamData?['name'] as String?,
                      logoUrl: _teamData?['logo_url'] as String?,
                    ),
                    const SizedBox(height: 16),
                    _TeamSummaryCard(
                      teamName: _teamData?['name'] as String?,
                      bio: _teamData?['bio'] as String?,
                      membersCount: _teamData?['members_count'] as int?,
                      logoUrl: _teamData?['logo_url'] as String?,
                      ranking: _teamData?['competitive'] as Map<String, dynamic>?,
                    ),
                    SizedBox(height: 16),
                    _AchievementsSection(
                      ranking: _teamData?['competitive'] as Map<String, dynamic>?,
                    ),
                    SizedBox(height: 16),
                    _DetailedStatsSection(
                      ranking: _teamData?['competitive'] as Map<String, dynamic>?,
                    ),
                    SizedBox(height: 16),
                    _HonorsAchievementsSection(),
                    SizedBox(height: 16),
                    _TechnicalStaffSummary(
                      leaderName: (_teamData?['leader']
                          as Map<String, dynamic>?)?['name'] as String?,
                      leaderPhone: (_teamData?['leader']
                          as Map<String, dynamic>?)?['phone'] as String?,
                      subLeaderName: (_teamData?['sub_leader']
                          as Map<String, dynamic>?)?['name'] as String?,
                      subLeaderPhone: (_teamData?['sub_leader']
                          as Map<String, dynamic>?)?['phone'] as String?,
                    ),
                    SizedBox(height: 16),
                    _InviteSettingsSection(),
                  ],
                ),
              ),
              _MembersTab(
                teamName: _teamData?['name'] as String?,
                logoUrl: _teamData?['logo_url'] as String?,
                users: _teamData?['users'] as List<dynamic>?,
                membersCount: _teamData?['members_count'] as int?,
              ),
              _JoinRequestsTab(
                teamName: _teamData?['name'] as String?,
                logoUrl: _teamData?['logo_url'] as String?,
              ),
              _TransferRequestsTab(
                teamName: _teamData?['name'] as String?,
                logoUrl: _teamData?['logo_url'] as String?,
              ),
              // Chat tab for messaging within the team.
              _ChatTab(
                teamId: widget.teamId.toString(),
                teamName: _teamData?['name'] as String?,
                logoUrl: _teamData?['logo_url'] as String?,
              ),
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
                Tab(
                  icon: const Icon(Icons.info),
                  text: LocaleKeys.team_details_info.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.groups),
                  text: LocaleKeys.team_details_members.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.person_add),
                  text: LocaleKeys.team_details_join.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.transfer_within_a_station),
                  text: LocaleKeys.team_details_transfer.tr(),
                ),
                Tab(
                  icon: const Icon(Icons.chat),
                  text: LocaleKeys.team_details_chat.tr(),
                ),
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
  /// Optional name of the team to display.
  final String? teamName;

  /// Optional logo URL for the team.
  final String? logoUrl;

  /// Creates a [_TopBar] with optional team details.
  const _TopBar({this.teamName, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    final name = teamName ?? 'ريـمونتادا';
    final logo = logoUrl;
    final leading = (logo != null && logo.isNotEmpty)
        ? NetworkImagesWidgets(
            logo,
            width: 24,
            height: 24,
            fit: BoxFit.cover,
            radius: 12,
          )
        : const Icon(Icons.settings, color: darkBlue);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leading,
          Text(
            name,
            style: const TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: darkBlue),
        ],
      ),
    );
  }
}

/// Card displaying a summary about the team.
class _TeamSummaryCard extends StatelessWidget {
  /// Optional team name.
  final String? teamName;

  /// Optional team bio.
  final String? bio;

  /// Optional count of members.
  final int? membersCount;

  /// Optional logo URL for the team.
  final String? logoUrl;

  /// Competitive ranking information for stats.
  final Map<String, dynamic>? ranking;

  /// Creates a [_TeamSummaryCard] with optional details.
  const _TeamSummaryCard({
    this.teamName,
    this.bio,
    this.membersCount,
    this.logoUrl,
    this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    final name = teamName ?? 'ريـمونتادا';
    final description = bio ?? 'فريق يبحث عن التحديات و الصراعات الكوراوويه';
    final members = membersCount?.toString() ?? '10';
    final logo = logoUrl;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: darkBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (logo != null && logo.isNotEmpty)
            NetworkImagesWidgets(
              logo,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              radius: 20,
            )
          else
            const Icon(Icons.sports_soccer, color: Colors.white, size: 40),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TeamStatItem(number: members, label: 'اللاعبين'),
              _TeamStatItem(
                number: (ranking?['match_count'] ?? 0).toString(),
                label: 'المباريات',
              ),
              _TeamStatItem(
                number: (ranking?['wins'] ?? 0).toString(),
                label: 'الانتصارات',
              ),
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
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }
}

/// Section showing the achievements and badges for the team.
class _AchievementsSection extends StatelessWidget {
  /// Competitive ranking information from the backend.
  final Map<String, dynamic>? ranking;

  /// Creates a const [_AchievementsSection].
  const _AchievementsSection({this.ranking});

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
        if (ranking != null)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Badge(
                label: ranking!['level']?.toString() ?? '',
                color: (ranking!['level_color'] as String?)?.toColor() ??
                    Colors.grey,
                count: '',
                icon: Icons.emoji_events,
              ),
            ],
          )
        else
          const Text('لا يوجد اوسمة و انجازات بعد'),
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
          Text(label, style: const TextStyle(color: Colors.white)),
          if (count.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(count, style: const TextStyle(color: Colors.white)),
          ],
        ],
      ),
    );
  }
}

/// Section showing detailed statistics in a 2x2 grid.
class _DetailedStatsSection extends StatelessWidget {
  /// Competitive ranking information from the backend.
  final Map<String, dynamic>? ranking;

  /// Creates a const [_DetailedStatsSection].
  const _DetailedStatsSection({this.ranking});

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
            height: 310,
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.3,
              children: [
                _StatTile(
                  icon: Icons.emoji_events,
                  value: (ranking?['wins'] ?? 0).toString(),
                  label: 'الانتصارات',
                  backgroundColor: const Color(0xFFE1F3E2),
                  textColor: Colors.green,
                ),
                _StatTile(
                  icon: Icons.sports_soccer,
                  value: (ranking?['match_count'] ?? 0).toString(),
                  label: 'المباريات',
                  backgroundColor: const Color(0xFFE1F0FB),
                  textColor: Colors.blue,
                ),
                _StatTile(
                  icon: Icons.trending_down,
                  value: (ranking?['losses'] ?? 0).toString(),
                  label: 'الهزائم',
                  backgroundColor: const Color(0xFFFDEAEA),
                  textColor: Colors.red,
                ),
                _StatTile(
                  icon: Icons.swap_horiz,
                  value: (ranking?['draws'] ?? 0).toString(),
                  label: 'التعادل',
                  backgroundColor: const Color(0xFFFFF4D9),
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
            Text(label, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}

/// Section summarizing honors and achievements for the team.
class _HonorsAchievementsSection extends StatelessWidget {
  /// Creates a const [_HonorsAchievementsSection].
  const _HonorsAchievementsSection();

  @override
  Widget build(BuildContext context) {
    const headerColor = Colors.green;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.greenAccent.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Row(
              children: [
                Icon(Icons.star, color: headerColor),
                SizedBox(width: 8),
                Text(
                  'التكريم والإنجازات',
                  style: TextStyle(
                    color: headerColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            _BulletText('أفضل فريق في الدوري المحلي (2024)'),
            _BulletText('فريق اللعب النظيف (3 مرات)'),
            _BulletText('أفضل هجوم في البطولة'),
            _BulletText('جائزة الروح الرياضية'),
          ],
        ),
      ),
    );
  }
}

/// Card summarizing the technical staff information.
class _TechnicalStaffSummary extends StatelessWidget {
  /// Leader name.
  final String? leaderName;

  /// Leader phone number.
  final String? leaderPhone;

  /// Assistant name.
  final String? subLeaderName;

  /// Assistant phone number.
  final String? subLeaderPhone;

  /// Creates a summary card for the technical staff.
  const _TechnicalStaffSummary({
    this.leaderName,
    this.leaderPhone,
    this.subLeaderName,
    this.subLeaderPhone,
  });

  @override
  Widget build(BuildContext context) {
    const headerColor = Colors.blue;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.settings, color: headerColor),
                  SizedBox(width: 8),
                  Text(
                    'الجهاز الفني',
                    style: TextStyle(
                      color: headerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _LabeledText(label: 'المدرب:', value: leaderName ?? 'غاري'),
              _LabeledText(
                label: 'هاتف المدرب:',
                value: leaderPhone != null
                    ? obfuscatePhone(leaderPhone!)
                    : '0........5',
              ),
              _LabeledText(
                label: 'المساعد:',
                value: subLeaderName ?? 'عبدالرحمن',
              ),
              _LabeledText(
                label: 'هاتف المساعد:',
                value: subLeaderPhone != null
                    ? obfuscatePhone(subLeaderPhone!)
                    : '0........5',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Card describing invite settings for the team.
class _InviteSettingsSection extends StatelessWidget {
  /// Creates a const [_InviteSettingsSection].
  const _InviteSettingsSection();

  @override
  Widget build(BuildContext context) {
    const headerColor = Colors.blue;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Row(
                children: [
                  Icon(Icons.share, color: headerColor),
                  SizedBox(width: 8),
                  Text(
                    'إعدادات الدعوة',
                    style: TextStyle(
                      color: headerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              _LabeledText(label: 'الدعوة الاجتماعية:', value: 'مفعلة'),
            ],
          ),
        ),
      ),
    );
  }
}

/// Members tab displaying team players.
class _MembersTab extends StatelessWidget {
  /// Team name to pass to [_TopBar].
  final String? teamName;

  /// Logo URL to pass to [_TopBar].
  final String? logoUrl;

  /// Full list of users in the team.
  final List<dynamic>? users;

  /// Total members count for the team.
  final int? membersCount;

  /// Creates a [_MembersTab].
  const _MembersTab({
    this.teamName,
    this.logoUrl,
    this.users,
    this.membersCount,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(teamName: teamName, logoUrl: logoUrl),
            const SizedBox(height: 16),
            _StatsSummaryRow(
              activePlayers: _countActivePlayers(users ?? []),
              totalPlayers: membersCount ?? (users?.length ?? 0),
            ),
            const SizedBox(height: 16),
            const _PlayersSectionTitle(),
            const SizedBox(height: 16),
            _PlayerList(players: users ?? const []),
          ],
        ),
      ),
    );
  }
}

/// Row showing active and total players stats.
class _StatsSummaryRow extends StatelessWidget {
  /// Number of active players in the team.
  final int activePlayers;

  /// Total number of players in the team.
  final int totalPlayers;

  /// Creates a const [_StatsSummaryRow].
  const _StatsSummaryRow({
    required this.activePlayers,
    required this.totalPlayers,
  });

  Widget _buildBox({
    required String label,
    required String value,
    required Color valueColor,
    required Color bgColor,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(label),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: valueColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildBox(
          label: 'اللاعبين النشطين',
          value: activePlayers.toString(),
          valueColor: Colors.green,
          bgColor: const Color(0xFFE1F3E2),
        ),
        const SizedBox(width: 8),
        _buildBox(
          label: 'إجمالي اللاعبين',
          value: totalPlayers.toString(),
          valueColor: Colors.grey,
          bgColor: const Color(0xFFF0F0F0),
        ),
      ],
    );
  }
}

/// Section title for the players list.
class _PlayersSectionTitle extends StatelessWidget {
  /// Creates a const [_PlayersSectionTitle].
  const _PlayersSectionTitle();

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Text(
        'قائمة اللاعبين',
        style: const TextStyle(
          color: darkBlue,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}

/// List of player cards.
class _PlayerList extends StatelessWidget {
  /// List of players to display.
  final List<dynamic> players;

  /// Creates a const [_PlayerList].
  const _PlayerList({required this.players});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: players.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final p = players[index] as Map<String, dynamic>;
        return PlayerCard(
          number: (p['num'] ?? index + 1) as int,
          name: p['name'] as String? ?? '',
          shirt: (p['shirt'] ?? p['shirt_number'] ?? 0) as int,
          phone: obfuscatePhone((p['phone'] ?? p['mobile'] ?? '') as String),
          isActive: p['active'] == true,
        );
      },
    );
  }
}

/// Card widget displaying basic player info.
class PlayerCard extends StatelessWidget {
  /// Player number for badge.
  final int number;

  /// Player full name.
  final String name;

  /// Jersey number.
  final int shirt;

  /// Obfuscated phone number.
  final String phone;

  /// Whether the player is currently active.
  final bool isActive;

  /// Creates a const [PlayerCard].
  const PlayerCard({
    required this.number,
    required this.name,
    required this.shirt,
    required this.phone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: Text(number.toString()),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('رقم القميص: $shirt'),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 14, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(phone),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              isActive
                  ? LocaleKeys.player_active.tr()
                  : LocaleKeys.player_inactive.tr(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
      ],
    );
  }
}

/// Helper widget to display a bullet point text line.
class _BulletText extends StatelessWidget {
  /// Text to display after the bullet.
  final String text;

  /// Creates a const [_BulletText].
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        '• $text',
        style: const TextStyle(fontSize: 12, color: Colors.green),
      ),
    );
  }
}

/// Helper widget to display a bold label followed by a value.
class _LabeledText extends StatelessWidget {
  /// Label text shown in bold.
  final String label;

  /// Value text shown in normal weight.
  final String value;

  /// Creates a const [_LabeledText].
  const _LabeledText({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text.rich(
        TextSpan(
          text: label + ' ',
          style: const TextStyle(fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab displaying pending join requests for the team.
class _JoinRequestsTab extends StatelessWidget {
  /// Team name for the [_TopBar].
  final String? teamName;

  /// Logo URL for the [_TopBar].
  final String? logoUrl;

  /// Creates a [_JoinRequestsTab].
  const _JoinRequestsTab({this.teamName, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    final requests = [
      {
        'name': 'أحمد محمد',
        'position': 'مهاجم',
        'age': 25,
        'date': '2024-05-01',
        'note': 'أريد الانضمام لفريقكم المميز',
      },
      {
        'name': 'محمد علي',
        'position': 'حارس',
        'age': 22,
        'date': '2024-05-03',
        'note': 'متحمس للعب معكم',
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(teamName: teamName, logoUrl: logoUrl),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'طلبات الانضمام',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${requests.length} طلب',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (var r in requests) ...[
              _JoinRequestCard(
                name: r['name'] as String,
                position: r['position'] as String,
                age: r['age'] as int,
                date: r['date'] as String,
                note: r['note'] as String,
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

/// Card displaying the details of a join request with action buttons.
class _JoinRequestCard extends StatelessWidget {
  /// Applicant name.
  final String name;

  /// Applicant position on the field.
  final String position;

  /// Applicant age in years.
  final int age;

  /// Date of the request.
  final String date;

  /// Additional note from the applicant.
  final String note;

  /// Creates a const [_JoinRequestCard].
  const _JoinRequestCard({
    required this.name,
    required this.position,
    required this.age,
    required this.date,
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              CircleAvatar(
                backgroundColor: Colors.yellow.shade700,
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(
            '$position - $age سنة',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          Text(note),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {},
                  child: const Text('قبول'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                  onPressed: () {},
                  child: const Text('رفض'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Tab displaying transfer requests with actions for pending ones.
class _TransferRequestsTab extends StatelessWidget {
  /// Team name for the [_TopBar].
  final String? teamName;

  /// Logo URL for the [_TopBar].
  final String? logoUrl;

  /// Creates a [_TransferRequestsTab].
  const _TransferRequestsTab({this.teamName, this.logoUrl});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    final requests = [
      {
        'name': 'سالم عبدالله',
        'toTeam': 'النجوم',
        'reason': 'فرصة أفضل',
        'date': '2024-05-05',
        'status': 'pending',
      },
      {
        'name': 'خالد محمد',
        'toTeam': 'الهلال',
        'reason': 'تحدي جديد',
        'date': '2024-05-02',
        'status': 'approved',
      },
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(teamName: teamName, logoUrl: logoUrl),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'طلبات الانتقال',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: darkBlue,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${requests.length} طلب',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (var r in requests) ...[
              _TransferRequestCard(
                name: r['name'] as String,
                toTeam: r['toTeam'] as String,
                reason: r['reason'] as String,
                date: r['date'] as String,
                status: r['status'] as String,
              ),
              const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

/// Card widget displaying transfer request info and actions.
class _TransferRequestCard extends StatelessWidget {
  /// Player name submitting the transfer request.
  final String name;

  /// Destination team name.
  final String toTeam;

  /// Reason for requesting transfer.
  final String reason;

  /// Date of the request.
  final String date;

  /// Request status value; 'pending' or 'approved'.
  final String status;

  /// Creates a const [_TransferRequestCard].
  const _TransferRequestCard({
    required this.name,
    required this.toTeam,
    required this.reason,
    required this.date,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isPending = status == 'pending';
    final borderColor = isPending ? Colors.orange : Colors.green;
    final iconColor = borderColor;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.directions_walk, color: iconColor),
            ],
          ),
          const SizedBox(height: 8),
          Text('إلى فريق: $toTeam'),
          Text('السبب: $reason'),
          Text('تاريخ الطلب: $date'),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: borderColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isPending ? 'قيد المراجعة' : 'موافق عليه',
                  style: TextStyle(color: borderColor),
                ),
              ),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: const Text('موافقة'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                    onPressed: () {},
                    child: const Text('رفض'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Chat tab displaying real team chat functionality.
class _ChatTab extends StatefulWidget {
  /// Team ID for the chat.
  final String teamId;

  /// Team name used in the [_TopBar].
  final String? teamName;

  /// Logo URL used in the [_TopBar].
  final String? logoUrl;

  /// Creates a [_ChatTab].
  const _ChatTab({
    required this.teamId,
    this.teamName, 
    this.logoUrl,
  });

  @override
  State<_ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<_ChatTab> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TeamMessagesCubit _messagesCubit;
  late SendMessageCubit _sendMessageCubit;

  @override
  void initState() {
    super.initState();
    // Initialize cubits with the actual team ID using service locator
    _messagesCubit = TeamMessagesCubit(
      locator<ChatRepository>(), 
      widget.teamId
    );
    _sendMessageCubit = SendMessageCubit(
      locator<ChatRepository>()
    );
    
    _messagesCubit.loadMessages(refresh: true);
    
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= 
          _scrollController.position.maxScrollExtent - 200) {
        _messagesCubit.loadMoreMessages();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _messagesCubit.close();
    _sendMessageCubit.close();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _sendMessageCubit.sendMessage(
        SendMessageRequest(
          teamId: widget.teamId,
          message: message,
        ),
      );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _messagesCubit),
        BlocProvider.value(value: _sendMessageCubit),
      ],
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _TopBar(teamName: widget.teamName, logoUrl: widget.logoUrl),
            Container(
              color: const Color(0xFFF2F2F2),
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.wifi, color: Colors.green, size: 16),
                      SizedBox(width: 4),
                      Text('متصل', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                  Text(
                    'دردشة الفريق',
                    style: TextStyle(
                      color: darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(Icons.chat_bubble, color: darkBlue),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<TeamMessagesCubit, TeamMessagesState>(
                builder: (context, state) {
                  if (state is TeamMessagesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state is TeamMessagesError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                          const SizedBox(height: 16),
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => _messagesCubit.loadMessages(refresh: true),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  if (state is TeamMessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('لا توجد رسائل بعد'),
                            SizedBox(height: 8),
                            Text('ابدأ المحادثة!', style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true,
                      padding: const EdgeInsets.all(12),
                      itemCount: state.messages.length + (state.isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.messages.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        
                        final message = state.messages[index];
                        final isMyMessage = message.senderId == Utils.userId;
                        
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: _MessageBubble(
                            sender: message.senderName,
                            message: message.message,
                            time: _formatTime(message.timestamp),
                            isSender: isMyMessage,
                            onDelete: isMyMessage ? () => _messagesCubit.deleteMessage(message.id) : null,
                          ),
                        );
                      },
                    );
                  }
                  
                  return const SizedBox.shrink();
                },
              ),
            ),
            BlocListener<SendMessageCubit, SendMessageState>(
              listener: (context, state) {
                if (state is SendMessageError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: _buildMessageInput(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: 'اكتب رسالة...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<SendMessageCubit, SendMessageState>(
            builder: (context, state) {
              final isLoading = state is SendMessageLoading;
              return GestureDetector(
                onTap: isLoading ? null : _sendMessage,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFF23425F),
                    shape: BoxShape.circle,
                  ),
                  child: isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (now.difference(messageDate).inDays == 1) {
      return 'أمس';
    } else if (now.difference(messageDate).inDays < 7) {
      const weekdays = ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'];
      return weekdays[dateTime.weekday - 1];
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// Single chat message bubble with timestamp and sender name.
class _MessageBubble extends StatelessWidget {
  /// Name of the message sender.
  final String sender;

  /// Text content of the message.
  final String message;

  /// Timestamp string displayed above the bubble.
  final String time;

  /// Whether the current user is the sender.
  final bool isSender;

  /// Optional callback for deleting the message (only for sender's messages).
  final VoidCallback? onDelete;

  /// Creates a const [_MessageBubble].
  const _MessageBubble({
    required this.sender,
    required this.message,
    required this.time,
    required this.isSender,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
    final bubbleColor = isSender ? darkBlue : Colors.white;
    final textColor = isSender ? Colors.white : Colors.black87;
    final mainAxis = isSender ? MainAxisAlignment.end : MainAxisAlignment.start;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: mainAxis,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isSender) ...[
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: GestureDetector(
              onLongPress: onDelete != null ? () => _showDeleteDialog(context) : null,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: isSender ? const Radius.circular(16) : const Radius.circular(4),
                    bottomRight: isSender ? const Radius.circular(4) : const Radius.circular(16),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (!isSender)
                      Text(
                        sender,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: darkBlue,
                        ),
                      ),
                    if (!isSender) const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(
                        fontSize: 10,
                        color: isSender ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isSender) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              child: Icon(Icons.person, size: 16),
            ),
          ],
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الرسالة'),
        content: const Text('هل أنت متأكد من حذف هذه الرسالة؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete?.call();
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
