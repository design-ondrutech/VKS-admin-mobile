import 'package:equatable/equatable.dart';
import 'package:admin/data/models/add_gold_price.dart';

abstract class AddGoldPriceEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Create
class SubmitGoldPrice extends AddGoldPriceEvent {
  final GoldPriceInput input;
  SubmitGoldPrice(this.input);

  @override
  List<Object?> get props => [input];
}

/// Update
class UpdateGoldPrice extends AddGoldPriceEvent {
  final String id;
  final GoldPriceInput input;
  UpdateGoldPrice({required this.id, required this.input});

  @override
  List<Object?> get props => [id, input];
}

///  Delete (very important)
class DeleteGoldPrice extends AddGoldPriceEvent {
  final String priceId;
  DeleteGoldPrice(this.priceId);
}
