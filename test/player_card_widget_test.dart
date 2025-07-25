import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remontada/features/challenges/presentation/screens/team_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  testWidgets('PlayerCard shows active state', (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: Builder(
          builder: (context) => MaterialApp(
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            home: const Scaffold(
              body: PlayerCard(
                number: 1,
                name: 'Test',
                shirt: 10,
                phone: '0........9',
                isActive: true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Active'), findsOneWidget);
    final containerFinder = find
        .ancestor(of: find.text('Active'), matching: find.byType(Container))
        .first;
    final decoration =
        tester.widget<Container>(containerFinder).decoration as BoxDecoration;
    expect(decoration.color, Colors.green);
  }, skip: true);

  testWidgets('PlayerCard shows inactive state', (tester) async {
    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: const [Locale('en', 'US')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: Builder(
          builder: (context) => MaterialApp(
            locale: context.locale,
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            home: const Scaffold(
              body: PlayerCard(
                number: 1,
                name: 'Test',
                shirt: 10,
                phone: '0........9',
                isActive: false,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Inactive'), findsOneWidget);
    final containerFinder = find
        .ancestor(of: find.text('Inactive'), matching: find.byType(Container))
        .first;
    final decoration =
        tester.widget<Container>(containerFinder).decoration as BoxDecoration;
    expect(decoration.color, Colors.red);
  }, skip: true);
}
