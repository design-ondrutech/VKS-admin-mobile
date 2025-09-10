import 'package:admin/blocs/gold/add_gold_event.dart';
import 'package:admin/blocs/gold/add_gold_state.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddGoldPriceBloc extends Bloc<AddGoldPriceEvent, AddGoldPriceState> {
  final AddGoldPriceRepository repository;

  AddGoldPriceBloc(this.repository) : super(AddGoldPriceInitial()) {
    on<SubmitGoldPrice>(_onSubmitGoldPrice);
  }

  Future<void> _onSubmitGoldPrice(

    

      SubmitGoldPrice event, Emitter<AddGoldPriceState> emit) async {
    emit(AddGoldPriceLoading());
    try {
      final goldPrice = await repository.addOrUpdateGoldPrice(event.input);
      emit(AddGoldPriceSuccess(goldPrice));
    } catch (e) {
      emit(AddGoldPriceFailure(e.toString()));
    }
  }
}
