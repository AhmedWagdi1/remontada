import '../../home/domain/model/home_model.dart';

abstract class MatchDetailsState {}

class MatchDetailsInitial extends MatchDetailsState {}

class MatchDetailsLoading extends MatchDetailsState {}

class MatchDetailsLoaded extends MatchDetailsState {
  final MatchModel matchDetails;
  final SubScribersModel subScribers;
  MatchDetailsLoaded(this.matchDetails, this.subScribers);

  // SubScribersLoaded(this.subScribers);
}

class MatchDetailsFailed extends MatchDetailsState {}

class SubScribersLoading extends MatchDetailsState {}

// class SubScribersLoaded extends MatchDetailsState {

// }

class SubScribersFailed extends MatchDetailsState {}

class RefreshState extends MatchDetailsState {}

class isOwnerSuccess extends MatchDetailsState {}
