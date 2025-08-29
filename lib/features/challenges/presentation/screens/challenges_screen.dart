import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/utils/extentions.dart';
import 'package:remontada/features/home/presentation/widgets/custom_dots.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import '../widgets/championship_card.dart';
import 'create_team_page.dart';
import 'team_details_page.dart';
import 'create_challenge_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/config/key.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/Router/Router.dart';
import '../../domain/model/challenge_overview_model.dart';
import '../../data/challenges_repository_impl.dart';



/// Placeholder screen shown for the upcoming Challenges feature.
class ChallengesScreen extends StatefulWidget {
  /// Optional flag indicating whether the current player already belongs to a team.
  final bool? hasTeam;

  const ChallengesScreen({super.key, this.hasTeam});

  @override
  State<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends State<ChallengesScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  /// Local images displayed in the carousel slider.
  final List<String> _sliderImages = const [
    'assets/images/slider.png',
    'assets/images/slider.png',
    'assets/images/slider.png',
  ];
  List<ChallengeOverviewModel> _challengesOverview = [];
  bool _loadingChallengesOverview = false;
  String? _challengesOverviewError;
  int _currentSlideIndex = 0;
  bool? _hasTeam;
  List<dynamic> _userTeams = [];
  String? _userRole;
  bool _isValidatingTeam = false;

  /// Retrieves the list of teams the current user belongs to.
  ///
  /// This makes a GET request to `/team/user-teams` and expects a response in
  /// the following form:
  /// ```json
  /// {
  ///   "status": true,
  ///   "message": "تم التحميل بنجاح",
  ///   "data": [
  ///     {"id": 25, "name": "test team", ...},
  ///     {"id": 26, "name": "123test team", ...}
  ///   ]
  /// }
  /// ```
  /// When the returned `data` list is not empty, [_hasTeam] becomes `true`.
  Future<void> _fetchUserTeams() async {
    try {
      final res = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/team/user-teams'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );
      if (res.statusCode < 400) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['status'] == true) {
          final teams = data['data'] as List<dynamic>;
          setState(() {
            _userTeams = teams;
            _hasTeam = teams.isNotEmpty;
          });
          // Fetch user role if they have teams
          if (teams.isNotEmpty) {
            _fetchUserRole();
          }
          return;
        }
      }
    } catch (_) {}
    setState(() => _hasTeam = false);
  }
  /// Retrieves the current user's role in their team.
  ///
  /// This makes a GET request to `/team/show/{teamId}` to get detailed team information
  /// and finds the current user's role among the team members.
  Future<void> _fetchUserRole() async {
    if (_userTeams.isEmpty) {
      setState(() => _userRole = null);
      return;
    }

    try {
      // Get the first team (assuming user can only be in one team at a time)
      final teamId = _userTeams[0]['id'];
      final res = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/team/show/$teamId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );

      if (res.statusCode < 400) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['status'] == true) {
          final teamData = data['data'] as Map<String, dynamic>;
          final users = teamData['users'] as List<dynamic>? ?? [];

          // Find current user's role
          final currentUserPhone = Utils.user.user?.phone;
          if (currentUserPhone != null) {
            for (final user in users) {
              if (user is Map<String, dynamic> && user['mobile'] == currentUserPhone) {
                setState(() => _userRole = user['role'] as String?);
                return;
              }
            }
          }
        }
      }
    } catch (_) {}
    setState(() => _userRole = null);
  }

  /// Shows a warning dialog when team doesn't have enough members.
  void _showTeamSizeWarning(int currentCount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                'تحذير',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'لا يمكنك إنشاء تحدي جديد',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'يجب أن يحتوي الفريق على 10 أعضاء على الأقل لإنشاء تحدي.\n\nعدد الأعضاء الحالي: $currentCount',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF23425F),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('موافق'),
            ),
          ],
        );
      },
    );
  }

  /// Handles the create challenge button tap with team validation.
  Future<void> _onCreateChallengeTap() async {
    if (_isValidatingTeam) return; // Prevent multiple taps

    setState(() => _isValidatingTeam = true);

    try {
      // Get current team member count
      final teamId = _userTeams[0]['id'];
      final res = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/team/show/$teamId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );

      if (res.statusCode < 400) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['status'] == true) {
          final teamData = data['data'] as Map<String, dynamic>;
          final users = teamData['users'] as List<dynamic>? ?? [];

          // Count active players
          int activeCount = 0;
          for (final user in users) {
            if (user is Map<String, dynamic> && user['active'] == true) {
              activeCount++;
            }
          }

          if (activeCount >= 10) {
            // Team has enough members, navigate to create challenge page
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const CreateChallengePage(),
                ),
              );
            }
          } else {
            // Show warning dialog
            if (mounted) {
              _showTeamSizeWarning(activeCount);
            }
          }
        }
      }
    } catch (_) {
      // Show error if something went wrong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ في التحقق من بيانات الفريق'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isValidatingTeam = false);
      }
    }
  }

  /// Retrieves challenges overview from the backend API.
  /// `{ "status": true, "data": [ { "id": 1, "name": "...", "ranking": {...} } ] }`.
  Future<void> _fetchChallengesOverview() async {
    setState(() {
      _loadingChallengesOverview = true;
      _challengesOverviewError = null;
    });
    try {
      final repository = ChallengesRepositoryImpl();
      final challenges = await repository.getChallengesOverview();
      setState(() => _challengesOverview = challenges);
    } catch (e) {
      _challengesOverviewError = 'Failed to load challenges overview: $e';
    } finally {
      if (mounted) {
        setState(() => _loadingChallengesOverview = false);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.hasTeam != null) {
      _hasTeam = widget.hasTeam;
      // If we know the user has a team, fetch their role
      if (_hasTeam == true) {
        _fetchUserTeams().then((_) => _fetchUserRole());
      }
    } else {
      _fetchUserTeams().then((_) => _fetchUserRole());
    }
    _fetchChallengesOverview();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Builds the card displaying a completed challenge summary.
  Widget _completedChallengeCard() {
    const borderColor = Color(0xFFD4EDDA);
    const badgeColor = Color(0xFFE6F4EA);
    const badgeTextColor = Color(0xFF28A745);
    const buttonColor = Color(0xFF23425F);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.check_circle, color: badgeTextColor, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'تحدي مكتمل - اليوم 8:00 م',
                        style: TextStyle(
                          color: badgeTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text(
                        'الفهود',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          'assets/images/profile_image.png',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'VS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 2,
                        width: 20,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                  Column(
                    children: const [
                      Text(
                        'ابطال الخرج',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          'assets/images/profile_image.png',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 12,
                  bottom: 12,
                  left: 12,
                  right: 12,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12),
                          topRight: Radius.circular(12),
                          topLeft: Radius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'عرض التفاصيل',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the card allowing a user to join an upcoming challenge.
  Widget _joinChallengeCard() {
    const borderColor = Color(0xFFFEEBCB);
    const badgeColor = Color(0xFFFFF3E0);
    const highlightColor = Color(0xFFF9A825);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.access_time, color: highlightColor, size: 16),
                      SizedBox(width: 4),
                      Text(
                        'انضم للتحدي - اليوم 7:30 م',
                        style: TextStyle(
                          color: highlightColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: const [
                      Text(
                        'الابطال',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 4),
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(
                          'assets/images/profile_image.png',
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'VS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: highlightColor,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        height: 2,
                        width: 20,
                        color: highlightColor,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'انضم',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: highlightColor),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }

  /// Displays a placeholder message when the player does not belong to a team.
  Widget _noTeamPlaceholder() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Text(
        'You need a team to participate in challenges',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  /// Builds a button allowing a user to initiate a new challenge.
  Widget _createChallengeButton() {
    const darkBlue = Color(0xFF23425F);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: _isValidatingTeam ? null : _onCreateChallengeTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFF5F5F5)],
            ),
            border: Border.all(color: darkBlue),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _isValidatingTeam
              ? Center(
                  child: SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(darkBlue),
                    ),
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: darkBlue),
                    const SizedBox(height: 4),
                    Text(
                      LocaleKeys.challenge_create_challenge.tr(),
                      style: const TextStyle(
                        color: darkBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// Builds a numbered step item for the how challenges work card.
  Widget _buildHowStep({
    required Widget icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Creates an informational card explaining how challenges work.
  Widget _howChallengesWorkCard() {
    final borderColor = Colors.grey.shade300;
    const infoColor = Colors.blue;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline, color: infoColor),
                const SizedBox(width: 4),
                Text(
                  LocaleKeys.how_challenges_work_title.tr(),
                  style: const TextStyle(
                    color: infoColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildHowStep(
              icon: const CircleAvatar(
                radius: 12,
                backgroundColor: infoColor,
                child: Text(
                  '1',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              title: LocaleKeys.how_challenges_step1_title.tr(),
              subtitle: LocaleKeys.how_challenges_step1_subtitle.tr(),
            ),
            const SizedBox(height: 12),
            _buildHowStep(
              icon: const CircleAvatar(
                radius: 12,
                backgroundColor: infoColor,
                child: Icon(Icons.add, size: 16, color: Colors.white),
              ),
              title: LocaleKeys.how_challenges_step2_title.tr(),
              subtitle: LocaleKeys.how_challenges_step2_subtitle.tr(),
            ),
            const SizedBox(height: 12),
            _buildHowStep(
              icon: const CircleAvatar(
                radius: 12,
                backgroundColor: infoColor,
                child: Text(
                  '3',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              title: LocaleKeys.how_challenges_step3_title.tr(),
              subtitle: LocaleKeys.how_challenges_step3_subtitle.tr(),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      LocaleKeys.how_challenges_tip.tr(),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Displays the league table header with a trophy icon.
  Widget _leagueHeaderCard() {
    const darkBlue = Color(0xFF23425F);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: const BoxDecoration(
          color: darkBlue,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              LocaleKeys.league_table_title.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the table displaying current league standings.
  ///
  /// The table is styled with reduced padding and font sizes so that it fits on
  /// smaller screens without requiring horizontal scrolling in most cases.
  Widget _leagueTable() {
    const headingStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.bold);
    const dataStyle = TextStyle(fontSize: 12);

    if (_loadingChallengesOverview) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_challengesOverviewError != null) {
      return Center(child: Text(_challengesOverviewError!));
    }
    if (_challengesOverview.isEmpty) {
      return const Center(child: Text('No challenges overview available'));
    }

    // Filter teams that have ranking data and sort by points
    final teamsWithRanking = _challengesOverview
        .where((team) => team.ranking != null)
        .toList()
      ..sort((a, b) => (b.ranking?.points ?? 0).compareTo(a.ranking?.points ?? 0));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 10,
            horizontalMargin: 8,
            headingRowHeight: 32,
            dataRowMinHeight: 32,
            dataRowMaxHeight: 32,
            columns: [
              DataColumn(
                label: Text(LocaleKeys.league_rank.tr(), style: headingStyle),
              ),
              DataColumn(
                label: Text(LocaleKeys.league_team.tr(), style: headingStyle),
              ),
              DataColumn(
                label: Text(LocaleKeys.league_played.tr(), style: headingStyle),
              ),
              DataColumn(
                label: Text(LocaleKeys.league_won.tr(), style: headingStyle),
              ),
              DataColumn(
                label: Text(LocaleKeys.league_drawn.tr(), style: headingStyle),
              ),
              DataColumn(
                label: Text(LocaleKeys.league_lost.tr(), style: headingStyle),
              ),
              DataColumn(
                label: Text(
                  LocaleKeys.league_goals_for.tr(),
                  style: headingStyle,
                ),
              ),
              DataColumn(
                label: Text(
                  LocaleKeys.league_goals_against.tr(),
                  style: headingStyle,
                ),
              ),
              DataColumn(
                label: Text(
                  LocaleKeys.league_goal_diff.tr(),
                  style: headingStyle,
                ),
              ),
              DataColumn(
                label: Text(LocaleKeys.league_points.tr(), style: headingStyle),
              ),
            ],
            rows: teamsWithRanking.asMap().entries.map((entry) {
              final index = entry.key;
              final team = entry.value;
              final ranking = team.ranking!;
              final int gd = ranking.goalDifference;
              final rank = index + 1;
              
              return DataRow(
                cells: [
                  DataCell(Text(rank.toString(), style: dataStyle)),
                  DataCell(
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage: team.logo != null && team.logo!.isNotEmpty
                              ? NetworkImage('${ConstKeys.baseUrl}/storage/$team.logo')
                              : null,
                          child: team.logo == null || team.logo!.isEmpty
                              ? const Icon(Icons.sports_soccer, color: Colors.grey)
                              : null,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            team.name,
                            style: headingStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(ranking.played.toString(), style: dataStyle)),
                  DataCell(Text(ranking.wins.toString(), style: dataStyle)),
                  DataCell(Text(ranking.draws.toString(), style: dataStyle)),
                  DataCell(Text(ranking.losses.toString(), style: dataStyle)),
                  DataCell(Text(ranking.owns.toString(), style: dataStyle)),
                  DataCell(Text(ranking.againsts.toString(), style: dataStyle)),
                  DataCell(
                    Text(
                      gd.toString(),
                      style: dataStyle.copyWith(
                        color: gd >= 0 ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                  DataCell(Text(ranking.points.toString(), style: dataStyle)),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  /// Returns the carousel slider displayed at the top of the page.
  Widget _buildCarousel() {
    return Stack(
      alignment: Alignment.center,
      children: [
        CarouselSlider(
          items: _sliderImages
              .map(
                (img) => ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.asset(img, width: 400, fit: BoxFit.fill),
                ),
              )
              .toList(),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              setState(() => _currentSlideIndex = index);
            },
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.zoom,
            autoPlayAnimationDuration: const Duration(seconds: 1),
            autoPlay: true,
            height: 170,
            viewportFraction: 1,
          ),
        ).paddingHorizontal(5),
        Positioned(
          bottom: 30,
          child: CustomSliderDots(
            length: _sliderImages.length,
            indexItem: _currentSlideIndex,
          ),
        ),
      ],
    );
  }

  /// Builds the manage team row consisting of an icon, team name and action button.
  ///
  /// The button has an explicit minimum width to avoid layout issues when the
  /// row is placed inside scrollable containers with unconstrained widths.
  Widget _manageTeamRow() {
    const darkBlue = Color(0xFF23425F);
    // Assume you have a field: List<dynamic> _userTeams; (add it to the class)
    // And you fetch it in _fetchUserTeams and store the result
    // We'll use the first team as the user's team for navigation
    final userTeamId = _userTeams.isNotEmpty
        ? (_userTeams.first['id'] as int)
        : null;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: const Color(0xFFF2F2F2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: darkBlue,
              child: const Icon(Icons.groups, color: Colors.white),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'ريـمونتادا',
                  style: const TextStyle(
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: userTeamId != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TeamDetailsPage(teamId: userTeamId),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  minimumSize: const Size(120, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleKeys.manage_your_team.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a banner prompting users without a team to create one.
  ///
  /// Displays an icon, a short message and a button that navigates to
  /// [CreateTeamPage] when pressed.
  Widget _buildCreateTeamBanner() {
    if (Utils.isSuperVisor ?? false) return const SizedBox.shrink();
    const darkBlue = Color(0xFF23425F);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        color: const Color(0xFFF2F2F2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: darkBlue,
              child: const Icon(Icons.group, color: Colors.white),
            ),
            Expanded(
              child: Center(
                child: Text(
                  LocaleKeys.challenge_create_team.tr(),
                  style: const TextStyle(
                    color: darkBlue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 36,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CreateTeamPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  minimumSize: const Size(120, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  LocaleKeys.challenge_create_team.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);

    // Show loading state while fetching team data
    if (_hasTeam == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomText(
                        LocaleKeys.challenge_updates.tr(),
                        color: darkBlue,
                        weight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCarousel(),
                const SizedBox(height: 18),
                // Loading indicator for team status
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF23425F)),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'جاري تحميل بيانات الفريق...',
                        style: TextStyle(
                          color: darkBlue,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Disabled tabs during loading
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F2F2).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: AbsorbPointer(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: false,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.all(2),
                        indicator: BoxDecoration(
                          color: darkBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelColor: Colors.white.withOpacity(0.7),
                        unselectedLabelColor: Colors.grey.withOpacity(0.5),
                        labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(text: LocaleKeys.challenges_nav.tr()),
                          Tab(text: LocaleKeys.league_results.tr()),
                          Tab(text: LocaleKeys.championships.tr()),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 21),
                // Disabled tab content during loading
                Expanded(
                  child: AbsorbPointer(
                    child: Opacity(
                      opacity: 0.5,
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                color: darkBlue.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                color: darkBlue.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                color: darkBlue.withOpacity(0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: (Utils.isSuperVisor ?? false)
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.createMatch);
              },
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_hasTeam == false && !(Utils.isSuperVisor ?? false))
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CreateTeamPage()),
                          );
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.group, color: darkBlue),
                            const SizedBox(height: 4),
                            CustomText(
                              LocaleKeys.challenge_create_team.tr(),
                              color: darkBlue,
                              weight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),

                    CustomText(
                      LocaleKeys.challenge_updates.tr(),
                      color: darkBlue,
                      weight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildCarousel(),
              (_hasTeam ?? false) ? _manageTeamRow() : _buildCreateTeamBanner(),
              18.ph,
              Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(2),
                    indicator: BoxDecoration(
                      color: darkBlue,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(text: LocaleKeys.challenges_nav.tr()),
                      Tab(text: LocaleKeys.league_results.tr()),
                      Tab(text: LocaleKeys.championships.tr()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 21),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          if ((_hasTeam ?? false) && _userRole == 'leader') ...[
                            _createChallengeButton(),
                            const SizedBox(height: 12),
                          ],
                          _completedChallengeCard(),
                          const SizedBox(height: 12),
                          if (_hasTeam ?? false) ...[
                            _joinChallengeCard(),
                            const SizedBox(height: 12),
                          ] else ...[
                            _noTeamPlaceholder(),
                            const SizedBox(height: 12),
                          ],
                          _howChallengesWorkCard(),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          _leagueHeaderCard(),
                          const SizedBox(height: 8),
                          _leagueTable(),
                        ],
                      ),
                    ),
                    SingleChildScrollView(
                      child: Column(
                        children: const [
                          SuperRemontadaChampionshipCard(),
                          SizedBox(height: 12),
                          EliteRemontadaChampionshipCard(),
                          SizedBox(height: 12),
                          RemontadaChampionsLeagueCard(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
