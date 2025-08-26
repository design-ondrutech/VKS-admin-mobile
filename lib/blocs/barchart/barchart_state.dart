import 'package:admin/data/models/barchart.dart';


abstract class GoldDashboardState {
  const GoldDashboardState();
}

class GoldDashboardInitial extends GoldDashboardState {
  const GoldDashboardInitial();
}

class GoldDashboardLoading extends GoldDashboardState {
  const GoldDashboardLoading();
}

class GoldDashboardLoaded extends GoldDashboardState {
  final GoldDashboardModel data;
  const GoldDashboardLoaded(this.data);
}

class GoldDashboardError extends GoldDashboardState {
  final String message;
  const GoldDashboardError(this.message);
}
