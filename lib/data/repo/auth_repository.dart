
import 'package:admin/data/models/add_gold_price.dart';
import 'package:admin/data/models/barchart.dart';
import 'package:admin/data/models/card.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:admin/data/models/create_scheme.dart';
import 'package:admin/data/models/customer.dart';
import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/data/models/notification_model.dart';
import 'package:admin/data/models/online_payment.dart';
import 'package:admin/data/models/scheme.dart';
import 'package:admin/data/models/today_active_scheme.dart';
import 'package:admin/data/models/total_active_scheme';
import 'package:admin/screens/dashboard/customer/customer_detail/model/customer_details_model.dart';
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

  Future<SchemesResponse> fetchSchemes() async {
    const String query = r'''
      query GetAllSchemes {
        getAllSchemes {
          data {
            scheme_id
            scheme_name
            scheme_type
            duration_type
            duration
            benefits
            amount_benefits
            min_amount
            max_amount
            increment_amount
            is_active
            redemption_terms
            interest_rate
            created_date
            last_update_date
            isDeleted
            scheme_icon
            scheme_image
            scheme_notes
            is_benifit_popup
            popup_benifits
          }
          limit
          totalCount
          totalPages
          currentPage
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(query)));

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final json = result.data?['getAllSchemes'] ?? {};
    return SchemesResponse.fromJson(json);
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

  fetchCustomerDetails(String id) {}
}

// Total Active Scheme Repository
class TotalActiveSchemesRepository {
  final GraphQLClient client;

  TotalActiveSchemesRepository(this.client);

  Future<TotalActiveSchemesResponse> fetchTotalActiveSchemes({String? savingId}) async {
    const String query = r'''
    query GetTotalActiveSchemes($savingId: String) {
      getTotalActiveSchemes(savingId: $savingId) {
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
        total_scheme_amount
        total_scheme_gold_weight
      }
    }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {'savingId': savingId},
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    // Parse the nested "getTotalActiveSchemes" data
    return TotalActiveSchemesResponse.fromJson(result.data!['getTotalActiveSchemes']);
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

// Create Scheme Repository
class CreateSchemeRepository {
  final GraphQLClient client;
  CreateSchemeRepository(this.client);

  /// CREATE scheme
  Future<CreateSchemeModel> createScheme(Map<String, dynamic> data) async {
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
          
          #  Nested amount_benefits query
          amount_benefits {
            threshold
            bonus
          }

          is_active
          scheme_icon
          scheme_image
          scheme_notes
          redemption_terms
          interest_rate
          isDeleted
        }
      }
    ''';

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {"data": data},
      ),
    );

    if (result.hasException) {
      throw Exception("CreateScheme Error: ${result.exception.toString()}");
    }

    final schemeJson = result.data?['createScheme'];
    if (schemeJson == null) {
      throw Exception("No data returned from createScheme");
    }

    return CreateSchemeModel.fromJson(schemeJson);
  }

  /// UPDATE scheme
  Future<CreateSchemeModel> updateScheme(String id, Map<String, dynamic> data) async {
    if (id.isEmpty) throw Exception("schemeId cannot be empty");

    const String mutation = r'''
      mutation UpdateScheme($id: ID!, $data: ProductSchemesInput!) {
        updateScheme(id: $id, data: $data) {
          scheme_id
          scheme_name
          scheme_type
          duration_type
          duration
          min_amount
          max_amount
          increment_amount
          
          #  Nested amount_benefits query
          amount_benefits {
            threshold
            bonus
          }

          is_active
          scheme_icon
          scheme_image
          scheme_notes
          redemption_terms
          interest_rate
          isDeleted
        }
      }
    ''';

    final result = await client.mutate(
      MutationOptions(
        document: gql(mutation),
        variables: {
          "id": id, //  Corrected argument name
          "data": data,
        },
      ),
    );

    if (result.hasException) {
      throw Exception("UpdateScheme Error: ${result.exception.toString()}");
    }

    final schemeJson = result.data?['updateScheme'];
    if (schemeJson == null) {
      throw Exception("No data returned from updateScheme");
    }

    return CreateSchemeModel.fromJson(schemeJson);
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

  return CustomerDetails.fromJson({
    ...customerJson,
    'savings': savingsJson,
  });
}

}
