import 'package:remontada/features/home/domain/model/home_model.dart';
import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';

abstract class MyMatchesState {}

class MyMatchesInitial extends MyMatchesState {}

class MyMatchesLoading extends MyMatchesState {}

class MyMatchesLoaded extends MyMatchesState {
  MyMatches mymatches;
  MyMatchesLoaded(this.mymatches);
}

class MyMatchesFailed extends MyMatchesState {}

class CreateMatchLoading extends MyMatchesState {}

class CreateMatchSuccess extends MyMatchesState {}

class CreateMatchFailed extends MyMatchesState {}

class MatchDetailsLoading extends MyMatchesState {}

class MatchDetailsLoaded extends MyMatchesState {
  MatchModel matchModel;
  MatchDetailsLoaded(this.matchModel);
}

class MatchDetailsFailed extends MyMatchesState {}

class DeleteMatchLoading extends MyMatchesState {}

class DeleteMatchSuccess extends MyMatchesState {}

class DeleteMatchFailed extends MyMatchesState {}
