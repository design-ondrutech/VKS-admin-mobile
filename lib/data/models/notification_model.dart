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
      cDescription: json['c_description'],
      cHeader: json['c_header'],
      cSendDate: json['c_send_date'],
      cIconImg: json['c_icon_img'],
      cId: json['c_id'],
      cIsDeleted: json['c_is_deleted'],
      cNotificationId: json['c_notification_id'],
      cReceiveDate: json['c_receive_date'],
      tenantId: json['tenant_id'],
    );
  }
}
