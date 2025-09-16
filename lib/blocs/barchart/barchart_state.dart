import 'package:admin/data/models/barchart.dart';
import 'package:equatable/equatable.dart';

abstract class GoldDashboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GoldDashboardInitial extends GoldDashboardState {}

class GoldDashboardLoading extends GoldDashboardState {}

class GoldDashboardLoaded extends GoldDashboardState {
  final GoldDashboard dashboard;
  GoldDashboardLoaded(this.dashboard);

  @override
  List<Object?> get props => [dashboard];
}

class GoldDashboardError extends GoldDashboardState {
  final String message;
  GoldDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
