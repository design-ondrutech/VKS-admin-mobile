import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GraphQLClient> getGraphQLClient() async {
  //  Use your production or local endpoint
  const String endpoint = 'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';
  // const String endpoint = 'http://10.0.2.2:4000/graphql/admin';
  // const String endpoint = 'https://api.vkskumaran.in/graphql/admin';

  //  Get saved token
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');

  //  Step 1: Base link
  final HttpLink httpLink = HttpLink(endpoint);

  //  Step 2: Add Authorization header dynamically
  Link link = httpLink;

  if (token != null && token.isNotEmpty) {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    link = authLink.concat(httpLink);
  }

  //  Step 3: Create GraphQL client with cache + timeout
  final client = GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
  );

  return client;
}
