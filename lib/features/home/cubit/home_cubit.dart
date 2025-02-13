import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/domain/repositories/home_repo.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_details_repo.dart';
import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';
import 'package:remontada/features/my_matches/domain/repositories/my_matches_repo.dart';

import '../../../core/utils/Locator.dart';
import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);
  HomeRepo homeRepo = locator<HomeRepo>();
  MatchDetailsRepo matchDetailsRepo = MatchDetailsRepo(locator<DioService>());
  getHomeData({List<int>? playgrounds, List<String>? data, int? areaId}) async {
    emit(HomeDataLoading());
    final response = await homeRepo.getHomedata(
        playgrounds: playgrounds, data: data, areaId: areaId);

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

  getGroupeMatches(
      {List<int>? playgrounds, List<String>? data, int? areaId}) async {
    emit(GroupMatchesLoading());
    final response = await homeRepo.getGroupeMatches(
      playgrounds: playgrounds,
      data: data,
      areaId: areaId,
    );

    if (response != null) {
      HomeModel homeModel = HomeModel.fromMap(response as Map<String, dynamic>);
      log(homeModel.slider?[1].image ?? "ashraf");
      emit(
        GroupMatchesLoaded(
          homeModel,
        ),
      );
      return true;
    } else {
      emit(GroupMatchesFailed());

      return null;
    }
  }

  Future<PlayGrounds?> getplayground() async {
    final response = await homeRepo.getPlaygrounds();
    if (response != null) {
      PlayGrounds playgrounds = PlayGrounds.fromMap(response);

      return playgrounds;
    } else {
      return null;
    }
  }

  Future<Days?> getclander() async {
    final res = await homeRepo.getclander();
    if (res != null) {
      Days days = Days.fromMap(res);

      return days;
    } else {
      emit(PlayGroundFailed());
      return null;
    }
  }

  getSubscribers(String? id) async {
    final res = await matchDetailsRepo.getSubscribers(id ?? "");
    if (res != null) {
      return SubScribersModel.fromMap(res);
    } else {
      return null;
    }
  }

  MyMatchesRepo myMatchesrepo = MyMatchesRepo(locator<DioService>());

  getMymatches(
      {String? type,
      List<int>? playgrounds,
      List<String>? data,
      int? areaId}) async {
    emit(MyMatchesLoading());
    final res = await myMatchesrepo.getMymatches(
        type: type, playgrounds: playgrounds, data: data, areaId: areaId);
    if (res != null) {
      emit(
        MyMatchesLoaded(
          MyMatches.fromMap(res),
        ),
      );
      return true;
    } else {
      emit(MyMatchesFailed());
      return null;
    }
  }
}
// }
