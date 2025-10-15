import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/features/home/presentation/widgets/custom_dots.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import '../../../../core/services/app_events.dart';
import '../../../../core/config/key.dart';
import '../../../../core/utils/utils.dart';
import '../../../../core/Router/Router.dart';
import '../../domain/model/challenge_overview_model.dart';
import '../../data/challenges_repository_impl.dart';
import '../../domain/model/challenge_match_model.dart';
import '../widgets/championship_card.dart';
import 'create_team_page.dart';
import 'team_details_page.dart';
import 'match_details_page.dart';

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

  List<ChallengeMatch> _matches = [];
  bool _loadingMatches = false;
  String? _matchesError;
  bool _isRefreshingMatches = false;

  // Pagination state
  int _currentPage = 1;
  int _lastPage = 1;
  bool _isLoadingMore = false;
  bool _hasMorePages = true;
  final ScrollController _matchesScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.hasTeam != null) {
      _hasTeam = widget.hasTeam;
      if (_hasTeam == true) {
        _fetchUserTeams().then((_) => _fetchUserRole());
      }
    } else {
      _fetchUserTeams().then((_) => _fetchUserRole());
    }
    _fetchChallengesOverview();
    _fetchMatches();
    _matchesScrollController.addListener(_onMatchesScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _matchesScrollController.dispose();
    try {
      AppEvents.matchesRefresh.removeListener(_onMatchesRefreshEvent);
    } catch (_) {}
    super.dispose();
  }

  void _onMatchesScroll() {
    if (_matchesScrollController.position.pixels >=
        _matchesScrollController.position.maxScrollExtent - 200) {
      if (_hasMorePages && !_isLoadingMore && !_loadingMatches) {
        _fetchMatchesPage(page: _currentPage + 1, append: true);
      }
    }
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _loadingMatches = true;
      _matchesError = null;
      _currentPage = 1;
      _hasMorePages = true;
      _lastPage = 1;
    });
    await _fetchMatchesPage(page: 1, append: false);
    setState(() => _loadingMatches = false);
  }

  Future<void> _fetchMatchesPage(
      {required int page, bool append = true}) async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    try {
      final res = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/challenges-index?page=$page'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );
      if (res.statusCode < 400) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['status'] == true) {
          final matchesData = data['data']['matches'] as List<dynamic>;
          final matches =
              matchesData.map((m) => ChallengeMatch.fromJson(m)).toList();
          final pagination =
              data['data']['pagination'] as Map<String, dynamic>?;
          final lastPage =
              pagination?['lastPage'] ?? pagination?['total_pages'] ?? 1;
          final currentPage = pagination?['currentPage'] ?? page;
          final nextPageUrl = pagination?['next_page_url'];

          setState(() {
            _lastPage = lastPage is int
                ? lastPage
                : int.tryParse(lastPage.toString()) ?? 1;
            _currentPage = currentPage is int
                ? currentPage
                : int.tryParse(currentPage.toString()) ?? page;
            if (append) {
              // Avoid duplicates
              final existingIds = _matches.map((m) => m.id).toSet();
              _matches
                  .addAll(matches.where((m) => !existingIds.contains(m.id)));
            } else {
              _matches = matches;
            }
            _hasMorePages = nextPageUrl != null;
          });
        }
      }
    } catch (e) {
      setState(() {
        _matchesError = 'Failed to load matches: $e';
        _hasMorePages = false;
      });
    } finally {
      setState(() => _isLoadingMore = false);
    }
  }

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

      print('🔍 DEBUG: Fetching user teams');
      print('📥 DEBUG: User teams response status: ${res.statusCode}');

      if (res.statusCode < 400) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        print('📊 DEBUG: User teams response: ${jsonEncode(data)}');

        if (data['status'] == true) {
          final teams = data['data'] as List<dynamic>;
          print('👥 DEBUG: Found ${teams.length} teams');

          for (int i = 0; i < teams.length; i++) {
            print('🏆 DEBUG: Team $i: ${jsonEncode(teams[i])}');
          }

          setState(() {
            _userTeams = teams;
            _hasTeam = teams.isNotEmpty;
          });
          // Fetch user role if they have teams
          if (teams.isNotEmpty) {
            _fetchUserRole();
          }
          return;
        } else {
          print(
              '❌ DEBUG: User teams API returned status false: ${data['message']}');
        }
      } else {
        print('❌ DEBUG: User teams API failed with status: ${res.statusCode}');
      }
    } catch (e) {
      print('💥 DEBUG: Error fetching user teams: $e');
    }
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

      print('🔍 DEBUG: Fetching user role for team $teamId');
      print('📥 DEBUG: Team details response status: ${res.statusCode}');

      if (res.statusCode < 400) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        print('📊 DEBUG: Team details response data: ${jsonEncode(data)}');

        if (data['status'] == true) {
          final teamData = data['data'] as Map<String, dynamic>;
          final users = teamData['users'] as List<dynamic>? ?? [];
          print('👥 DEBUG: Team users count: ${users.length}');

          // Find current user's role
          final currentUserPhone = Utils.user.user?.phone;
          print('📱 DEBUG: Current user phone: $currentUserPhone');

          if (currentUserPhone != null) {
            for (final user in users) {
              if (user is Map<String, dynamic>) {
                final userMobile = user['mobile']?.toString();
                final userRole = user['role']?.toString();
                print(
                    '👤 DEBUG: Checking user - Mobile: $userMobile, Role: $userRole');

                if (userMobile == currentUserPhone) {
                  print('✅ DEBUG: Found current user! Role: $userRole');
                  setState(() => _userRole = userRole);
                  return;
                }
              }
            }
            print('❌ DEBUG: Current user not found in team members list');
          } else {
            print('❌ DEBUG: Current user phone is null');
          }
        } else {
          print(
              '❌ DEBUG: Team details API returned status false: ${data['message']}');
        }
      } else {
        print(
            '❌ DEBUG: Team details API failed with status: ${res.statusCode}');
      }
    } catch (e) {
      print('💥 DEBUG: Error fetching user role: $e');
    }
    setState(() => _userRole = null);
  }

  /// Helper method to check if the current user is a team captain/leader
  /// Handles different possible role values and formats
  bool _isUserCaptain() {
    if (_userRole == null) {
      print('🔍 DEBUG: User role is null, not leader/captain');
      return false;
    }

    final role = _userRole!.toLowerCase().trim();
    print('🔍 DEBUG: Checking role (normalized): "$role"');

    // Check for different possible captain role values
    final captainRoles = [
      'leader', // Primary captain role
      'captain',
      'cap',
      'كابتن',
      'قائد',
      'coach',
      'مدرب',
      '1', // In case role is stored as numeric
    ];

    for (final captainRole in captainRoles) {
      if (role == captainRole.toLowerCase()) {
        print('✅ DEBUG: User is leader/captain (matched: $captainRole)');
        return true;
      }
    }

    // Additional fallback: Check if user is the team creator/owner
    if (_userTeams.isNotEmpty) {
      final currentUserPhone = Utils.user.user?.phone;
      final team = _userTeams[0];

      // Check if team has owner_phone or creator_phone field
      final ownerPhone = team['owner_phone']?.toString() ??
          team['creator_phone']?.toString() ??
          team['phone']?.toString();

      if (currentUserPhone != null && ownerPhone != null) {
        if (currentUserPhone == ownerPhone) {
          print('✅ DEBUG: User is leader/captain (team owner/creator)');
          return true;
        }
      }
    }

    print('❌ DEBUG: User role "$role" does not match leader/captain roles');
    return false;
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

  /// Fetches the list of challenges/matches from the API.

  void _onMatchesRefreshEvent() {
    // Re-fetch matches when an external event requests a refresh.
    // Backend may be eventually consistent, so retry a couple of times with short delays
    // to increase chance the newly-created match appears immediately.
    if (_isRefreshingMatches) return;
    _isRefreshingMatches = true;
    () async {
      try {
        await _fetchMatches();
        for (var attempt = 0; attempt < 2; attempt++) {
          await Future.delayed(const Duration(seconds: 1));
          await _fetchMatches();
        }
      } catch (_) {
      } finally {
        _isRefreshingMatches = false;
      }
    }();
  }

  /// Builds the card displaying a completed challenge summary.
  Widget _completedChallengeCard([ChallengeMatch? match]) {
    const borderColor = Color(0xFFD4EDDA);
    const badgeColor = Color(0xFFE6F4EA);
    const badgeTextColor = Color(0xFF28A745);
    const buttonColor = Color(0xFF23425F);

    final badgeText = match != null
        ? (match.isPast
            ? 'تحدي مكتمل - ${match.playground} - ${match.date} ${match.startTime}'
            : 'تحدي جاهز - ${match.playground} - ${match.date} ${match.startTime}')
        : '';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
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
                        children: [
                          Icon(Icons.check_circle,
                              color: badgeTextColor, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            badgeText,
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
                      // Slot 1 - Left side (before VS)
                      _buildCompletedTeamSlot(
                        match: match,
                        team: match?.team1,
                        isSlot1: true,
                      ),
                      // VS Section with competitive badge
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
                          const SizedBox(height: 8),
                          _buildCompetitiveBadge(match),
                        ],
                      ),
                      // Slot 2 - Right side (after VS)
                      _buildCompletedTeamSlot(
                        match: match,
                        team: match?.team2,
                        isSlot1: false,
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
                        onPressed: () {
                          if (match != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MatchDetailsPage(match: match),
                              ),
                            );
                          }
                        },
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
          ],
        ),
      ),
    );
  }

  /// Builds the card allowing a user to join an upcoming challenge.
  Widget _joinChallengeCard([ChallengeMatch? match]) {
    const borderColor = Color(0xFFFEEBCB);
    const badgeColor = Color(0xFFFFF3E0);
    const highlightColor = Color(0xFFF9A825);

    final badgeText = match != null
        ? 'انضم للتحدي - ${match.playground} - ${match.date} ${match.startTime}'
        : '';

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
                    children: [
                      Icon(Icons.access_time, color: highlightColor, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        badgeText,
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
                  // Slot 1 - Left side (before VS)
                  _buildTeamSlot(
                    match: match,
                    team: match?.team1,
                    isSlot1: true,
                    highlightColor: highlightColor,
                    badgeColor: badgeColor,
                  ),
                  // VS Section with competitive badge
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
                      const SizedBox(height: 8),
                      _buildCompetitiveBadge(match),
                    ],
                  ),
                  // Slot 2 - Right side (after VS)
                  _buildTeamSlot(
                    match: match,
                    team: match?.team2,
                    isSlot1: false,
                    highlightColor: highlightColor,
                    badgeColor: badgeColor,
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

  /// Builds a card for a challenge match based on its state.
  Widget _buildMatchCard(ChallengeMatch match) {
    if (match.team1 != null && match.team2 != null) {
      return _completedChallengeCard(match);
    } else {
      return _joinChallengeCard(match);
    }
  }

  /// Helper function to get the appropriate image provider for a team logo.
  ImageProvider _getTeamLogoImage(String? logoUrl) {
    if (logoUrl != null && logoUrl.isNotEmpty && logoUrl.startsWith('http')) {
      return NetworkImage(logoUrl);
    }
    return const AssetImage('assets/images/profile_image.png');
  }

  /// Builds a team slot with conditional logic for team display
  Widget _buildTeamSlot({
    required ChallengeMatch? match,
    required Map<String, dynamic>? team,
    required bool isSlot1,
    required Color highlightColor,
    required Color badgeColor,
  }) {
    // Case 1: Both teams are null - only show reserve button in slot 1
    if (match?.team1 == null && match?.team2 == null) {
      if (isSlot1) {
        return _buildActionSlot(
          text: LocaleKeys.challenge_reserve_match.tr(),
          onTap: () => _showReserveMatchDialog(match),
          highlightColor: highlightColor,
          badgeColor: badgeColor,
        );
      } else {
        return _buildEmptySlot();
      }
    }

    // Case 2: Only team1 exists, team2 is null
    if (match?.team1 != null && match?.team2 == null) {
      if (isSlot1) {
        return _buildTeamInfo(team: match!.team1!);
      } else {
        return _buildActionSlot(
          text: LocaleKeys.challenge_join_match.tr(),
          onTap: () => _showJoinChallengeDialog(match),
          highlightColor: highlightColor,
          badgeColor: badgeColor,
        );
      }
    }

    // Case 3: Both teams exist
    if (match?.team1 != null && match?.team2 != null) {
      if (isSlot1) {
        return _buildTeamInfo(team: match!.team1!);
      } else {
        return _buildTeamInfo(team: match!.team2!);
      }
    }

    // Default case - empty slot
    return _buildEmptySlot();
  }

  /// Builds a team slot for completed challenge cards (simplified logic)
  Widget _buildCompletedTeamSlot({
    required ChallengeMatch? match,
    required Map<String, dynamic>? team,
    required bool isSlot1,
  }) {
    if (team != null) {
      return _buildTeamInfo(team: team);
    } else {
      return _buildEmptySlot();
    }
  }

  /// Builds team info display with name and logo
  Widget _buildTeamInfo({required Map<String, dynamic> team}) {
    final teamName = team['name']?.toString() ?? '';
    final teamLogo = team['logo_url']?.toString();

    return Column(
      children: [
        Text(
          teamName,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        CircleAvatar(
          radius: 20,
          backgroundImage: _getTeamLogoImage(teamLogo),
          child: teamLogo == null ||
                  teamLogo.isEmpty ||
                  !teamLogo.startsWith('http')
              ? const Icon(Icons.groups, color: Colors.grey)
              : null,
        ),
      ],
    );
  }

  /// Builds action slot with + icon and text
  Widget _buildActionSlot({
    required String text,
    required VoidCallback onTap,
    required Color highlightColor,
    required Color badgeColor,
  }) {
    return Column(
      children: [
        Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: badgeColor,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: highlightColor),
          ),
        ),
      ],
    );
  }

  /// Builds empty slot
  Widget _buildEmptySlot() {
    return const Column(
      children: [
        SizedBox(height: 20), // Match text height
        SizedBox(height: 4),
        SizedBox(
          width: 40,
          height: 40, // Match avatar height
        ),
      ],
    );
  }

  /// Builds a competitive badge for matches that have at least one team
  Widget _buildCompetitiveBadge(ChallengeMatch? match) {
    // Only show badge if match has at least one team
    if (match == null || (match.team1 == null && match.team2 == null)) {
      return const SizedBox.shrink();
    }

    final isCompetitive = match.isCompetitive ?? false;
    final badgeColor = isCompetitive
        ? const Color(0xFF28A745) // Green for competitive
        : const Color(0xFF6C757D); // Gray for friendly

    final badgeText = isCompetitive
        ? LocaleKeys.challenge_competitive_match.tr()
        : LocaleKeys.create_match_friendly.tr();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isCompetitive ? Icons.emoji_events : Icons.sports_soccer,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 2),
          Text(
            badgeText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a button for supervisors to create challenge matches.
  // Supervisor challenge match button removed — button should not appear for any user.

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
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Builds a card explaining how challenges work.
  Widget _buildHowChallengesWorkCard() {
    const infoColor = Color(0xFF17A2B8);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
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
      ..sort(
          (a, b) => (b.ranking?.points ?? 0).compareTo(a.ranking?.points ?? 0));

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
                          backgroundImage:
                              team.logo != null && team.logo!.isNotEmpty
                                  ? NetworkImage(
                                      '${ConstKeys.baseUrl}/storage/$team.logo')
                                  : null,
                          child: team.logo == null || team.logo!.isEmpty
                              ? const Icon(Icons.sports_soccer,
                                  color: Colors.grey)
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: CarouselSlider(
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
          ),
        ),
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
    final userTeamId =
        _userTeams.isNotEmpty ? (_userTeams.first['id'] as int) : null;
    final userTeamName =
        _userTeams.isNotEmpty ? (_userTeams.first['name'] as String?) : null;
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
                  userTeamName ?? 'ريـمونتادا',
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
                    MaterialPageRoute(builder: (_) => const CreateTeamPage()),
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
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF23425F)),
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
                      color: const Color(0xFFF2F2F2).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: AbsorbPointer(
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: false,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorPadding: const EdgeInsets.all(2),
                        indicator: BoxDecoration(
                          color: darkBlue.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        labelColor: Colors.white.withValues(alpha: 0.7),
                        unselectedLabelColor:
                            Colors.grey.withValues(alpha: 0.5),
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
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
                                color: darkBlue.withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                color: darkBlue.withValues(alpha: 0.7),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              'جاري التحميل...',
                              style: TextStyle(
                                color: darkBlue.withValues(alpha: 0.7),
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
              const SizedBox(height: 18),
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
                    NotificationListener<ScrollNotification>(
                      onNotification: (scrollInfo) {
                        if (scrollInfo.metrics.pixels >=
                            scrollInfo.metrics.maxScrollExtent - 200) {
                          if (_hasMorePages &&
                              !_isLoadingMore &&
                              !_loadingMatches) {
                            _fetchMatchesPage(
                                page: _currentPage + 1, append: true);
                          }
                        }
                        return false;
                      },
                      child: ListView.builder(
                        controller: _matchesScrollController,
                        itemCount: _matches.length + 2,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            return const SizedBox(height: 12);
                          }
                          if (index == _matches.length + 1) {
                            if (_loadingMatches) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (_matchesError != null) {
                              return Center(child: Text(_matchesError!));
                            } else if (_isLoadingMore) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            } else if (!_hasMorePages) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                    child: Text(
                                        'لا توجد مباريات أخرى للعرض')), // No more matches
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }
                          final match = _matches[index - 1];
                          return Column(
                            children: [
                              _buildMatchCard(match),
                              const SizedBox(height: 12),
                            ],
                          );
                        },
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
                    Stack(
                      children: [
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
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 8,
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.access_time,
                                        color: Colors.orange, size: 28),
                                    const SizedBox(width: 12),
                                    Text(
                                      'قريباً',
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  /// Shows a custom dialog for joining a challenge
  void _showJoinChallengeDialog(ChallengeMatch? match) {
    print('🔍 DEBUG: Showing join challenge dialog');
    print(
        '📋 DEBUG: Match ID: ${match?.id}, Playground: ${match?.playground}, Date: ${match?.date}');
    print('👥 DEBUG: Team1: ${match?.team1}, Team2: ${match?.team2}');

    if (_userTeams.isEmpty) {
      print('❌ DEBUG: User has no teams - cannot join challenge');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يجب أن تكون عضواً في فريق للانضمام للتحدي'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('✅ DEBUG: User has ${_userTeams.length} team(s)');
    print('👤 DEBUG: Current user team: ${_userTeams[0]}');

    final team1Name = match?.team1?['name'] ?? '';
    final team1Logo = match?.team1?['logo_url']?.toString();
    final playground = match?.playground ?? '';
    final date = match?.date ?? '';
    final startTime = match?.startTime ?? '';

    print(
        '🏟️ DEBUG: Challenge details - Playground: $playground, Date: $date, Time: $startTime');
    print('👥 DEBUG: Opposing team: $team1Name');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text(
              'طلب الانضمام للتحدي',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF23425F),
              ),
              textAlign: TextAlign.center,
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Challenge details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'تفاصيل التحدي',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFF23425F),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Color(0xFF6C757D), size: 20),
                          const SizedBox(width: 8),
                          Text('الملعب: $playground'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.calendar_today,
                              color: Color(0xFF6C757D), size: 20),
                          const SizedBox(width: 8),
                          Text('التاريخ: $date'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Color(0xFF6C757D), size: 20),
                          const SizedBox(width: 8),
                          Text('الوقت: $startTime'),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Team information
                const Text(
                  'الفريق الخصم',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF23425F),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: _getTeamLogoImage(team1Logo),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      team1Name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Confirmation message
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFFEAA7)),
                  ),
                  child: const Text(
                    'هل أنت متأكد من إرسال طلب الانضمام لهذا التحدي؟ سيتم إرسال الطلب إلى فريق الخصم للموافقة.',
                    style: TextStyle(
                      color: Color(0xFF856404),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(color: Color(0xFF6C757D)),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  print(
                      '✅ DEBUG: User confirmed join request - proceeding to send API call');
                  Navigator.of(context).pop();
                  _sendJoinRequest(match);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF23425F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'إرسال الطلب',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Sends a join request to the challenge API
  Future<void> _sendJoinRequest(ChallengeMatch? match) async {
    if (match == null || _userTeams.isEmpty) {
      print(
          '🔍 DEBUG: Cannot send join request - match is null or user has no teams');
      return;
    }

    final matchId = match.id;
    final invitedTeamId = _userTeams[0]['id'];
    final requestUrl = '${ConstKeys.baseUrl}/challenge/send-team-match-request';

    print('🚀 DEBUG: Sending join request to: $requestUrl');
    print(
        '📤 DEBUG: Request body: {match_id: $matchId, invited_team_id: $invitedTeamId}');
    print('🔑 DEBUG: Authorization header: Bearer ${Utils.token}');

    try {
      final response = await http.post(
        Uri.parse(requestUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
        body: jsonEncode({
          'match_id': matchId,
          'invited_team_id': invitedTeamId,
        }),
      );

      print('📥 DEBUG: Response status code: ${response.statusCode}');
      print('📥 DEBUG: Response body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        print('✅ DEBUG: Join request sent successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(responseData['message'] ?? 'تم إرسال طلب الانضمام بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        print(
            '❌ DEBUG: Join request failed - Status: ${responseData['status']}, Message: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text(responseData['message'] ?? 'فشل في إرسال طلب الانضمام'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('💥 DEBUG: Error sending join request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Fetches team members for a specific team
  Future<List<Map<String, dynamic>>> _fetchTeamMembers(int teamId) async {
    try {
      print('🔍 DEBUG: Fetching members for team $teamId');
      final res = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/team/show/$teamId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );

      print('📥 DEBUG: Team members response status: ${res.statusCode}');

      if (res.statusCode < 400) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        if (data['status'] == true) {
          final team = data['data'] as Map<String, dynamic>;
          final users = team['users'] as List<dynamic>? ?? [];
          
          print('👥 DEBUG: Found ${users.length} team members');
          
          // Convert to List<Map<String, dynamic>> and filter out nulls
          final members = users
              .where((u) => u is Map<String, dynamic>)
              .map((u) => u as Map<String, dynamic>)
              .toList();
          
          return members;
        }
      }
    } catch (e) {
      print('💥 DEBUG: Error fetching team members: $e');
    }
    return [];
  }

  /// Shows a dialog to confirm match reservation
  Future<void> _showReserveMatchDialog(ChallengeMatch? match) async {
    print('🔍 DEBUG: Showing reserve match dialog');
    print(
        '📋 DEBUG: Match ID: ${match?.id}, Playground: ${match?.playground}, Date: ${match?.date}');
    print('👤 DEBUG: Current user role: $_userRole');
    print(
        '👥 DEBUG: User teams: ${_userTeams.map((t) => t['name']).join(', ')}');

    // Check if user has teams
    if (_userTeams.isEmpty) {
      print('❌ DEBUG: User has no teams - cannot reserve match');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يجب أن تكون عضواً في فريق لحجز المباراة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Enhanced leader/captain check - handle different possible role values
    final isCaptain = _isUserCaptain();
    print('👑 DEBUG: Is user leader/captain? $isCaptain (Role: $_userRole)');

    if (!isCaptain) {
      print('❌ DEBUG: User is not leader/captain - Role: $_userRole');

      // Try to re-fetch user role in case it was not loaded properly
      print('🔄 DEBUG: Re-fetching user role to verify...');
      await _fetchUserRole();
      final isCapatinAfterRefresh = _isUserCaptain();
      print(
          '🔄 DEBUG: After refresh - Is leader/captain? $isCapatinAfterRefresh (Role: $_userRole)');

      if (!isCapatinAfterRefresh) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${LocaleKeys.challenge_captain_required.tr()}\nدورك الحالي: ${_userRole ?? "غير محدد"}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        return;
      }
    }

    print('✅ DEBUG: User is captain with ${_userTeams.length} team(s)');

    // Fetch team members before showing dialog
    final teamId = _userTeams[0]['id'] as int;
    final teamMembers = await _fetchTeamMembers(teamId);
    
    if (teamMembers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('لا يوجد أعضاء في الفريق'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final playground = match?.playground ?? '';
    final date = match?.date ?? '';
    final startTime = match?.startTime ?? '';
    final userTeamName = _userTeams[0]['name'] ?? '';
    final userTeamLogo = _userTeams[0]['logo_url']?.toString();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        bool isCompetitive = false; // Default value for the toggle
        Set<int> selectedPlayerIds = {}; // Track selected player IDs

        return Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (context, setState) {
              // Validation: Check if at least 10 players are selected
              final bool canSubmit = selectedPlayerIds.length >= 10;
              
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                title: Text(
                  LocaleKeys.challenge_reserve_title.tr(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF23425F),
                  ),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    // Match details
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE9ECEF)),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'تفاصيل المباراة',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Color(0xFF23425F),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Color(0xFF6C757D), size: 20),
                              const SizedBox(width: 8),
                              Text('الملعب: $playground'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.calendar_today,
                                  color: Color(0xFF6C757D), size: 20),
                              const SizedBox(width: 8),
                              Text('التاريخ: $date'),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.access_time,
                                  color: Color(0xFF6C757D), size: 20),
                              const SizedBox(width: 8),
                              Text('الوقت: $startTime'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // User's team information
                    const Text(
                      'فريقك',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF23425F),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundImage: _getTeamLogoImage(userTeamLogo),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          userTeamName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Competitive toggle
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE9ECEF)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              LocaleKeys.challenge_competitive_match.tr(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFF23425F),
                              ),
                            ),
                          ),
                          Switch(
                            value: isCompetitive,
                            onChanged: (value) {
                              setState(() {
                                isCompetitive = value;
                              });
                            },
                            activeColor: const Color(0xFF23425F),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Competitive description
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCompetitive
                            ? const Color(0xFFE6F4EA)
                            : const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                            color: isCompetitive
                                ? const Color(0xFF28A745)
                                : const Color(0xFFE9ECEF)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isCompetitive
                                ? Icons.emoji_events
                                : Icons.sports_soccer,
                            color: isCompetitive
                                ? const Color(0xFF28A745)
                                : const Color(0xFF6C757D),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              isCompetitive
                                  ? LocaleKeys.challenge_competitive_description
                                      .tr()
                                  : LocaleKeys.challenge_friendly_description
                                      .tr(),
                              style: TextStyle(
                                fontSize: 12,
                                color: isCompetitive
                                    ? const Color(0xFF28A745)
                                    : const Color(0xFF6C757D),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Player Selection Section
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FA),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE9ECEF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'اختر اللاعبين للمباراة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF23425F),
                                ),
                              ),
                              Text(
                                '${selectedPlayerIds.length}/10',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: selectedPlayerIds.length >= 10
                                      ? const Color(0xFF28A745)
                                      : const Color(0xFFDC3545),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'يجب اختيار 10 لاعبين على الأقل',
                            style: TextStyle(
                              fontSize: 12,
                              color: selectedPlayerIds.length >= 10
                                  ? const Color(0xFF28A745)
                                  : const Color(0xFFDC3545),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Players list with checkboxes
                          Container(
                            constraints: const BoxConstraints(maxHeight: 300),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: teamMembers.length,
                              itemBuilder: (context, index) {
                                final member = teamMembers[index];
                                final memberId = member['id'] as int?;
                                final memberName = member['name'] as String? ?? 'لا يوجد اسم';
                                final memberPhone = (member['mobile'] ?? member['phone'] ?? 'لا يوجد رقم') as String;
                                
                                if (memberId == null) return const SizedBox.shrink();
                                
                                final isSelected = selectedPlayerIds.contains(memberId);
                                
                                return CheckboxListTile(
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  controlAffinity: ListTileControlAffinity.leading,
                                  value: isSelected,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        selectedPlayerIds.add(memberId);
                                      } else {
                                        selectedPlayerIds.remove(memberId);
                                      }
                                    });
                                  },
                                  title: Text(
                                    memberName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  subtitle: Text(
                                    memberPhone,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  activeColor: const Color(0xFF23425F),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Confirmation message
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3CD),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFFFEAA7)),
                      ),
                      child: Text(
                        LocaleKeys.challenge_reserve_confirm.tr(),
                        style: const TextStyle(
                          color: Color(0xFF856404),
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ],
                  ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'إلغاء',
                      style: TextStyle(color: Color(0xFF6C757D)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: canSubmit
                        ? () {
                            if (selectedPlayerIds.length < 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('يجب اختيار 10 لاعبين على الأقل'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }
                            print(
                                '✅ DEBUG: User confirmed reservation - proceeding to book match (competitive: $isCompetitive, players: ${selectedPlayerIds.length})');
                            Navigator.of(context).pop();
                            _sendReserveRequest(
                              match,
                              isCompetitive: isCompetitive,
                              playerIds: selectedPlayerIds.toList(),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: canSubmit
                          ? const Color(0xFF23425F)
                          : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'تأكيد الحجز',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  /// Sends a reserve match request to the API
  Future<void> _sendReserveRequest(
    ChallengeMatch? match, {
    bool isCompetitive = false,
    List<int>? playerIds,
  }) async {
    if (match == null || _userTeams.isEmpty) {
      print(
          '🔍 DEBUG: Cannot send reserve request - match is null or user has no teams');
      return;
    }

    final matchId = match.id;
    final teamId = _userTeams[0]['id'];
    final requestUrl = '${ConstKeys.baseUrl}/challenge/book-match';

    print('🚀 DEBUG: Sending reserve request to: $requestUrl');
    print(
        '📤 DEBUG: Request body: {team_id: $teamId, match_id: $matchId, is_competitive: ${isCompetitive ? 1 : 0}, players: $playerIds}');
    print('🔑 DEBUG: Authorization header: Bearer ${Utils.token}');

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final requestBody = <String, dynamic>{
        'team_id': teamId,
        'match_id': matchId,
        'is_competitive': isCompetitive ? 1 : 0,
      };
      
      // Add players array if provided
      if (playerIds != null && playerIds.isNotEmpty) {
        requestBody['players'] = playerIds;
      }
      
      final response = await http.post(
        Uri.parse(requestUrl),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 DEBUG: Response status code: ${response.statusCode}');
      print('📥 DEBUG: Response body: ${response.body}');

      // Hide loading indicator
      Navigator.of(context).pop();

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        print('✅ DEBUG: Match reserved successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(LocaleKeys.challenge_reserve_success.tr()),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh matches to reflect the new booking
        _fetchMatches();
      } else {
        print(
            '❌ DEBUG: Reserve request failed - Status: ${responseData['status']}, Message: ${responseData['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'فشل في حجز المباراة'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('💥 DEBUG: Error sending reserve request: $e');
      // Hide loading indicator
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('حدث خطأ في الاتصال. يرجى المحاولة مرة أخرى.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
