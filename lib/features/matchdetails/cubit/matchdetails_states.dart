import '../../home/domain/model/home_model.dart';

abstract class MatchDetailsState {}

class MatchDetailsInitial extends MatchDetailsState {}

class MatchDetailsLoading extends MatchDetailsState {}

class MatchDetailsLoaded extends MatchDetailsState {
  MatchModel matchDetails;
  MatchDetailsLoaded(this.matchDetails);
}

class MatchDetailsFailed extends MatchDetailsState {}

class SubScribersLoading extends MatchDetailsState {}

class SubScribersLoaded extends MatchDetailsState {
  SubScribersModel subScribers;
  SubScribersLoaded(this.subScribers);
}

class SubScribersFailed extends MatchDetailsState {}

class RefreshState extends MatchDetailsState {}

class isOwnerSuccess extends MatchDetailsState {}
