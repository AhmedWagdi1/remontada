import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/domain/repositories/home_repo.dart';

import '../../../core/utils/Locator.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  HomeRepo homeRepo = locator<HomeRepo>();
  getHomeData() async {
    emit(HomeDataLoading());
    final response = await homeRepo.getHomedata();

    if (response != null) {
      HomeModel homeModel = HomeModel.fromMap(response as Map<String, dynamic>);
      log(homeModel.slider?[1].image ?? "ashraf");
      emit(
        HomeDataLoaded(
          homeModel,
        ),
      );
      return true;
    } else {
      emit(HomeDataFailed());

      return null;
    }
  }
}
// }
