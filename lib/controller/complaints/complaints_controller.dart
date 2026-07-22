import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';

class ComplaintModel {
  final int complaintId;
  final String id;
  final String ticketId;
  final String description;
  final String date;
  final String status;
  final String type;

  final dynamic relatedTripId;
  final dynamic relatedBookingId;
  final dynamic relatedDriver;
  final dynamic relatedPassenger;
  final String resolvedAt;

  ComplaintModel({
    required this.complaintId,
    required this.id,
    required this.ticketId,
    required this.description,
    required this.date,
    required this.status,
    required this.type,
    this.relatedTripId,
    this.relatedBookingId,
    this.relatedDriver,
    this.relatedPassenger,
    required this.resolvedAt,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final complaintId =
        int.tryParse(json["complaint_id"]?.toString() ?? "0") ?? 0;

    return ComplaintModel(
      complaintId: complaintId,
      id: json["complaint_code"]?.toString() ?? "",
      ticketId: "Ticket ID #$complaintId",
      description: json["description"]?.toString() ?? "",
      date: _formatDate(json["created_at"]?.toString() ?? ""),
      status: _capitalize(json["status"]?.toString() ?? ""),
      type: _capitalize(json["complaint_type"]?.toString() ?? ""),
      relatedTripId: json["related_trip_id"],
      relatedBookingId: json["related_booking_id"],
      relatedDriver: json["related_driver"],
      relatedPassenger: json["related_passenger"],
      resolvedAt: json["resolved_at"]?.toString() ?? "",
    );
  }

  static String _capitalize(String value) {
    if (value.isEmpty) return "";
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  static String _formatDate(String isoDate) {
    if (isoDate.isEmpty) return "";

    try {
      final dateTime = DateTime.parse(isoDate);

      final months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];

      final monthName = months[dateTime.month - 1];

      final period = dateTime.hour >= 12 ? "PM" : "AM";

      int hour = dateTime.hour % 12;
      if (hour == 0) hour = 12;

      final formattedHour = hour.toString().padLeft(2, "0");
      final formattedMinute = dateTime.minute.toString().padLeft(2, "0");

      return "$monthName ${dateTime.day}, ${dateTime.year} - $formattedHour:$formattedMinute $period";
    } catch (e) {
      return isoDate;
    }
  }
}

abstract class ComplaintsController extends GetxController {
  Future<void> getComplaints();
  Future<void> refreshComplaints();
  void changeFilter(String filter);
  void searchComplaints(String value);
}

class ComplaintsControllerImp extends ComplaintsController {
  StatusRequest? complaintsStatusRequest;

  final List<ComplaintModel> _allComplaints = [];

  List<ComplaintModel> filteredComplaints = [];

  String selectedFilter = "All";
  String searchText = "";

  int totalFromApi = 0;

  int get totalComplaints {
    if (totalFromApi > 0) {
      return totalFromApi;
    }
    return _allComplaints.length;
  }

  int get newComplaints {
    return _allComplaints
        .where((complaint) => complaint.status.toLowerCase() == "new")
        .length;
  }

  int get resolvedComplaints {
    return _allComplaints
        .where((complaint) => complaint.status.toLowerCase() == "resolved")
        .length;
  }

  int get technicalComplaints {
    return _allComplaints
        .where((complaint) => complaint.type.toLowerCase() == "technical")
        .length;
  }

  @override
  void onInit() {
    super.onInit();
    getComplaints();
  }

  @override
  Future<void> getComplaints() async {
    complaintsStatusRequest = StatusRequest.loading;
    update();

    try {
      final value = await DioHelper.getDataa(url: "v1/driver/complaints");

      print("COMPLAINTS STATUS CODE => ${value?.statusCode}");
      print("COMPLAINTS RESPONSE => ${value?.data}");

      if (value != null && value.statusCode == 200) {
        final responseBody = value.data;

        if (responseBody is Map && responseBody["success"] == true) {
          final data = responseBody["data"];

          if (data is! Map) {
            _allComplaints.clear();
            filteredComplaints.clear();
            totalFromApi = 0;
            complaintsStatusRequest = StatusRequest.noData;
            update();
            return;
          }

          totalFromApi = int.tryParse(data["total"]?.toString() ?? "0") ?? 0;

          final items = data["items"];

          _allComplaints.clear();

          if (items is List) {
            _allComplaints.addAll(
              items
                  .whereType<Map>()
                  .map(
                    (item) => ComplaintModel.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList(),
            );
          }

          _applyFilterAndSearch();

          complaintsStatusRequest =
              _allComplaints.isEmpty
                  ? StatusRequest.noData
                  : StatusRequest.success;
        } else {
          _allComplaints.clear();
          filteredComplaints.clear();
          totalFromApi = 0;

          complaintsStatusRequest = StatusRequest.noData;

          Get.snackbar(
            "Error",
            responseBody is Map
                ? responseBody["message"]?.toString() ??
                    "Failed to load complaints"
                : "Failed to load complaints",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (value != null && value.statusCode == 401) {
        complaintsStatusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول، يرجى تسجيل الدخول مرة أخرى",
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppRoute.login);
        
      } else {
        complaintsStatusRequest = StatusRequest.serverfailure;

        Get.snackbar(
          "Error",
          "Failed to load complaints",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error, stackTrace) {
      print("COMPLAINTS ERROR => $error");
      print("COMPLAINTS STACKTRACE => $stackTrace");

      complaintsStatusRequest = StatusRequest.serverfailure;

      Get.snackbar(
        "Error",
        "حدث خطأ أثناء تحميل الشكاوى",
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update();
  }

  @override
  Future<void> refreshComplaints() async {
    await getComplaints();
  }

  @override
  void changeFilter(String filter) {
    selectedFilter = filter;
    _applyFilterAndSearch();
    update();
  }

  @override
  void searchComplaints(String value) {
    searchText = value.trim().toLowerCase();
    _applyFilterAndSearch();
    update();
  }

  void _applyFilterAndSearch() {
    List<ComplaintModel> result = List.from(_allComplaints);

    if (selectedFilter == "New" || selectedFilter == "Resolved") {
      result =
          result
              .where(
                (complaint) =>
                    complaint.status.toLowerCase() ==
                    selectedFilter.toLowerCase(),
              )
              .toList();
    } else if (selectedFilter == "Technical") {
      result =
          result
              .where(
                (complaint) =>
                    complaint.type.toLowerCase() ==
                    selectedFilter.toLowerCase(),
              )
              .toList();
    }

    if (searchText.isNotEmpty) {
      result =
          result.where((complaint) {
            return complaint.id.toLowerCase().contains(searchText) ||
                complaint.ticketId.toLowerCase().contains(searchText) ||
                complaint.description.toLowerCase().contains(searchText) ||
                complaint.status.toLowerCase().contains(searchText) ||
                complaint.type.toLowerCase().contains(searchText);
          }).toList();
    }

    filteredComplaints = result;
  }
}
