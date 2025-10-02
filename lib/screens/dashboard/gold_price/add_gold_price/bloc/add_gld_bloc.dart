import 'package:flutter_bloc/flutter_bloc.dart';
import 'add_gold_event.dart';
import 'add_gold_state.dart';
import 'package:admin/data/repo/auth_repository.dart';

class AddGoldPriceBloc extends Bloc<AddGoldPriceEvent, AddGoldPriceState> {
  final AddGoldPriceRepository repository;

  AddGoldPriceBloc(this.repository) : super(AddGoldPriceInitial()) {
    on<SubmitGoldPrice>(_onSubmitGoldPrice);
    on<UpdateGoldPrice>(_onUpdateGoldPrice);
on<DeleteGoldPrice>(_onDeleteGoldPrice);


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

  Future<void> _onUpdateGoldPrice(
      UpdateGoldPrice event, Emitter<AddGoldPriceState> emit) async {
    emit(AddGoldPriceLoading());
    try {
      final goldPrice =
          await repository.updateGoldPrice(event.id, event.input);
      emit(AddGoldPriceSuccess(goldPrice));
    } catch (e) {
      emit(AddGoldPriceFailure(e.toString()));
    }
  }


Future<void> _onDeleteGoldPrice(
    DeleteGoldPrice event, Emitter<AddGoldPriceState> emit) async {
  emit(AddGoldPriceLoading());
  try {
    await repository.deleteGoldPrice(event.priceId);
    emit(AddGoldPriceDeleted("Gold price deleted successfully"));
  } catch (e) {
    emit(AddGoldPriceFailure(e.toString()));
  }
}


}
