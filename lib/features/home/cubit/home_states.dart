import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';

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
  final PlayGrounds playgrounds;
  PlayGroundLoaded(this.playgrounds);
}

class PlayGroundFailed extends HomeState {}

class MyMatchesLoading extends HomeState {}

class MyMatchesLoaded extends HomeState {
  MyMatches myMatches;
  MyMatchesLoaded(this.myMatches);
}

class MyMatchesFailed extends HomeState {}

class GroupMatchesLoading extends HomeState {}

class GroupMatchesLoaded extends HomeState {
  HomeModel homeModel;
  GroupMatchesLoaded(this.homeModel);
}

class GroupMatchesFailed extends HomeState {}
