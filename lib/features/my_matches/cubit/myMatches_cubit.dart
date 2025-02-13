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
    final res = await myMatchesrepo.getMymatches(isCurrent: isCurrent);
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

  CreateMatchRequest request = CreateMatchRequest();
  createMatches({String? id}) async {
    emit(CreateMatchLoading());
    final res = await myMatchesrepo.createMatche(
      request,
      id: id,
    );
    if (res != null) {
      emit(CreateMatchSuccess());
    } else {
      emit(CreateMatchFailed());
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
