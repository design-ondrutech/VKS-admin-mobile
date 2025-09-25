import 'package:equatable/equatable.dart';
import '../../data/models/scheme.dart';

abstract class SchemesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SchemeInitial extends SchemesState {}

class SchemeLoading extends SchemesState {}

class SchemeLoaded extends SchemesState {
  final List<Scheme> schemes;
  SchemeLoaded(this.schemes);

  @override
  List<Object?> get props => [schemes];
}

class SchemeError extends SchemesState {
  final String message;
  SchemeError(this.message);

  @override
  List<Object?> get props => [message];
}

///  NEW STATE TO FIX YOUR ISSUE
class SchemeOperationSuccess extends SchemesState {
  final Scheme scheme;
  SchemeOperationSuccess(this.scheme);

  @override
  List<Object?> get props => [scheme];
}
