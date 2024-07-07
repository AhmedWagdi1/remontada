import 'package:remontada/features/home/domain/model/home_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeDataLoading extends HomeState {}

class HomeDataLoaded extends HomeState {
  HomeModel homeModel;
  HomeDataLoaded(this.homeModel);
}

class HomeDataFailed extends HomeState {}

class PlayGroundLoading extends HomeState {}

class PlayGroundLoaded extends HomeState {
  final playGrounds playgrounds;
  PlayGroundLoaded(this.playgrounds);
}

class PlayGroundFailed extends HomeState {}
