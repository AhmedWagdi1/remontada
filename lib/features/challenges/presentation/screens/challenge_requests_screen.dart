import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/extensions/all_extensions.dart';
import 'package:remontada/core/theme/light_theme.dart';
import 'package:remontada/features/home/cubit/home_cubit.dart';
import 'package:remontada/features/home/cubit/home_states.dart';
import 'package:remontada/features/home/domain/model/challenge_request_model.dart';
import 'package:remontada/shared/widgets/customtext.dart';
import 'package:remontada/core/Router/Router.dart';
import 'package:remontada/shared/widgets/network_image.dart';

/// Screen displaying list of pending challenge requests for the user
class ChallengeRequestsScreen extends StatefulWidget {
  const ChallengeRequestsScreen({super.key});

  @override
  State<ChallengeRequestsScreen> createState() => _ChallengeRequestsScreenState();
}

class _ChallengeRequestsScreenState extends State<ChallengeRequestsScreen> {
  List<ChallengeRequest> _challengeRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChallengeRequests();
  }

  Future<void> _fetchChallengeRequests() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final homeCubit = context.read<HomeCubit>();
      await homeCubit.getChallengeRequests();
      
      if (mounted) {
        final state = homeCubit.state;
        if (state is ChallengeRequestsLoaded) {
          setState(() {
            _challengeRequests = state.requests.where((request) => request.isPending).toList();
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: const CustomText(
            'طلبات التحديات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: context.primaryColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          color: context.primaryColor,
        ),
      );
    }

    if (_challengeRequests.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _fetchChallengeRequests,
      color: context.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _challengeRequests.length,
        itemBuilder: (context, index) {
          final request = _challengeRequests[index];
          return _buildChallengeRequestCard(request);
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: context.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.sports_soccer,
              size: 64,
              color: context.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          CustomText(
            'لا توجد طلبات تحديات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: LightThemeColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          const CustomText(
            'لم تستلم أي طلبات تحديات من الفرق الأخرى حتى الآن',
            style: TextStyle(
              fontSize: 14,
              color: LightThemeColors.secondaryText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChallengeRequestCard(ChallengeRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: context.primaryColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Header Section
          Container(
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // Challenge Icon with Badge
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
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.priority_high,
                          color: Colors.white,
                          size: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),

                // Challenge Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        'طلب تحدي',
                        style: TextStyle(
                          color: context.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      CustomText(
                        'من فريق ${request.fromTeamName}',
                        style: const TextStyle(
                          color: LightThemeColors.secondaryText,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      CustomText(
                        request.formattedDate,
                        style: TextStyle(
                          color: LightThemeColors.surfaceSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.withOpacity(0.3)),
                  ),
                  child: const CustomText(
                    'قيد الانتظار',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Team Info Section
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // From Team
                _buildTeamRow(
                  'الفريق المتحدي',
                  request.fromTeamName,
                  request.fromTeam?['logo_url'],
                  Icons.arrow_upward,
                  context.primaryColor,
                ),
                
                const SizedBox(height: 12),
                
                // VS Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: context.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const CustomText(
                        'VS',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // To Team (Your Team)
                _buildTeamRow(
                  'فريقك',
                  request.toTeamName,
                  request.toTeam?['logo_url'],
                  Icons.arrow_downward,
                  Colors.green,
                ),
              ],
            ),
          ),

          // Action Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _viewRequestDetails(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: context.primaryColor,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const CustomText(
                      'عرض التفاصيل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _quickReject(request),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const CustomText(
                      'رفض',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamRow(
    String label,
    String teamName,
    String? logoUrl,
    IconData icon,
    Color iconColor,
  ) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 8),
        CustomText(
          label,
          style: TextStyle(
            color: LightThemeColors.secondaryText,
            fontSize: 12,
          ),
        ),
        const SizedBox(width: 8),
        
        // Team Logo
        if (logoUrl != null && logoUrl.isNotEmpty) ...[
          NetworkImagesWidgets(
            logoUrl,
            width: 24,
            height: 24,
            radius: 12,
          ),
          const SizedBox(width: 8),
        ],
        
        Expanded(
          child: CustomText(
            teamName,
            style: TextStyle(
              color: LightThemeColors.primaryText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _viewRequestDetails(ChallengeRequest request) {
    Navigator.pushNamed(
      context,
      Routes.challengeRequestDetailsScreen,
      arguments: request.id,
    ).then((_) {
      // Refresh the list when returning from details screen
      _fetchChallengeRequests();
    });
  }

  void _quickReject(ChallengeRequest request) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                const Icon(Icons.warning, color: Colors.red, size: 24),
                const SizedBox(width: 8),
                const CustomText(
                  'تأكيد رفض الطلب',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: CustomText(
              'هل تريد رفض طلب التحدي من فريق ${request.fromTeamName}؟ لن تتمكن من التراجع عن هذا القرار.',
              style: TextStyle(
                color: LightThemeColors.secondaryText,
                fontSize: 14,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const CustomText(
                  'إلغاء',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  // TODO: Implement reject functionality
                  _rejectChallenge(request);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const CustomText(
                  'رفض',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _rejectChallenge(ChallengeRequest request) {
    // TODO: Implement the API call to reject the challenge request
    // For now, just remove from local list and show success message
    setState(() {
      _challengeRequests.removeWhere((r) => r.id == request.id);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const CustomText(
          'تم رفض الطلب بنجاح',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}