import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/profile/domain/edit_request.dart';
import 'package:remontada/features/profile/domain/repositories/edit_endPoints.dart';

class EditRepo {
  DioService dioService;
  EditRepo(this.dioService);

  editProfile(EditRequest edit) async {
    final ApiResponse response = await dioService.postData(
      isForm: true,
      isFile: true,
      url: EditEndpoints.edit_profile,
      loading: true,
      body: await edit.edit(),
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  getProfile() async {
    final ApiResponse response = await dioService.getData(
      url: EditEndpoints.profile,
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  confirmProfile(String code) async {
    final ApiResponse response = await dioService.postData(
      isForm: true,
      loading: true,
      url: EditEndpoints.confirm_mobile,
      body: {"code" : code},
    );

    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }
}
