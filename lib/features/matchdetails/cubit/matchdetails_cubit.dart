import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_details_repo.dart';

import '../../../core/utils/Locator.dart';
import 'matchdetails_states.dart';

class MatchDetailsCubit extends Cubit<MatchDetailsState> {
  MatchDetailsCubit() : super(MatchDetailsInitial());
  static MatchDetailsCubit get(context) => BlocProvider.of(context);
  MatchDetailsRepo matchDetailsRepo = MatchDetailsRepo(locator<DioService>());
  MatchModel? matchModel;
  bool? isMymatch;
  List<int> playersId = [];
  getMatchDetails(String id) async {
    emit(MatchDetailsLoading());
    final res = await matchDetailsRepo.getMatchDetails(id);
    if (res != null) {
      emit(
        MatchDetailsLoaded(
          MatchModel.fromMap(
            res["match"],
          ),
        ),
      );
      await getOwner(id);
      return true;
    } else {
      emit(MatchDetailsFailed());
      return null;
    }
  }

  getSubscribers(String id) async {
    final res = await matchDetailsRepo.getSubscribers(id);
    if (res != null) {
      emit(SubScribersLoaded(SubScribersModel.fromMap(res)));
      return SubScribersModel.fromMap(res);
    } else {
      return null;
    }
  }

  getOwner(id) async {
    final res = await getSubscribers(id);
    if (res != null) {
      (res as SubScribersModel).subscribers?.forEach(
        (element) {
          playersId.add(element.id ?? 0);
        },
      );
      isMymatch = playersId.contains(Utils.user.user?.id);
      emit(RefreshState());
      return isMymatch;
    }
  }

  subScribe(int id) async {
    final res = await matchDetailsRepo.subScribe(id);
    if (res != null) {
      emit(RefreshState());
      return true;
    } else {
      return null;
    }
  }

  cancel(String id) async {
    final res = await matchDetailsRepo.cancel(id);
    if (res != null) {
      Alerts.snack(text: "تم الاعتذار عن المشاركة", state: SnackState.success);
      emit(RefreshState());
      return true;
    } else {
      return false;
    }
  }
}
// }
