abstract class DatabaseStates {
  String get msg;
}

class InitialState extends DatabaseStates {
  @override
  String get msg => 'InitialState';
}

class LoadingState extends DatabaseStates {
  @override
  String get msg => 'LoadingState';
}

class LoadingTripState extends DatabaseStates {
  @override
  String get msg => 'LoadingTripState';
}

class SelectTripState extends DatabaseStates {
  @override
  String get msg => 'SelectTripState';
}

class Connected extends DatabaseStates {
  @override
  String get msg => 'Connected';
}

class ErrorConnectingDataState extends DatabaseStates {
  @override
  String msg;

  ErrorConnectingDataState(this.msg);
}

class DisConnected extends DatabaseStates {
  @override
  String get msg => 'DisConnected';
}

class ErrorDisConnectingDataState extends DatabaseStates {
  @override
  String msg;

  ErrorDisConnectingDataState(this.msg);
}

class SelectedData extends DatabaseStates {
  SelectedData(this.msg);

  @override
  String msg;
}

class ErrorSelectingDataState extends DatabaseStates {
  @override
  String msg;

  ErrorSelectingDataState(this.msg);
}

class InsertedData extends DatabaseStates {
  InsertedData(this.msg);

  @override
  String msg;
}

class ErrorInsertingDataState extends DatabaseStates {
  @override
  String msg;

  ErrorInsertingDataState(this.msg);
}

class DeletedData extends DatabaseStates {
  DeletedData(this.msg);

  @override
  String msg;
}

class ErrorDeletingDataState extends DatabaseStates {
  @override
  String msg;

  ErrorDeletingDataState(this.msg);
}

class UpdatedData extends DatabaseStates {
  UpdatedData(this.msg);

  @override
  String msg;
}

class ErrorUpdatingDataState extends DatabaseStates {
  @override
  String msg;

  ErrorUpdatingDataState(this.msg);
}
