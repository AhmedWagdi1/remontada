import 'dart:developer';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/home/domain/model/challenge_request_model.dart';
import 'package:remontada/features/home/domain/repositories/home_repo.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_details_repo.dart';
import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';
import 'package:remontada/features/my_matches/domain/repositories/my_matches_repo.dart';

import '../../../core/config/key.dart';
import '../../../core/utils/Locator.dart';
import '../../../core/utils/utils.dart';
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

  /// Fetch challenge requests for the current user
  Future<List<ChallengeRequest>> getChallengeRequests() async {
    try {
      emit(ChallengeRequestsLoading());

      final response = await http.get(
        Uri.parse('${ConstKeys.baseUrl}/challenge/team-match-invites'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ${Utils.token}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;

        if (data['status'] == true) {
          final List<dynamic> requestsData = data['data'] as List<dynamic>;
          final requests = requestsData
              .map((requestJson) => ChallengeRequest.fromJson(requestJson as Map<String, dynamic>))
              .toList();

          emit(ChallengeRequestsLoaded(requests));
          return requests;
        } else {
          emit(ChallengeRequestsFailed(data['message'] ?? 'Failed to fetch challenge requests'));
          return [];
        }
      } else {
        emit(ChallengeRequestsFailed('Failed to fetch challenge requests: ${response.statusCode}'));
        return [];
      }
    } catch (e) {
      emit(ChallengeRequestsFailed('Error fetching challenge requests: $e'));
      return [];
    }
  }

  /// Get the count of pending challenge requests
  int getPendingChallengeRequestsCount(List<ChallengeRequest> requests) {
    return requests.where((request) => request.isPending).length;
  }
}
// }
