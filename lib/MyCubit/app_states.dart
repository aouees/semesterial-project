enum StateType { successState, errorState }

abstract class AppStates {
  StateType get type;

  String get msg;

  @override
  String toString() {
    return msg;
  }
}

class InitialState extends AppStates {
  @override
  String get msg => 'InitialState';

  @override
  StateType get type => StateType.successState;
}

class Connecting extends AppStates {
  @override
  StateType type;

  Connecting(this.type, this.msg);

  @override
  String msg;
}

class Connected extends AppStates {
  @override
  StateType type;

  Connected(this.type, this.msg);

  @override
  String msg;
}

class DisConnecting extends AppStates {
  @override
  StateType type;

  DisConnecting(this.type, this.msg);

  @override
  String msg;
}

class DisConnected extends AppStates {
  @override
  StateType type;

  DisConnected(this.type, this.msg);

  @override
  String msg;
}

class SelectedData extends AppStates {
  @override
  StateType type;

  SelectedData(this.type, this.msg);

  @override
  String msg;
}

class SelectingData extends AppStates {
  @override
  StateType type;

  SelectingData(this.type, this.msg);

  @override
  String msg;
}

class InsertedData extends AppStates {
  @override
  StateType type;

  InsertedData(this.type, this.msg);

  @override
  String msg;
}

class DeletedData extends AppStates {
  @override
  StateType type;

  DeletedData(this.type, this.msg);

  @override
  String msg;
}

class UpdatedData extends AppStates {
  @override
  StateType type;

  UpdatedData(this.type, this.msg);

  @override
  String msg;
}
