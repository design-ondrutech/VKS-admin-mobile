class TodayActiveSchemeResponse {
  final List<TodayActiveScheme> data;
  final int limit;
  final int page;
  final int totalCount;
  final double? totalSchemeAmount;
  final double? totalSchemeGoldWeight;

  TodayActiveSchemeResponse({
    required this.data,
    required this.limit,
    required this.page,
    required this.totalCount, 
    this.totalSchemeAmount,
    this.totalSchemeGoldWeight,
  });

  factory TodayActiveSchemeResponse.fromJson(Map<String, dynamic> json) {
    return TodayActiveSchemeResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => TodayActiveScheme.fromJson(e))
          .toList(),
      limit: json['limit'] ?? 0,
      page: json['page'] ?? 0,
      totalCount: json['totalCount'] ?? 0,
      totalSchemeAmount: (json['total_scheme_amount'] as num?)?.toDouble(),
      totalSchemeGoldWeight: (json['total_scheme_gold_weight'] as num?)?.toDouble(),
    );
  }
}

class TodayActiveScheme {
  final String savingId;
  final double? paidAmount;
  final Customer customer;
  final String schemeType;
  final String schemeId;
  final String startDate;
  final String endDate;
  final String status;
  final double? totalGoldWeight;
  final String lastUpdated;
  final String schemePurpose;
  final String schemeName;
  final bool isKyc;
  final bool isCompleted;
  final double? percentage;
  final double? totalAmount;
  final bool goldDelivered;
  final double? deliveredGoldWeight;
  final double? pendingGoldWeight;
  final double? pendingAmount;
  final List<PaymentHistory> history;

  TodayActiveScheme({
    required this.savingId,
    this.paidAmount,
    required this.customer,
    required this.schemeType,
    required this.schemeId,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.totalGoldWeight,
    required this.lastUpdated,
    required this.schemePurpose,
    required this.schemeName,
    required this.isKyc,
    required this.isCompleted,
    this.percentage,
    this.totalAmount,
    required this.goldDelivered,
    this.deliveredGoldWeight,
    this.pendingGoldWeight,
    this.pendingAmount,
    required this.history,
  });

  factory TodayActiveScheme.fromJson(Map<String, dynamic> json) {
    return TodayActiveScheme(
      savingId: json['saving_id'] ?? '',
      paidAmount: (json['paidAmount'] as num?)?.toDouble(),
      customer: Customer.fromJson(json['customer']),
      schemeType: json['scheme_type'] ?? '',
      schemeId: json['scheme_id'] ?? '',
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      status: json['status'] ?? '',
      totalGoldWeight: (json['total_gold_weight'] as num?)?.toDouble(),
      lastUpdated: json['last_updated'] ?? '',
      schemePurpose: json['scheme_purpose'] ?? '',
      schemeName: json['scheme_name'] ?? '',
      isKyc: json['is_kyc'] ?? false,
      isCompleted: json['is_completed'] ?? false,
      percentage: (json['percentage'] as num?)?.toDouble(),
      totalAmount: (json['totalAmount'] as num?)?.toDouble(),
      goldDelivered: json['gold_delivered'] ?? false,
      deliveredGoldWeight: (json['delivered_gold_weight'] as num?)?.toDouble(),
      pendingGoldWeight: (json['pending_gold_weight'] as num?)?.toDouble(),
      pendingAmount: (json['pending_amount'] as num?)?.toDouble(),
      history: (json['history'] as List<dynamic>)
          .map((e) => PaymentHistory.fromJson(e))
          .toList(),
    );
  }
}

class Customer {
  final String id;
  final String cName;
  final String cEmail;
  final String cDob;
  final String cPhoneNumber;
  final List<Nominee> nominees;
  final List<Address> addresses;
  final List<Document> documents;
  final String? cProfileImage;

  Customer({
    required this.id,
    required this.cName,
    required this.cEmail,
    required this.cDob,
    required this.cPhoneNumber,
    required this.nominees,
    required this.addresses,
    required this.documents,
    this.cProfileImage,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'] ?? '',
      cName: json['cName'] ?? '',
      cEmail: json['cEmail'] ?? '',
      cDob: json['cDob'] ?? '',
      cPhoneNumber: json['cPhoneNumber'] ?? '',
      cProfileImage: json['c_profile_image'],
      nominees: (json['nominees'] as List<dynamic>)
          .map((e) => Nominee.fromJson(e))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>)
          .map((e) => Address.fromJson(e))
          .toList(),
      documents: (json['documents'] as List<dynamic>)
          .map((e) => Document.fromJson(e))
          .toList(),
    );
  }
}

class Nominee {
  final String nomineeId;
  final String nomineeName;
  final String nomineeEmail;
  final String nomineePhone;
  final String pinCode;

  Nominee({
    required this.nomineeId,
    required this.nomineeName,
    required this.nomineeEmail,
    required this.nomineePhone,
    required this.pinCode,
  });

  factory Nominee.fromJson(Map<String, dynamic> json) {
    return Nominee(
      nomineeId: json['c_nominee_id'] ?? '',
      nomineeName: json['c_nominee_name'] ?? '',
      nomineeEmail: json['c_nominee_email'] ?? '',
      nomineePhone: json['c_nominee_phone_no'] ?? '',
      pinCode: json['pin_code'] ?? '',
    );
  }
}

class Address {
  final String addressId;
  final String doorNo;
  final String line1;
  final String line2;
  final String city;
  final String state;
  final String pinCode;
  final bool isPrimary;

  Address({
    required this.addressId,
    required this.doorNo,
    required this.line1,
    required this.line2,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.isPrimary,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      addressId: json['c_address_id'] ?? '',
      doorNo: json['c_door_no'] ?? '',
      line1: json['c_address_line1'] ?? '',
      line2: json['c_address_line2'] ?? '',
      city: json['c_city'] ?? '',
      state: json['c_state'] ?? '',
      pinCode: json['c_pin_code'] ?? '',
      isPrimary: json['c_is_primary'] ?? false,
    );
  }
}

class Document {
  final String documentId;
  final String aadharNo;
  final String panNo;

  Document({
    required this.documentId,
    required this.aadharNo,
    required this.panNo,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      documentId: json['c_document_id'] ?? '',
      aadharNo: json['c_aadhar_no'] ?? '',
      panNo: json['c_pan_no'] ?? '',
    );
  }
}

class PaymentHistory {
  final String dueDate;
  final String status;
  final String paidDate;
  final String paymentMode;
  final double? monthlyAmount;
  final double? goldWeight;
  final double? amount;

  PaymentHistory({
    required this.dueDate,
    required this.status,
    required this.paidDate,
    required this.paymentMode,
    this.monthlyAmount,
    this.goldWeight,
    this.amount,
  });

  factory PaymentHistory.fromJson(Map<String, dynamic> json) {
    return PaymentHistory(
      dueDate: json['dueDate'] ?? '',
      status: json['status'] ?? '',
      paidDate: json['paidDate'] ?? '',
      paymentMode: json['paymentMode'] ?? '',
      monthlyAmount: (json['monthly_amount'] as num?)?.toDouble(),
      goldWeight: (json['goldWeight'] as num?)?.toDouble(),
      amount: (json['amount'] as num?)?.toDouble(),
    );
  }
}
