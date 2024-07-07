import 'package:remontada/features/home/domain/model/home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeDataLoading extends HomeState {}

class HomeDataLoaded extends HomeState {
  HomeModel homeModel;
  HomeDataLoaded(this.homeModel);
}

class HomeDataFailed extends HomeState {}
