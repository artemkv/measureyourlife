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
      var metrics = {
        "id1": const BooleanMetric("id1", "hello"),
        "id2": const BooleanMetric("id2", "world"),
        "id21": const BooleanMetric("id21", "aaa bbb ccc"),
        "id3": const CounterMetric("id3", "count me"),
        "id31": const CounterMetric("id31", "count me"),
        "id32": const CounterMetric("id32", "count me"),
        "id33": const CounterMetric("id33", "count me"),
        "id34": const CounterMetric("id34", "count me"),
        "id35": const CounterMetric("id35", "count me"),
        "id36": const CounterMetric("id36", "count me"),
        "id37": const CounterMetric("id37", "count me"),
        "id38": const CounterMetric("id38", "count me"),
        "id39": const CounterMetric("id39", "count me"),
        "id30": const CounterMetric("id30", "count me"),
        "id301": const CounterMetric("id301", "count me"),
        "id302": const CounterMetric("id302", "count me"),
        "id303": const CounterMetric("id303", "count me"),
        "id304": const CounterMetric("id304", "count me"),
        "id305": const CounterMetric("id305", "count me"),
        "id306": const CounterMetric("id306", "count me"),
        "id307": const CounterMetric("id307", "count me"),
        "id308": const CounterMetric("id308", "count me"),
        "id309": const CounterMetric("id309", "count me"),
      };
      var metricValues = [
        const BooleanMetricValue("id1", true),
        const BooleanMetricValue("id2", false),
        const CounterMetricValue("id3", 4),
        const CounterMetricValue("id31", 4),
        const CounterMetricValue("id32", 4),
        const CounterMetricValue("id33", 4),
        const BooleanMetricValue("id21", false),
        const CounterMetricValue("id34", 4),
        const CounterMetricValue("id35", 4),
        const CounterMetricValue("id36", 4),
        const CounterMetricValue("id37", 4),
        const CounterMetricValue("id38", 4),
        const CounterMetricValue("id39", 4),
        const CounterMetricValue("id30", 4),
        const CounterMetricValue("id301", 4),
        const CounterMetricValue("id302", 4),
        const CounterMetricValue("id303", 4),
        const CounterMetricValue("id304", 4),
        const CounterMetricValue("id305", 4),
        const CounterMetricValue("id306", 4),
        const CounterMetricValue("id307", 4),
        const CounterMetricValue("id308", 4),
        const CounterMetricValue("id309", 4),
      ];

      dispatch(DayStatsLoaded(date, today, editable, metrics, metricValues));
    } catch (err) {
      dispatch(DayStatsLoadingFailed(date, today, err.toString()));
    }
  }
}
