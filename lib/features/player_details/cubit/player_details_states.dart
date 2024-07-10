import 'package:remontada/features/home/domain/model/home_model.dart';

abstract class PlayerDetailsState {}

class PlayerDetailsInitial extends PlayerDetailsState {}

class PlayerDetailsLoading extends PlayerDetailsState {}

class PlayerDetailsLoaded extends PlayerDetailsState {
  Subscriber playerdetails;
  PlayerDetailsLoaded(this.playerdetails);
}

class PlayerDetailsFailed extends PlayerDetailsState {}
