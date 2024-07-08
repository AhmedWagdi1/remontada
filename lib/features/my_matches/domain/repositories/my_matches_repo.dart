import 'package:remontada/core/data_source/dio_helper.dart';

import 'myMatches_endpoints.dart';

class MyMatchesRepo {
  DioService dioService;
  MyMatchesRepo(this.dioService);
  getMymatches() async {
    final ApiResponse response = await dioService.getData(
      url: MyMatchesEndpoints.myMatches,
    );
    if (response.isError == false) {
      return response.response?.data["data"] as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
