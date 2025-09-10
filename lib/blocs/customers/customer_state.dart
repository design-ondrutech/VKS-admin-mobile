import 'package:equatable/equatable.dart';
import '../../data/models/customer.dart';

abstract class CustomerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;
  final int currentPage;
  final int totalPages;
  final bool hasReachedEnd;

  CustomerLoaded({
    required this.customers,
    required this.currentPage,
    required this.totalPages,
    this.hasReachedEnd = false,
  });

  CustomerLoaded copyWith({
    List<Customer>? customers,
    int? currentPage,
    int? totalPages,
    bool? hasReachedEnd,
  }) {
    return CustomerLoaded(
      customers: customers ?? this.customers,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
    );
  }

  @override
  List<Object?> get props => [customers, currentPage, totalPages, hasReachedEnd];
}

class CustomerError extends CustomerState {
  final String message;

  CustomerError(this.message);

  @override
  List<Object?> get props => [message];
}
