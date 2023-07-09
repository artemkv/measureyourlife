// This is the only place where side-effects are allowed!

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:measureyourlife/dateutil.dart';

import 'domain.dart';
import 'messages.dart';
import 'services/google_sign_in.dart';
import 'services/session_api.dart';

@immutable
abstract class Command {
  void execute(void Function(Message) dispatch);

  static Command none() {
    return None();
  }

  static Command getInitialCommand() {
    return InitializeApp();
  }
}

@immutable
class None implements Command {
  @override
  void execute(void Function(Message) dispatch) {}
}

@immutable
class CommandList implements Command {
  final List<Command> items;

  const CommandList(this.items);

  @override
  void execute(void Function(Message) dispatch) {
    for (var cmd in items) {
      cmd.execute(dispatch);
    }
  }
}

@immutable
class InitializeApp implements Command {
  @override
  void execute(void Function(Message) dispatch) {
    var today = DateTime.now();

    Firebase.initializeApp()
        .then((app) => Future<FirebaseApp>.delayed(
              const Duration(milliseconds: 500),
              () => app,
            ))
        .then((_) {
      GoogleSignInFacade.subscribeToIdTokenChanges(
        (_) {
          dispatch(UserSignedIn(today));
        },
        () {
          killSession();
          dispatch(UserSignedOut());
        },
        (err) {
          killSession();
          dispatch(SignInFailed(err.toString()));
        },
      );
    }).catchError((err) {
      dispatch(AppInitializationFailed(err.toString()));
    });
  }
}

@immutable
class SignIn implements Command {
  @override
  void execute(void Function(Message) dispatch) {
    GoogleSignInFacade.signInWithGoogle().catchError((err) {
      killSession();
      dispatch(SignInFailed(err.toString()));
    });
  }
}

@immutable
class SignOut implements Command {
  @override
  void execute(void Function(Message) dispatch) {
    killSession();
    GoogleSignInFacade.signOut().then((_) {
      dispatch(UserSignedOut());
    }).catchError((err) {
      dispatch(UserSignedOut());
    });
  }
}

@immutable
class LoadDayStats implements Command {
  final DateTime date;

  const LoadDayStats(this.date);

  @override
  void execute(void Function(Message) dispatch) {
    Future<void>.delayed(Duration.zero, () => loadDayStats(dispatch));
  }

  Future<void> loadDayStats(void Function(Message) dispatch) async {
    var today = DateTime.now();
    bool editable = date.isSameDate(today) || date.isBefore(today);

    try {
      // TODO:
      /*if (!editable) {
        dispatch(DailyWinViewLoaded(date, today, priorityList, WinData.empty(),
            editable, askForReview));
        return;
      }*/

      // TODO: metrics are hard-coded by now
      var metrics = [
        const EvaluationMetric("hap", "Overall happiness"),
        const EvaluationMetric("egy", "Energy level"),
        const EvaluationMetric("act", "Activity level"),
        const EvaluationMetric("soc", "Social interactions"),
        const EvaluationMetric("frd", "Level of connection"),
        const EvaluationMetric("ach", "Level of achievement"),
        const EvaluationMetric("anx", "Anxiety"),
        const EvaluationMetric("eng", "Motivation and focus with projects"),
        const BooleanMetric("id1", "Abs"),
        const BooleanMetric("id2", "Shoulders"),
        const CounterMetric("id3", "Hangs"),
      ];

      var dateKey = date.toCompact();

      var json = await getDayStats(dateKey, GoogleSignInFacade.getIdToken);
      var metricTypes = {for (var m in metrics) m.id: m.type};
      var dayStats = DayStatsData.fromJson(metricTypes, json);
      var metricValues = {for (var m in dayStats.metricValues) m.id: m};

      dispatch(DayStatsLoaded(date, today, editable, metrics, metricValues));
    } catch (err) {
      dispatch(DayStatsLoadingFailed(date, today, err.toString()));
    }
  }
}

@immutable
class SaveDayStats implements Command {
  final DateTime date;
  final Map<String, MetricValue> metricValues;

  const SaveDayStats(this.date, this.metricValues);

  @override
  void execute(void Function(Message) dispatch) {
    var today = DateTime.now();

    var dateKey = date.toCompact();

    postDayStats(dateKey, DayStatsData(metricValues.values.toList()),
            GoogleSignInFacade.getIdToken)
        .then((_) {
      dispatch(DayStatsSaved(date, today));
    }).catchError((err) {
      dispatch(SavingDayStatsFailed(date, metricValues, err.toString()));
    });
  }
}
