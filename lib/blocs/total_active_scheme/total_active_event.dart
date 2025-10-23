// ignore: depend_on_referenced_packages
import 'package:equatable/equatable.dart';

abstract class TotalActiveEvent extends Equatable {
  @override
  List<Object> get props => [];
}

// ✅ Updated to support pagination
class FetchTotalActiveSchemes extends TotalActiveEvent {
  final int page;
  final int limit;

  FetchTotalActiveSchemes({
    required this.page,
    required this.limit,
  });

  @override
  List<Object> get props => [page, limit];
}

// ✅ Existing event for adding cash payment
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

// ✅ Existing event for delivered gold update
class UpdateDeliveredGoldEvent extends TotalActiveEvent {
  final String savingId;
  final double deliveredGold;

  UpdateDeliveredGoldEvent({
    required this.savingId,
    required this.deliveredGold,
  });

  @override
  List<Object> get props => [savingId, deliveredGold];
}
