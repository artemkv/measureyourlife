import 'package:flutter/foundation.dart';

@immutable
abstract class Metric {
  final String id;
  final String text;

  const Metric(this.id, this.text);
}

@immutable
class BooleanMetric extends Metric {
  final String t = "b";

  const BooleanMetric(String id, String text) : super(id, text);
}

@immutable
class CounterMetric extends Metric {
  final String t = "c";

  const CounterMetric(String id, String text) : super(id, text);
}

@immutable
class EvaluationMetric extends Metric {
  final String t = "v";

  const EvaluationMetric(String id, String text) : super(id, text);
}

@immutable
abstract class MetricValue {
  final String id;

  const MetricValue(this.id);
}

@immutable
class BooleanMetricValue extends MetricValue {
  final bool val;

  const BooleanMetricValue(String id, this.val) : super(id);
}

@immutable
class CounterMetricValue extends MetricValue {
  final int val;

  const CounterMetricValue(String id, this.val) : super(id);
}

@immutable
class EvaluationMetricValue extends MetricValue {
  final int val;

  const EvaluationMetricValue(String id, this.val) : super(id);
}
