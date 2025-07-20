import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:remontada/features/auth/cubit/auth_cubit.dart';
import 'package:remontada/features/auth/cubit/auth_states.dart';
import 'package:remontada/features/auth/domain/request/auth_request.dart';
import 'package:remontada/features/auth/domain/repository/auth_repository.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/utils.dart';

/// Dummy Dio service used by the fake repository.
class DummyDioService extends DioService {
  DummyDioService() : super('');
}

/// Fake repository returning a test-mode login response.
class FakeAuthRepository extends AuthRepository {
  FakeAuthRepository() : super(DummyDioService());

  @override
  Future<dynamic> loginRequest(AuthRequest user) async {
    return {
      'user': {'id': 1},
      'access_token': 'token',
      'type': 'supervisor'
    };
  }
}

void main() {
  setUpAll(() async {
    await setupLocator();
    await Utils.dataManager.initHive();
  });

  testWidgets('login emits ActivateCodeSuccessState when token returned',
      (tester) async {
    await tester.pumpWidget(MaterialApp(builder: FlutterSmartDialog.init()));

    final cubit = AuthCubit(repository: FakeAuthRepository());
    final result = await cubit.login(loginRequestModel: AuthRequest(phone: '1'));
    expect(result, isTrue);
    expect(cubit.state, isA<ActivateCodeSuccessState>());
  });
}
