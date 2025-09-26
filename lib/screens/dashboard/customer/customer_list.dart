import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/customers/customer_state.dart';
import 'package:admin/data/models/customer.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/customer/customer_detail/customer_detail_screen.dart';
import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Total Customers",
          style: TextStyle(color: Appcolors.white),
        ),
        centerTitle: true,
        backgroundColor: Appcolors.headerbackground,
        elevation: 0,
      ),
      body: BlocBuilder<CustomerBloc, CustomerState>(
        builder: (context, state) {
          if (state is CustomerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CustomerLoaded) {
            if (state.customers.isEmpty) {
              return const Center(
                child: Text(
                  "No Customers Found",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.customers.length,
                    itemBuilder: (context, index) {
                      final Customer customer = state.customers[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (_) => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          try {
                            final client = GraphQLProvider.of(context).value;
                            final details = await CustomerDetailsRepository(client)
                                .fetchCustomerDetails(customer.id);

                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CustomerDetailScreen(details: details),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to load details: $e')),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 6,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Card Header with name + ID
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.blue.shade100,
                                      child: Text(
                                        customer.name.isNotEmpty
                                            ? customer.name[0].toUpperCase()
                                            : "?",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            customer.name,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue.shade900,
                                            ),
                                          ),
                                          // Text(
                                          //   "ID: ${customer.id}",
                                          //   style: const TextStyle(
                                          //     fontSize: 12,
                                          //     color: Colors.grey,
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Card Body with info rows
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _infoRow(Icons.phone, customer.phoneNumber),
                                    _infoRow(Icons.email, customer.email),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Pagination footer
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Page ${state.currentPage} of ${state.totalPages}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          _pageButton("Previous", state.currentPage > 1,
                              () => _loadPage(state.currentPage - 1)),
                          const SizedBox(width: 8),
                          _pageButton("Next", state.currentPage < state.totalPages,
                              () => _loadPage(state.currentPage + 1)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CustomerError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageButton(String label, bool enabled, VoidCallback onTap) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? Appcolors.buttoncolor : Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: enabled ? onTap : null,
      child: Text(label, style: const TextStyle(color: Appcolors.black)),
    );
  }
}
