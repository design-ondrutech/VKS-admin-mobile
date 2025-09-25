
import 'package:admin/data/models/add_gold_price.dart';
import 'package:admin/data/models/barchart.dart';
import 'package:admin/data/models/card.dart';
import 'package:admin/data/models/cash_payment.dart';
import 'package:admin/data/models/customer.dart';
import 'package:admin/data/models/gold_rate.dart';
import 'package:admin/data/models/notification_model.dart';
import 'package:admin/data/models/online_payment.dart';
import 'package:admin/data/models/scheme.dart';
import 'package:admin/data/models/today_active_scheme.dart';
import 'package:admin/data/models/total_active_scheme.dart';
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

  // GET ALL
  Future<List<Scheme>> getAllSchemes() async {
    const String query = r'''
      query GetScheme {
        getAllSchemes {
          data {
            scheme_id
            scheme_name
            scheme_type
            duration_type
            duration
            amount_benefits
            min_amount
            max_amount
            increment_amount
            is_active
            isDeleted
            scheme_icon
          }
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(query)));

    if (result.hasException) throw Exception(result.exception.toString());

    final List<dynamic> data = result.data?['getAllSchemes']['data'] ?? [];
    return data.map((json) => Scheme.fromJson(json)).toList();
  }

  // CREATE
  Future<Scheme> createScheme(Scheme scheme) async {
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
          is_active
          isDeleted
        }
      }
    ''';

    final result = await client.mutate(MutationOptions(
      document: gql(mutation),
      variables: {"data": scheme.toCreateJson()},
    ));

    if (result.hasException) throw Exception(result.exception.toString());

    return Scheme.fromJson(result.data?['createScheme']);
  }

  // UPDATE
  Future<Scheme> updateScheme(Scheme scheme) async {
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
        is_active
        isDeleted
      }
    }
  ''';

  final result = await client.mutate(MutationOptions(
    document: gql(mutation),
    variables: {
      "data": scheme.toUpdateJson(), // scheme_id excluded
      "schemeId": scheme.schemeId,   // path variable
    },
  ));

  if (result.hasException) throw Exception(result.exception.toString());

  return Scheme.fromJson(result.data!['updateScheme']);
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
// total_active_scheme_repository.dart

class TotalActiveSchemesRepository {
  final GraphQLClient client;

  TotalActiveSchemesRepository({required this.client});

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
      QueryOptions(document: gql(query)),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    return TotalActiveSchemeResponse.fromJson(
        result.data!['getTotalActiveSchemes']);
  }
}



// Today Active Scheme Repository
class TodayActiveSchemeRepository {
  final GraphQLClient client;

  TodayActiveSchemeRepository(this.client);

  Future<TodayActiveSchemeResponse> fetchTodayActiveSchemes({
    String? startDate,
    String? savingId,
  }) async {
    const String query = r'''
      query GetTodayActiveSchemes($startDate: String, $savingId: String) {
        getTodayActiveSchemes(startDate: $startDate, savingId: $savingId) {
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
        }
      }
    ''';

    final result = await client.query(
      QueryOptions(
        document: gql(query),
        variables: {
          'startDate': startDate,
          'savingId': savingId,
        },
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

    final responseData = result.data?['GetOnlinCashTransaction'];
    if (responseData == null) throw Exception("No online payments found");

    return OnlinePaymentResponse.fromJson(responseData);
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




// class CreateSchemeRepository {
//   final GraphQLClient client;

//   CreateSchemeRepository(this.client);

//   // CREATE
//   Future<CreateSchemeResponse> createScheme(Map<String, dynamic> data) async {
//     const mutation = r'''
//       mutation CreateScheme($data: ProductSchemesInput!) {
//         createScheme(data: $data) {
//           scheme_id
//           scheme_name
//           scheme_type
//           duration_type
//           duration
//           min_amount
//           max_amount
//           increment_amount
//           is_active
//           scheme_icon
//           isDeleted
//           threshold
//           bonus
//         }
//       }
//     ''';

//     final result = await client.mutate(
//       MutationOptions(document: gql(mutation), variables: {'data': data}),
//     );

//     if (result.hasException) throw Exception(result.exception.toString());
//     final schemeJson = result.data?['createScheme'];
//     if (schemeJson == null) throw Exception('Create scheme returned null');
//     return CreateSchemeResponse.fromJson(schemeJson);
//   }

//   // UPDATE
//   Future<CreateSchemeResponse> updateScheme(
//       String schemeId, Map<String, dynamic> data) async {
//     const mutation = r'''
//       mutation UpdateScheme($scheme_id: String!, $data: ProductSchemesInput!) {
//         updateScheme(scheme_id: $scheme_id, data: $data) {
//           scheme_id
//           scheme_name
//           scheme_type
//           duration_type
//           duration
//           min_amount
//           max_amount
//           increment_amount
//           is_active
//           scheme_icon
//           isDeleted
//           threshold
//           bonus
//         }
//       }
//     ''';

//     // Debug print to confirm variables
//     print('updateScheme variables: ${{
//       'scheme_id': schemeId,
//       'data': data,
//     }}');

//     final result = await client.mutate(
//       MutationOptions(
//         document: gql(mutation),
//         variables: {
//           'scheme_id': schemeId,
//           'data': data,
//         },
//       ),
//     );

//     if (result.hasException) {
//       throw Exception('UpdateScheme Error: ${result.exception.toString()}');
//     }

//     final schemeJson = result.data?['updateScheme'];
//     if (schemeJson == null) throw Exception('Update scheme returned null');

//     return CreateSchemeResponse.fromJson(schemeJson);
//   }
// }





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

// class UpdateSchemeRepository {
//   final GraphQLClient client;

//   UpdateSchemeRepository(this.client);

//   static const String updateSchemeMutation = r'''
//     mutation UpdateScheme($data: UpdateProductSchemesInput!, $schemeId: String!) {
//       updateScheme(data: $data, scheme_id: $schemeId) {
//         scheme_id
//         scheme_name
//         scheme_type
//         duration_type
//         duration
//         min_amount
//         max_amount
//         increment_amount
//         is_active
//         scheme_icon
//         scheme_image
//         scheme_notes
//         redemption_terms
//         interest_rate
//         isDeleted
//       }
//     }
//   ''';

//   Future<UpdateSchemeModel> updateScheme(
//     String schemeId,
//     UpdateSchemeModel model,
//   ) async {
//     final result = await client.mutate(
//       MutationOptions(
//         document: gql(updateSchemeMutation),
//         variables: {
//           "schemeId": schemeId,
//           "data": model.toJson(),
//         },
//       ),
//     );

//     if (result.hasException) {
//       throw Exception("UpdateScheme Error: ${result.exception}");
//     }

//     final json = result.data?['updateScheme'];
//     if (json == null) throw Exception("No data returned from updateScheme");

//     return UpdateSchemeModel.fromJson(json);
//   }
// }
