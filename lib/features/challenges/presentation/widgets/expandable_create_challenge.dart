import 'package:flutter/material.dart';
import '../screens/create_challenge_page.dart';
import 'create_challenge_form.dart';

class ExpandableCreateChallenge extends StatefulWidget {
  final VoidCallback? onCreated;
  const ExpandableCreateChallenge({Key? key, this.onCreated}) : super(key: key);

  @override
  State<ExpandableCreateChallenge> createState() =>
      _ExpandableCreateChallengeState();
}

class _ExpandableCreateChallengeState extends State<ExpandableCreateChallenge> {
  bool _expanded = false;

  void _toggle() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: Icon(_expanded ? Icons.close : Icons.add),
            label: Text(_expanded ? 'إغلاق' : 'إضافة تحدي جديد'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF23425F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            onPressed: _toggle,
          ),
        ),
        AnimatedCrossFade(
          firstChild: SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Material(
              elevation: 2,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CreateChallengeForm(),
              ),
            ),
          ),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
        ),
      ],
    );
  }
}
