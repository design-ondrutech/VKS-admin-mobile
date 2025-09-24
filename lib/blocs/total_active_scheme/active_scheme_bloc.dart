import 'package:admin/blocs/total_active_scheme/active_scheme_event.dart';
import 'package:admin/blocs/total_active_scheme/active_scheme_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // date compare ku helpful

class TotalActiveBloc extends Bloc<TotalActiveEvent, TotalActiveState> {
  final TotalActiveSchemesRepository repository;

  TotalActiveBloc({required this.repository}) : super(TotalActiveInitial()) {
    on<FetchTotalActiveSchemes>((event, emit) async {
      emit(TotalActiveLoading());
      try {
        final response = await repository.getTotalActiveSchemes();
        final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

        final todayData =
            response.data.where((scheme) {
              final startDate = DateFormat(
                'yyyy-MM-dd',
              ).format(DateTime.tryParse(scheme.startDate) ?? DateTime(1900));
              return startDate == today;
            }).toList();

        emit(
          TotalActiveLoaded(
            response: response.copyWith(
              data: todayData,
              totalCount: todayData.length,
            ),
          ),
        );
      } catch (e) {
        emit(TotalActiveError(message: e.toString()));
      }
    });
  }
}
