import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';
import 'package:remontada/features/my_matches/domain/repositories/my_matches_repo.dart';
import 'package:remontada/features/my_matches/domain/request/create_match_request.dart';

import '../../../core/utils/Locator.dart';
import '../../matchdetails/domain/repositories/match_details_repo.dart';
import 'myMatches_states.dart';

class MyMatchesCubit extends Cubit<MyMatchesState> {
  MyMatchesCubit() : super(MyMatchesInitial());
  static MyMatchesCubit get(context) => BlocProvider.of(context);
  MyMatchesRepo myMatchesrepo = MyMatchesRepo(locator<DioService>());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  MatchModel matchmodel = MatchModel();
  MatchDetailsRepo matchDetailsRepo = MatchDetailsRepo(locator<DioService>());
  getMatchDetails(
    String id, {
    bool makeRequest = true,
  }) async {
    if (makeRequest == true) {
      emit(MatchDetailsLoading());
      final res = await matchDetailsRepo.getMatchDetails(id);
      if (res != null) {
        // await getOwner(id);
        matchmodel = MatchModel.fromMap(
          res["match"],
        );
        emit(
          MatchDetailsLoaded(
            matchmodel,
          ),
        );

        return true;
      } else {
        emit(MatchDetailsFailed());
        return null;
      }
    }
  }

  getMymatches({bool? isCurrent, bool? isloading = true}) async {
    if (isloading == true) emit(MyMatchesLoading());
    print(
        '\n[MyMatchesCubit] getMymatches() called with isCurrent: $isCurrent, isloading: $isloading');
    final res = await myMatchesrepo.getMymatches(isCurrent: isCurrent);
    print('[MyMatchesCubit] getMymatches() raw response: $res');
    if (res != null) {
      try {
        final myMatches = MyMatches.fromMap(res);
        final count = myMatches.matches?.length ?? 0;
        print('[MyMatchesCubit] Parsed MyMatches count: $count');
        emit(
          MyMatchesLoaded(
            myMatches,
          ),
        );
      } catch (e, st) {
        print('[MyMatchesCubit] Error parsing MyMatches.fromMap: $e');
        print(st);
        emit(MyMatchesFailed());
        return null;
      }
      return true;
    } else {
      print('[MyMatchesCubit] getMymatches() returned null');
      emit(MyMatchesFailed());
      return null;
    }
  }

  CreateMatchRequest request = CreateMatchRequest();
  createMatches({String? id}) async {
    emit(CreateMatchLoading());
    final res = await myMatchesrepo.createMatche(
      request,
      id: id,
    );
    // Debug: print request payload
    print('\n[MyMatchesCubit] createMatches() called. id: ${id ?? "(new)"}');
    try {
      print('[MyMatchesCubit] request payload: ' + request.toMap().toString());
    } catch (_) {
      print('[MyMatchesCubit] request payload: (toMap unavailable) $request');
    }

    // Debug: print raw response
    print('[MyMatchesCubit] createMatche() repository returned: $res');

    if (res != null) {
      emit(CreateMatchSuccess());
    } else {
      emit(CreateMatchFailed());
    }
    // Debug: print emitted state
    if (res != null) {
      print('[MyMatchesCubit] Emitted CreateMatchSuccess');
    } else {
      print('[MyMatchesCubit] Emitted CreateMatchFailed (null response)');
    }
  }

  deletMatch({String? id}) async {
    emit(DeleteMatchLoading());
    final res = await myMatchesrepo.deletMatch(id: id);
    if (res != null) {
      emit(DeleteMatchSuccess());
    } else {
      emit(DeleteMatchFailed());
    }
  }
}
