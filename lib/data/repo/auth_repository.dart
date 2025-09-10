import 'dart:convert';

import 'package:admin/data/graphql_config.dart';
import 'package:admin/data/models/add_gold_price.dart';
import 'package:admin/data/models/barchart.dart';
import 'package:admin/data/models/card.dart';
import 'package:admin/data/models/customer.dart';
import 'package:admin/data/models/gold_rate.dart';
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
// gold_dashboard_repository.dart

class GoldDashboardRepository {
  final GraphQLClient client;

  GoldDashboardRepository(this.client);

  Future<GoldDashboardModel> fetchGoldDashboard() async {
    const query = r'''
      query GoldDashboard {
        goldDashboard {
          latest_gold_weight
          latest_buy_date
          monthly_summary {
            month
            gold_bought
          }
          scheme_monthly_summary {
            scheme_name
            month
            customer_count
            total_gold_bought
          }
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return GoldDashboardModel.fromJson(result.data!['goldDashboard']);
  }
}

// Gold Dashboard Repository

class GoldPriceRepository {
  final GraphQLClient client;

  GoldPriceRepository(this.client);

  Future<List<GoldPrice>> fetchAllPrices({String? date}) async {
    const query = r'''
      query GetAllGoldPrice($date: String) {
        getAllGoldPrice(date: $date) {
          price_id
          date
          value
          metal
          unit
          price
          created_date
          isdeleted
          percentage_diff
          is_price_up
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {"date": date},
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    print("API RESPONSE: ${result.data}"); // 🔎 Debug

    final List data = result.data?['getAllGoldPrice'] ?? [];
    return data.map((e) => GoldPrice.fromJson(e)).toList();
  }
}

// Add Gold Price Repository

class AddGoldPriceRepository {
  final GraphQLClient client;
  AddGoldPriceRepository(this.client);

  Future<GoldPrice> addOrUpdateGoldPrice(GoldPriceInput input) async {
    const String mutation = r'''
      mutation AddGoldPrice($data: GoldPriceInput!) {
        addGoldPrice(data: $data) {
          price_id
          date
          value
          metal
          unit
          price
          created_date
          isdeleted
          percentage_diff
          is_price_up
        }
      }
    ''';

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {
          'data': input.toJson(),
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return GoldPrice.fromJson(result.data!["addGoldPrice"]);
  }
}

// Customer Repository

class CustomerRepository {
  final GraphQLClient client;

  CustomerRepository(this.client);

  Future<CustomerResponse> getAllCustomers(int page, int limit) async {
    const query = r'''
      query GetAllCustomers($page: Float, $limit: Float, $filter: CustomerFilterInput) {
        getAllCustomers(page: $page, limit: $limit, filter: $filter) {
          totalCount
          currentPage
          limit
          totalPages
          data {
            id
            cName
            cEmail
            cPhoneNumber
          }
        }
      }
    ''';

    final options = QueryOptions(
      document: gql(query),
      variables: {
        "page": page,
        "limit": limit,
      },
      fetchPolicy: FetchPolicy.networkOnly,
    );

    final result = await client.query(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return CustomerResponse.fromJson(result.data!["getAllCustomers"]);
  }
}
