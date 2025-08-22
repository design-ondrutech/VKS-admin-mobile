import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchDashboardSummary extends DashboardEvent {}

class ChangeDashboardTab extends DashboardEvent {
  final String tab;
  ChangeDashboardTab(this.tab);

  @override
  List<Object?> get props => [tab];
}
