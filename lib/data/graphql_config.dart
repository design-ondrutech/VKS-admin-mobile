import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GraphQLClient> getGraphQLClient() async {
  const String endpoint =
      'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('accessToken');
  final tenantUuid = prefs.getString('tenant_uuid'); //  same key

  print('🧩 Token: $token');
  print('🧩 Tenant UUID: $tenantUuid');

  final HttpLink httpLink = HttpLink(
    endpoint,
    defaultHeaders: {
      if (tenantUuid != null && tenantUuid.isNotEmpty)
        'x-tenant-uuid': tenantUuid, //  add required header
    },
  );

  Link link;
  if (token != null && token.isNotEmpty) {
    final AuthLink authLink = AuthLink(
      getToken: () async => 'Bearer $token',
    );
    link = authLink.concat(httpLink);
  } else {
    link = httpLink;
  }

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
    queryRequestTimeout: const Duration(seconds: 30),
  );
}
