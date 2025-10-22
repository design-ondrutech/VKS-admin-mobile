import 'package:admin/screens/dashboard/gold_price/add_gold_price/add_gold_price.dart';
import 'package:equatable/equatable.dart';

abstract class AddGoldPriceEvent extends Equatable {
  const AddGoldPriceEvent();

  @override
  List<Object?> get props => [];
}

// 🔹 Add new gold price
class SubmitGoldPrice extends AddGoldPriceEvent {
  final GoldPriceInput input;

  const SubmitGoldPrice({required this.input});

  @override
  List<Object?> get props => [input];
}

// 🔹 Update existing gold price
class UpdateGoldPrice extends AddGoldPriceEvent {
  final String id;
  final GoldPriceInput input;

  const UpdateGoldPrice({required this.id, required this.input});

  @override
  List<Object?> get props => [id, input];
}

// 🔹 Delete existing gold price
class DeleteGoldPrice extends AddGoldPriceEvent {
  final String priceId;

  const DeleteGoldPrice(this.priceId);

  @override
  List<Object?> get props => [priceId];
}
