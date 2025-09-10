// gold_dashboard_event.dart
import 'package:equatable/equatable.dart';

abstract class GoldDashboardEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadGoldDashboard extends GoldDashboardEvent {}
