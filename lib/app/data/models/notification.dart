class InAppNotification {
  int? id;
  int? receiver;
  String? header;
  String? message;
  String? notType;
  int? contentType;
  int? objectId;
  bool? seen;
  DateTime? timestamp;

  InAppNotification({
    this.id,
    this.receiver,
    this.header,
    this.message,
    this.notType,
    this.contentType,
    this.objectId,
    this.seen,
    this.timestamp,
  });

  factory InAppNotification.fromJson(Map<String, dynamic> json) => InAppNotification(
    id: json['id'],
    receiver: json['receiver'],
    header: json['header'],
    message: json['message'],
    notType: json['not_type'],
    contentType: json['content_type'],
    objectId: json['object_id'],
    seen: json['seen'],
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp']) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'receiver': receiver,
    'header': header,
    'message': message,
    'not_type': notType,
    'content_type': contentType,
    'object_id': objectId,
    'seen': seen,
    'timestamp': timestamp?.toIso8601String(),
  };
}
