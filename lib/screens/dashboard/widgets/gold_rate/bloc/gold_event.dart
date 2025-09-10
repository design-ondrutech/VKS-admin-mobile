abstract class GoldPriceEvent {}

class FetchGoldPriceEvent extends GoldPriceEvent {
  final String? date;
  FetchGoldPriceEvent({this.date});
}
class LoadGoldPriceEvent extends FetchGoldPriceEvent{}