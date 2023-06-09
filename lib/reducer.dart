import 'package:flutter/material.dart';

import 'model.dart';
import 'messages.dart';
import 'commands.dart';
import 'dateutil.dart';

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

  if (message is EditDayStatsRequested) {
    return ModelAndCommand.justModel(DayStatsEditorModel(
        message.date, message.today, message.metrics, message.metricValues));
  }
  if (message is CancelEditingDayStatsRequested) {
    return ModelAndCommand(DayStatsLoadingModel(message.today, message.today),
        LoadDayStats(message.date));
  }
  if (message is DayStatsChangesConfirmed) {
    return ModelAndCommand(DayStatsEditorSavingModel(message.date),
        SaveDayStats(message.date, message.metricValues));
  }
  if (message is DayStatsSaveRequested) {
    return ModelAndCommand(DayStatsEditorSavingModel(message.date),
        SaveDayStats(message.date, message.metricValues));
  }
  if (message is DayStatsSaved) {
    return ModelAndCommand(DayStatsLoadingModel(message.date, message.today),
        LoadDayStats(message.date));
  }
  if (message is SavingDayStatsFailed) {
    return ModelAndCommand.justModel(DayStatsEditorFailedToSaveModel(
        message.date, message.metricValues, message.reason));
  }

  if (message is MoveToPrevDay) {
    DateTime newDate = message.date.prevDay();
    return ModelAndCommand(
        DayStatsLoadingModel(newDate, message.today), LoadDayStats(newDate));
  }
  if (message is MoveToNextDay) {
    DateTime newDate = message.date.nextDay();
    return ModelAndCommand(
        DayStatsLoadingModel(newDate, message.today), LoadDayStats(newDate));
  }
  if (message is MoveToPrevWeek) {
    DateTime newDate = message.date.prevWeek();
    return ModelAndCommand(
        DayStatsLoadingModel(newDate, message.today), LoadDayStats(newDate));
  }
  if (message is MoveToNextWeek) {
    DateTime newDate = message.date.nextWeek();
    return ModelAndCommand(
        DayStatsLoadingModel(newDate, message.today), LoadDayStats(newDate));
  }
  if (message is MoveToDay) {
    return ModelAndCommand(DayStatsLoadingModel(message.date, message.today),
        LoadDayStats(message.date));
  }

  return ModelAndCommand.justModel(model);
}
