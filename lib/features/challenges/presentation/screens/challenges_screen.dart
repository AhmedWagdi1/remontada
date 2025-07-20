import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:remontada/core/app_strings/locale_keys.dart';
import 'package:remontada/shared/widgets/customtext.dart';

/// Placeholder screen shown for the upcoming Challenges feature.
class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF23425F);
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
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.more_horiz, color: darkBlue),
                        const SizedBox(height: 4),
                        CustomText(
                          LocaleKeys.challenge_more.tr(),
                          color: darkBlue,
                          weight: FontWeight.bold,
                        ),
                      ],
                    ),
                    CustomText(
                      LocaleKeys.challenge_updates.tr(),
                      color: darkBlue,
                      weight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    Column(
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
                  ],
                ),
              ),
              const Spacer(),
              const Center(
                child: CustomText(
                  'هذه الصفحة قيد التطوير',
                  fontSize: 18,
                  weight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
