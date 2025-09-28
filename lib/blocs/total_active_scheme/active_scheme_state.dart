// active_scheme_state.dart
import 'package:admin/data/models/today_active_scheme.dart';
import 'package:equatable/equatable.dart';

abstract class TotalActiveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TotalActiveInitial extends TotalActiveState {}

class TotalActiveLoading extends TotalActiveState {}

class TotalActiveLoaded extends TotalActiveState {
  final TotalActiveSchemeResponse response;

  TotalActiveLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class TotalActiveError extends TotalActiveState {
  final String message;

  TotalActiveError({required this.message});

  @override
  List<Object?> get props => [message];
}
