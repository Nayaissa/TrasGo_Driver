class BookingStatusModel {
  bool? success;
  String? message;
  BookingStatusData? data;
  int? statusCode;
  String? timestamp;

  BookingStatusModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? BookingStatusData.fromJson(json['data']) : null;
    statusCode = json['status_code'];
    timestamp = json['timestamp'];
  }
}

class BookingStatusData {
  List<BookingStatusItem>? items;

  BookingStatusData.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items!.add(BookingStatusItem.fromJson(v));
      });
    }
  }
}

class BookingStatusItem {
  int? id;
  String? key;
  String? name;
  String? description;
  bool? isFinal;
  int? displayOrder;
  String? color;

  BookingStatusItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    key = json['key'];
    name = json['name'];
    description = json['description'];
    isFinal = json['is_final'];
    displayOrder = json['display_order'];
    color = json['color'];
  }
}