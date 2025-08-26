import 'package:admin/blocs/barchart/barchart_event.dart';
import 'package:admin/blocs/barchart/barchart_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GoldDashboardBloc extends Bloc<GoldDashboardEvent, GoldDashboardState> {
  final BarChartRepository repository;

  GoldDashboardBloc(this.repository) : super(const GoldDashboardInitial()) {
    on<FetchGoldDashboard>((event, emit) async {
      emit(const GoldDashboardLoading());
      try {
        final data = await repository.fetchGoldDashboard();
        emit(GoldDashboardLoaded(data));
      } catch (e) {
        emit(GoldDashboardError(e.toString()));
      }
    });
  }
}
