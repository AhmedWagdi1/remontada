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
          appBar: AppBar(title: Text(LocaleKeys.manage_your_team.tr())),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // Info tab content.
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TopBar(),
                    SizedBox(height: 16),
                    _TeamSummaryCard(),
                    SizedBox(height: 16),
                    _AchievementsSection(),
                    SizedBox(height: 16),
                    _DetailedStatsSection(),
                    SizedBox(height: 16),
                    _HonorsAchievementsSection(),
                    SizedBox(height: 16),
                    _TechnicalStaffSummary(),
                    SizedBox(height: 16),
                    _InviteSettingsSection(),
                  ],
                ),
              ),
              const _MembersTab(),
              const _JoinRequestsTab(),
              const _TransferRequestsTab(),
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        Text(label, style: const TextStyle(color: Colors.white)),
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
            _Badge(
              label: 'ذهبي',
              color: Colors.amber,
              count: '5x',
              icon: Icons.emoji_events,
            ),
            _Badge(
              label: 'فضي',
              color: Colors.grey,
              count: '3x',
              icon: Icons.emoji_events,
            ),
            _Badge(
              label: 'برونزي',
              color: Colors.brown,
              count: '2x',
              icon: Icons.emoji_events,
            ),
            _Badge(
              label: 'أسطوري',
              color: Colors.deepPurple,
              count: '1x',
              icon: Icons.emoji_events,
            ),
            _Badge(
              label: 'بلاتيني',
              color: Colors.blueGrey,
              count: '1x',
              icon: Icons.emoji_events,
            ),
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
          Text(label, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 4),
          Text(count, style: const TextStyle(color: Colors.white)),
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
            height: 310,
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
  /// Creates a const [_TechnicalStaffSummary].
  const _TechnicalStaffSummary();

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
              SizedBox(height: 8),
              _LabeledText(label: 'المدرب:', value: 'غاري'),
              _LabeledText(label: 'هاتف المدرب:', value: '0........5'),
              _LabeledText(label: 'المساعد:', value: 'عبدالرحمن'),
              _LabeledText(label: 'هاتف المساعد:', value: '0........5'),
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
  /// Creates a const [_MembersTab].
  const _MembersTab();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _TopBar(),
            SizedBox(height: 16),
            _StatsSummaryRow(),
            SizedBox(height: 16),
            _PlayersSectionTitle(),
            SizedBox(height: 16),
            _PlayerList(),
          ],
        ),
      ),
    );
  }
}

/// Row showing active and total players stats.
class _StatsSummaryRow extends StatelessWidget {
  /// Creates a const [_StatsSummaryRow].
  const _StatsSummaryRow();

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
          value: '10',
          valueColor: Colors.green,
          bgColor: const Color(0xFFE1F3E2),
        ),
        const SizedBox(width: 8),
        _buildBox(
          label: 'إجمالي اللاعبين',
          value: '10',
          valueColor: Colors.grey,
          bgColor: Color(0xFFF0F0F0),
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
  /// Creates a const [_PlayerList].
  const _PlayerList();

  @override
  Widget build(BuildContext context) {
    final players = [
      {'num': 3, 'name': 'فهد', 'shirt': 3, 'phone': '٠........٥'},
      {'num': 10, 'name': 'عمر', 'shirt': 10, 'phone': '٠........٥'},
      {'num': 8, 'name': 'سالم', 'shirt': 8, 'phone': '٠........٥'},
    ];
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: players.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final p = players[index];
        return _PlayerCard(
          number: p['num'] as int,
          name: p['name'] as String,
          shirt: p['shirt'] as int,
          phone: p['phone'] as String,
        );
      },
    );
  }
}

/// Card widget displaying basic player info.
class _PlayerCard extends StatelessWidget {
  /// Player number for badge.
  final int number;

  /// Player full name.
  final String name;

  /// Jersey number.
  final int shirt;

  /// Obfuscated phone number.
  final String phone;

  /// Creates a const [_PlayerCard].
  const _PlayerCard({
    required this.number,
    required this.name,
    required this.shirt,
    required this.phone,
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
              color: Colors.green,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'نشط',
              style: TextStyle(color: Colors.white, fontSize: 10),
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
  /// Creates a const [_JoinRequestsTab].
  const _JoinRequestsTab();

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
            const _TopBar(),
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
  /// Creates a const [_TransferRequestsTab].
  const _TransferRequestsTab();

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
            const _TopBar(),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
              Text(
                name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
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
                        foregroundColor: Colors.white),
                    onPressed: () {},
                    child: const Text('موافقة'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red)),
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
