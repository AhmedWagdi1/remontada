import '../../../../core/data_source/dio_helper.dart';

//put it in locators locator.registerLazySingleton(() => SplashRepository(locator<DioService>()));
//  import '../../modules/splash/domain/repository/repository.dart';
class SplashRepository {
  final DioService dioService;
  SplashRepository(this.dioService);

  getProfileData() async {
    final ApiResponse response = await dioService.getData(url: "/profile");
    if (response.isError == false) {
      return response.response?.data["data"];
    } else {
      return null;
    }
  }

  
}
