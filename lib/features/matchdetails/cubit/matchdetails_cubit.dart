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
  SubScribersModel subscribers = SubScribersModel();
  MatchModel matchmodel = MatchModel();

  MatchModel? matchModel;
  bool? isMymatch;
  List<int> playersId = [];
  MatchDetailsRepo matchDetailsRepo = MatchDetailsRepo(locator<DioService>());
  getMatchDetails(String id, {bool isLoading = true}) async {
    if (isLoading == true) emit(MatchDetailsLoading());
    final res = await matchDetailsRepo.getMatchDetails(id);
    if (res != null) {
      // await getOwner(id);
      matchmodel = MatchModel.fromMap(
        res["match"],
      );
      emit(
        MatchDetailsLoaded(
          matchmodel,
          subscribers,
        ),
      );

      return true;
    } else {
      emit(MatchDetailsFailed());
      return null;
    }
  }

  getSubscribers(String id, {String? type, bool? isloading}) async {
    if (isloading == true) emit(SubScribersLoading());
    final res = await matchDetailsRepo.getSubscribers(id, type: type);
    if (res != null) {
      subscribers = SubScribersModel.fromMap(res);
      subscribers.subscribers?.forEach(
        (element) {
          playersId.add(element.id ?? 0);
        },
      );
      isMymatch = playersId.contains(Utils.user.user?.id);
      emit(MatchDetailsLoaded(
        matchmodel,
        subscribers,
      ));
      return SubScribersModel.fromMap(res);
    } else {
      emit(SubScribersFailed());
      return null;
    }
  }

  apcense({String? paymentMethod, String? id}) async {
    final res = await matchDetailsRepo.apsence(
      subscriber_id: id,
      paymment_method: paymentMethod,
    );
    if (res != null) {
      emit(RefreshState());
      return true;
    }
  }

  // getOwner(id) async {
  //   final res = await getSubscribers(id);
  //   if (res != null) {
  //     (res as SubScribersModel)

  //     return isMymatch;
  //   }
  // }

  addsubscrubers({String? matchid, String? name, String? phone}) async {
    final res = await matchDetailsRepo.addSubscribers(
      name: name,
      phone: phone,
      matchId: matchid,
    );
    if (res != null) {
      emit(RefreshState());
      return true;
    } else {
      return null;
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
