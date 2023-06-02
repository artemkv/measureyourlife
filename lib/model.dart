// Should all be immutable classes and no logic!
// No side effects allowed!

import 'package:flutter/cupertino.dart';

@immutable
abstract class Model {
  const Model();

  static Model getInitialModel() {
    return ApplicationNotInitializedModel();
  }
}

@immutable
class ApplicationNotInitializedModel extends Model {}

@immutable
class ApplicationFailedToInitializeModel extends Model {
  final String reason;

  const ApplicationFailedToInitializeModel(this.reason);
}

@immutable
class UserFailedToSignInModel extends Model {
  final String reason;

  const UserFailedToSignInModel(this.reason);
}

@immutable
class UserNotSignedInModel extends Model {
  final bool privacyPolicyAccepted;
  final bool personalDataProcessingAccepted;

  const UserNotSignedInModel(
      this.privacyPolicyAccepted, this.personalDataProcessingAccepted);
}

@immutable
class SignInInProgressModel extends Model {}

@immutable
class SignOutInProgressModel extends Model {}

@immutable
class DayStatsModel extends Model {
  final DateTime date;
  final DateTime today;
  final bool editable;

  const DayStatsModel(this.date, this.today, this.editable);
}

@immutable
class DayStatsLoadingModel extends Model {
  final DateTime date;
  final DateTime today;

  const DayStatsLoadingModel(this.date, this.today);
}

@immutable
class DayStatsFailedToLoadModel extends Model {
  final DateTime date;
  final DateTime today;
  final String reason;

  const DayStatsFailedToLoadModel(this.date, this.today, this.reason);
}
