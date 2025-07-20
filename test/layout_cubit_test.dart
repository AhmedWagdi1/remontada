import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:remontada/features/layout/cubit/layout_cubit.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/data_source/dio_helper.dart';

void main() {
  test('initTabBar sets up five tabs', () {
    locator.registerLazySingleton(() => DioService(''));
    final cubit = LayoutCubit();
    cubit.initTabBar(const TestVSync());
    expect(cubit.tabController.length, 5);
    locator.reset();
  });
}
