import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remontada/features/challenges/presentation/screens/create_team_page.dart';

void main() {
  testWidgets('CreateTeamPage layout displays all sections', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateTeamPage()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    expect(find.text('team_logo_section'), findsOneWidget);
    expect(find.text('team_info_section'), findsOneWidget);
    expect(find.text('coaching_staff_section'), findsOneWidget);
  });
}
