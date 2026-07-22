import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/data/model/tab_model.dart';
import 'package:transport_project/view/screen/trips/active_trip_tracking_page.dart';

abstract class TripsController extends GetxController {
  getTabs();
  getTripsByStatus(String status);

  goToDetailsPage(int tripId);
  goToBookingsPage(Map<String, dynamic> trip);
  startTrip(int tripId);
  endTrip(int tripId, {bool fromTracking = false});
}

class TripsControllerImp extends TripsController {
  final box = GetStorage();

  StatusRequest? getTabStatusRequest;
  StatusRequest? tripActionStatusRequest;

  TabModel? tabModel;

  int selectedTab = 0;
  String selectedStatus = "";

  List<Map<String, dynamic>> trips = [];

  int? activeTripId;
  Map<String, dynamic>? activeTripData;
  Map<String, dynamic>? trackingData;

  Position? currentDriverPosition;

  Timer? trackingTimer;
  Timer? locationTimer;

  BitmapDescriptor? carMarkerIcon;

  @override
  void onInit() {
    box.remove("active_trip_id");

    loadCarMarker();
    getTabs();
    checkActiveTripOnStart();
    super.onInit();
  }

  @override
  void onClose() {
    stopLiveTracking();
    super.onClose();
  }

  void checkActiveTripOnStart() {
    final savedTripId = box.read("active_trip_id");

    if (savedTripId != null) {
      activeTripId = int.parse(savedTripId.toString());

      getTrackingData(activeTripId!);
      startLiveTracking(activeTripId!);

      Future.delayed(const Duration(milliseconds: 500), () {
        Get.offAll(() => const ActiveTripTrackingPage());
      });
    }
  }

  Future<void> loadCarMarker() async {
    try {
      final ByteData data = await rootBundle.load(
        "assets/images/car_marker.png",
      );

      final ui.Codec codec = await ui.instantiateImageCodec(
        data.buffer.asUint8List(),
        targetWidth: 90,
      );

      final ui.FrameInfo fi = await codec.getNextFrame();

      final ByteData? byteData = await fi.image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      carMarkerIcon = BitmapDescriptor.fromBytes(
        byteData!.buffer.asUint8List(),
      );

      update();
    } catch (e) {
      print("CAR MARKER ERROR => $e");
    }
  }

  @override
  getTabs() {
    getTabStatusRequest = StatusRequest.loading;
    update();

    DioHelper.getDataa(url: 'v1/trip-statuses')
        .then((value) {
          if (value != null && value.statusCode == 200) {
            tabModel = TabModel.fromJson(value.data);

            if (tabModel?.data?.items == null ||
                tabModel!.data!.items!.isEmpty) {
              getTabStatusRequest = StatusRequest.noData;
            } else {
              getTabStatusRequest = StatusRequest.success;

              final firstKey = tabModel!.data!.items![selectedTab].key!;
              selectedStatus = firstKey;

              getTripsByStatus(firstKey);
            }
          } else {
            getTabStatusRequest = StatusRequest.noData;
          }

          update();
        })
        .catchError((error) {
          print(error.toString());
          getTabStatusRequest = StatusRequest.serverfailure;
          update();
        });
  }

  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('EEE, MMM d • hh:mm a').format(parsedDate.toLocal());
    } catch (e) {
      return date;
    }
  }

  @override
  void getTripsByStatus(String status) {
    selectedStatus = status;

    getTabStatusRequest = StatusRequest.loading;
    update();

    final endpointStatus = status == "active" ? "current" : status;
    final endpoint = "v1/driver/trips/$endpointStatus";

    DioHelper.getDataa(url: endpoint)
        .then((value) {
          if (value != null && value.statusCode == 200) {
            final items = value.data["data"]["items"];

            if (items == null || items.isEmpty) {
              trips = [];
              getTabStatusRequest = StatusRequest.noData;
            } else {
              trips = List<Map<String, dynamic>>.from(
                items.map((trip) {
                  final card = trip["card"];

                  return {
                    "trip_id": trip["trip_id"],
                    "status": status,
                    "title": "Trip #${trip["trip_id"]}",
                    "price": card["shared_price"] ?? 0,
                    "date": formatDate(card["departure_time"] ?? ""),
                    "departure_time": card["departure_time"] ?? "",
                    "from": card["departure_location"] ?? "",
                    "to": card["arrival_location"] ?? "",
                    "image":
                        card["vehicle_image"] == null
                            ? ""
                            : "https://alkhader.softup.agency/api/${card["vehicle_image"]}",
                    "type": trip["classification"]?["name"] ?? "",
                  };
                }),
              );

              getTabStatusRequest = StatusRequest.success;
            }
          } else {
            getTabStatusRequest = StatusRequest.noData;

        Get.snackbar(
          "Error",
          "انتهت صلاحية تسجيل الدخول",
          snackPosition: SnackPosition.BOTTOM,
        );
      }

          update();
        })
        .catchError((error) {
          print("ERROR => $error");
          getTabStatusRequest = StatusRequest.serverfailure;
          update();
        });
  }

  void changeTab(int index) {
    selectedTab = index;
    final key = tabModel!.data!.items![index].key!;
    selectedStatus = key;
    getTripsByStatus(key);
    update();
  }

  @override
  void goToDetailsPage(int tripId) {
    Get.toNamed(AppRoute.detailsTrip, arguments: {"trip_id": tripId});
  }

  @override
  void goToBookingsPage(Map<String, dynamic> trip) {
    Get.toNamed(
      AppRoute.bookingsTrip,
      arguments: {
        "trip_id": trip["trip_id"],
        "from": trip["from"],
        "to": trip["to"],
        "departure_time": trip["departure_time"],
      },
    );
  }

  @override
  void startTrip(int tripId) {
    tripActionStatusRequest = StatusRequest.loading;
    update();

    DioHelper.postsData(url: "v1/driver/trips/$tripId/start", data: {})
        .then((value) {
          print("START STATUS => ${value?.statusCode}");
          print("START RESPONSE => ${value?.data}");

          if (value != null && value.data["success"] == true) {
            activeTripId = tripId;
            box.write("active_trip_id", tripId);

            activeTripData = value.data["data"];
            trackingData = null;

            selectedStatus = "current";
            tripActionStatusRequest = StatusRequest.success;
            update();

            startLiveTracking(tripId);

            Get.to(() => const ActiveTripTrackingPage());

            Get.snackbar(
              "Success",
              value.data["message"] ?? "تم بدء الرحلة بنجاح",
              snackPosition: SnackPosition.BOTTOM,
            );
          } else {
            tripActionStatusRequest = StatusRequest.success;
            update();

            Get.snackbar(
              "Error",
              value?.data["message"] ?? "فشل بدء الرحلة",
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        })
        .catchError((error) {
          print("START TRIP ERROR => $error");

          tripActionStatusRequest = StatusRequest.serverfailure;
          update();

          Get.snackbar(
            "Error",
            "حدث خطأ أثناء بدء الرحلة",
            snackPosition: SnackPosition.BOTTOM,
          );
        });
  }

  @override
  void endTrip(int tripId, {bool fromTracking = false}) async {
    tripActionStatusRequest = StatusRequest.loading;
    update();

    try {
      final value = await DioHelper.postsData(
        url: "v1/driver/trips/$tripId/complete",
        data: {"notes": "وصلنا إلى نقطة النهاية"},
      );

      print("END STATUS => ${value?.statusCode}");
      print("END RESPONSE => ${value?.data}");

      if (value != null && value.data["success"] == true) {
        stopLiveTracking();
        box.remove("active_trip_id");

        if (fromTracking) {
          Get.back();
        }

        activeTripId = null;
        activeTripData = null;
        trackingData = null;
        currentDriverPosition = null;

        selectedStatus = "completed";
        tripActionStatusRequest = StatusRequest.success;

        getTripsByStatus("completed");

        update();

        Get.snackbar(
          "Success",
          value.data["message"] ?? "تم إنهاء الرحلة بنجاح",
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        tripActionStatusRequest = StatusRequest.success;
        update();

        Get.snackbar(
          "Error",
          value?.data["message"] ?? "فشل إنهاء الرحلة",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      print("END TRIP ERROR => $error");

      tripActionStatusRequest = StatusRequest.serverfailure;
      update();

      Get.snackbar(
        "Error",
        "حدث خطأ أثناء إنهاء الرحلة",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void startLiveTracking(int tripId) {
    activeTripId = tripId;

    stopLiveTracking();

    sendDriverLocation(tripId);
    getTrackingData(tripId);

    trackingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      getTrackingData(tripId);
    });

    locationTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      sendDriverLocation(tripId);
    });
  }

  void stopLiveTracking() {
    trackingTimer?.cancel();
    locationTimer?.cancel();

    trackingTimer = null;
    locationTimer = null;
  }

  Future<void> sendDriverLocation(int tripId) async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        Get.snackbar(
          "Location",
          "الرجاء تفعيل خدمة الموقع",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Get.snackbar(
          "Location",
          "لم يتم منح صلاحية الموقع",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentDriverPosition = position;
      update();

      final Map<String, dynamic> data = {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "accuracy_meters": position.accuracy,
        "recorded_at": DateTime.now().toIso8601String(),
      };

      if (position.speed > 0) {
        data["speed_kmh"] = position.speed * 3.6;
      }

      if (position.heading >= 0) {
        data["heading"] = position.heading;
      }

      DioHelper.postsData(url: "v1/driver/trips/$tripId/location", data: data)
          .then((value) {
            print("LOCATION STATUS => ${value?.statusCode}");
            print("LOCATION RESPONSE => ${value?.data}");

            if (value != null && value.data["success"] == true) {
              getTrackingData(tripId);
            }
          })
          .catchError((error) {
            print("LOCATION ERROR => $error");
          });
    } catch (e) {
      print("LOCATION EXCEPTION => $e");
    }
  }

  void getTrackingData(int tripId) {
    DioHelper.getDataa(url: "v1/driver/trips/$tripId/tracking?history_limit=50")
        .then((value) {
          print("TRACKING STATUS => ${value?.statusCode}");
          print("TRACKING RESPONSE => ${value?.data}");

          if (value != null && value.data["success"] == true) {
            trackingData = value.data["data"];
            update();
          }
        })
        .catchError((error) {
          print("TRACKING ERROR => $error");
        });
  }
}
