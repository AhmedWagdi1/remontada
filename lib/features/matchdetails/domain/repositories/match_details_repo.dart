import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_endpoints.dart';

class MatchDetailsRepo {
  DioService dioService;
  MatchDetailsRepo(this.dioService);

  getMatchDetails(String id) async {
    final ApiResponse response =
        await dioService.getData(url: "${MatchEndpoints.matchShow}/$id");
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  getSubscribers(String id) async {
    final ApiResponse response =
        await dioService.getData(url: "${MatchEndpoints.subscribers}/$id");
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  subScribe(int id) async {
    final ApiResponse response = await dioService.postData(
      loading: true,
      url: "${MatchEndpoints.subscribe}",
      body: {"match_id": id},
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  cancel(String id) async {
    final ApiResponse response = await dioService.postData(
      body: {"match_id": id},
      loading: true,
      url: "${MatchEndpoints.cancel}",
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }
}
