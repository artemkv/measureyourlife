import 'package:flutter/material.dart';
import 'package:measureyourlife/view.dart';

import 'domain.dart';
import 'messages.dart';
import 'model.dart';
import 'theme.dart';

class DayStatsView extends StatefulWidget {
  final DayStatsModel model;
  final void Function(Message) dispatch;

  const DayStatsView({Key? key, required this.model, required this.dispatch})
      : super(key: key);

  @override
  State<DayStatsView> createState() => _DayStatsViewState();
}

class _DayStatsViewState extends State<DayStatsView> {
  static const yesterday = 1;
  static const today = 2;
  static const tomorrow = 3;

  final PageController _controller = PageController(initialPage: today);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Measure your life'),
          elevation: 0.0,
        ),
        drawer: drawer(
            context, widget.model.date, widget.model.today, widget.dispatch),
        body: Column(children: [
          Expanded(
              child: Center(
                  child: PageView.builder(
                      onPageChanged: (page) {},
                      scrollDirection: Axis.horizontal,
                      controller: _controller,
                      itemBuilder: (context, index) {
                        return dayStatsPageReadOnly(
                            widget.model, index == today, widget.dispatch);
                      })))
        ]),
        floatingActionButton: (widget.model.editable
            ? FloatingActionButton(
                onPressed: () {
                  widget.dispatch(EditStatsRequested(
                      widget.model.date,
                      widget.model.today,
                      widget.model.metrics,
                      widget.model.metricValues));
                },
                backgroundColor: crayolaBlue,
                child: const Icon(Icons.edit),
              )
            : null));
  }
}

class DayStatsEditor extends StatefulWidget {
  final DayStatsEditorModel model;
  final void Function(Message) dispatch;

  const DayStatsEditor({Key? key, required this.model, required this.dispatch})
      : super(key: key);

  @override
  State<DayStatsEditor> createState() => _DayStatsEditorState();
}

class _DayStatsEditorState extends State<DayStatsEditor> {
  List<MetricValue> _metricValues = List.empty();

  @override
  void initState() {
    super.initState();
    _metricValues = widget.model.metricValues;
  }

  Widget toAnswer(Metric? metric, MetricValue metricValue) {
    if (metricValue is BooleanMetricValue) {
      if (metric is BooleanMetric) {
        return boolAnswer(metric.text, metricValue.val, (value) {
          setState(() {
            _metricValues = _metricValues.map((m) {
              if (m.id == metricValue.id) {
                return BooleanMetricValue(m.id, value ?? false);
              } else {
                return m;
              }
            }).toList();
          });
        });
      } else {
        return const Text("unknown metric");
      }
    } else if (metricValue is CounterMetricValue) {
      if (metric is CounterMetric) {
        return countAnswer(metric.text, metricValue.val, (value) {
          setState(() {
            _metricValues = _metricValues.map((m) {
              if (m.id == metricValue.id) {
                return CounterMetricValue(m.id, value);
              } else {
                return m;
              }
            }).toList();
          });
        });
      } else {
        return const Text("unknown metric");
      }
    } else if (metricValue is EvaluationMetricValue) {
      if (metric is EvaluationMetric) {
        return evalAnswer(metric.text, metricValue.val, (value) {
          setState(() {
            _metricValues = _metricValues.map((m) {
              if (m.id == metricValue.id) {
                return EvaluationMetricValue(m.id, value);
              } else {
                return m;
              }
            }).toList();
          });
        });
      } else {
        return const Text("unknown metric");
      }
    } else {
      return const Text("unknown metric");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Edit stats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Save',
            onPressed: () {
              widget.dispatch(StatsChangesConfirmed(
                  widget.model.date, widget.model.today, _metricValues));
            },
          )
        ],
      ),
      body: WillPopScope(
          onWillPop: () async {
            widget.dispatch(CancelEditingStatsRequested(
                widget.model.date, widget.model.today));
            return false;
          },
          child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(TEXT_PADDING),
                        child: Column(
                            children: _metricValues.map((metricValue) {
                          var metric = widget.model.metrics[metricValue.id];
                          return toAnswer(metric, metricValue);
                        }).toList()))))
          ])),
    );
  }
}

class Evaluator extends StatefulWidget {
  final int value;
  final void Function(int value) onChanged;

  const Evaluator({super.key, required this.value, required this.onChanged});

  @override
  State<Evaluator> createState() => _EvaluatorState();
}

class _EvaluatorState extends State<Evaluator> {
  int? _val = -1;

  @override
  void initState() {
    super.initState();
    _val = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<int>(
            value: 1,
            groupValue: _val,
            onChanged: (val) {
              setState(() {
                _val = val;
              });
              if (val != null) {
                widget.onChanged(val);
              }
            }),
        Radio<int>(
            value: 2,
            groupValue: _val,
            onChanged: (val) {
              setState(() {
                _val = val;
              });
              if (val != null) {
                widget.onChanged(val);
              }
            }),
        Radio<int>(
            value: 3,
            groupValue: _val,
            onChanged: (val) {
              setState(() {
                _val = val;
              });
              if (val != null) {
                widget.onChanged(val);
              }
            }),
        Radio<int>(
            value: 4,
            groupValue: _val,
            onChanged: (val) {
              setState(() {
                _val = val;
              });
              if (val != null) {
                widget.onChanged(val);
              }
            }),
        Radio<int>(
            value: 5,
            groupValue: _val,
            onChanged: (val) {
              setState(() {
                _val = val;
              });
              if (val != null) {
                widget.onChanged(val);
              }
            }),
      ],
    );
  }
}
