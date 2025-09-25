abstract class OnlinePaymentEvent {}

class FetchOnlinePayments extends OnlinePaymentEvent {
  final int page;
  final int limit;

  FetchOnlinePayments({required this.page, required this.limit});
}
