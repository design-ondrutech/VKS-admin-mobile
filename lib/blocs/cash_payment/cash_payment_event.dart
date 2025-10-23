abstract class CashPaymentEvent {}

class FetchCashPayments extends CashPaymentEvent {
  final int page;
  final int limit;
  FetchCashPayments({required this.page, required this.limit});
}

