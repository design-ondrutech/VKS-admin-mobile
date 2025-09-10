import 'package:admin/data/models/add_gold_price.dart';

abstract class AddGoldPriceEvent {}

class SubmitGoldPrice extends AddGoldPriceEvent {
  final GoldPriceInput input;
  SubmitGoldPrice(this.input);
}
