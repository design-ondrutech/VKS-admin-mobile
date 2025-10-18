class CustomerDetails {
  final String id;
  final String cName;
  final String cEmail;
  final String cDob;
  final String cPasswordHash;
  final String cPhoneNumber;
  final List<Nominee> nominees;
  final List<Address> addresses;
  final List<Document> documents;
  final List<Saving> savings;
  final Summary? summary; //  single object

  final String? cProfileImage;
  final String? resetPassword;
  final String? fcmToken;
  final String? firebaseUid;
  final bool? isPhoneVerified;
  final String? lastOtpVerifiedAt;
  final String? lastRegisteredId;
  final String? lastRegisteredAt;

  CustomerDetails({
    required this.id,
    required this.cName,
    required this.cEmail,
    required this.cDob,
    required this.cPasswordHash,
    required this.cPhoneNumber,
    required this.nominees,
    required this.addresses,
    required this.documents,
    required this.savings,
    this.summary, // 
    this.cProfileImage,
    this.resetPassword,
    this.fcmToken,
    this.firebaseUid,
    this.isPhoneVerified,
    this.lastOtpVerifiedAt,
    this.lastRegisteredId,
    this.lastRegisteredAt,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: json['id']?.toString() ?? '',
      cName: json['cName']?.toString() ?? '',
      cEmail: json['cEmail']?.toString() ?? '',
      cDob: json['cDob']?.toString() ?? '',
      cPasswordHash: json['cPasswordHash']?.toString() ?? '',
      cPhoneNumber: json['cPhoneNumber']?.toString() ?? '',
      nominees: (json['nominees'] as List<dynamic>? ?? [])
          .map((n) => Nominee.fromJson(n))
          .toList(),
      addresses: (json['addresses'] as List<dynamic>? ?? [])
          .map((a) => Address.fromJson(a))
          .toList(),
      documents: (json['documents'] as List<dynamic>? ?? [])
          .map((d) => Document.fromJson(d))
          .toList(),
      savings: (json['savings'] as List<dynamic>? ?? [])
          .map((s) => Saving.fromJson(s))
          .toList(),
      summary: json['summary'] != null
          ? Summary.fromJson(json['summary'])
          : null, //  single object parse
      cProfileImage: json['c_profile_image']?.toString(),
      resetPassword: json['reset_password']?.toString(),
      fcmToken: json['fcmToken']?.toString(),
      firebaseUid: json['firebaseUid']?.toString(),
      isPhoneVerified: json['isPhoneVerified'] as bool?,
      lastOtpVerifiedAt: json['lastOtpVerifiedAt']?.toString(),
      lastRegisteredId: json['lastRegisteredId']?.toString(),
      lastRegisteredAt: json['lastRegisteredAt']?.toString(),
    );
  }
}

class Summary {
  final double totalPaidAmount;
  final double totalPaidGoldWeight;
  final double totalBenefitGram;
  final double totalBonusGoldWeight;

  Summary({
    required this.totalPaidAmount,
    required this.totalPaidGoldWeight,
    required this.totalBenefitGram,
    required this.totalBonusGoldWeight,
  });

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalPaidAmount: (json['total_paid_amount'] ?? 0).toDouble(),
      totalPaidGoldWeight: (json['total_paid_gold_weight'] ?? 0).toDouble(),
      totalBenefitGram: (json['total_benefit_gram'] ?? 0).toDouble(),
      totalBonusGoldWeight: (json['total_bonus_gold_weight'] ?? 0).toDouble(),
    );
  }
}



class Nominee {
  final String cNomineeId;
  final String cId;
  final String cNomineeName;
  final String cNomineeEmail;
  final String cNomineePhoneNo;
  final String cCreatedAt;
  final String pinCode;

  Nominee({
    required this.cNomineeId,
    required this.cId,
    required this.cNomineeName,
    required this.cNomineeEmail,
    required this.cNomineePhoneNo,
    required this.cCreatedAt,
    required this.pinCode,
  });

  factory Nominee.fromJson(Map<String, dynamic> json) {
    return Nominee(
      cNomineeId: json['c_nominee_id'] ?? '',
      cId: json['c_id'] ?? '',
      cNomineeName: json['c_nominee_name'] ?? '',
      cNomineeEmail: json['c_nominee_email'] ?? '',
      cNomineePhoneNo: json['c_nominee_phone_no'] ?? '',
      cCreatedAt: json['c_created_at'] ?? '',
      pinCode: json['pin_code'] ?? '',
    );
  }
}

class Address {
  final String cAddressId;
  final String id;
  final String cDoorNo;
  final String cAddressLine1;
  final String cAddressLine2;
  final String cCity;
  final String cState;
  final String cPinCode;
  final bool cIsPrimary;
  final String cCreatedAt;
  final String tenantId;

  Address({
    required this.cAddressId,
    required this.id,
    required this.cDoorNo,
    required this.cAddressLine1,
    required this.cAddressLine2,
    required this.cCity,
    required this.cState,
    required this.cPinCode,
    required this.cIsPrimary,
    required this.cCreatedAt,
    required this.tenantId,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      cAddressId: json['c_address_id'] ?? '',
      id: json['id'] ?? '',
      cDoorNo: json['c_door_no'] ?? '',
      cAddressLine1: json['c_address_line1'] ?? '',
      cAddressLine2: json['c_address_line2'] ?? '',
      cCity: json['c_city'] ?? '',
      cState: json['c_state'] ?? '',
      cPinCode: json['c_pin_code'] ?? '',
      cIsPrimary: json['c_is_primary'] ?? false,
      cCreatedAt: json['c_created_at'] ?? '',
      tenantId: json['tenant_id'] ?? '',
    );
  }
}

class Document {
  final String cDocumentId;
  final String cId;
  final String cAadharNo;
  final String cPanNo;
  final String cCreatedAt;

  Document({
    required this.cDocumentId,
    required this.cId,
    required this.cAadharNo,
    required this.cPanNo,
    required this.cCreatedAt,
  });

  factory Document.fromJson(Map<String, dynamic> json) {
    return Document(
      cDocumentId: json['c_document_id'] ?? '',
      cId: json['c_id'] ?? '',
      cAadharNo: json['c_aadhar_no'] ?? '',
      cPanNo: json['c_pan_no'] ?? '',
      cCreatedAt: json['c_created_at'] ?? '',
    );
  }
}


class Saving {
  final String savingId;
  final double totalAmount;
  final double totalGoldWeight;
  final double totalBenefitGram;
  final String startDate;
  final String endDate;
  final String schemeName;
  final List<Transaction> transactions;

  // NEW: scheme status from TotalActiveScheme
  String? schemeStatus;

  Saving({
    required this.savingId,
    required this.totalAmount,
    required this.totalGoldWeight,
    required this.totalBenefitGram,
    required this.startDate,
    required this.endDate,
    required this.schemeName,
    required this.transactions,
    this.schemeStatus,
  });

  factory Saving.fromJson(Map<String, dynamic> json) {
    return Saving(
      savingId: json['saving_id']?.toString() ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      totalGoldWeight: (json['total_gold_weight'] ?? 0).toDouble(),
      totalBenefitGram: (json['total_benefit_gram'] ?? 0).toDouble(),
      startDate: json['start_date'] ?? '',
      endDate: json['end_date'] ?? '',
      schemeName: json['schemeName'] ?? '',
      transactions: (json['transactions'] as List<dynamic>? ?? [])
          .map((t) => Transaction.fromJson(t))
          .toList(),
    );
  }

  Saving copyWith({
    String? schemeStatus,
  }) {
    return Saving(
      savingId: savingId,
      totalAmount: totalAmount,
      totalGoldWeight: totalGoldWeight,
      totalBenefitGram: totalBenefitGram,
      startDate: startDate,
      endDate: endDate,
      schemeName: schemeName,
      transactions: transactions,
      schemeStatus: schemeStatus ?? this.schemeStatus,
    );
  }
}


class Transaction {
  final String transactionId;
  final String transactionDate;
  final double transactionAmount;
  final double transactionGoldGram;
  final String transactionType;

  Transaction({
    required this.transactionId,
    required this.transactionDate,
    required this.transactionAmount,
    required this.transactionGoldGram,
    required this.transactionType,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transactionId'] ?? '',
      transactionDate: json['transactionDate'] ?? '',
      transactionAmount: (json['transactionAmount'] ?? 0).toDouble(),
      transactionGoldGram: (json['transactionGoldGram'] ?? 0).toDouble(),
      transactionType: json['transactionType'] ?? '',
    );
  }
}

