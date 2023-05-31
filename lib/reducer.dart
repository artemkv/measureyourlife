import 'package:flutter/material.dart';

import 'model.dart';
import 'messages.dart';
import 'commands.dart';

@immutable
class ModelAndCommand {
  final Model model;
  final Command command;

  const ModelAndCommand(this.model, this.command);
  ModelAndCommand.justModel(Model model) : this(model, Command.none());
}

// reduce must be a pure function!

ModelAndCommand reduce(Model model, Message message) {
  if (message is AppInitializedNotSignedIn) {
    return ModelAndCommand.justModel(const UserNotSignedInModel(false, false));
  }
  if (message is AppInitializationFailed) {
    return ModelAndCommand.justModel(
        ApplicationFailedToInitializeModel(message.reason));
  }
  if (message is ReInitializationRequested) {
    return ModelAndCommand(ApplicationNotInitializedModel(), InitializeApp());
  }

  if (message is SignInRequested) {
    return ModelAndCommand(SignInInProgressModel(), SignIn());
  }
  if (message is UserSignedIn) {
    return ModelAndCommand.justModel(
        DayStatsModel(message.today, message.today, false));
  }
  if (message is SignInFailed) {
    return ModelAndCommand.justModel(UserFailedToSignInModel(message.reason));
  }
  if (message is SignOutRequested) {
    return ModelAndCommand(SignOutInProgressModel(), SignOut());
  }
  if (message is UserSignedOut) {
    return ModelAndCommand.justModel(const UserNotSignedInModel(false, false));
  }

  return ModelAndCommand.justModel(model);
}
