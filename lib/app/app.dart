// import 'package:admin/app/cycle_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:graphql_flutter/graphql_flutter.dart';
// import '../widgets/global_refresh.dart';
// import '../screens/login_screen.dart';
// import 'app_bloc_providers.dart';
// import 'initial_screen.dart';

// class MyApp extends StatefulWidget {
//   final GraphQLClient client;
//   const MyApp({super.key, required this.client});
// // 
//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     handleAppLifecycleStateChange(context, state);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: createAppBlocProviders(widget.client),
//       child: MaterialApp(
//         title: 'VKS Admin',
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(primarySwatch: Colors.deepPurple),
//         home: FutureBuilder(
//           future: getInitialScreen(widget.client),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Scaffold(
//                 body: Center(child: CircularProgressIndicator()),
//               );
//             }
//             return GlobalRefreshWrapper(
//               child: snapshot.data ?? const LoginScreen(),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
