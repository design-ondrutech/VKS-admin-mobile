import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchCustomers extends CustomerEvent {
  final int page;
  final int limit;

  FetchCustomers({required this.page, required this.limit});

  @override
  List<Object?> get props => [page, limit];
}

class LoadMoreCustomers extends CustomerEvent {}
