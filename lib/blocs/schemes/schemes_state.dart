import 'package:admin/data/models/scheme.dart';

abstract class SchemesState {}

class SchemeInitial extends SchemesState {}
class SchemeLoading extends SchemesState {}

class SchemeLoaded extends SchemesState {
  final List<Scheme> schemes;
  SchemeLoaded(this.schemes);
}

class SchemeOperationSuccess extends SchemesState {
  final Scheme scheme;
  SchemeOperationSuccess(this.scheme);
}

class SchemeError extends SchemesState {
  final String message;
  SchemeError(this.message);
}
class SchemeActionSuccess extends SchemesState {
  final String message;
  SchemeActionSuccess(this.message);
}
