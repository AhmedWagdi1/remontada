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

  getSubscribers(String id, {String? type}) async {
    final ApiResponse response = await dioService.getData(
      url:
          // type == "group"
          //     ? "/subscribers_list"
          //     :
          "${MatchEndpoints.subscribers}/$id",
    );
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  subScribe(int id) async {
    final ApiResponse response = await dioService.postData(
      loading: true,
      isForm: true,
      url: "${MatchEndpoints.subscribe}",
      body: {"match_id": id},
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  // perscense(String paymentMethod, {String? id}) async {
  //   final ApiResponse response = await dioService.postData(
  //     isForm: true,
  //     body: {"payment_method": paymentMethod},
  //     loading: true,
  //     url: "/perscense/$id",
  //   );
  // }

  addSubscribers({String? name, String? matchId, String? phone}) async {
    final ApiResponse response = await dioService.postData(
      isForm: true,
      body: {
        "name": name,
        "match_id": matchId,
        "phone": name,
      },
      loading: true,
      url: "/add_subscriber",
    );
  }

  apsence({String? subscriber_id, String? paymment_method}) async {
    final ApiResponse response = await dioService.postData(
      isForm: true,
      body: {
        "payment_method": paymment_method,
        // "subscriber_id": subscriber_id,
      },
      // body: {
      //   "name": name,
      //   "match_id": matchId,
      //   "phone": name,
      // },
      loading: true,
      url: "/presence/$subscriber_id",
    );
    if (response.isError == false) {
      return true;
    } else {
      return null;
    }
  }

  cancel(String id) async {
    final ApiResponse response = await dioService.postData(
      isForm: true,
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
