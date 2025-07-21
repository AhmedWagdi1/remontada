import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:remontada/features/challenges/presentation/screens/team_details_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();
  testWidgets('info tab scroll view layout', (tester) async {
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
            home: const TeamDetailsPage(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final scrollFinder = find.byType(SingleChildScrollView).first;
    final scroll = tester.widget<SingleChildScrollView>(scrollFinder);
    expect(scroll.padding, const EdgeInsets.all(16));

    final columnFinder =
        find.descendant(of: scrollFinder, matching: find.byType(Column)).first;
    final column = tester.widget<Column>(columnFinder);
    expect(column.crossAxisAlignment, CrossAxisAlignment.start);

    // Verify new sections are present in the info tab.
    expect(find.text('التكريم والإنجازات'), findsOneWidget);
    expect(find.text('الجهاز الفني'), findsOneWidget);
    expect(find.text('إعدادات الدعوة'), findsOneWidget);
  });
}
