abstract class AppStates {
  @override
  String toString() {
    return stateName;
  }

  String get stateName;
}

class InitialState extends AppStates {
  @override
  String get stateName => 'InitialState';
}
