// gold_state.dart
import 'package:equatable/equatable.dart';
import 'package:admin/data/models/gold_rate.dart';

abstract class GoldPriceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GoldPriceInitial extends GoldPriceState {}

class GoldPriceLoading extends GoldPriceState {}

class GoldPriceLoaded extends GoldPriceState {
  final List<GoldPrice> goldRates;
  final List<GoldPrice> silverRates;

  GoldPriceLoaded({required this.goldRates, required this.silverRates});

  @override
  List<Object?> get props => [goldRates, silverRates];
}

class GoldPriceError extends GoldPriceState {
  final String message;
  GoldPriceError(this.message);

  @override
  List<Object?> get props => [message];
}
