import 'package:flutter_bloc/flutter_bloc.dart';
import 'gold_event.dart';
import 'gold_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:intl/intl.dart'; // date format use panna

class GoldPriceBloc extends Bloc<GoldPriceEvent, GoldPriceState> {
  final GoldPriceRepository repository;

  GoldPriceBloc(this.repository) : super(GoldPriceInitial()) {
    on<FetchGoldPriceEvent>(_onFetchGoldPrices);
    on<DeleteGoldPriceEvent>(_onDeleteGoldPrice);
  }

  Future<void> _onFetchGoldPrices(
      FetchGoldPriceEvent event, Emitter<GoldPriceState> emit) async {
    emit(GoldPriceLoading()); //  force rebuild

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      //  Server call (date optional but we will filter after fetching)
      final allRates = await repository.fetchAllPrices(date: event.date);

      //  First filter gold/silver, then filter today's date
      final goldRates = allRates
          .where((e) => e.metal.toLowerCase() == "gold" && e.date == today)
          .toList();

      final silverRates = allRates
          .where((e) => e.metal.toLowerCase() == "silver" && e.date == today)
          .toList();

      emit(GoldPriceLoaded(goldRates: goldRates, silverRates: silverRates));
    } catch (e) {
      emit(GoldPriceError(e.toString()));
    }
  }

  Future<void> _onDeleteGoldPrice(
      DeleteGoldPriceEvent event, Emitter<GoldPriceState> emit) async {
    try {
      await repository.deleteGoldPrice(event.id);

      //  Refresh only today's data after delete
      add(const FetchGoldPriceEvent());
    } catch (e) {
      emit(GoldPriceError("Delete failed: ${e.toString()}"));
    }
  }
}
