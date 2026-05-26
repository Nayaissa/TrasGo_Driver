import 'package:get/get.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/data/model/attendance_model%20.dart';

class RideController extends GetxController {
  RideController({required this.tripId});

  final int tripId;

  StatusRequest? attendanceRequest;
  AttendanceModel? attendanceModel;

  List<AttendanceItem> get passengers => attendanceModel?.data?.items ?? [];

  @override
  void onInit() {
    getAttendance();
    super.onInit();
  }

  Future<void> getAttendance() async {
    attendanceRequest = StatusRequest.loading;
    update();

    try {
      final response = await DioHelper.getDataa(
        url: 'v1/driver/trips/$tripId/attendance',
      );

      if (response != null && response.statusCode == 200) {
        attendanceModel = AttendanceModel.fromJson(response.data);

        final items = attendanceModel?.data?.items ?? [];

        attendanceRequest =
            items.isEmpty ? StatusRequest.noData : StatusRequest.success;
      } else {
        attendanceRequest = StatusRequest.noData;
      }
    } catch (e) {
      print("ATTENDANCE ERROR => $e");
      attendanceRequest = StatusRequest.serverfailure;
    }

    update();
  }

  Future<void> setAttendance(int index, bool isPresent) async {
    final item = passengers[index];

    if (item.bookingId == null) return;

    final oldStatusKey = item.attendanceStatusKey;
    final oldStatus = item.attendanceStatus;

    final newStatusKey = isPresent ? "present" : "absent";
    final newStatusName = isPresent ? "حاضر" : "غائب";

    item.attendanceStatusKey = newStatusKey;
    item.attendanceStatus = newStatusName;
    update();

    try {
      final response = await DioHelper.patchData(
        url: 'v1/driver/bookings/${item.bookingId}/attendance',
        data: {
          "attendance_status": newStatusKey,
          "notes": isPresent ? "حضر في الوقت المحدد" : "لم يحضر في الوقت المحدد",
        },
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data['data'];
        final attendance = data?['booking']?['attendance_status'];

        item.attendanceStatusKey = attendance?['key'] ?? newStatusKey;
        item.attendanceStatus = attendance?['name'] ?? newStatusName;

        update();

        Get.snackbar(
          "تم",
          response.data['message'] ?? "تم تحديث حالة الحضور بنجاح",
        );
      } else {
        item.attendanceStatusKey = oldStatusKey;
        item.attendanceStatus = oldStatus;
        update();

        Get.snackbar("خطأ", "لم يتم تحديث حالة الحضور");
      }
    } catch (e) {
      print("SET ATTENDANCE ERROR => $e");

      item.attendanceStatusKey = oldStatusKey;
      item.attendanceStatus = oldStatus;
      update();

      Get.snackbar("خطأ", "حدث خطأ أثناء تحديث حالة الحضور");
    }
  }
}