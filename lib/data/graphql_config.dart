
import 'package:graphql_flutter/graphql_flutter.dart';

GraphQLClient getGraphQLClient() {
 // final HttpLink httpLink = HttpLink('http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin');

   final HttpLink httpLink = HttpLink('http://10.0.2.2:4000/graphql/admin');

  //final HttpLink httpLink = HttpLink('https://api.vkskumaran.in/graphql/admin');


  return GraphQLClient(
    
    link: httpLink,
    cache: GraphQLCache(store: InMemoryStore()),

  );
  
}
