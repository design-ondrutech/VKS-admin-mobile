// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

abstract class TotalActiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTotalActiveSchemes extends TotalActiveEvent {}

//  Existing event for cash payment
class AddCashPayment extends TotalActiveEvent {
  final String savingId;
  final double amount;

  AddCashPayment({
    required this.savingId,
    required this.amount,
  });

  @override
  List<Object> get props => [savingId, amount];
}

//  New event for updating delivered gold
// class UpdateGoldDelivered extends TotalActiveEvent {
//   final String savingId;
//   final double deliveredGoldWeight;
//   final bool isFullyDelivered;

//   UpdateGoldDelivered({
//     required this.savingId,
//     required this.deliveredGoldWeight,
//     required this.isFullyDelivered,
//   });

//   @override
//   List<Object> get props => [savingId, deliveredGoldWeight, isFullyDelivered];
// }
