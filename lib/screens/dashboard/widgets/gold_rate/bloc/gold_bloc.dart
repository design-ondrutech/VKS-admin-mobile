import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/widgets/gold_rate/bloc/gold_event.dart';
import 'package:admin/screens/dashboard/widgets/gold_rate/bloc/gold_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GoldPriceBloc extends Bloc<GoldPriceEvent, GoldPriceState> {
  final GoldPriceRepository repository;

  GoldPriceBloc(this.repository) : super(GoldPriceInitial()) {
    on<FetchGoldPriceEvent>((event, emit) async {
      emit(GoldPriceLoading());
      try {
        final allRates = await repository.fetchAllPrices(date: event.date);

        final goldRates =
            allRates.where((e) => e.metal.toLowerCase() == "gold").toList();
        final silverRates =
            allRates.where((e) => e.metal.toLowerCase() == "silver").toList();

        emit(GoldPriceLoaded(goldRates: goldRates, silverRates: silverRates));
      } catch (e) {
        emit(GoldPriceError(e.toString()));
      }
    });
  }
}
