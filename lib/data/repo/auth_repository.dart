
import 'package:admin/data/app_config.dart';
import 'package:admin/data/models/add_gold_price.dart';
import 'package:admin/data/models/barchart.dart';
import 'package:admin/data/models/card.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:admin/data/models/customer.dart';
import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/data/models/notification_model.dart';
import 'package:admin/data/models/online_payment.dart';
import 'package:admin/data/models/scheme.dart';
import 'package:admin/data/models/TodayActiveScheme.dart';
import 'package:admin/data/models/TotalActiveScheme.dart';
import 'package:admin/screens/dashboard/customer/customer_detail/model/customer_details_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:developer';


import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final GraphQLClient client;

  AuthRepository(this.client);

  Future<Map<String, dynamic>> adminLogin(String mobile, String password) async {
    const String query = r'''
      mutation AdminLogin($tenantUuid: String!, $password: String!, $mobileno: String!) {
        adminLogin(tenant_uuid: $tenantUuid, password: $password, mobileno: $mobileno) {
          accessToken
          refreshToken
          user {
            uName
            tenant_id
            tenant_uuid
            id
            uEmail
            uPasswordHash
            uPhoneNumber
          }
        }
      }
    ''';

    //  Tenant UUID can be constant for now or dynamic (fetched from config)
    // You can later make it dynamic if your system supports multi-tenant login screens.
    const String defaultTenantUuid = "7a551e1b-d39f-4a2b-bad0-74fd753cea4e";

    final options = MutationOptions(
      document: gql(query),
      variables: {
        'tenantUuid': defaultTenantUuid,
        'password': password,
        'mobileno': mobile,
      },
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final loginData = result.data?['adminLogin'];
    if (loginData == null) {
      throw Exception("Invalid login response from server");
    }

    //  Save tokens and tenant info locally
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', loginData['accessToken'] ?? '');
    await prefs.setString('refreshToken', loginData['refreshToken'] ?? '');
    await prefs.setString('tenantUuid', loginData['user']?['tenant_uuid'] ?? '');

    return loginData;
  }
}



// Dashboard Repository

class CardRepository {
  final GraphQLClient client;

  CardRepository(this.client);

  ///  Fetch Dashboard Summary — Always fetch fresh data
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

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        //  Always get fresh data from backend (no cache)
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?['getDashboardSummary'];

    if (data == null) {
      throw Exception('No data found');
    }

    //  Always return new object (avoid stale UI)
    return DashboardSummary.fromJson(Map<String, dynamic>.from(data));
  }
}


// Scheme Repository


class SchemeRepository {
  final GraphQLClient client;
  SchemeRepository(this.client);

  //  Get all schemes — Force fresh data (no cache)
  Future<List<Scheme>> fetchSchemes() async {
    const String query = r'''
      query {
        getAllSchemes {
          data {
            scheme_id
            scheme_name
            scheme_type
            duration_type
            duration
            min_amount
            max_amount
            increment_amount
            is_active
            amount_benefits
          }
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        //  Always get fresh data from server
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw result.exception!;
    }

    final List data = result.data?['getAllSchemes']?['data'] ?? [];
    //  Emit new list instance every time (forces UI rebuild)
    return List<Scheme>.from(data.map((e) => Scheme.fromJson(e)));
  }

  //  Create scheme
  Future<Scheme> createScheme(Map<String, dynamic> data) async {
    const String mutation = r'''
      mutation CreateScheme($data: ProductSchemesInput!) {
        createScheme(data: $data) {
          scheme_id
          scheme_name
          scheme_type
          duration_type
          duration
          min_amount
          max_amount
          increment_amount
        }
      }
    ''';

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {"data": data},
        //  Ensure this result doesn’t pollute cache
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;
    return Scheme.fromJson(result.data!['createScheme']);
  }

  //  Update scheme
  Future<Scheme> updateScheme(String schemeId, Map<String, dynamic> data) async {
    const String mutation = r'''
      mutation UpdateScheme($data: UpdateProductSchemesInput!, $schemeId: String!) {
        updateScheme(data: $data, scheme_id: $schemeId) {
          scheme_id
          scheme_name
          scheme_type
          duration_type
          duration
          min_amount
          max_amount
          increment_amount
        }
      }
    ''';

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {
          "schemeId": schemeId,
          "data": data,
        },
        //  Prevent GraphQL cache from showing stale data
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;
    return Scheme.fromJson(result.data!['updateScheme']);
  }

  //  Delete scheme
  Future<bool> deleteScheme(String schemeId) async {
    const String mutation = r'''
      mutation DeleteScheme($schemeId: String!) {
        softDeleteScheme(scheme_id: $schemeId)
      }
    ''';

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {"schemeId": schemeId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) throw result.exception!;
    final data = result.data?['softDeleteScheme'];

    if (data is bool) return data;
    if (data is int) return data == 1;
    return false;
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


// Add Gold Price Repository




class GoldPriceRepository {
  final GraphQLClient client;

  GoldPriceRepository(this.client);

  /// Fetch all gold prices for the logged-in tenant
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
          tenant_uuid
        }
      }
    ''';

    //  Get token from SharedPreferences (tenant info is inside token)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Token missing. Please log in again.");
    }

    // Ensure token is in Authorization header
    final authLink = AuthLink(getToken: () async => 'Bearer $token');
    final link = authLink.concat(client.link);

    final authedClient = GraphQLClient(
      cache: GraphQLCache(store: InMemoryStore()),
      link: link,
    );

    //  Run GraphQL query (without tenant_uuid argument)
    final result = await authedClient.query(
      QueryOptions(
        document: gql(query),
        variables: {"date": date},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      print("❌ GoldPriceRepository Error: ${result.exception.toString()}");
      throw Exception(result.exception.toString());
    }

    final List data = result.data?['getAllGoldPrice'] ?? [];

    //  Filter deleted entries
    final filtered = data.where((e) => e["isdeleted"] == false).toList();

    return List<GoldPrice>.from(filtered.map((e) => GoldPrice.fromJson(e)));
  }
}


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
        variables: {'data': input.toJson()},
        //  Prevent mutation cache pollution
        fetchPolicy: FetchPolicy.noCache,
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
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return GoldPrice.fromJson(result.data!["updateGoldPrice"]);
  }

  ///  Fetch Gold Rates (always fresh)
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
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?["goldRates"] as List<dynamic>? ?? [];
    return List<GoldPrice>.from(data.map((e) => GoldPrice.fromJson(e)));
  }

  ///  Fetch Silver Rates (always fresh)
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
      QueryOptions(
        document: gql(query),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?["silverRates"] as List<dynamic>? ?? [];
    return List<GoldPrice>.from(data.map((e) => GoldPrice.fromJson(e)));
  }

  ///  Delete Gold Price
  Future<void> deleteGoldPrice(String priceId) async {
    const mutation = r'''
      mutation Mutation($priceId: String!) {
        softDeleteGold(price_id: $priceId)
      }
    ''';

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {"priceId": priceId},
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
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

  fetchCustomerDetails(String id) {}
}

// Total Active Scheme Repository
// total_active_scheme_repository.dart



class TotalActiveSchemesRepository {
  final GraphQLClient client;

  TotalActiveSchemesRepository({required this.client});

  ///  QUERY: Fetch all active schemes — always fresh data
  Future<TotalActiveSchemeResponse> getTotalActiveSchemes() async {
    const query = r'''
      query GetTotalActiveSchemes {
        getTotalActiveSchemes {
          data {
            saving_id
            paidAmount
            customer {
              id
              cName
              cEmail
              cDob
              cPasswordHash
              cPhoneNumber
              nominees {
                c_nominee_id
                c_nominee_name
                c_nominee_email
                c_nominee_phone_no
              }
              addresses {
                c_address_id
                c_door_no
                c_address_line1
                c_address_line2
                c_city
                c_state
                c_pin_code
              }
              documents {
                c_document_id
                c_aadhar_no
                c_pan_no
              }
              c_profile_image
            }
            scheme_type
            scheme_id
            start_date
            end_date
            status
            total_gold_weight
            last_updated
            scheme_purpose
            scheme_name
            is_kyc
            is_completed
            percentage
            totalAmount
            gold_delivered
            delivered_gold_weight
            pending_gold_weight
            pending_amount
            total_benefit_gram
            tottalbonusgoldweight
            history {
              dueDate
              status
              paidDate
              paymentMode
              monthly_amount
              goldWeight
              amount
            }
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
        //  Always fetch fresh data from backend
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    //  Always parse as fresh object (no stale memory ref)
    return TotalActiveSchemeResponse.fromJson(
      Map<String, dynamic>.from(result.data!['getTotalActiveSchemes']),
    );
  }

  ///  MUTATION: Add cash payment — force no cache
  Future<Map<String, dynamic>> addCashCustomerSavings({
    required String savingId,
    required double amount,
  }) async {
    const mutation = r'''
      mutation Mutation($data: AddAmountToSavingInput!) {
        addCashCustomerSavings(data: $data) {
          saving_id
          customer {
            id
          }
          scheme_id
          total_amount
          start_date
          end_date
          status
          total_gold_weight
          last_updated
          bonusAmount
          current_rate
        }
      }
    ''';

    final variables = {
      "data": {
        "saving_id": savingId,
        "amount": amount,
      },
    };

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: variables,
        //  Don’t store mutation result in cache
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return Map<String, dynamic>.from(result.data!['addCashCustomerSavings']);
  }

 Future<bool> updateDeliveredGold({
  required String savingId,
  required double deliveredGold,
}) async {
  const String mutation = r'''
    mutation UpdateDeliveredGold($savingId: ID!, $deliveredGold: Float!) {
      updateDeliveredGold(savingId: $savingId, deliveredGold: $deliveredGold) {
        success
        message
      }
    }
  ''';

  final result = await client.mutate(
    MutationOptions(
      document: gql(mutation),
      variables: {
        "savingId": savingId,
        "deliveredGold": deliveredGold,
      },
    ),
  );

  if (result.hasException) {
    log("❌ GraphQL Error: ${result.exception.toString()}");
    return false;
  }

  return result.data?['updateDeliveredGold']?['success'] ?? false;
}


}



// Today Active Scheme Repository

class TodayActiveSchemeRepository {
  final GraphQLClient client;

  TodayActiveSchemeRepository(this.client);

  ///  Fetch today's active schemes (always fresh from backend)
  Future<TodayActiveSchemeResponse> fetchTodayActiveSchemes({
    String? startDate,
    String? savingId,
    required int page,
    required int limit,
  }) async {
    const String query = r'''
      query GetTodayActiveSchemes(
        $startDate: String,
        $savingId: String,
        $page: Float,
        $limit: Float
      ) {
        getTodayActiveSchemes(
          startDate: $startDate,
          savingId: $savingId,
          page: $page,
          limit: $limit
        ) {
          data {
            saving_id
            paidAmount
            customer {
              id
              cName
              cEmail
              cDob
              cPasswordHash
              cPhoneNumber
              nominees {
                c_nominee_id
                c_id
                c_nominee_name
                c_nominee_email
                c_nominee_phone_no
                c_created_at
                pin_code
              }
              addresses {
                c_address_id
                id
                c_door_no
                c_address_line1
                c_address_line2
                c_city
                c_state
                c_pin_code
                c_is_primary
                c_created_at
                tenant_id
              }
              documents {
                c_document_id
                c_id
                c_aadhar_no
                c_pan_no
                c_created_at
              }
              c_profile_image
              reset_password
              fcmToken
              firebaseUid
              isPhoneVerified
              lastOtpVerifiedAt
              lastRegisteredId
              lastRegisteredAt
            }
            scheme_type
            scheme_id
            start_date
            end_date
            status
            total_gold_weight
            last_updated
            scheme_purpose
            scheme_name
            is_kyc
            is_completed
            percentage
            totalAmount
            gold_delivered
            delivered_gold_weight
            pending_gold_weight
            pending_amount
            total_benefit_gram
            tottalbonusgoldweight
            history {
              dueDate
              status
              paidDate
              paymentMode
              monthly_amount
              goldWeight
              amount
            }
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
        variables: {
          'startDate': startDate,
          'savingId': savingId,
          'page': page,
          'limit': limit,
        },
        //  Always fetch live data from backend (ignore cache)
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final data = result.data?['getTodayActiveSchemes'];

    if (data == null) {
      throw Exception("No data received from backend");
    }

    //  Ensure new object for UI rebuild
    return TodayActiveSchemeResponse.fromJson(
      Map<String, dynamic>.from(data),
    );
  }

  ///  Add cash payment — disable cache to avoid stale updates
  Future<Map<String, dynamic>> addCashCustomerSavings({
    required String savingId,
    required double amount,
  }) async {
    const mutation = r'''
      mutation Mutation($data: AddAmountToSavingInput!) {
        addCashCustomerSavings(data: $data) {
          saving_id
          customer {
            id
          }
          scheme_id
          total_amount
          start_date
          end_date
          status
          total_gold_weight
          last_updated
          bonusAmount
          current_rate
        }
      }
    ''';

    final variables = {
      "data": {
        "saving_id": savingId,
        "amount": amount,
      },
    };

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: variables,
        //  Prevent GraphQL mutation cache
        fetchPolicy: FetchPolicy.noCache,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return Map<String, dynamic>.from(result.data!['addCashCustomerSavings']);
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

    try {
      final result = await client.query(
        QueryOptions(
          document: gql(query),
          variables: {"transactionType": "online"},
          fetchPolicy: FetchPolicy.networkOnly,
        ),
      );

      if (result.hasException) {
        log("OnlinePaymentRepo Error: ${result.exception}", name: "OnlinePaymentRepo");
        throw Exception("Unable to fetch online payments. Please try again.");
      }

      final responseData = result.data?['GetOnlinCashTransaction'];
      if (responseData == null) throw Exception("No online payments found");

      //  Ensure type-safe Map<String, dynamic>
      final Map<String, dynamic> safeResponse = Map<String, dynamic>.from(responseData);

      //  Parse using your model which already handles NaN & null safely
      return OnlinePaymentResponse.fromJson(safeResponse);
    } catch (e) {
      log("Repository Exception: $e", name: "OnlinePaymentRepo");
      rethrow;
    }
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



// Notification Repository
class NotificationRepository {
  final GraphQLClient client;

  NotificationRepository(this.client);

  Future<NotificationModel> sendNotification({
    required String cDescription,
    required String cHeader,
  }) async {
    const String mutation = r'''
      mutation Mutation($cDescription: String!, $cHeader: String!) {
        sendNotification(c_description: $cDescription, c_header: $cHeader) {
          c_description
          c_header
          c_send_date
          c_icon_img
          c_id
          c_is_deleted
          c_notification_id
          c_receive_date
          tenant_id
        }
      }
    ''';

    final options = MutationOptions(
      document: gql(mutation),
      variables: {
        "cDescription": cDescription,
        "cHeader": cHeader,
      },
    );

    final result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return NotificationModel.fromJson(
        result.data!['sendNotification']);
  }

  fetchNotifications() {}
}

// repo/customer_details_repository.dart

class CustomerDetailsRepository {
  final GraphQLClient client;

  CustomerDetailsRepository(this.client);
Future<CustomerDetails> fetchCustomerDetails(String customerId) async {
  const String query = r'''
  query GetAllSchemes($customerId: String!) {
    getCustomerDetails(customerId: $customerId) {
      customer {
        id
        cName
        cEmail
        cDob
        cPasswordHash
        cPhoneNumber
        nominees {
          c_nominee_id
          c_id
          c_nominee_name
          c_nominee_email
          c_nominee_phone_no
          c_created_at
          pin_code
        }
        addresses {
          c_address_id
          id
          c_door_no
          c_address_line1
          c_address_line2
          c_city
          c_state
          c_pin_code
          c_is_primary
          c_created_at
          tenant_id
        }
        documents {
          c_document_id
          c_id
          c_aadhar_no
          c_pan_no
          c_created_at
        }
        c_profile_image
        reset_password
        fcmToken
        firebaseUid
        isPhoneVerified
        lastOtpVerifiedAt
        lastRegisteredId
        lastRegisteredAt
      }
      savings {
        saving_id
        total_amount
        total_gold_weight
        total_benefit_gram
        start_date
        end_date
        schemeName
        transactions {
          transactionId
          transactionDate
          transactionAmount
          transactionGoldGram
          transactionType
        }
      }
      summary {
        total_paid_amount
        total_paid_gold_weight
        total_benefit_gram
        total_bonus_gold_weight
      }
    }
  }
''';


  final result = await client.query(QueryOptions(
    document: gql(query),
    variables: {"customerId": customerId},
    fetchPolicy: FetchPolicy.networkOnly,
  ));

  if (result.hasException) {
    throw Exception(result.exception.toString());
  }

 final data = result.data!['getCustomerDetails'];
final customerJson = data['customer'] as Map<String, dynamic>? ?? {};
final savingsJson = data['savings'] as List<dynamic>? ?? [];
final summaryJson = data['summary'] as Map<String, dynamic>? ?? {};

return CustomerDetails.fromJson({
  ...customerJson,
  'savings': savingsJson,
  'summary': summaryJson, //  FIXED
});

}

}


class TodayActiveRepository {
  final GraphQLClient client;
  TodayActiveRepository(this.client);

  Future<void> payNow({
    required String savingId,
  }) async {
    const String mutation = r'''
      mutation AddCashCustomerSavings($data: AddAmountToSavingInput!) {
        addCashCustomerSavings(data: $data) {
          saving_id
          scheme_id
          total_amount
          status
          last_updated
        }
      }
    ''';

    final variables = {
      "data": {
        "saving_id": savingId,
      }
    };

    final result = await client.mutate(MutationOptions(
      document: gql(mutation),
      variables: variables,
    ));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
  }
}
