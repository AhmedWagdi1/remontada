import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/home/domain/repositories/end_points.dart';

class HomeRepo {
  final DioService dioService;
  HomeRepo(this.dioService);

  getHomedata({int? playGround, String? date}) async {
    final ApiResponse response = await dioService.getData(
      url: HomeEndPoints.home,
      query: playGround != null || date != null
          ? {
              "playgrounds[]": playGround ?? '',
              "date": date ?? '',
            }
          : null,
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
