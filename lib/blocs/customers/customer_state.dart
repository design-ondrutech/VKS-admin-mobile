import 'package:admin/data/models/customer.dart';
import 'package:equatable/equatable.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();
  @override
  List<Object?> get props => [];
}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
  final int currentPage;
  final int totalPages;

  const CustomerLoaded({
    required this.customers,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  List<Object?> get props => [customers, currentPage, totalPages];
}

class CustomerDetailsLoading extends CustomerState {}

class CustomerDetailsLoaded extends CustomerState {
  final Customer details;
  const CustomerDetailsLoaded({required this.details});
  @override
  List<Object?> get props => [details];
}

class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);
  @override
  List<Object?> get props => [message];
}
