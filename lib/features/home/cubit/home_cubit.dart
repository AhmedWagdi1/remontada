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
  getHomeData({int? playground, String? date}) async {
    emit(HomeDataLoading());
    final response = await homeRepo.getHomedata(
      playGround: playground,
      date: date,
    );

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

  getplayground() async {
    emit(PlayGroundLoading());
    final response = await homeRepo.getPlaygrounds();
    if (response != null) {
      playGrounds playgrounds = playGrounds.fromMap(response);
      emit(PlayGroundLoaded(playgrounds));
      return true;
    } else {
      emit(PlayGroundFailed());
      return null;
    }
  }
}
// }
