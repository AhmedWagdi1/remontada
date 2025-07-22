import 'package:flutter_test/flutter_test.dart';
import 'package:remontada/features/challenges/presentation/screens/team_details_page.dart';

void main() {
  group('obfuscatePhone', () {
    test('hides middle digits when length > 2', () {
      expect(obfuscatePhone('0123456789'), '0........9');
    });

    test('returns original when length <= 2', () {
      expect(obfuscatePhone('05'), '05');
    });
  });
}
