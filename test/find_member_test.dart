import 'package:flutter_test/flutter_test.dart';
import 'package:remontada/features/challenges/presentation/screens/team_details_page.dart';

void main() {
  group('find member', () {
    test('returns matching user when role exists', () {
      final users = [
        {'name': 'A', 'mobile': '1', 'role': 'leader'},
        {'name': 'B', 'mobile': '2', 'role': 'member'},
      ];
      final res = findMemberByRole(users, 'leader');
      expect(res?['name'], 'A');
    });

    test('returns null when role not found', () {
      final users = [
        {'name': 'A', 'mobile': '1', 'role': 'member'},
      ];
      final res = findMemberByRole(users, 'leader');
      expect(res, isNull);
    });
  });
}
