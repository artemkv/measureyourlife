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
class EditStatsRequested implements Message {
  final DateTime date;
  final DateTime today;
  final List<Metric> metrics;
  final Map<String, MetricValue> metricValues;

  const EditStatsRequested(
      this.date, this.today, this.metrics, this.metricValues);
}

@immutable
class CancelEditingStatsRequested implements Message {
  final DateTime date;
  final DateTime today;

  const CancelEditingStatsRequested(this.date, this.today);
}

@immutable
class StatsChangesConfirmed implements Message {
  final DateTime date;
  final DateTime today;
  final Map<String, MetricValue> metricValues;

  const StatsChangesConfirmed(this.date, this.today, this.metricValues);
}

@immutable
class StatsSaveRequested implements Message {
  final DateTime date;
  final Map<String, MetricValue> metricValues;

  const StatsSaveRequested(this.date, this.metricValues);
}

@immutable
class StatsSaved implements Message {
  final DateTime date;
  final DateTime today;

  const StatsSaved(this.date, this.today);
}

@immutable
class SavingStatsFailed implements Message {
  final DateTime date;
  final Map<String, MetricValue> metricValues;
  final String reason;

  const SavingStatsFailed(this.date, this.metricValues, this.reason);
}
