import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:equatable/equatable.dart';

/// Base State Class
abstract class TodayActiveSchemeState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial State (Before Any Fetch)
class TodayActiveSchemeInitial extends TodayActiveSchemeState {}

/// Loading State (When Fetching)
class TodayActiveSchemeLoading extends TodayActiveSchemeState {}

/// Loaded State (With Data + Pagination Info)
class TodayActiveSchemeLoaded extends TodayActiveSchemeState {
  final TodayActiveSchemeResponse response;
  final int currentPage;
  final int totalPages;

  TodayActiveSchemeLoaded({
    required this.response,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [response, currentPage, totalPages];
}


/// Error State (API or Logic Error)
class TodayActiveSchemeError extends TodayActiveSchemeState {
  final String message;
  TodayActiveSchemeError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Payment: Loading
class AddCashSavingLoading extends TodayActiveSchemeState {}

/// Payment: Success
class AddCashSavingSuccess extends TodayActiveSchemeState {
  final Map<String, dynamic> result;
  AddCashSavingSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// Payment: Error
class AddCashSavingError extends TodayActiveSchemeState {
  final String message;
  AddCashSavingError(this.message);

  @override
  List<Object?> get props => [message];
}
