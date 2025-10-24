// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<GraphQLClient> getGraphQLClient() async {
//   const String endpoint = 'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';

//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('accessToken');
//   final tenantUuid = prefs.getString('tenant_uuid'); 

//   print('🧩 Token in GraphQLClient: $token');
//   print('🧩 Tenant UUID in GraphQLClient: $tenantUuid');

//   final HttpLink httpLink = HttpLink(
//     endpoint,
//     defaultHeaders: {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       if (tenantUuid != null && tenantUuid.isNotEmpty)
//         'x-tenant-uuid': tenantUuid,
//     },
//   );

//   Link link;

//   if (token != null && token.isNotEmpty) {
//     final AuthLink authLink = AuthLink(
//       getToken: () async => 'Bearer $token',
//     );
//     link = authLink.concat(httpLink);
//     print("✅ Authenticated GraphQL client initialized");
//   } else {
//     link = httpLink;
//     print("⚠️ Unauthenticated GraphQL client initialized");
//   }

//   return GraphQLClient(
//     link: link,
//     cache: GraphQLCache(store: InMemoryStore()),
//     queryRequestTimeout: const Duration(seconds: 30),
//   );
// }
// import 'package:graphql_flutter/graphql_flutter.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// Future<GraphQLClient> getGraphQLClient() async {
//   const String endpoint =
//       'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';

//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('accessToken');
//   final tenantUuid = prefs.getString('tenant_uuid');

//   print('🧩 GraphQL Init → Token: $token');
//   print('🧩 GraphQL Init → Tenant UUID: $tenantUuid');

//   if (tenantUuid == null || tenantUuid.isEmpty || token == null || token.isEmpty) {
//     print("⚠️ Tenant or Token missing. Waiting 300ms to retry...");
//     await Future.delayed(const Duration(milliseconds: 300));
//     final prefsRetry = await SharedPreferences.getInstance();
//     final retryTenant = prefsRetry.getString('tenant_uuid');
//     final retryToken = prefsRetry.getString('accessToken');
//     print('🔁 Retried Tenant: $retryTenant, Token: $retryToken');
//   }

//   final HttpLink httpLink = HttpLink(
//     endpoint,
//     defaultHeaders: {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//       if (tenantUuid != null && tenantUuid.isNotEmpty)
//         'x-tenant': tenantUuid, 
//     },
//   );

  
//   Link link;
//   if (token != null && token.isNotEmpty) {
//     final AuthLink authLink = AuthLink(
//       getToken: () async => 'Bearer $token',
//     );
//     link = authLink.concat(httpLink);
//     print("✅ Authenticated GraphQL client initialized with tenant header");
//   } else {
//     link = httpLink;
//     print("⚠️ GraphQL client initialized without authentication");
//   }

  
//   return GraphQLClient(
//     link: link,
//     cache: GraphQLCache(store: InMemoryStore()),
//     defaultPolicies: DefaultPolicies(
//       query: Policies(fetch: FetchPolicy.networkOnly),
//       mutate: Policies(fetch: FetchPolicy.noCache),
//     ),
//     queryRequestTimeout: const Duration(seconds: 30),
//   );
// }

import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GraphQLClient> getGraphQLClient() async {
  const String endpoint =
      'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';

  final AuthLink authLink = AuthLink(
    getToken: () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      return token != null && token.isNotEmpty ? 'Bearer $token' : null;
    },
  );

  final Link tenantLink = Link.function((request, [forward]) async* {
    final prefs = await SharedPreferences.getInstance();
    final tenantUuid = prefs.getString('tenant_uuid');
    if (tenantUuid != null && tenantUuid.isNotEmpty) {
      request.updateContextEntry<HttpLinkHeaders>(
        (headers) => HttpLinkHeaders(
          headers: {
            ...?headers?.headers,
            'x-tenant': tenantUuid,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
    }
    yield* forward!(request);
  });

  final HttpLink httpLink = HttpLink(endpoint);
  final Link link = authLink.concat(tenantLink).concat(httpLink);

  print("🧩 GraphQL Client initialized (Dynamic headers every request)");

  return GraphQLClient(
    link: link,
    cache: GraphQLCache(store: InMemoryStore()),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.networkOnly),
      mutate: Policies(fetch: FetchPolicy.noCache),
    ),
  );
}
