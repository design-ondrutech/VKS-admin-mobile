import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GraphQLClient> getGraphQLClient() async {
  // Base API endpoint
  final String endpoint = 'http://10.0.2.2:4000/graphql/admin';
  // final String endpoint = 'https://api.vkskumaran.in/graphql/admin';

  // Check for saved token
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');

  // Add token if available
  final HttpLink httpLink = HttpLink(
    endpoint,
    defaultHeaders: token != null
        ? {
            'Authorization': 'Bearer $token', //  include token
          }
        : {},
  );

  // Build the GraphQL client
  return GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
    queryRequestTimeout: const Duration(seconds: 30),
  );
}
