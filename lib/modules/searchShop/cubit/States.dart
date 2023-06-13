abstract class SearchStates {}

class InitialSearchState extends SearchStates {}

class LoadingSearchState extends SearchStates {}

class SuccessSearchState extends SearchStates {}

class ErrorSearchState extends SearchStates {
  final String error;
  ErrorSearchState(this.error);
}

class ClearSearchState extends SearchStates {}

class ChangesOnFieldSearchState extends SearchStates {}