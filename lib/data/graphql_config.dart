import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GraphQLClient> getGraphQLClient() async {
  const String endpoint =
      'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';
  // const String endpoint = 'http://10.0.2.2:4000/graphql/admin';
  // const String endpoint = 'https://api.vkskumaran.in/graphql/admin';

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');
  final tenantUuid = prefs.getString('tenant_uuid'); //  Make sure it's saved during login

  final HttpLink httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      if (tenantUuid != null && tenantUuid.isNotEmpty)
        'x-tenant-uuid': tenantUuid, //  add custom header
    },
  );

  Link link;

  if (token != null && token.isNotEmpty) {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    link = authLink.concat(httpLink);
    print("✅ Authenticated GraphQL client built with token and tenant UUID: $tenantUuid");
  } else {
    link = httpLink;
    print("⚠️ No token found — using unauthenticated GraphQL client");
  }

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
    queryRequestTimeout: const Duration(seconds: 30),
  );
}
