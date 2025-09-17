
import 'package:admin/data/models/add_gold_price.dart';
import 'package:admin/data/models/barchart.dart';
import 'package:admin/data/models/card.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:admin/data/models/customer.dart';
import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/data/models/online_payment.dart';
import 'package:admin/data/models/scheme.dart';
import 'package:admin/data/models/today_active_scheme.dart';
import 'package:admin/data/models/total_active_scheme';
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
          todayActiveSchemes
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

// Gold Dashboard Repository barchart

class GoldDashboardRepository {
  final GraphQLClient client;
  GoldDashboardRepository(this.client);

  Future<GoldDashboard> fetchGoldDashboard() async {
    const query = r'''
      query GoldDashboard {
        goldDashboard {
          latest_buy_date
          latest_gold_weight
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

    final data = result.data?['goldDashboard'];
    return GoldDashboard.fromJson(data);
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

    print("API RESPONSE: ${result.data}"); //  Debug

    final List data = result.data?['getAllGoldPrice'] ?? [];
    return data.map((e) => GoldPrice.fromJson(e)).toList();
  }

  deleteGoldPrice(String id) {}
}

// Add Gold Price Repository

class AddGoldPriceRepository {
  final GraphQLClient client;
  AddGoldPriceRepository(this.client);

  ///  ADD new gold price
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

  ///  UPDATE existing gold price
  Future<GoldPrice> updateGoldPrice(String id, GoldPriceInput input) async {
    const String mutation = r'''
      mutation UpdateGoldPrice($id: ID!, $data: GoldPriceInput!) {
        updateGoldPrice(id: $id, data: $data) {
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
          'id': id,
          'data': input.toJson(),
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return GoldPrice.fromJson(result.data!["updateGoldPrice"]);
  }

  ///  Fetch Gold Rates
  Future<List<GoldPrice>> getGoldRates() async {
    const String query = r'''
      query GetGoldRates {
        goldRates {
          price_id
          date
          value
          metal
          unit
          price
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?["goldRates"] as List<dynamic>? ?? [];
    return data.map((e) => GoldPrice.fromJson(e)).toList();
  }

  ///  Fetch Silver Rates
  Future<List<GoldPrice>> getSilverRates() async {
    const String query = r'''
      query GetSilverRates {
        silverRates {
          price_id
          date
          value
          metal
          unit
          price
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?["silverRates"] as List<dynamic>? ?? [];
    return data.map((e) => GoldPrice.fromJson(e)).toList();
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

// Total Active Scheme Repository
class TotalActiveSchemesRepository {
  final GraphQLClient client;

  TotalActiveSchemesRepository(this.client);

  Future<TotalActiveSchemesResponse> fetchTotalActiveSchemes() async {
    const String query = r'''
    query GetTotalActiveSchemes {
      getTotalActiveSchemes {
        data {
          customer {
            cName
            cPhoneNumber
            cEmail
          }
          status
          scheme_type
          total_gold_weight
          totalAmount
          scheme_name
          start_date
        }
        limit
        page
        totalCount
      }
    }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return TotalActiveSchemesResponse.fromJson(result.data!);
  }
}


// Today Active Scheme Repository
class TodayActiveSchemeRepository {
  final GraphQLClient client;
  TodayActiveSchemeRepository(this.client);

  Future<TodayActiveSchemeResponse> fetchTodayActiveSchemes(String startDate) async {
    const String query = r'''
      query GetTodayActiveSchemes($startDate: String) {
        getTodayActiveSchemes(startDate: $startDate) {
          data {
            customer {
              cName
              cEmail
              cPhoneNumber
            }
            totalAmount
            status
            scheme_type
            scheme_name
            scheme_purpose
            total_gold_weight
            start_date
          }
          limit
          page
          totalCount
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {'startDate': startDate},
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?['getTodayActiveSchemes'];
    return TodayActiveSchemeResponse.fromJson(data);
  }
}

// Online Payment Repository
class OnlinePaymentRepository {
  final GraphQLClient client;
  OnlinePaymentRepository(this.client);

  Future<OnlinePaymentResponse> fetchOnlinePayments() async {
    const String query = r'''
      query GetOnlinCashTransaction($transactionType: String) {
        GetOnlinCashTransaction(transactionType: $transactionType) {
          data {
            transactionId
            transactionAmount
            transactionGoldGram
            transactionDate
            customer {
              cName
            }
            transactionStatus
            transactionType
          }
          limit
          totalCount
          totalPages
          currentPage
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {"transactionType": "online"},
      ),
    );

    if (result.hasException) throw Exception(result.exception.toString());

    final data = result.data?['GetOnlinCashTransaction'];
    if (data == null) throw Exception("No online payments found");

    return OnlinePaymentResponse.fromJson(data);
  }
}

// Cash Payment Repository
class CashPaymentRepository {
  final GraphQLClient client;
  CashPaymentRepository(this.client);

  Future<CashPaymentResponse> fetchCashPayments() async {
    const String query = r'''
      query GetOnlinCashTransaction($transactionType: String) {
        GetOnlinCashTransaction(transactionType: $transactionType) {
          data {
            transactionId
            transactionAmount
            transactionGoldGram
            transactionDate
            customer {
              cName
            }
            transactionStatus
            transactionType
          }
          limit
          totalCount
          totalPages
          currentPage
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {"transactionType": "cash"},
      ),
    );

    if (result.hasException) throw Exception(result.exception.toString());

    final data = result.data?['GetOnlinCashTransaction'];
    if (data == null) throw Exception("No cash payments found");

    return CashPaymentResponse.fromJson(data);
  }
}
