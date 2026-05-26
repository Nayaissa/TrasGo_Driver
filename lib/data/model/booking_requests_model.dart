class BookingRequestsModel {
  bool? success;
  String? message;
  BookingRequestsData? data;
  int? statusCode;
  String? timestamp;

  BookingRequestsModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  BookingRequestsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null
        ? BookingRequestsData.fromJson(json['data'])
        : null;
    statusCode = json['status_code'];
    timestamp = json['timestamp'];
  }
}

class BookingRequestsData {
  int? tripId;
  List<BookingItem>? items;

  BookingRequestsData({
    this.tripId,
    this.items,
  });

  BookingRequestsData.fromJson(Map<String, dynamic> json) {
    tripId = json['trip_id'];

    if (json['items'] != null) {
      items = <BookingItem>[];
      json['items'].forEach((v) {
        items!.add(BookingItem.fromJson(v));
      });
    }
  }
}

class BookingItem {
  int? bookingId;
  String? bookingCode;
  String? passengerName;
  String? passengerImage;
  num? passengerRating;
  int? seatsReserved;
  String? paymentMethod;
  BookingStatus? status;
  String? sentAt;
  bool? isNew;
  String? detailsEndpoint;

  BookingItem({
    this.bookingId,
    this.bookingCode,
    this.passengerName,
    this.passengerImage,
    this.passengerRating,
    this.seatsReserved,
    this.paymentMethod,
    this.status,
    this.sentAt,
    this.isNew,
    this.detailsEndpoint,
  });

  BookingItem.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingCode = json['booking_code'];
    passengerName = json['passenger_name'];
    passengerImage = json['passenger_image'];
    passengerRating = json['passenger_rating'];
    seatsReserved = json['seats_reserved'];
    paymentMethod = json['payment_method'];
    status =
        json['status'] != null ? BookingStatus.fromJson(json['status']) : null;
    sentAt = json['sent_at'];
    isNew = json['is_new'];
    detailsEndpoint = json['details_endpoint'];
  }
}

class BookingStatus {
  String? key;
  String? name;

  BookingStatus({
    this.key,
    this.name,
  });

  BookingStatus.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
  }
}