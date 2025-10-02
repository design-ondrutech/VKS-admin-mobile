import 'package:admin/data/models/gold_rate.dart';

abstract class AddGoldPriceState {}

class AddGoldPriceInitial extends AddGoldPriceState {}

class AddGoldPriceLoading extends AddGoldPriceState {}

class AddGoldPriceSuccess extends AddGoldPriceState {
  final GoldPrice goldPrice;
  final String message;

  AddGoldPriceSuccess(this.goldPrice, {this.message = "Success"});
}


class AddGoldPriceFailure extends AddGoldPriceState {
  final String error;
  
  AddGoldPriceFailure(this.error);
}

class AddGoldPriceDeleted extends AddGoldPriceState {
  final String message;
  AddGoldPriceDeleted(this.message);
}
