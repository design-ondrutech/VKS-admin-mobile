import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:equatable/equatable.dart';

abstract class TodayActiveSchemeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TodayActiveSchemeInitial extends TodayActiveSchemeState {}

class TodayActiveSchemeLoading extends TodayActiveSchemeState {}

class TodayActiveSchemeLoaded extends TodayActiveSchemeState {
  final TodayActiveSchemeResponse response;
  final int currentPage;
  final int totalPages;

  TodayActiveSchemeLoaded(this.response, {required this.currentPage, required this.totalPages});



  @override
  List<Object?> get props => [response, currentPage, totalPages];

}

class TodayActiveSchemeError extends TodayActiveSchemeState {
  final String message;

  TodayActiveSchemeError(this.message);

  @override
  List<Object?> get props => [message];
}

//  Payment mutation states
class AddCashSavingLoading extends TodayActiveSchemeState {}

class AddCashSavingSuccess extends TodayActiveSchemeState {
  final Map<String, dynamic> result;

  AddCashSavingSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class AddCashSavingError extends TodayActiveSchemeState {
  final String message;

  AddCashSavingError(this.message);

  @override
  List<Object?> get props => [message];
}
