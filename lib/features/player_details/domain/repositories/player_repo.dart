import 'package:remontada/core/data_source/dio_helper.dart';
import 'package:remontada/features/player_details/domain/repositories/player_endpoints.dart';

class PlayerRepo {
  DioService dioService;
  PlayerRepo(this.dioService);

  getplayerDetails(String id) async {
    final ApiResponse response =
        await dioService.getData(url: "${PlayerEndpoints.subscriber}/$id");
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }
}
