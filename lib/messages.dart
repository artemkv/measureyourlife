// Should all be immutable classes and no logic!

import 'package:flutter/material.dart';

@immutable
abstract class Message {}

@immutable
class ReInitializationRequested implements Message {}

@immutable
class AppInitializedNotSignedIn implements Message {}

@immutable
class AppInitializationFailed implements Message {
  final String reason;

  const AppInitializationFailed(this.reason);
}

@immutable
class SignInRequested implements Message {}

@immutable
class UserSignedIn implements Message {
  final DateTime today;

  const UserSignedIn(this.today);
}

@immutable
class SignInFailed implements Message {
  final String reason;

  const SignInFailed(this.reason);
}

@immutable
class SignOutRequested implements Message {}

@immutable
class UserSignedOut implements Message {}

@immutable
class DayStatsLoaded implements Message {
  final DateTime date;
  final DateTime today;
  final bool editable;

  const DayStatsLoaded(this.date, this.today, this.editable);
}
