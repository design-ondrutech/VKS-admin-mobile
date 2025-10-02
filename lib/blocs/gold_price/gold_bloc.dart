import 'package:flutter_bloc/flutter_bloc.dart';
import 'gold_event.dart';
import 'gold_state.dart';
import 'package:admin/data/repo/auth_repository.dart';

class GoldPriceBloc extends Bloc<GoldPriceEvent, GoldPriceState> {
  final GoldPriceRepository repository;

  GoldPriceBloc(this.repository) : super(GoldPriceInitial()) {
    on<FetchGoldPriceEvent>(_onFetchGoldPrices);
  }

Future<void> _onFetchGoldPrices(
    FetchGoldPriceEvent event, Emitter<GoldPriceState> emit) async {
  emit(GoldPriceLoading());

  try {
    final allRates = await repository.fetchAllPrices(date: event.date);

    final today = DateTime.now();

    //  Filter: remove future records
    final validRates = allRates.where((e) {
      final parsed = DateTime.tryParse(e.date);
      return parsed != null && parsed.isBefore(today.add(const Duration(days: 1)));
    }).toList();

    final goldRates = validRates
        .where((e) => e.metal.toLowerCase() == "gold")
        .toList()
      ..sort((a, b) =>
          DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    final silverRates = validRates
        .where((e) => e.metal.toLowerCase() == "silver")
        .toList()
      ..sort((a, b) =>
          DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    final latestGold = goldRates.take(3).toList();
    final latestSilver = silverRates.take(3).toList();

    emit(GoldPriceLoaded(
      goldRates: latestGold,
      silverRates: latestSilver,
    ));
  } catch (e) {
    emit(GoldPriceError(e.toString()));
  }
}

}
