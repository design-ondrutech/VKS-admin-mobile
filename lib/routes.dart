
import 'package:admin/screens/dashboard/active_scheme/total_active_scheme/total_active_list.dart';
import 'package:admin/screens/dashboard/active_scheme/today_active_scheme/today_active_list.dart';
import 'package:admin/screens/dashboard/customer/customer_list.dart';
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
  static const String customerDetail = '/dashboard/customer/detail';
  static const String totalActiveSchemes = '/dashboard/active_schemes/total';
  static const String todayActiveSchemes = '/dashboard/active_schemes/today';  
  // ignore: constant_identifier_names
  static const String today_fixed_payment = '/dashboard/active_schemes/today/fixed_payment';
  // ignore: constant_identifier_names
  static const String today_flexible_payment = '/dashboard/active_schemes/today/flexible_payment';
  // ignore: constant_identifier_names
  static const String total_fixed_payment = '/dashboard/active_schemes/total/fixed_payment';
  // ignore: constant_identifier_names
  static const String total_flexible_payment = '/dashboard/active_schemes/total/flexible_payment';

static const String schemeCompletePopup = '/dashboard/active_schemes/complete_popup';

// ignore: constant_identifier_names
static const String scheme_details_section = '/dashboard/active_schemes/scheme_details_section';



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
     
      case customerDetail:
        return MaterialPageRoute(builder: (_) => CustomersScreen());

      case totalActiveSchemes:
        return MaterialPageRoute(builder: (_) => const TotalActiveSchemesScreen());

      case todayActiveSchemes:
        return MaterialPageRoute(builder: (_) => const TodayActiveSchemesScreen());  
      
      case today_fixed_payment:
        return MaterialPageRoute(builder: (_) => const TodayActiveSchemesScreen());

      case today_flexible_payment:
        return MaterialPageRoute(builder: (_) => const TodayActiveSchemesScreen());

      case total_fixed_payment:
        return MaterialPageRoute(builder: (_) => const TotalActiveSchemesScreen());

      case total_flexible_payment:
        return MaterialPageRoute(builder: (_) => const TotalActiveSchemesScreen());
     
      case schemeCompletePopup:
        return MaterialPageRoute(builder: (_) => const TotalActiveSchemesScreen());
      
      case scheme_details_section:
        return MaterialPageRoute(builder: (_) => const TotalActiveSchemesScreen());


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
