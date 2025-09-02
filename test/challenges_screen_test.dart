import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:remontada/features/challenges/presentation/screens/challenges_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await EasyLocalization.ensureInitialized();

  testWidgets('challenge screen shows header icons', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: false)));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.group), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);
  });

  testWidgets('carousel slider is visible', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: true)));
    await tester.pumpAndSettle();
    expect(find.byType(CarouselSlider), findsOneWidget);
  });

  testWidgets('manage team row is displayed', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: true)));
    await tester.pumpAndSettle();
    expect(
      find.widgetWithText(ElevatedButton, 'manage_your_team'),
      findsOneWidget,
    );
    final buttonBox = tester.renderObject<RenderBox>(
      find.widgetWithText(ElevatedButton, 'manage_your_team'),
    );
    expect(buttonBox.size.height, 36);
    expect(buttonBox.size.width, greaterThanOrEqualTo(120));
    expect(find.text('ريـمونتادا'), findsOneWidget);
    expect(find.byIcon(Icons.groups), findsOneWidget);
  });

  testWidgets('team widgets hidden when user has no team', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: false)));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'manage_your_team'), findsNothing);
    expect(find.text('challenge_create_challenge'), findsNothing);
    expect(find.widgetWithText(ElevatedButton, 'challenge_create_team'),
        findsOneWidget);
  });

  testWidgets('first tab shows challenge cards', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: true)));
    await tester.pumpAndSettle();
    expect(find.text('challenge_create_challenge'), findsOneWidget);
    expect(find.text('how_challenges_work_title'), findsOneWidget);
  });

  testWidgets('championship tab shows championship cards', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: true)));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(2));
    await tester.pumpAndSettle();
    expect(find.text('super_remontada_championship'), findsOneWidget);
    expect(find.text('elite_remontada_championship'), findsOneWidget);
    expect(find.text('champions_league_remontada_championship'), findsOneWidget);
  });

  testWidgets('league tab shows standings state', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: true)));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(1));
    await tester.pumpAndSettle();
    expect(find.text('league_table_title'), findsOneWidget);
    final tableFinder = find.byType(DataTable);
    final errorFinder = find.text('Failed to load standings');
    expect(
      tableFinder.evaluate().isNotEmpty || errorFinder.evaluate().isNotEmpty,
      isTrue,
    );
  });

  testWidgets('league table uses compact layout when available',
      (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: true)));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(1));
    await tester.pumpAndSettle();
    final tableFinder = find.byType(DataTable);
    if (tableFinder.evaluate().isNotEmpty) {
      final dataTable = tester.widget<DataTable>(tableFinder);
      expect(dataTable.columnSpacing, lessThan(20));
      expect(dataTable.horizontalMargin, lessThan(12));
      expect(dataTable.dataRowHeight, 32);
    } else {
      expect(find.text('Failed to load standings'), findsOneWidget);
    }
  });

  testWidgets('tab bar has segmented control style', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: true)));
    await tester.pumpAndSettle();

    final tabBar = tester.widget<TabBar>(find.byType(TabBar));
    expect(tabBar.isScrollable, isFalse);
    final indicator = tabBar.indicator as BoxDecoration;
    expect(indicator.color, const Color(0xFF23425F));
    expect(indicator.borderRadius, BorderRadius.circular(30));

    final containerFinder =
        find.ancestor(of: find.byType(TabBar), matching: find.byType(Container)).first;
    final containerWidget = tester.widget<Container>(containerFinder);
    final containerDecoration = containerWidget.decoration as BoxDecoration;
    expect(containerDecoration.borderRadius, BorderRadius.circular(30));
    expect(containerDecoration.color, const Color(0xFFF2F2F2));
  });

  testWidgets('tapping create team navigates to CreateTeamPage', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(
        const MaterialApp(home: ChallengesScreen(hasTeam: false)));
    await tester.pumpAndSettle();
    await tester.tap(
        find.widgetWithText(ElevatedButton, 'challenge_create_team'));
    await tester.pumpAndSettle();
    expect(find.text('create_team_title'), findsOneWidget);
  });

  testWidgets('tapping manage team navigates to TeamDetailsPage', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
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
            home: const ChallengesScreen(hasTeam: true),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ElevatedButton, 'Manage Your Team'));
    await tester.pumpAndSettle();
    expect(find.text('Info'), findsWidgets);
    // Verify that elements from the info tab exist.
    expect(find.text('ريـمونتادا'), findsWidgets);
    expect(find.byIcon(Icons.settings), findsNWidgets(2));
    expect(find.text('الأوسمة والإنجازات'), findsOneWidget);
    expect(find.text('الإحصائيات المفصلة'), findsOneWidget);
  });
}
