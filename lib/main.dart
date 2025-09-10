import 'package:admin/blocs/auth/auth_bloc.dart';
import 'package:admin/blocs/card/card_bloc.dart';
import 'package:admin/blocs/card/card_event.dart';
import 'package:admin/blocs/customers/customer_bloc.dart';
import 'package:admin/blocs/customers/customer_event.dart';
import 'package:admin/blocs/dashboard/dashboard_bloc.dart';
import 'package:admin/blocs/gold/add_gld_bloc.dart';
import 'package:admin/blocs/schemes/schemes_bloc.dart';
import 'package:admin/data/repo/auth_repository.dart';
import 'package:admin/screens/dashboard/widgets/gold_rate/bloc/gold_bloc.dart';
import 'package:admin/screens/dashboard/widgets/gold_rate/bloc/gold_event.dart';
import 'package:admin/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final HttpLink httpLink = HttpLink(
    'http://api-vkskumaran-0env-env.eba-jpagnpin.ap-south-1.elasticbeanstalk.com/graphql/admin',
  );

  final GraphQLClient client = GraphQLClient(
    cache: GraphQLCache(),
    link: httpLink,
  );

  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final GraphQLClient client;
  MyApp({required this.client});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(client);
    final dashboardRepository = CardRepository(client);  
    final schemeRepository = SchemeRepository(client);
    final goldRepository = GoldPriceRepository(client);
    final addGoldPriceRepository = AddGoldPriceRepository(client);
    final customerRepository = CustomerRepository(client);   

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(authRepository)),
        BlocProvider(create: (_) => DashboardBloc(dashboardRepository)),
        BlocProvider(create: (_) => SchemesBloc(schemeRepository)),
        BlocProvider(
          create: (_) => CardBloc(dashboardRepository)..add(FetchCardSummary()),
        ),
        BlocProvider(
          create: (_) => GoldPriceBloc(goldRepository)..add(LoadGoldPriceEvent()),
        ),
        BlocProvider(
          create: (_) => AddGoldPriceBloc(addGoldPriceRepository),
        ),
        BlocProvider(
          create: (_) => CustomerBloc(customerRepository)
            ..add(FetchCustomers(page: 1, limit: 10)),  
        ),
      ],
      child: MaterialApp(
        title: 'VKS Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: LoginScreen(),
      ),
    );
  }
}
