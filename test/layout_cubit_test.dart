import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';
import 'package:remontada/features/layout/cubit/layout_cubit.dart';

void main() {
  test('initTabBar sets up five tabs', () {
    final cubit = LayoutCubit();
    cubit.initTabBar(const TestVSync());
    expect(cubit.tabController.length, 5);
  });
}
