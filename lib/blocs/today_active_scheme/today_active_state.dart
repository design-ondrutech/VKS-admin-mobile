import 'package:admin/data/models/total_active_scheme.dart';

abstract class TodayActiveSchemeState {}

class TodayActiveSchemeInitial extends TodayActiveSchemeState {}

class TodayActiveSchemeLoading extends TodayActiveSchemeState {}

class TodayActiveSchemeLoaded extends TodayActiveSchemeState {
  final TodayActiveSchemeResponse response;
  TodayActiveSchemeLoaded(this.response);
}

class TodayActiveSchemeError extends TodayActiveSchemeState {
  final String message;
  TodayActiveSchemeError(this.message);
}
