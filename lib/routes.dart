
import 'package:admin/screens/dashboard/dashboard_screen.dart';
import 'package:admin/screens/dashboard/gold_price/add_gold_price/gold_add_popup.dart';
import 'package:admin/screens/dashboard/gold_price/goldrate.dart';
import 'package:admin/screens/dashboard/notification/notification.dart';
import 'package:admin/screens/dashboard/scheme/schemes.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String overview = '/dashboard/overview';
  static const String schemes = '/dashboard/schemes';
  static const String notifications = '/dashboard/notifications';
  static const String goldPrice = '/dashboard/gold_price';
  static const String addGoldPrice = '/dashboard/gold_price/add';
  // ignore: constant_identifier_names
  static const String AddSchemeDialog = '/dashboard/schemes/add';
  


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());

      case dashboard:
        return MaterialPageRoute(builder: (_) => DashboardHeader());

      case overview:
        return MaterialPageRoute(builder: (_) => DashboardHeader());  

      case schemes:
        return MaterialPageRoute(builder: (_) => SchemesTab());  

      case notifications:
        return MaterialPageRoute(builder: (_) => NotificationsTab());  

      case goldPrice:
        return MaterialPageRoute(builder: (_) => GoldPriceScreen());

      case addGoldPrice:
        return MaterialPageRoute(builder: (_) => AddGoldRateDialog());

      case AddSchemeDialog:
        return MaterialPageRoute(builder: (_) => SchemesTab());
     

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
