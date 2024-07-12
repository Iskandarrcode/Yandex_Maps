import 'package:dars9/data/models/restorant_model.dart';

sealed class RestorantState {}

final class InitialState extends RestorantState {}

final class LoadingState extends RestorantState {}

final class LoadedState extends RestorantState {
  List<Restorant>? restorants;
  LoadedState(this.restorants);
}

final class ErrorState extends RestorantState {
  String message;
  ErrorState(this.message);
}