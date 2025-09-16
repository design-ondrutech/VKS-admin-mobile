
import 'package:admin/data/models/gold_rate.dart';

abstract class GoldPriceState {}

class GoldPriceInitial extends GoldPriceState {}

class GoldPriceLoading extends GoldPriceState {}

class GoldPriceLoaded extends GoldPriceState {
  final List<GoldPrice> goldRates;
  final List<GoldPrice> silverRates;

  GoldPriceLoaded({required this.goldRates, required this.silverRates});


}

class GoldPriceError extends GoldPriceState {
  final String message;
  GoldPriceError(this.message);
}
