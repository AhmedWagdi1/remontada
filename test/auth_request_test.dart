import 'package:flutter_test/flutter_test.dart';
import 'package:remontada/features/auth/domain/request/auth_request.dart';
import 'package:remontada/core/config/key.dart';

void main() {
  test('login uses dev phone when devEnv is true', () {
    ConstKeys.devEnv = true;
    final request = AuthRequest(phone: '123');
    final body = request.login();
    expect(body['mobile'], ConstKeys.devLoginPhone);
  });

  test('login uses provided phone when devEnv is false', () {
    ConstKeys.devEnv = false;
    final request = AuthRequest(phone: '456');
    final body = request.login();
    expect(body['mobile'], '456');
  });
}
