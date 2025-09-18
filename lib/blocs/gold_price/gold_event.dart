// gold_event.dart
import 'package:equatable/equatable.dart';

abstract class GoldPriceEvent extends Equatable {
  const GoldPriceEvent();

  @override
  List<Object?> get props => [];
}

//  Full list fetch (date optional)
class FetchGoldPriceEvent extends GoldPriceEvent {
  final String? date; // optional
  const FetchGoldPriceEvent({this.date});

  @override
  List<Object?> get props => [date];
}

//  Delete event
class DeleteGoldPriceEvent extends GoldPriceEvent {
  final String id;
  const DeleteGoldPriceEvent(this.id);

  @override
  List<Object?> get props => [id];
}
