
// import 'package:graphql_flutter/graphql_flutter.dart';

// class GraphQLConfig {
//   static HttpLink httpLink = HttpLink('http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin');

//   static GraphQLClient client = GraphQLClient(

//     cache: GraphQLCache(),
//     link: httpLink,
//   );
// }
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient getGraphQLClient() {
  final HttpLink httpLink = HttpLink(
    'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin', 
  );

  return GraphQLClient(
    
    link: httpLink,
    cache: GraphQLCache(store: InMemoryStore()),

  );
}
