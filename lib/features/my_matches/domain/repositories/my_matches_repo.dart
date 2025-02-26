import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/core/services/alerts.dart';
import 'package:remontada/features/my_matches/domain/request/create_match_request.dart';

import 'myMatches_endpoints.dart';

class MyMatchesRepo {
  DioService dioService;
  MyMatchesRepo(this.dioService);
  getMymatches({
    List<int>? playgrounds,
    List<String>? data,
    int? areaId,
    bool? isCurrent,
    String? type,
  }) async {
    final ApiResponse response = await dioService.getData(
      url: MyMatchesEndpoints.myMatches,
      query: {
        if (playgrounds != null || playgrounds?.isNotEmpty == true)
          "playgrounds[]": playgrounds,
        if (data != null || data?.isNotEmpty == true) "date[]": data,
        if (areaId != null) "area_id": areaId,
        if (type != null || isCurrent != null)
          "type": isCurrent == true ? type ?? "current" : type ?? "finished",
      },
    );
    if (response.isError == false) {
      return response.response?.data["data"] as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  createMatche(CreateMatchRequest request, {String? id}) async {
    final ApiResponse response = await dioService.postData(
      loading: true,
      url: request.isUpdate == true
          ? "/matches/$id"
          : MyMatchesEndpoints.createMatch,
      body: request.toMap(),
    );
    if (response.isError == false) {
      Alerts.snack(
        text: response.response?.data["message"],
        state: SnackState.success,
      );
      return true;
    } else {
      return null;
    }
  }

  deletMatch({String? id}) async {
    final ApiResponse response = await dioService.deleteData(
      loading: true,
      url: "/matches/$id",
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }
}
