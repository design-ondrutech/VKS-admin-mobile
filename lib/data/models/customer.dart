class Customer {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;

  Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json["id"],
      name: json["cName"],
      email: json["cEmail"],
      phoneNumber: json["cPhoneNumber"],
    );
  }
}

class CustomerResponse {
  final int totalCount;
  final int currentPage;
  final int limit;
  final int totalPages;
  final List<Customer> data;

  CustomerResponse({
    required this.totalCount,
    required this.currentPage,
    required this.limit,
    required this.totalPages,
    required this.data,
  });

  factory CustomerResponse.fromJson(Map<String, dynamic> json) {
    return CustomerResponse(
      totalCount: json["totalCount"],
      currentPage: json["currentPage"],
      limit: json["limit"],
      totalPages: json["totalPages"],
      data: (json["data"] as List)
          .map((e) => Customer.fromJson(e))
          .toList(),
    );
  }
}
