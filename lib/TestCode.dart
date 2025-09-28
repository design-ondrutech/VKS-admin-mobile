// import 'package:flutter/material.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';

// class CustomerTestScreen extends StatefulWidget {
//   const CustomerTestScreen({super.key});

//   @override
//   State<CustomerTestScreen> createState() => _CustomerTestScreenState();
// }

// class _CustomerTestScreenState extends State<CustomerTestScreen> {
//   String resultText = "Press the button to test";

//   Future<void> _runTestQuery() async {
//     final HttpLink httpLink = HttpLink(
//       'https://api.vkskumaran.in/graphql/admin', // production endpoint
//     );

//     final GraphQLClient client = GraphQLClient(
//       link: httpLink,
//       cache: GraphQLCache(store: InMemoryStore()), // fresh cache
//     );

//     const String query = r'''
//       query Test($customerId: String!) {
//         getCustomerDetails(customerId: $customerId) {
//           savings {
//             saving_id
//             total_amount
//             total_gold_weight
//           }
//         }
//       }
//     ''';

//     try {
//       final result = await client.query(QueryOptions(
//         document: gql(query),
//         variables: {"customerId": "PUT_A_VALID_CUSTOMER_ID_HERE"},
//         fetchPolicy: FetchPolicy.networkOnly,
//       ));

//       if (result.hasException) {
//         setState(() {
//           resultText = "❌ Exception: ${result.exception}";
//         });
//       } else {
//         setState(() {
//           resultText = "✅ Data: ${result.data}";
//         });
//       }
//     } catch (e) {
//       setState(() {
//         resultText = "❌ Error: $e";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Customer Test Query")),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: _runTestQuery,
//                 child: const Text("Run Test Query"),
//               ),
//               const SizedBox(height: 16),
//               SingleChildScrollView(
//                 child: Text(resultText, textAlign: TextAlign.center),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
