// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

abstract class TotalActiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchTotalActiveSchemes extends TotalActiveEvent {}

//  New event for adding cash payment
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
