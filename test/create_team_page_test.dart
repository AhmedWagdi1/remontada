import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remontada/features/challenges/presentation/screens/create_team_page.dart';

void main() {
  group('parseTeamId', () {
    test('returns integer when value is numeric', () {
      expect(parseTeamId(5), 5);
      expect(parseTeamId('10'), 10);
    });

    test('throws FormatException when null', () {
      expect(() => parseTeamId(null), throwsFormatException);
    });

    test('throws FormatException on invalid format', () {
      expect(() => parseTeamId('abc'), throwsFormatException);
    });
  });
  testWidgets('CreateTeamPage layout displays all sections', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateTeamPage()));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    expect(find.text('team_logo_section'), findsOneWidget);
    expect(find.text('team_info_section'), findsOneWidget);
    expect(find.text('coaching_staff_section'), findsOneWidget);
    expect(find.text('players_list_section'), findsOneWidget);
    expect(find.text('add_new_player'), findsOneWidget);
    expect(find.text('invite_members_section'), findsOneWidget);
    expect(find.text('enable_invite_title'), findsOneWidget);
    expect(find.text('choose_social_platforms_label'), findsOneWidget);
    expect(find.text('create_team_button'), findsOneWidget);
  });

  testWidgets('Add player button adds a new card', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CreateTeamPage()));
    await tester.pumpAndSettle();

    expect(find.textContaining('player_card_title'), findsNWidgets(2));
    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.byIcon(Icons.add),
      500,
      scrollable: scrollable,
    );
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.textContaining('player_card_title'), findsNWidgets(3));
  });
}
