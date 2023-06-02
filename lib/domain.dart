import 'package:flutter/foundation.dart';

@immutable
abstract class Metric {}

@immutable
class BooleanMetric implements Metric {
  final String t = "b";
  final String id;
  final String text;

  const BooleanMetric(this.id, this.text);
}

@immutable
class CounterMetric implements Metric {
  final String t = "c";
  final String id;
  final String text;

  const CounterMetric(this.id, this.text);
}

@immutable
abstract class MetricValue {}

@immutable
class BooleanMetricValue implements MetricValue {
  final String t = "b";
  final String id;
  final bool val;

  const BooleanMetricValue(this.id, this.val);
}

@immutable
class CounterMetricValue implements MetricValue {
  final String t = "c";
  final String id;
  final int val;

  const CounterMetricValue(this.id, this.val);
}

@immutable
class DayStats {
  final List<MetricValue> metrics;

  const DayStats(this.metrics);
}
