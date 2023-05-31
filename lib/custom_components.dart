import 'package:flutter/material.dart';
import 'package:measureyourlife/view.dart';

import 'messages.dart';
import 'model.dart';

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
                        return dayStatsPage(
                            widget.model, index == today, widget.dispatch);
                      })))
        ]));
  }
}
