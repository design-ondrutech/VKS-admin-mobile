import 'package:admin/data/models/gold_rate.dart';

abstract class AddGoldPriceState {}

class AddGoldPriceInitial extends AddGoldPriceState {}
class AddGoldPriceLoading extends AddGoldPriceState {}
class AddGoldPriceSuccess extends AddGoldPriceState {
  final GoldPrice goldPrice;
  AddGoldPriceSuccess(this.goldPrice);
}
class AddGoldPriceFailure extends AddGoldPriceState {
  final String error;
  AddGoldPriceFailure(this.error);
}
