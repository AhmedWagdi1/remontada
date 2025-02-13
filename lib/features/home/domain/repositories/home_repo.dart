import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/home/domain/repositories/end_points.dart';

class HomeRepo {
  final DioService dioService;
  HomeRepo(this.dioService);

  getHomedata({List<int>? playgrounds, List<String>? data, int? areaId}) async {
    final ApiResponse response = await dioService.getData(
      url: HomeEndPoints.home,
      query: {
        "playgrounds[]": playgrounds,
        "date[]": data,
        "area_id": areaId,
      }..removeWhere((key, value) => value == null),
    );

    if (response.isError == false) {
      return response.response?.data["data"] as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  getGroupeMatches(
      {List<int>? playgrounds, List<String>? data, int? areaId}) async {
    final ApiResponse response = await dioService.getData(
      url: "/group-matches",
      query: {
        "playgrounds[]": playgrounds,
        "date[]": data,
        "area_id": areaId,
      }..removeWhere((key, value) => value == null),
    );

    if (response.isError == false) {
      return response.response?.data["data"] as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  getPlaygrounds() async {
    final ApiResponse response =
        await dioService.getData(url: HomeEndPoints.playgrounds);

    if (response.isError == false) {
      return response.response?.data["data"] as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  getclander() async {
    final ApiResponse response =
        await dioService.getData(url: HomeEndPoints.schedules);
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }
}
