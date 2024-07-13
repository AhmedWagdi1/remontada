import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/utils/Locator.dart';
import 'package:remontada/core/utils/utils.dart';
import 'package:remontada/features/auth/domain/model/auth_model.dart';
import 'package:remontada/features/profile/domain/edit_request.dart';
import 'package:remontada/features/profile/domain/repositories/edit_repositories.dart';

import 'edit_states.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit() : super(EditInitial());
  static EditCubit get(context) => BlocProvider.of(context);
  EditRepo editRepo = EditRepo(locator<DioService>());

  editprofile(EditRequest edit) async {
    final res = await editRepo.editProfile(edit);
    if (res != null) {
      Utils.user = User.fromMap(res);

      return User.fromMap(res);
    } else {
      return null;
    }
  }

  getProfile() async {
    emit(ProfileLoading());
    final res = await editRepo.getProfile();
    if (res != null) {
      Utils.user = User.fromMap(res);
      emit(
        ProfileLoaded(
          User.fromMap(res),
        ),
      );
      return true;
    } else {
      emit(ProfileFailed());
      return false;
    }
  }

  confirmRequest(String code) async {
    final res = await editRepo.confirmProfile(code);
    if (res != null) {
      await Utils.saveUserInHive(res);
      return true;
    } else {
      return false;
    }
  }
}
// }
