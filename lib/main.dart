import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  // TODO: move to initialization command
  WidgetsFlutterBinding.ensureInitialized();

  // The rest of the code is moved away to stay null safe
  runApp(const MyApp());
}
