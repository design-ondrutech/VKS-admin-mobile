import 'package:admin/data/models/cash_payment.dart';

abstract class CashPaymentState {}

class CashPaymentInitial extends CashPaymentState {}

class CashPaymentLoading extends CashPaymentState {}

class CashPaymentLoaded extends CashPaymentState {
  final CashPaymentResponse response;
  CashPaymentLoaded({required this.response});
}


class CashPaymentError extends CashPaymentState {
  final String message;
  CashPaymentError(this.message);
}
