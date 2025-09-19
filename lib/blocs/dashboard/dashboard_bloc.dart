import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import 'package:admin/data/repo/auth_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final CardRepository repository;
  Timer? _timer;

  DashboardBloc(this.repository)
      : super(const DashboardLoading(selectedTab: "Overview")) {
    on<FetchDashboardSummary>((event, emit) async {
      emit(DashboardLoading(selectedTab: state.selectedTab));
      try {
        final summary = await repository.fetchSummary();
        emit(DashboardLoaded(summary, selectedTab: state.selectedTab));
      } catch (e) {
        emit(DashboardError(e.toString(), selectedTab: state.selectedTab));
      }
    });

    on<ChangeDashboardTab>((event, emit) async {
      if (state is DashboardLoaded) {
        emit(DashboardLoaded((state as DashboardLoaded).summary,
            selectedTab: event.tab));
      } else if (state is DashboardError) {
        emit(DashboardError((state as DashboardError).message,
            selectedTab: event.tab));
      } else {
        emit(DashboardLoading(selectedTab: event.tab));
      }
    });

    //  Auto refresh every 10 sec
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      add(FetchDashboardSummary());
    });

    // Initial load
    add(FetchDashboardSummary());
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
