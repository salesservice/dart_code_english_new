class NotificationModel {
  int? notificationId;
  String? notificationTitle;
  String? notificationBody;
  int? notificationUserid;
  String? notificationTime;

  NotificationModel(
      {this.notificationId,
      this.notificationTitle,
      this.notificationBody,
      this.notificationUserid,
      this.notificationTime});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    notificationTitle = json['notification_title'];
    notificationBody = json['notification_body'];
    notificationUserid = json['notification_userid'];
    notificationTime = json['notification_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['notification_title'] = this.notificationTitle;
    data['notification_body'] = this.notificationBody;
    data['notification_userid'] = this.notificationUserid;
    data['notification_time'] = this.notificationTime;
    return data;
  }
}
