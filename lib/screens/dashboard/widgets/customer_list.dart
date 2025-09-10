import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/customers/customer_state.dart';
import 'package:admin/data/models/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  int page = 1;
  final int limit = 10;

  @override
  void initState() {
    super.initState();
    context.read<CustomerBloc>().add(FetchCustomers(page: page, limit: limit));
  }

  void _loadPage(int newPage) {
    setState(() => page = newPage);
    context.read<CustomerBloc>().add(FetchCustomers(page: page, limit: limit));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Customers")),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerLoaded) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.customers.length,
                    itemBuilder: (context, index) {
                      final Customer customer = state.customers[index];
                      final rollNumber =
                          ((state.currentPage - 1) * limit) + (index + 1);

                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              customer.name[0],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                          title: Text(
                            customer.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("No: $rollNumber"), 
                              Text("Phone: ${customer.phoneNumber}"),
                              Text("Email: ${customer.email}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                //  Page navigation bar
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 16),
                  color: Colors.grey.shade200,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Page ${state.currentPage} of ${state.totalPages}"),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: state.currentPage > 1
                                ? () => _loadPage(state.currentPage - 1)
                                : null,
                            child: const Text("Previous"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: state.currentPage < state.totalPages
                                ? () => _loadPage(state.currentPage + 1)
                                : null,
                            child: const Text("Next"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CustomerError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}
