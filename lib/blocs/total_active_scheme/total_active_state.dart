import 'package:admin/data/models/TotalActiveScheme.dart';

abstract class TotalActiveState {}

class TotalActiveInitial extends TotalActiveState {}

class TotalActiveLoading extends TotalActiveState {}

class TotalActiveLoaded extends TotalActiveState {
  final TotalActiveSchemeResponse response;
  final bool hasReachedEnd;

  TotalActiveLoaded({
    required this.response,
    this.hasReachedEnd = false,
  });

  TotalActiveLoaded copyWith({
    TotalActiveSchemeResponse? response,
    bool? hasReachedEnd,
  }) {
    return TotalActiveLoaded(
      response: response ?? this.response,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }
}

class TotalActiveError extends TotalActiveState {
  final String message;
  TotalActiveError({required this.message});
}

class CashPaymentLoading extends TotalActiveState {
  final String savingId;
  CashPaymentLoading({required this.savingId});
}

class CashPaymentSuccess extends TotalActiveState {
  final String savingId;
  final String totalAmount;
  CashPaymentSuccess({required this.savingId, required this.totalAmount});
}

class CashPaymentFailure extends TotalActiveState {
  final String message;
  CashPaymentFailure({required this.message});
}
class TotalActiveEmpty extends TotalActiveState {}
