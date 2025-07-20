import 'package:flutter/material.dart';
import 'package:remontada/shared/widgets/customtext.dart';

/// Placeholder screen shown for the upcoming Challenges feature.
class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التحديات')),
      body: const Center(
        child: CustomText(
          'هذه الصفحة قيد التطوير',
          fontSize: 18,
          weight: FontWeight.w600,
          color: Colors.grey,
        ),
      ),
    );
  }
}
