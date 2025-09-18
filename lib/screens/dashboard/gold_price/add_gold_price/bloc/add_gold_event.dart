import 'package:admin/data/models/add_gold_price.dart';
import 'package:equatable/equatable.dart';

abstract class AddGoldPriceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

///  Add New Gold Price
class SubmitGoldPrice extends AddGoldPriceEvent {
  final GoldPriceInput input;
  SubmitGoldPrice(this.input);

  @override
  List<Object?> get props => [input];
}

///  Update Existing Gold Price
class UpdateGoldPrice extends AddGoldPriceEvent {
  final String id;
  final GoldPriceInput input;

  UpdateGoldPrice({required this.id, required this.input});

  @override
  List<Object?> get props => [id, input];
}
