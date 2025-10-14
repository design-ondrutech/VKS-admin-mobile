import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:equatable/equatable.dart';

abstract class TotalActiveState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TotalActiveInitial extends TotalActiveState {}

class TotalActiveLoading extends TotalActiveState {}

class TotalActiveLoaded extends TotalActiveState {
  final TotalActiveSchemeResponse response;

  TotalActiveLoaded({required this.response});

  @override
  List<Object?> get props => [response];
}

class TotalActiveError extends TotalActiveState {
  final String message;

  TotalActiveError({required this.message});

  @override
  List<Object?> get props => [message];
}

//  Existing payment states
class CashPaymentLoading extends TotalActiveState {
  final String savingId;

  CashPaymentLoading({required this.savingId});

  @override
  List<Object?> get props => [savingId];
}

class CashPaymentSuccess extends TotalActiveState {
  final String savingId;
  final String totalAmount;

  CashPaymentSuccess({
    required this.savingId,
    required this.totalAmount,
  });

  @override
  List<Object?> get props => [savingId, totalAmount];
}

class CashPaymentFailure extends TotalActiveState {
  final String message;

  CashPaymentFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

// //  New gold delivery states
// class GoldDeliveryLoading extends TotalActiveState {}

// class GoldDeliverySuccess extends TotalActiveState {
//   final String savingId;
//   final double deliveredWeight;
//   final bool isFullyDelivered;
//   final String message;

//   GoldDeliverySuccess({
//     required this.savingId,
//     required this.deliveredWeight,
//     required this.isFullyDelivered,
//     required this.message,
//   });

//   @override
//   List<Object?> get props =>
//       [savingId, deliveredWeight, isFullyDelivered, message];
// }

// class GoldDeliveryFailure extends TotalActiveState {
//   final String error;

//   GoldDeliveryFailure({required this.error});

//   @override
//   List<Object?> get props => [error];
// }
