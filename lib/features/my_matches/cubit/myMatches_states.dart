import 'package:remontada/features/my_matches/domain/model/myMatches_Model.dart';

abstract class MyMatchesState {}

class MyMatchesInitial extends MyMatchesState {}

class MyMatchesLoading extends MyMatchesState {}

class MyMatchesLoaded extends MyMatchesState {
  MyMatches mymatches;
  MyMatchesLoaded(this.mymatches);
}

class MyMatchesFailed extends MyMatchesState {}
