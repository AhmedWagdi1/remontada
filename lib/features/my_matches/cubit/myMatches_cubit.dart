import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';
import 'package:remontada/features/my_matches/domain/repositories/my_matches_repo.dart';

import '../../../core/utils/Locator.dart';
import 'myMatches_states.dart';

class MyMatchesCubit extends Cubit<MyMatchesState> {
  MyMatchesCubit() : super(MyMatchesInitial());
  static MyMatchesCubit get(context) => BlocProvider.of(context);
  MyMatchesRepo myMatchesrepo = MyMatchesRepo(locator<DioService>());

  getMymatches() async {
    emit(MyMatchesLoading());
    final res = await myMatchesrepo.getMymatches();
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
