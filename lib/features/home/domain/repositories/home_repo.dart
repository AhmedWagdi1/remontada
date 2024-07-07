import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/home/domain/repositories/end_points.dart';

class HomeRepo {
  final DioService dioService;
  HomeRepo(this.dioService);

  getHomedata() async {
    final ApiResponse response =
        await dioService.getData(url: HomeEndPoints.home);

    if (response.isError == false) {
      return response.response?.data["data"] as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
