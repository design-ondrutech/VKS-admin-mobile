import 'dart:convert';

import 'package:admin/data/graphql_config.dart';
import 'package:admin/data/models/barchart.dart';
import 'package:admin/data/models/card.dart';
import 'package:admin/data/models/table.dart';
import 'package:graphql_flutter/graphql_flutter.dart';


//login 
class AuthRepository {
  final GraphQLClient client;

  AuthRepository(this.client);

  Future<Map<String, dynamic>> adminLogin(
    String mobile,
    String password,
  ) async {
    const String query = r'''
      mutation AdminLogin($password: String!, $mobileno: String!) {
        adminLogin(password: $password, mobileno: $mobileno) {
          accessToken
          refreshToken
          user {
            uName
          }
        }
      }
    ''';

    final options = MutationOptions(
      document: gql(query),
      variables: {'password': password, 'mobileno': mobile},
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return result.data?['adminLogin'];
  }
}

// Dashboard Repository
class CardRepository {
  final GraphQLClient client;

  CardRepository(this.client);

  Future<DashboardSummary> fetchSummary() async {
    const String query = r'''
      query GetDashboardSummary {
        getDashboardSummary {
          totalCustomers
          totalOnlinePayment
          totalCashPayment
          totalActiveSchemes
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?['getDashboardSummary'];
    if (data == null) {
      throw Exception('No data found');
    }

    return DashboardSummary.fromJson(data);
  }
}



// Scheme Repository  
class SchemeRepository {
  final GraphQLClient client;

  SchemeRepository(this.client);

  Future<List<Scheme>> fetchSchemes() async {
    const String query = r'''
      query GetAllSchemes {
        getAllSchemes {
          currentPage
          data {
            scheme_name
            max_amount
            min_amount
            duration
          }
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List<dynamic> schemesData =
        result.data?['getAllSchemes']['data'] ?? [];

    return schemesData.map((json) => Scheme.fromJson(json)).toList();
  }

}



// Gold Dashboard Repository
class BarChartRepository {
  final GraphQLClient client;
  BarChartRepository(this.client);

  Future<GoldDashboardModel> fetchGoldDashboard() async {
    const String query = r'''
      query GoldDashboard {
        goldDashboard {
          latest_gold_weight
          latest_buy_date
          scheme_monthly_summary {
            customer_count
            month
            scheme_name
            total_gold_bought
          }
          monthly_summary {
            gold_bought
            month
          }
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?['goldDashboard'] as Map<String, dynamic>?;
    if (data == null) throw Exception('No data');
    return GoldDashboardModel.fromJson(data);
  }
}
// Gold Dashboard Repository
