import 'package:measureyourlife/services/rest_api.dart' as rest;

String session = "";

bool hasSession() {
  return session != "";
}

void killSession() {
  session = "";
}

Future<void> signIn(String idToken) async {
  try {
    var json = await rest.signIn(idToken);
    session = json['session'];
  } catch (e) {
    session = "";
  }
}

Future<dynamic> callApi(
    Future<dynamic> Function() f, Future<String> Function() getIdToken) async {
  if (!hasSession()) {
    // print(">> No session, first need to sign in");
    var idToken = await getIdToken();
    await signIn(idToken);
    return f();
  }
  try {
    // print(">> Has session, go to the api directly");
    return await f();
  } on rest.ApiException catch (e) {
    if (e.statusCode == 401) {
      // print(">> Oops, expired, will sign in again and retry");
      var idToken = await getIdToken();
      await signIn(idToken);
      return f();
    }
    rethrow;
  }
}

Future<dynamic> getDayStats(String date, Future<String> Function() getIdToken) {
  return callApi(() => rest.getDayStats(date, session), getIdToken);
}

Future<dynamic> postDayStats(
    String date, Object data, Future<String> Function() getIdToken) {
  return callApi(() => rest.postDayStats(date, data, session), getIdToken);
}
