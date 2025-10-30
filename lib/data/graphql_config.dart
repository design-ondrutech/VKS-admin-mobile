import 'package:admin/widgets/network_error_interceptor.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<GraphQLClient> getGraphQLClient() async {
  const String endpoint =
      'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin';

  //  Auth token
  final AuthLink authLink = AuthLink(
    getToken: () async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      return token != null && token.isNotEmpty ? 'Bearer $token' : null;
    },
  );

  //  Tenant header
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

  //  Main HTTP link
  final HttpLink httpLink = HttpLink(endpoint);

  //  Final chain (order matters!)
  final Link finalLink = Link.from([
    NetworkErrorInterceptor(),  //  catches network + token errors
    authLink,
    tenantLink,
    httpLink,
  ]);

  print("🧩 GraphQL Client initialized with token + tenant headers + interceptors");

  return GraphQLClient(
    link: finalLink,
    cache: GraphQLCache(store: InMemoryStore()),
    defaultPolicies: DefaultPolicies(
      query: Policies(fetch: FetchPolicy.networkOnly),
      mutate: Policies(fetch: FetchPolicy.noCache),
    ),
  );
}
