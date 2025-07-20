import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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

  testWidgets('challenge screen contains completed challenge card', (
    tester,
  ) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    expect(find.text('تحدي مكتمل - اليوم 8:00 م'), findsOneWidget);
    expect(find.text('عرض التفاصيل'), findsOneWidget);
  });

  testWidgets('challenge screen contains join challenge card', (tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(1200, 800);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });
    await tester.pumpWidget(const MaterialApp(home: ChallengesScreen()));
    await tester.pumpAndSettle();
    expect(find.text('انضم للتحدي - اليوم 7:30 م'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
