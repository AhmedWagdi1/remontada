abstract class SplashStates {}

class SplashInitial extends SplashStates {}

class ChangeIntroState extends SplashStates {}

class LocationDeniedstate extends SplashStates {}

class LocationAcceptedState extends SplashStates {}

class LastVersionSuccessState extends SplashStates {
  bool isLastVersion;

  LastVersionSuccessState(this.isLastVersion);
}
// class ChangeIntroState extends SplashStates {}
