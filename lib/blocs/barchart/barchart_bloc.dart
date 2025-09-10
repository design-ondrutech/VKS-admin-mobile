// gold_dashboard_bloc.dart
import 'package:admin/blocs/barchart/barchart_event.dart';
import 'package:admin/blocs/barchart/barchart_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GoldDashboardBloc extends Bloc<GoldDashboardEvent, GoldDashboardState> {
  final GoldDashboardRepository repository;

  GoldDashboardBloc(this.repository) : super(GoldDashboardInitial()) {
    on<LoadGoldDashboard>((event, emit) async {
      emit(GoldDashboardLoading());
      try {
        final dashboard = await repository.fetchGoldDashboard();
        emit(GoldDashboardLoaded(dashboard));
      } catch (e) {
        emit(GoldDashboardError(e.toString()));
      }
    });
  }
}
