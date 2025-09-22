import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository repository;
  CustomerBloc(this.repository) : super(CustomerLoading()) {
    on<FetchCustomers>((event, emit) async {
      emit(CustomerLoading());
      try {
        final response = await repository.getAllCustomers(event.page, event.limit);
        emit(CustomerLoaded(
          customers: response.data,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });

    on<FetchCustomerDetails>((event, emit) async {
      emit(CustomerDetailsLoading());
      try {
        final customerDetailsResponse = await repository.fetchCustomerDetails(event.customerId);
        emit(CustomerDetailsLoaded(details: customerDetailsResponse.data));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });
  }
}
