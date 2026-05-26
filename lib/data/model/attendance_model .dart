class AttendanceModel {
  final bool? success;
  final AttendanceData? data;

  AttendanceModel({this.success, this.data});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      success: json['success'],
      data: json['data'] != null ? AttendanceData.fromJson(json['data']) : null,
    );
  }
}

class AttendanceData {
  final int? tripId;
  final List<AttendanceItem> items;

  AttendanceData({this.tripId, required this.items});

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      tripId: json['trip_id'],
      items: json['attendance']?['items'] != null
          ? List<AttendanceItem>.from(
              json['attendance']['items'].map(
                (e) => AttendanceItem.fromJson(e),
              ),
            )
          : [],
    );
  }
}

class AttendanceItem {
  final int? bookingId;
  final String? bookingCode;
  final String? passengerName;
  final String? passengerPhone;
  final String? passengerImage;
  final int? passengerRating;
  final String? pickupPoint;
  final String? bookingStatus;
  String? attendanceStatus;
  String? attendanceStatusKey;

  AttendanceItem({
    this.bookingId,
    this.bookingCode,
    this.passengerName,
    this.passengerPhone,
    this.passengerImage,
    this.passengerRating,
    this.pickupPoint,
    this.bookingStatus,
    this.attendanceStatus,
    this.attendanceStatusKey,
  });

  factory AttendanceItem.fromJson(Map<String, dynamic> json) {
    return AttendanceItem(
      bookingId: json['booking_id'],
      bookingCode: json['booking_code'],
      passengerName: json['passenger_name'],
      passengerPhone: json['passenger_phone'],
      passengerImage: json['passenger_image'],
      passengerRating: json['passenger_rating'],
      pickupPoint: json['pickup_point'],
      bookingStatus: json['booking_status'],
      attendanceStatus: json['attendance_status'],
      attendanceStatusKey: json['attendance_status_key'],
    );
  }
}