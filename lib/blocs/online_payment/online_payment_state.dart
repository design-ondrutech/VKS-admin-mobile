import 'package:admin/data/models/online_payment.dart';

abstract class OnlinePaymentState {}
class OnlinePaymentInitial extends OnlinePaymentState {}
class OnlinePaymentLoading extends OnlinePaymentState {}
class OnlinePaymentLoaded extends OnlinePaymentState {
  final OnlinePaymentResponse response;
  OnlinePaymentLoaded(this.response);
}
class OnlinePaymentError extends OnlinePaymentState {
  final String message;
  OnlinePaymentError(this.message);
}