import 'package:equatable/equatable.dart';
import '../../data/models/card.dart';

abstract class DashboardState extends Equatable {
  final String selectedTab;
  const DashboardState({this.selectedTab = "Overview"}); // Capital O

  @override
  List<Object?> get props => [selectedTab];
}

class DashboardLoading extends DashboardState {
  const DashboardLoading({String selectedTab = "Overview"}) : super(selectedTab: selectedTab);
}

class DashboardLoaded extends DashboardState {
  final DashboardSummary summary;

  const DashboardLoaded(this.summary, {String selectedTab = "Overview"}) : super(selectedTab: selectedTab);

  @override
  List<Object?> get props => [summary, selectedTab];
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message, {String selectedTab = "Overview"}) : super(selectedTab: selectedTab);

  @override
  List<Object?> get props => [message, selectedTab];
}
