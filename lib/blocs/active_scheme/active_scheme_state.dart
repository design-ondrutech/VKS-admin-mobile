import 'package:admin/data/models/total_active_scheme';


abstract class TotalActiveSchemesState {}

class TotalActiveSchemesInitial extends TotalActiveSchemesState {}

class TotalActiveSchemesLoading extends TotalActiveSchemesState {}

class TotalActiveSchemesLoaded extends TotalActiveSchemesState {
  final TotalActiveSchemesResponse response;
  TotalActiveSchemesLoaded(this.response);
}

class TotalActiveSchemesError extends TotalActiveSchemesState {
  final String message;
  TotalActiveSchemesError(this.message);
}
