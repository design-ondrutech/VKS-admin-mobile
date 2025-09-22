import 'package:equatable/equatable.dart';

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
  @override
  List<Object?> get props => [];
}

class FetchCustomers extends CustomerEvent {
  final int page;
  final int limit;
  const FetchCustomers({required this.page, required this.limit});

  @override
  List<Object?> get props => [page, limit];
}

class FetchCustomerDetails extends CustomerEvent {
  final String customerId;
  const FetchCustomerDetails({required this.customerId});

  @override
  List<Object?> get props => [customerId];
}
