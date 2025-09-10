import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/customer.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;
  final int limit = 10;

  CustomerBloc(this.repository) : super(CustomerInitial()) {
    on<FetchCustomers>(_onFetchCustomers);
    on<LoadMoreCustomers>(_onLoadMoreCustomers);
  }

  Future<void> _onFetchCustomers(
      FetchCustomers event, Emitter<CustomerState> emit) async {
    emit(CustomerLoading());
    try {
      final response =
          await repository.getAllCustomers(event.page, event.limit);
      emit(CustomerLoaded(
        customers: response.data,
        currentPage: response.currentPage,
        totalPages: response.totalPages,
      ));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onLoadMoreCustomers(
      LoadMoreCustomers event, Emitter<CustomerState> emit) async {
    if (state is CustomerLoaded) {
      final currentState = state as CustomerLoaded;
      if (currentState.currentPage >= currentState.totalPages) {
        emit(currentState.copyWith(hasReachedEnd: true));
        return;
      }

      try {
        final response = await repository.getAllCustomers(
            currentState.currentPage + 1, limit);

        emit(CustomerLoaded(
          customers: [...currentState.customers, ...response.data],
          currentPage: response.currentPage,
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    }
  }
}
