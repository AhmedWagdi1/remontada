import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/challenge_request_model.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/core/app_strings/locale_keys.dart';

class ChallengeNotificationsWidget extends StatefulWidget {
  const ChallengeNotificationsWidget({super.key});

  @override
  State<ChallengeNotificationsWidget> createState() => _ChallengeNotificationsWidgetState();
}

class _ChallengeNotificationsWidgetState extends State<ChallengeNotificationsWidget> with WidgetsBindingObserver {
  List<ChallengeRequest> _challengeRequests = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadChallengeRequests();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // Refresh when app comes to foreground
    if (state == AppLifecycleState.resumed && mounted) {
      print('🔄 DEBUG: App resumed, refreshing challenge notifications');
      _loadChallengeRequests();
    }
  }

  Future<void> _loadChallengeRequests() async {
    final cubit = HomeCubit.get(context);
    await cubit.getChallengeRequests();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is ChallengeRequestsLoading) {
          setState(() => _isLoading = true);
        } else if (state is ChallengeRequestsLoaded) {
          final pendingCount = state.requests.where((request) => request.isPending).length;
          print('🔔 DEBUG: Notification widget received ${state.requests.length} total requests, ${pendingCount} pending');
          
          setState(() {
            _challengeRequests = state.requests;
            _isLoading = false;
          });
        } else if (state is ChallengeRequestsFailed) {
          setState(() => _isLoading = false);
          // You might want to show a snackbar or error message here
        }
      },
      child: _buildNotificationCard(),
    );
  }

  Widget _buildNotificationCard() {
    final pendingCount = HomeCubit.get(context).getPendingChallengeRequestsCount(_challengeRequests);

    if (pendingCount == 0 && !_isLoading) {
      return const SizedBox.shrink(); // Don't show if no pending requests
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.primaryColor.withOpacity(0.1),
            context.primaryColor.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Icon with badge
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: context.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.sports_soccer,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              if (pendingCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 20,
                      minHeight: 20,
                    ),
                    child: Center(
                      child: Text(
                        pendingCount > 99 ? '99+' : pendingCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  LocaleKeys.challenge_requests.tr(),
                  style: TextStyle(
                    color: context.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                CustomText(
                  _isLoading
                      ? LocaleKeys.challenge_loading.tr()
                      : pendingCount == 1
                          ? LocaleKeys.challenge_single_request.tr()
                          : LocaleKeys.challenge_multiple_requests.tr(args: [pendingCount.toString()]),
                  style: TextStyle(
                    color: LightThemeColors.secondaryText,
                    fontSize: 14,
                  ),
                ),
                if (_challengeRequests.isNotEmpty && !_isLoading) ...[
                  SizedBox(height: 8),
                  CustomText(
                    '${LocaleKeys.challenge_latest.tr()} ${_getLatestRequestText()}',
                    style: TextStyle(
                      color: LightThemeColors.surfaceSecondary,
                      fontSize: 12,
                    ),
                    maxLine: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Arrow icon
          Icon(
            Icons.arrow_forward_ios,
            color: context.primaryColor,
            size: 16,
          ),
        ],
      ),
    ).onTap(() {
      // Navigate to challenges screen or show challenge requests
      _navigateToChallenges();
    });
  }

  String _getLatestRequestText() {
    if (_challengeRequests.isEmpty) return '';

    final latestRequest = _challengeRequests
        .where((request) => request.isPending)
        .fold<ChallengeRequest?>(
          null,
          (previous, current) => previous == null ||
                  DateTime.parse(current.createdAt).isAfter(DateTime.parse(previous.createdAt))
              ? current
              : previous,
        );

    if (latestRequest == null) return '';

  return '${latestRequest.fromTeamName} ${LocaleKeys.challenge_challenged_you.tr(namedArgs: {'date': latestRequest.formattedDate})}';
  }

  void _navigateToChallenges() {
    final pendingRequests = _challengeRequests.where((request) => request.isPending).toList();
    print('🧭 DEBUG: Navigating - Found ${pendingRequests.length} pending requests');
    
    if (pendingRequests.length == 1) {
      // If only one pending request, navigate directly to details
      print('🧭 DEBUG: Navigating to single request details');
      Navigator.pushNamed(
        context,
        Routes.challengeRequestDetailsScreen,
        arguments: pendingRequests.first.id,
      ).then((_) {
        // Refresh challenge notifications when returning from details
        print('🔄 DEBUG: Returned from challenge details, refreshing notifications');
        _loadChallengeRequests();
      });
    } else if (pendingRequests.length > 1) {
      // If multiple pending requests, navigate to challenge requests list screen
      print('🧭 DEBUG: Navigating to challenge requests list screen');
      Navigator.pushNamed(
        context, 
        Routes.challengeRequestsScreen,
        arguments: pendingRequests, // Pass the pending requests directly
      ).then((_) {
        // Refresh challenge notifications when returning from list
        print('🔄 DEBUG: Returned from challenge requests list, refreshing notifications');
        _loadChallengeRequests();
      });
    } else {
      // If no pending requests, navigate to general challenges screen
      print('🧭 DEBUG: Navigating to general challenges screen (no pending requests)');
      Navigator.pushNamed(context, Routes.challengesScreen).then((_) {
        // Refresh challenge notifications when returning from challenges screen
        print('🔄 DEBUG: Returned from challenges screen, refreshing notifications');
        _loadChallengeRequests();
      });
    }
  }
}
