// Should all be immutable classes and no logic!

import 'package:flutter/material.dart';

import 'domain.dart';

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
  final List<Metric> metrics;
  final Map<String, MetricValue> metricValues;

  const DayStatsLoaded(
      this.date, this.today, this.editable, this.metrics, this.metricValues);
}

@immutable
class DayStatsLoadingFailed implements Message {
  final DateTime date;
  final DateTime today;
  final String reason;

  const DayStatsLoadingFailed(this.date, this.today, this.reason);
}

@immutable
class DayStatsReloadRequested implements Message {
  final DateTime date;
  final DateTime today;

  const DayStatsReloadRequested(this.date, this.today);
}

@immutable
class EditDayStatsRequested implements Message {
  final DateTime date;
  final DateTime today;
  final List<Metric> metrics;
  final Map<String, MetricValue> metricValues;

  const EditDayStatsRequested(
      this.date, this.today, this.metrics, this.metricValues);
}

@immutable
class CancelEditingDayStatsRequested implements Message {
  final DateTime date;
  final DateTime today;

  const CancelEditingDayStatsRequested(this.date, this.today);
}

@immutable
class DayStatsChangesConfirmed implements Message {
  final DateTime date;
  final DateTime today;
  final Map<String, MetricValue> metricValues;

  const DayStatsChangesConfirmed(this.date, this.today, this.metricValues);
}

@immutable
class DayStatsSaveRequested implements Message {
  final DateTime date;
  final Map<String, MetricValue> metricValues;

  const DayStatsSaveRequested(this.date, this.metricValues);
}

@immutable
class DayStatsSaved implements Message {
  final DateTime date;
  final DateTime today;

  const DayStatsSaved(this.date, this.today);
}

@immutable
class SavingDayStatsFailed implements Message {
  final DateTime date;
  final Map<String, MetricValue> metricValues;
  final String reason;

  const SavingDayStatsFailed(this.date, this.metricValues, this.reason);
}

@immutable
class MoveToNextDay implements Message {
  final DateTime date;
  final DateTime today;

  const MoveToNextDay(this.date, this.today);
}

@immutable
class MoveToPrevDay implements Message {
  final DateTime date;
  final DateTime today;

  const MoveToPrevDay(this.date, this.today);
}

@immutable
class MoveToNextWeek implements Message {
  final DateTime date;
  final DateTime today;

  const MoveToNextWeek(this.date, this.today);
}

@immutable
class MoveToPrevWeek implements Message {
  final DateTime date;
  final DateTime today;

  const MoveToPrevWeek(this.date, this.today);
}

@immutable
class MoveToDay implements Message {
  final DateTime date;
  final DateTime today;

  const MoveToDay(this.date, this.today);
}
