import 'package:admin/data/models/card.dart';
import 'package:equatable/equatable.dart';

abstract class CardState extends Equatable {
  const CardState();

  @override
  List<Object?> get props => [];
}

class CardLoading extends CardState {}

class CardLoaded extends CardState {
  final DashboardSummary summary;
  const CardLoaded(this.summary);

  @override
  List<Object?> get props => [summary];
}

class CardError extends CardState {
  final String message;
  const CardError(this.message);

  @override
  List<Object?> get props => [message];
}
