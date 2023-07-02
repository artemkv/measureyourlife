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
    return ModelAndCommand(DayStatsLoadingModel(message.today, message.today),
        LoadDayStats(message.today));
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

  if (message is DayStatsLoaded) {
    return ModelAndCommand.justModel(DayStatsModel(message.date, message.today,
        message.editable, message.metrics, message.metricValues));
  }
  if (message is DayStatsLoadingFailed) {
    return ModelAndCommand.justModel(
        DayStatsFailedToLoadModel(message.date, message.today, message.reason));
  }
  if (message is DayStatsReloadRequested) {
    return ModelAndCommand(DayStatsLoadingModel(message.today, message.today),
        LoadDayStats(message.date));
  }

  if (message is EditStatsRequested) {
    return ModelAndCommand.justModel(DayStatsEditorModel(
        message.date, message.today, message.metrics, message.metricValues));
  }
  if (message is CancelEditingStatsRequested) {
    return ModelAndCommand(DayStatsLoadingModel(message.today, message.today),
        LoadDayStats(message.date));
  }

  return ModelAndCommand.justModel(model);
}
