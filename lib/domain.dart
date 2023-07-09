import 'package:flutter/foundation.dart';

@immutable
abstract class Metric {
  final String type;
  final String id;
  final String text;

  const Metric(this.type, this.id, this.text);
}

@immutable
class BooleanMetric extends Metric {
  const BooleanMetric(String id, String text) : super("b", id, text);
}

@immutable
class CounterMetric extends Metric {
  const CounterMetric(String id, String text) : super("c", id, text);
}

@immutable
class EvaluationMetric extends Metric {
  const EvaluationMetric(String id, String text) : super("v", id, text);
}

@immutable
abstract class MetricValue {
  final String id;

  const MetricValue(this.id);

  Map<String, dynamic> toJson();
}

@immutable
class UnknownMetricValue extends MetricValue {
  final String val;

  const UnknownMetricValue(String id, this.val) : super(id);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'value': val};
}

@immutable
class BooleanMetricValue extends MetricValue {
  final bool val;

  const BooleanMetricValue(String id, this.val) : super(id);

  @override
  Map<String, dynamic> toJson() =>
      {'id': id, 'value': (val == true ? 1 : 0).toString()};
}

@immutable
class CounterMetricValue extends MetricValue {
  final int val;

  const CounterMetricValue(String id, this.val) : super(id);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'value': val.toString()};
}

@immutable
class EvaluationMetricValue extends MetricValue {
  final int val;

  const EvaluationMetricValue(String id, this.val) : super(id);

  @override
  Map<String, dynamic> toJson() => {'id': id, 'value': val.toString()};
}

@immutable
class DayStatsData {
  final List<MetricValue> metricValues;

  const DayStatsData(this.metricValues);

  DayStatsData.fromJson(
      Map<String, String> metricTypes, Map<String, dynamic> json)
      : metricValues = (json['metric_values'] as List)
            .map((x) => fromJson(metricTypes, x))
            .toList();

  Map<String, dynamic> toJson() =>
      {'metric_values': metricValues.map((i) => i.toJson()).toList()};
}

MetricValue fromJson(
    Map<String, String> metricTypes, Map<String, dynamic> json) {
  String id = json['id'];
  String? type = metricTypes[id];
  int val = 0;
  try {
    val = int.parse(json['value']);
  } on FormatException {
    // ignore
  }
  if (type != null) {
    if (type == "b") {
      return BooleanMetricValue(id, val == 1 ? true : false);
    } else if (type == "c") {
      return CounterMetricValue(id, val);
    } else if (type == "v") {
      return EvaluationMetricValue(id, val);
    }
  }
  return UnknownMetricValue(id, json['value']);
}

MetricValue getEmptyMetricValue(Metric metric) {
  if (metric is BooleanMetric) {
    return BooleanMetricValue(metric.id, false);
  }
  if (metric is CounterMetric) {
    return CounterMetricValue(metric.id, 0);
  }
  if (metric is EvaluationMetric) {
    return EvaluationMetricValue(metric.id, -1);
  }
  throw "Unhandled metric type";
}
