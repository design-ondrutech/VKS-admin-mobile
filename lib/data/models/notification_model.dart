class NotificationModel {
  final String cDescription;
  final String cHeader;
  final String? cSendDate;
  final String? cIconImg;
  final String? cId;
  final bool? cIsDeleted;
  final String? cNotificationId;
  final String? cReceiveDate;
  final String? tenantId;

  NotificationModel({
    required this.cDescription,
    required this.cHeader,
    this.cSendDate,
    this.cIconImg,
    this.cId,
    this.cIsDeleted,
    this.cNotificationId,
    this.cReceiveDate,
    this.tenantId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      cDescription: json['c_description'] ?? '',
      cHeader: json['c_header'] ?? '',
      cSendDate: json['c_send_date'],
      cIconImg: json['c_icon_img'],
      cId: json['c_id'],
      cIsDeleted: json['c_is_deleted'],
      cNotificationId: json['c_notification_id'],
      cReceiveDate: json['c_receive_date'],
      tenantId: json['tenant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'c_description': cDescription,
      'c_header': cHeader,
      'c_send_date': cSendDate,
      'c_icon_img': cIconImg,
      'c_id': cId,
      'c_is_deleted': cIsDeleted,
      'c_notification_id': cNotificationId,
      'c_receive_date': cReceiveDate,
      'tenant_id': tenantId,
    };
  }

  NotificationModel copyWith({
    String? cDescription,
    String? cHeader,
    String? cSendDate,
    String? cIconImg,
    String? cId,
    bool? cIsDeleted,
    String? cNotificationId,
    String? cReceiveDate,
    String? tenantId,
  }) {
    return NotificationModel(
      cDescription: cDescription ?? this.cDescription,
      cHeader: cHeader ?? this.cHeader,
      cSendDate: cSendDate ?? this.cSendDate,
      cIconImg: cIconImg ?? this.cIconImg,
      cId: cId ?? this.cId,
      cIsDeleted: cIsDeleted ?? this.cIsDeleted,
      cNotificationId: cNotificationId ?? this.cNotificationId,
      cReceiveDate: cReceiveDate ?? this.cReceiveDate,
      tenantId: tenantId ?? this.tenantId,
    );
  }
}
