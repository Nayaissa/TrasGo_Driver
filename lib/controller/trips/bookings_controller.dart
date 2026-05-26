import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/data/model/booking_requests_model.dart';
import 'package:transport_project/data/model/booking_status_model.dart';

abstract class BookingsController extends GetxController {
  getBookingStatuses();
  getBookingsByStatus(String status);
  changeFilter(int index);
  goToBookingDetails();
}

class BookingControllerImp extends BookingsController {
  StatusRequest? getBookingStatusRequest;
  StatusRequest? getBookingsRequest;

  BookingStatusModel? bookingStatusModel;
  BookingRequestsModel? bookingRequestsModel;

  int filterIndex = 0;

  late int tripId;
  String from = '';
  String to = '';
  String departureTime = '';

  @override
  void onInit() {
    final args = Get.arguments;

    if (args != null && args["trip_id"] != null) {
      tripId = int.parse(args["trip_id"].toString());
      from = args["from"]?.toString() ?? '';
      to = args["to"]?.toString() ?? '';
      departureTime = args["departure_time"]?.toString() ?? '';
    } else {
      tripId = -1;
    }

    if (tripId == -1) {
      getBookingsRequest = StatusRequest.noData;
      update();
      return;
    }

    getBookingStatuses();
    super.onInit();
  }

  @override
  getBookingStatuses() {
    getBookingStatusRequest = StatusRequest.loading;
    update();

    DioHelper.getDataa(url: 'v1/booking-statuses')
        .then((value) {
          if (value != null && value.statusCode == 200) {
            bookingStatusModel = BookingStatusModel.fromJson(value.data);

            final items = bookingStatusModel?.data?.items ?? [];

            if (items.isEmpty) {
              getBookingStatusRequest = StatusRequest.noData;
              getBookingsRequest = StatusRequest.noData;
            } else {
              getBookingStatusRequest = StatusRequest.success;
              getBookingsByStatus('all');
            }
          } else {
            getBookingStatusRequest = StatusRequest.noData;
            getBookingsRequest = StatusRequest.noData;
          }

          update();
        })
        .catchError((error) {
          print(error.toString());
          getBookingStatusRequest = StatusRequest.serverfailure;
          getBookingsRequest = StatusRequest.serverfailure;
          update();
        });
  }

  @override
  getBookingsByStatus(String status) {
    getBookingsRequest = StatusRequest.loading;
    update();

    DioHelper.getDataa(url: 'v1/driver/trips/$tripId/bookings?status=$status')
        .then((value) {
          if (value != null && value.statusCode == 200) {
            bookingRequestsModel = BookingRequestsModel.fromJson(value.data);

            final bookings = bookingRequestsModel?.data?.items ?? [];

            getBookingsRequest =
                bookings.isEmpty ? StatusRequest.noData : StatusRequest.success;
          } else {
            getBookingsRequest = StatusRequest.noData;
          }

          update();
        })
        .catchError((error) {
          print("BOOKINGS ERROR => $error");
          getBookingsRequest = StatusRequest.serverfailure;
          update();
        });
  }

  @override
  void changeFilter(int index) {
    filterIndex = index;

    final selectedStatus = bookingStatusModel?.data?.items?[index].key;

    if (selectedStatus != null) {
      getBookingsByStatus(selectedStatus);
    }

    update();
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return '';

    try {
      final parsed = DateTime.parse(date).toLocal();
      final now = DateTime.now();

      final isToday =
          parsed.year == now.year &&
          parsed.month == now.month &&
          parsed.day == now.day;

      final tomorrow = now.add(const Duration(days: 1));

      final isTomorrow =
          parsed.year == tomorrow.year &&
          parsed.month == tomorrow.month &&
          parsed.day == tomorrow.day;

      final time = DateFormat('hh:mm a').format(parsed);

      if (isToday) return 'Today, $time';
      if (isTomorrow) return 'Tomorrow, $time';

      return DateFormat('EEE, MMM d, hh:mm a').format(parsed);
    } catch (e) {
      return date;
    }
  }

  bool isDisabledBooking(String? statusKey) {
    return statusKey == 'rejected' ||
        statusKey == 'canceled' ||
        statusKey == 'completed';
  }

  String paymentText(String? payment) {
    if (payment == 'cash') return 'Cash';
    if (payment == 'electronic') return 'Electronic';
    return payment ?? '';
  }

  String buttonText(String? statusKey) {
    return 'View Details';
  }

  @override
 @override
goToBookingDetails() {
  Get.toNamed(
    AppRoute.bookingsdetails,
    arguments: {
      "trip_id": tripId,
      "from": from,
      "to": to,
      "departure_time": departureTime,
    },
  );
}
}
