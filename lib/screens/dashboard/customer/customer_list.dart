import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/customers/customer_state.dart';
import 'package:admin/data/models/customer.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/customer/customer_detail/customer_detail_screen.dart';
import 'package:admin/utils/colors.dart';
import 'package:admin/utils/error_helper.dart';
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

  String _getJoinedDate() {
    final now = DateTime.now();
    return "${now.day}/${now.month}/${now.year}";
  }

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Customers", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.teal,
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
                  child: ListView.separated(
                    itemCount: state.customers.length,
                    separatorBuilder:
                        (context, index) =>
                            const Divider(height: 1, thickness: 0.6),
                    itemBuilder: (context, index) {
                      final Customer customer = state.customers[index];

                      return ListTile(
                        onTap: () async {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder:
                                (_) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                          );

                          try {
                            final client = GraphQLProvider.of(context).value;
                            final details = await CustomerDetailsRepository(
                              client,
                            ).fetchCustomerDetails(customer.id);

                            if (!mounted) return;
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        CustomerDetailScreen(details: details),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Failed to load details: $e'),
                              ),
                            );
                          }
                        },
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal.shade100,
                          radius: 26,
                          child: Text(
                            customer.name.isNotEmpty
                                ? customer.name[0].toUpperCase()
                                : "?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.teal.shade900,
                            ),
                          ),
                        ),
                        title: Text(
                          customer.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  customer.phoneNumber,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.email,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    customer.email,
                                    style: const TextStyle(fontSize: 13),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey.shade600,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Joined: ${_getJoinedDate()}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        trailing: const Icon(
                          Icons.chevron_right,
                          color: Colors.grey,
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),

                //  Pagination Footer
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: const Border(
                      top: BorderSide(color: Colors.black12, width: 0.6),
                    ),
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
                          _pageButton(
                            "Previous",
                            state.currentPage > 1,
                            () => _loadPage(state.currentPage - 1),
                          ),
                          const SizedBox(width: 8),
                          _pageButton(
                            "Next",
                            state.currentPage < state.totalPages,
                            () => _loadPage(state.currentPage + 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is CustomerError) {
            // Hide text if it’s just a network issue (snackbar will handle it)
            if (ErrorHelper.isNetworkError(state.message)) {
              return const SizedBox();
            }

            // Show clean error message for all other cases
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _pageButton(String label, bool enabled, VoidCallback onTap) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: enabled ? Appcolors.buttoncolor : Colors.grey.shade300,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: enabled ? onTap : null,
      child: Text(
        label,
        style: TextStyle(color: enabled ? Appcolors.buttoncolor : Colors.grey),
      ),
    );
  }
}
