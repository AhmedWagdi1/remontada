import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:remontada/features/challenges/presentation/screens/challenges_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('challenge screen shows header icons', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
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
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
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
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    expect(find.text('manage_your_team'), findsOneWidget);
    expect(find.text('ريـمونتادا'), findsOneWidget);
    expect(find.byIcon(Icons.groups), findsOneWidget);
  });

  testWidgets('first tab shows challenge cards', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    expect(find.text('challenge_create_challenge'), findsOneWidget);
    expect(find.text('انضم للتحدي - اليوم 7:30 م'), findsOneWidget);
    expect(find.text('how_challenges_work_title'), findsOneWidget);
    expect(find.text('تحدي مكتمل - اليوم 8:00 م'), findsOneWidget);
  });

  testWidgets('championship tab shows championship cards', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(2));
    await tester.pumpAndSettle();
    expect(find.text('super_remontada_championship'), findsOneWidget);
    expect(find.text('elite_remontada_championship'), findsOneWidget);
    expect(find.text('champions_league_remontada_championship'), findsOneWidget);
  });

  testWidgets('league tab shows standings table', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(1));
    await tester.pumpAndSettle();
    expect(find.text('league_table_title'), findsOneWidget);
    expect(find.byType(DataTable), findsOneWidget);
  });

  testWidgets('league table uses compact layout', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Tab).at(1));
    await tester.pumpAndSettle();
    final dataTable = tester.widget<DataTable>(find.byType(DataTable));
    expect(dataTable.columnSpacing, lessThan(20));
    expect(dataTable.horizontalMargin, lessThan(12));
    expect(dataTable.dataRowHeight, 32);
  });

  testWidgets('tab bar has segmented control style', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
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
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.group));
    await tester.pumpAndSettle();
    expect(find.text('create_team_title'), findsOneWidget);
  });
}
