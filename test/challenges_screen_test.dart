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

  testWidgets('other tabs show under construction placeholder', (tester) async {
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
    expect(find.text('under_construction'), findsOneWidget);
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
}
