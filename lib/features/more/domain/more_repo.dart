import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/more/domain/endpoints.dart';

class MoreRepo {
  final DioService dioService;
  MoreRepo(this.dioService);

  logout() async {
    final response = await dioService.postData(
      isForm: true,
      body: {"uuid": "00000000-0000-0000-0000-000000000000"},
      url: MoreEndPoints.logOut,
      loading: true,
    );
    if (response.isError) {
      return null;
    } else {
      return true;
    }
  }

  getAboutpage() async {
    final response = await dioService.getData(
      url: MoreEndPoints.about,
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  getPolicy() async {
    final response = await dioService.getData(
      url: MoreEndPoints.policy,
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }
}
