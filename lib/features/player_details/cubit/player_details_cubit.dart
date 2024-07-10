import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/player_details/domain/repositories/player_repo.dart';

import 'player_details_states.dart';

class PlayerDetailsCubit extends Cubit<PlayerDetailsState> {
  PlayerDetailsCubit() : super(PlayerDetailsInitial());
  static PlayerDetailsCubit get(context) => BlocProvider.of(context);
  PlayerRepo playerRepo = PlayerRepo(locator<DioService>());

  getPlayerDetails(String id) async {
    emit(PlayerDetailsLoading());
    final res = await playerRepo.getplayerDetails(id);

    if (res != null) {
      emit(
        PlayerDetailsLoaded(
          Subscriber.fromMap(
            res["subscriber"],
          ),
        ),
      );
      return true;
    } else {
      emit(
        PlayerDetailsFailed(),
      );
      return false;
    }
  }
}
// }
