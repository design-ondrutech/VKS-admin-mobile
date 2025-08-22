import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/card.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';


class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final CardRepository repository;

  DashboardBloc(this.repository) : super(const DashboardLoading(selectedTab: "Overview")) { // capital O
    // Fetch dashboard summary
    on<FetchDashboardSummary>((event, emit) async {
      emit(DashboardLoading(selectedTab: state.selectedTab));
      try {
        final summary = await repository.fetchSummary();
        emit(DashboardLoaded(summary, selectedTab: state.selectedTab));
      } catch (e) {
        emit(DashboardError(e.toString(), selectedTab: state.selectedTab));
      }
    });

    // Change dashboard tab
    on<ChangeDashboardTab>((event, emit) async {
      if (state is DashboardLoaded) {
        emit(DashboardLoaded((state as DashboardLoaded).summary, selectedTab: event.tab));
      } else if (state is DashboardError) {
        emit(DashboardError((state as DashboardError).message, selectedTab: event.tab));
      } else {
        emit(DashboardLoading(selectedTab: event.tab));
      }
    });
  }
}

