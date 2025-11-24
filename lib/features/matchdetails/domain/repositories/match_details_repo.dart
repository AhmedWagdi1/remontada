import 'dart:developer' as developer;

import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_endpoints.dart';

import '../../../../core/services/alerts.dart';

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
      Alerts.snack(
        text: response.response?.data["message"],
        state: SnackState.success,
      );
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
        "phone": phone,
      },
      loading: true,
      url: "/add_subscriber",
    );
    if (response.isError == false) {
      Alerts.snack(
        text: response.response?.data["message"],
        state: SnackState.success,
      );
    }
  }

  apsence({String? subscriber_id, String? paymment_method, matchid}) async {
    developer.log(
      '🔴 [Repository] apsence method called',
      name: 'MatchDetailsRepo',
    );
    
    final url = "/presence/$matchid";
    final body = {
      "subscriber_id": subscriber_id,
      "payment_method": paymment_method,
    };

    developer.log(
      '🔴 [Repository] Request details:',
      name: 'MatchDetailsRepo',
    );
    developer.log(
      '   - URL: POST $url',
      name: 'MatchDetailsRepo',
    );
    developer.log(
      '   - Match ID: $matchid',
      name: 'MatchDetailsRepo',
    );
    developer.log(
      '   - Body: {"subscriber_id": $subscriber_id, "payment_method": $paymment_method}',
      name: 'MatchDetailsRepo',
    );

    if (subscriber_id == null || subscriber_id.isEmpty) {
      developer.log(
        '❌ [Repository] ERROR: subscriber_id is null or empty!',
        name: 'MatchDetailsRepo',
      );
    }

    if (matchid == null || matchid.toString().isEmpty) {
      developer.log(
        '❌ [Repository] ERROR: matchid is null or empty!',
        name: 'MatchDetailsRepo',
      );
    }

    if (paymment_method == null || paymment_method.isEmpty) {
      developer.log(
        '⚠️ [Repository] WARNING: payment_method is null or empty (will not be included in request)',
        name: 'MatchDetailsRepo',
      );
    }

    try {
      developer.log(
        '🔴 [Repository] Sending POST request...',
        name: 'MatchDetailsRepo',
      );
      
      final ApiResponse response = await dioService.postData(
        isForm: true,
        body: body,
        loading: true,
        url: url,
      );

      developer.log(
        '🔴 [Repository] Response received',
        name: 'MatchDetailsRepo',
      );
      developer.log(
        '   - isError: ${response.isError}',
        name: 'MatchDetailsRepo',
      );
      developer.log(
        '   - statusCode: ${response.response?.statusCode}',
        name: 'MatchDetailsRepo',
      );
      developer.log(
        '   - data: ${response.response?.data}',
        name: 'MatchDetailsRepo',
      );

      if (response.isError == false) {
        developer.log(
          '✅ [Repository] Success: Request completed successfully',
          name: 'MatchDetailsRepo',
        );
        developer.log(
          '   - Message: ${response.response?.data["message"]}',
          name: 'MatchDetailsRepo',
        );
        return true;
      } else {
        developer.log(
          '❌ [Repository] ERROR: Request failed',
          name: 'MatchDetailsRepo',
        );
        developer.log(
          '   - Error message: ${response.response?.data}',
          name: 'MatchDetailsRepo',
        );
        return null;
      }
    } catch (e, stackTrace) {
      developer.log(
        '❌ [Repository] EXCEPTION in apsence: $e',
        name: 'MatchDetailsRepo',
        error: e,
        stackTrace: stackTrace,
      );
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

  setTeamMatchResult({
    required String matchId,
    required List<Map<String, dynamic>> results,
  }) async {
    final ApiResponse response = await dioService.postData(
      loading: true,
      isForm: false,
      url: "/challenge/set-team-match-result",
      body: {
        "match_id": int.tryParse(matchId) ?? matchId,
        "results": results,
      },
    );
    if (response.isError == false) {
      Alerts.snack(
        text: response.response?.data["message"] ?? "Result submitted successfully!",
        state: SnackState.success,
      );
      return true;
    } else {
      Alerts.snack(
        text: response.response?.data["message"] ?? "Failed to submit result.",
        state: SnackState.failed,
      );
      return false;
    }
  }

  Future<dynamic> getTeamMatchResults(String matchId) async {
    final ApiResponse response = await dioService.getData(
      url: "/challenge/get-team-match-results/$matchId",
    );
    if (response.isError == false) {
      return response.response?.data;
    } else {
      return null;
    }
  }

  Future<dynamic> getTeamMatchParticipants(String matchId) async {
    final ApiResponse response = await dioService.getData(
      url: "/challenge/get-team-match-participants/$matchId",
    );
    if (response.isError == false) {
      return response.response?.data;
    } else {
      return null;
    }
  }
}
