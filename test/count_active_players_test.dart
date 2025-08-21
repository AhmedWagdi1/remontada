import 'package:flutter_test/flutter_test.dart';
import 'package:remontada/features/challenges/presentation/screens/team_details_page.dart';

void main() {
  group('count active players', () {
    test('returns number of active users', () {
      final users = [
        {'name': 'A', 'active': true},
        {'name': 'B', 'active': false},
        {'name': 'C', 'active': true},
      ];
      expect(countActivePlayers(users), 2);
    });

    test('returns zero when list empty', () {
      expect(countActivePlayers([]), 0);
    });
  });
} 
