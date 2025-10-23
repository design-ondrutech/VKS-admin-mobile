import 'package:equatable/equatable.dart';

/// Base Event Class
abstract class TodayActiveSchemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

///  Fetch Today Active Schemes (with Pagination)
class FetchTodayActiveSchemes extends TodayActiveSchemeEvent {
  final String startDate;
  final String? savingId;
  final int page;
  final int limit;

  FetchTodayActiveSchemes({
    required this.startDate,
    this.savingId,
    this.page = 1,
    this.limit = 10,
  });

  @override
  List<Object?> get props => [startDate, savingId, page, limit];
}

///  Add Cash Payment Event
class AddCashCustomerSavingEvent extends TodayActiveSchemeEvent {
  final String savingId;
  final double amount;

  AddCashCustomerSavingEvent({
    required this.savingId,
    required this.amount,
  });

  @override
  List<Object?> get props => [savingId, amount];
}
