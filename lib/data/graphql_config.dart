import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GraphQLClient> getGraphQLClient() async {
  const String endpoint = 'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');
  final tenantUuid = prefs.getString('tenant_uuid'); 

  print('🧩 Token in GraphQLClient: $token');
  print('🧩 Tenant UUID in GraphQLClient: $tenantUuid');

  final HttpLink httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (tenantUuid != null && tenantUuid.isNotEmpty)
        'x-tenant-uuid': tenantUuid,
    },
  );

  Link link;

  if (token != null && token.isNotEmpty) {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    link = authLink.concat(httpLink);
    print("✅ Authenticated GraphQL client initialized");
  } else {
    link = httpLink;
    print("⚠️ Unauthenticated GraphQL client initialized");
  }

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
    queryRequestTimeout: const Duration(seconds: 30),
  );
}
