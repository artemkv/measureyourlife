import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:measureyourlife/theme.dart';

import 'custom_components.dart';
import 'domain.dart';
import 'messages.dart';
import 'model.dart';

// These should be all stateless! No side effects allowed!

const TEXT_PADDING = 12.0;
const TEXT_FONT_SIZE = 16.0;
const THEME_COLOR = wildStrawberry;

Widget home(
    BuildContext context, Model model, void Function(Message) dispatch) {
  if (model is ApplicationNotInitializedModel) {
    return applicationNotInitialized(dispatch);
  }
  if (model is ApplicationFailedToInitializeModel) {
    return applicationFailedToInitialize(model, dispatch);
  }

  if (model is UserNotSignedInModel) {
    return userNotSignedIn(model, dispatch);
  }
  if (model is SignInInProgressModel) {
    return signInInProgress();
  }
  if (model is UserFailedToSignInModel) {
    return userFailedToSignIn(model, dispatch);
  }
  if (model is SignOutInProgressModel) {
    return signOutInProgress();
  }

  if (model is DayStatsLoadingModel) {
    return dayStatsLoading(context, model, dispatch);
  }
  if (model is DayStatsModel) {
    return DayStatsView(key: UniqueKey(), model: model, dispatch: dispatch);
  }
  if (model is DayStatsFailedToLoadModel) {
    return dayStatsFailedToLoad(context, model, dispatch);
  }

  if (model is DayStatsEditorModel) {
    return DayStatsEditor(model: model, dispatch: dispatch);
  }
  if (model is StatsEditorSavingModel) {
    return statsEditorSaving(model);
  }
  if (model is StatsEditorFailedToSaveModel) {
    return statsEditorFailedToSave(model, dispatch);
  }

  return unknownModel(model);
}

Widget unknownModel(Model model) {
  return Text("Unknown model: ${model.runtimeType}");
}

Widget applicationNotInitialized(void Function(Message) dispatch) {
  return Material(
    type: MaterialType.transparency,
    child: Container(
        decoration: const BoxDecoration(color: THEME_COLOR),
        child: const Expanded(child: Row())),
  );
}

Widget applicationFailedToInitialize(
    ApplicationFailedToInitializeModel model, void Function(Message) dispatch) {
  return Material(
      type: MaterialType.transparency,
      child: Container(
          decoration: const BoxDecoration(color: THEME_COLOR),
          child: Column(children: [
            const Padding(
                padding: EdgeInsets.only(top: 64, left: 12, right: 12),
                child: Text("Failed to start the application",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold))),
            Padding(
                padding: const EdgeInsets.all(12),
                child: Text("Failed to initialize: ${model.reason}",
                    style: const TextStyle(color: Colors.white, fontSize: 16))),
            Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  onPressed: () {
                    dispatch(ReInitializationRequested());
                  },
                  child: const Text("Try again",
                      style: TextStyle(
                          color: THEME_COLOR,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ))
          ])));
}

Widget userNotSignedIn(
    UserNotSignedInModel model, void Function(Message) dispatch) {
  return Material(
    type: MaterialType.transparency,
    child: Container(
        decoration: const BoxDecoration(color: THEME_COLOR),
        child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(children: [
              const Expanded(child: Row()),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: []))
                ],
              ),
              Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Expanded(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                          signInButton(model, dispatch),
                          // userConsent(model, dispatch) // TODO:
                        ]))
                  ])),
            ]))),
  );
}

Widget userFailedToSignIn(
    UserFailedToSignInModel model, void Function(Message) dispatch) {
  return Material(
      type: MaterialType.transparency,
      child: Container(
          decoration: const BoxDecoration(color: THEME_COLOR),
          child: Column(children: [
            const Padding(
                padding: EdgeInsets.only(top: 64, left: 12, right: 12),
                child: Text("Sign in failed or cancelled",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold))),
            Padding(
                padding: const EdgeInsets.all(12),
                child: Text("Failed to sign in: ${model.reason}",
                    style: const TextStyle(color: Colors.white, fontSize: 16))),
            Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10)),
                  onPressed: () {
                    dispatch(AppInitializedNotSignedIn());
                  },
                  child: const Text("Try again",
                      style: TextStyle(
                          color: THEME_COLOR,
                          fontSize: 24,
                          fontWeight: FontWeight.bold)),
                ))
          ])));
}

Widget signInInProgress() {
  return Material(
      type: MaterialType.transparency,
      child: Container(
          decoration: const BoxDecoration(color: THEME_COLOR),
          child: const Column(
            children: [],
          )));
}

Widget signOutInProgress() {
  return Material(
      type: MaterialType.transparency,
      child: Container(
          decoration: const BoxDecoration(color: THEME_COLOR),
          child: const Column(
            children: [],
          )));
}

Widget signInButton(
    UserNotSignedInModel model, void Function(Message) dispatch) {
  var consentGiven = true;
  //(model.privacyPolicyAccepted && model.personalDataProcessingAccepted);

  return Padding(
      padding: const EdgeInsets.all(12.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
        onPressed: consentGiven
            ? () {
                dispatch(SignInRequested());
              }
            // ignore: dead_code
            : null,
        child: const Text("Sign in",
            style: TextStyle(
                color: THEME_COLOR, fontSize: 24, fontWeight: FontWeight.bold)),
      ));
}

Widget drawer(BuildContext context, DateTime date, DateTime today,
    void Function(Message) dispatch) {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        const DrawerHeader(
          decoration: BoxDecoration(
            color: crayolaBlue,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
                padding: EdgeInsets.all(2.0),
                child: Text("Measure Your Life",
                    style: TextStyle(
                      fontSize: TEXT_FONT_SIZE,
                      color: Colors.white,
                    ))),
            Padding(
                padding: EdgeInsets.all(2.0),
                child: Text("Blah-blah",
                    style: TextStyle(
                      fontSize: TEXT_FONT_SIZE * 0.8,
                      color: Colors.white,
                    )))
          ]),
        ),
        ListTile(
          title: const Row(children: [
            Padding(
                padding: EdgeInsets.only(left: 4.0, right: 32.0),
                child: Icon(Icons.logout)),
            Text('Sign out')
          ]),
          onTap: () {
            dispatch(SignOutRequested());
          },
        ),
      ],
    ),
  );
}

Widget dayStatsLoading(BuildContext context, DayStatsLoadingModel model,
    void Function(Message) dispatch) {
  return Scaffold(
      appBar: AppBar(
        title: const Text('Measure your life'),
        elevation: 0.0,
      ),
      drawer: drawer(context, model.date, model.today, dispatch),
      body: Center(child: Column(children: [Expanded(child: spinner())])));
}

Widget dayStatsFailedToLoad(BuildContext context,
    DayStatsFailedToLoadModel model, void Function(Message) dispatch) {
  return Scaffold(
      appBar: AppBar(
        title: const Text('Measure your life'),
        elevation: 0.0,
      ),
      drawer: drawer(context, model.date, model.today, dispatch),
      body: Center(
          child: Column(children: [
        Padding(
            padding: const EdgeInsets.all(TEXT_PADDING),
            child: Text("Failed to contact the server: ${model.reason}",
                style: const TextStyle(
                    fontSize: TEXT_FONT_SIZE, color: Colors.red))),
        Expanded(
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  dispatch(DayStatsReloadRequested(model.date, model.today));
                },
                child: Center(
                    child: Text("Click to reload",
                        style: GoogleFonts.openSans(
                            textStyle: const TextStyle(
                                fontSize: TEXT_FONT_SIZE,
                                color: Colors.grey))))))
      ])));
}

Widget dayStatsPageReadOnly(
    DayStatsModel model, bool todayPage, void Function(Message) dispatch) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Expanded(child: dayStatsViewer(model.metrics, model.metricValues))
  ]);
}

Widget dayStatsViewer(
    List<Metric> metrics, Map<String, MetricValue> metricValues) {
  return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.all(TEXT_PADDING),
          child: Column(
              children: metrics.map((metric) {
            var metricValue = metricValues[metric.id];
            return toAnswerView(
                metric, metricValue ?? getEmptyMetricValue(metric));
          }).toList())));
}

Widget toAnswerView(Metric metric, MetricValue metricValue) {
  if (metricValue is BooleanMetricValue) {
    if (metric is BooleanMetric) {
      return boolAnswerView(metric.text, metricValue.val);
    } else {
      return const Text("unknown metric");
    }
  } else if (metricValue is CounterMetricValue) {
    if (metric is CounterMetric) {
      return countAnswerView(metric.text, metricValue.val);
    } else {
      return const Text("unknown metric");
    }
  } else if (metricValue is EvaluationMetricValue) {
    if (metric is EvaluationMetric) {
      return evalAnswerView(metric.text, metricValue.val);
    } else {
      return const Text("unknown metric");
    }
  } else {
    return const Text("unknown metric");
  }
}

Widget boolAnswerView(String text, bool value) {
  return Padding(
      padding: const EdgeInsets.only(top: TEXT_PADDING * 1.2),
      child: Column(children: [
        Row(children: [
          Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: value,
              onChanged: (x) {}),
          Flexible(
              child: Wrap(children: [
            Text(
              text,
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(fontSize: TEXT_FONT_SIZE)),
            )
          ]))
        ])
      ]));
}

Widget boolAnswer(
    String text, bool value, void Function(bool? value) onChanged) {
  return Padding(
      padding: const EdgeInsets.only(top: TEXT_PADDING * 1.2),
      child: Column(children: [
        Row(children: [
          Checkbox(
              checkColor: Colors.white,
              fillColor: MaterialStateProperty.resolveWith(getColor),
              value: value,
              onChanged: onChanged),
          Flexible(
              child: Wrap(children: [
            Text(
              text,
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(fontSize: TEXT_FONT_SIZE)),
            )
          ]))
        ])
      ]));
}

Widget countAnswerView(String text, int value) {
  return Padding(
      padding:
          const EdgeInsets.only(top: TEXT_PADDING * 1.2, left: TEXT_PADDING),
      child: Column(children: [
        Row(children: [
          Flexible(
              child: Wrap(children: [
            Text(
              "$text: ",
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(fontSize: TEXT_FONT_SIZE)),
            )
          ])),
          Padding(
              padding: const EdgeInsets.only(
                  left: TEXT_PADDING / 2, right: TEXT_PADDING / 2),
              child: Text(
                value.toString(),
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(
                        fontSize: TEXT_FONT_SIZE, fontWeight: FontWeight.w600)),
              )),
        ])
      ]));
}

Widget countAnswer(String text, int value, void Function(int value) onChanged) {
  return Padding(
      padding:
          const EdgeInsets.only(top: TEXT_PADDING * 1.2, left: TEXT_PADDING),
      child: Column(children: [
        Row(children: [
          Flexible(
              child: Wrap(children: [
            Text(
              "$text: ",
              style: GoogleFonts.openSans(
                  textStyle: const TextStyle(fontSize: TEXT_FONT_SIZE)),
            )
          ])),
          IconButton(
            icon: Icon(
              Icons.remove,
              color: wildStrawberry.shade900,
            ),
            iconSize: 32.0,
            onPressed: () {
              onChanged(value - 1);
            },
          ),
          Padding(
              padding: const EdgeInsets.only(
                  left: TEXT_PADDING / 2, right: TEXT_PADDING / 2),
              child: Text(
                value.toString(),
                style: GoogleFonts.openSans(
                    textStyle: const TextStyle(fontSize: TEXT_FONT_SIZE)),
              )),
          IconButton(
            icon: Icon(
              Icons.add,
              color: wildStrawberry.shade900,
            ),
            iconSize: 32.0,
            onPressed: () {
              onChanged(value + 1);
            },
          ),
        ])
      ]));
}

Widget evalAnswerView(String text, int value) {
  return Padding(
      padding:
          const EdgeInsets.only(top: TEXT_PADDING * 1.2, left: TEXT_PADDING),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "$text: ",
          style: GoogleFonts.openSans(
              textStyle: const TextStyle(fontSize: TEXT_FONT_SIZE)),
        ),
        Padding(
            padding: const EdgeInsets.only(
                left: TEXT_PADDING / 2, right: TEXT_PADDING / 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio<int>(value: 1, groupValue: value, onChanged: (val) {}),
                Radio<int>(value: 2, groupValue: value, onChanged: (val) {}),
                Radio<int>(value: 3, groupValue: value, onChanged: (val) {}),
                Radio<int>(value: 4, groupValue: value, onChanged: (val) {}),
                Radio<int>(value: 5, groupValue: value, onChanged: (val) {}),
              ],
            ))
      ]));
}

Widget evalAnswer(String text, int value, void Function(int value) onChanged) {
  return Padding(
      padding:
          const EdgeInsets.only(top: TEXT_PADDING * 1.2, left: TEXT_PADDING),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "$text: ",
          style: GoogleFonts.openSans(
              textStyle: const TextStyle(fontSize: TEXT_FONT_SIZE)),
        ),
        Padding(
            padding: const EdgeInsets.only(
                left: TEXT_PADDING / 2, right: TEXT_PADDING / 2),
            child: Evaluator(value: value, onChanged: onChanged))
      ]));
}

Color getColor(Set<MaterialState> states) {
  return wildStrawberry;
}

Widget spinner() {
  return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [CircularProgressIndicator(value: null)]);
}

Widget statsEditorSaving(StatsEditorSavingModel model) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Saving'),
    ),
    body: Center(child: spinner()),
  );
}

Widget statsEditorFailedToSave(
    StatsEditorFailedToSaveModel model, void Function(Message) dispatch) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Failed to save'),
    ),
    body: Center(
        child: Column(children: [
      Padding(
          padding: const EdgeInsets.all(TEXT_PADDING),
          child: Text("Failed to contact the server: ${model.reason}",
              style: const TextStyle(
                  fontSize: TEXT_FONT_SIZE, color: Colors.red))),
      Expanded(
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                dispatch(StatsSaveRequested(model.date, model.metricValues));
              },
              child: const Center(
                  child: Text("Click to re-try",
                      style: TextStyle(
                          fontSize: TEXT_FONT_SIZE, color: Colors.grey)))))
    ])),
  );
}
