import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'customer_event.dart';
import 'customer_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerRepository customerRepository;
  final TotalActiveSchemesRepository schemeRepository;

  CustomerBloc(this.customerRepository, this.schemeRepository)
      : super(CustomerLoading()) {
    // 🔹 Fetch all customers
    on<FetchCustomers>((event, emit) async {
      emit(CustomerLoading());
      try {
        final response =
            await customerRepository.getAllCustomers(event.page, event.limit);
        emit(CustomerLoaded(
          customers: response.data,
          currentPage: response.currentPage,
          totalPages: response.totalPages,
        ));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });

    //  Fetch single customer details + merge scheme status
    on<FetchCustomerDetails>((event, emit) async {
      emit(CustomerDetailsLoading());
      try {
        // 1 Fetch customer details
        final customerDetailsResponse =
            await customerRepository.fetchCustomerDetails(event.customerId);
        final customerDetails = customerDetailsResponse.data;

        // 2 Fetch all active/completed schemes
        final totalSchemesResponse =
            await schemeRepository.getTotalActiveSchemes();

        // 3 Create map of savingId → TotalActiveScheme
        final Map<String, TotalActiveScheme> schemeMap = {
          for (var s in totalSchemesResponse.data) s.savingId: s
        };

        // 4 Merge scheme status into each saving
        for (var saving in customerDetails.savings) {
          final matchedScheme = schemeMap[saving.savingId];
          if (matchedScheme != null) {
            saving.schemeStatus = matchedScheme.status;
          } else {
            saving.schemeStatus = "Unknown";
          }
        }

        //  Emit final loaded state
        emit(CustomerDetailsLoaded(details: customerDetails));
      } catch (e) {
        emit(CustomerError(e.toString()));
      }
    });
  }
}
