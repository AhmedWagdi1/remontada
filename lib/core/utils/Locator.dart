import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:remontada/features/home/domain/repositories/home_repo.dart';
import 'package:remontada/features/matchdetails/domain/repositories/match_details_repo.dart';
import 'package:remontada/features/chat/data/chat_data_source.dart';
import 'package:remontada/features/chat/data/chat_repository_impl.dart';
import 'package:remontada/features/chat/domain/repository/chat_repository.dart';

import '../../core/utils/validations.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/splash/domain/repository/splash_repository.dart';
import '../Router/Router.dart';
import '../config/key.dart';
import '../data_source/dio_helper.dart';
import '../data_source/hive_helper.dart';
import '../services/media/my_media.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerLazySingleton(() => DataManager());
  locator.registerLazySingleton(() => DioService(ConstKeys.baseUrl));
  locator.registerLazySingleton(() => Routes());
  locator.registerLazySingleton(() => Validation());
  locator.registerLazySingleton(() => MyMedia());
  locator.registerLazySingleton(() => GlobalKey<ScaffoldState>());
  locator.registerLazySingleton(() => GlobalKey<NavigatorState>());
  locator.registerLazySingleton(() => AuthRepository(locator<DioService>()));
  locator.registerLazySingleton(() => SplashRepository(locator<DioService>()));
  locator.registerLazySingleton(() => HomeRepo(locator<DioService>()));
  locator.registerLazySingleton(() => MatchDetailsRepo(locator<DioService>()));
  locator.registerLazySingleton(() => ChatDataSource(locator<DioService>()));
  locator.registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(locator<ChatDataSource>()));
}
