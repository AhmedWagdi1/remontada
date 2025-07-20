import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data_source/dio_helper.dart';
import '../../../core/utils/Locator.dart';
import '../domain/repository/repository.dart';
import 'layout_states.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitial());
  static LayoutCubit get(context) => BlocProvider.of(context);

  LayoutRepository layoutRepository = LayoutRepository(locator<DioService>());
  late TabController tabController;

  /// Initializes the bottom navigation tab controller.
  ///
  /// [vsync] provides the ticker provider for animations.
  /// [index] sets the initial tab index.
  void initTabBar(vsync, [int index = 0]) {
    tabController = TabController(length: 5, vsync: vsync, initialIndex: index);
  }

  void changeTab(int tab) {
    print(tab);
    switch (tab) {
      case 0:
        tabController.animateTo(0);
        break;
      case 1:
        tabController.animateTo(1);
        break;
      case 2:
        tabController.animateTo(2);
        break;
      case 3:
        tabController.animateTo(3);
        break;
      case 4:
        tabController.animateTo(4);
        break;
      default:
    }
    emit(HomeLayoutChangeScreenState());
  }
}
