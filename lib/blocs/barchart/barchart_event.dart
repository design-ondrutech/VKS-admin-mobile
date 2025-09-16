import 'package:equatable/equatable.dart';

abstract class GoldDashboardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchGoldDashboard extends GoldDashboardEvent {}
