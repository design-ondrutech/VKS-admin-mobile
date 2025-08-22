import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_event.dart';
import 'card_state.dart';
import '../../data/repo/auth_repository.dart';

class CardBloc extends Bloc<CardEvent, CardState> {
  final CardRepository repository;

  CardBloc(this.repository) : super(CardLoading()) {
    on<FetchCardSummary>((event, emit) async {
      emit(CardLoading());
      try {
        final summary = await repository.fetchSummary();
        emit(CardLoaded(summary));
      } catch (e) {
        emit(CardError(e.toString()));
      }
    });
  }
}
