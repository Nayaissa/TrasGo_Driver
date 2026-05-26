import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';

abstract class TripsDetails extends GetxController {
  getTripDetails();
}

class TripsDetailsImp extends TripsDetails {
  StatusRequest? statusRequest;

  int activeTab = 0;
  int? tripId;

  Map<String, dynamic>? tripData;
  Map<String, dynamic>? tripDetails;

  void changeTab(int index) {
    activeTab = index;
    update();
  }

  @override
  void onInit() {
    tripId = Get.arguments?["trip_id"];
    getTripDetails();
    super.onInit();
  }

  @override
  getTripDetails() {
    statusRequest = StatusRequest.loading;
    update();

    if (tripId == null) {
      statusRequest = StatusRequest.noData;
      update();
      return;
    }

    DioHelper.getDataa(url: 'v1/driver/trips/$tripId').then((value) {
      if (value != null && value.statusCode == 200) {
        tripData = value.data["data"];
        tripDetails = tripData?["trip_details"];
        statusRequest = StatusRequest.success;
      } else {
        statusRequest = StatusRequest.noData;
      }

      update();
    }).catchError((error) {
      print("TRIP DETAILS ERROR => $error");
      statusRequest = StatusRequest.serverfailure;
      update();
    });
  }

  String formatTime(String? date) {
    if (date == null) return "--";

    try {
      return DateFormat('hh:mm a').format(DateTime.parse(date).toLocal());
    } catch (_) {
      return date;
    }
  }

  String formatDate(String? date) {
    if (date == null) return "--";

    try {
      return DateFormat('EEE, MMM d • hh:mm a')
          .format(DateTime.parse(date).toLocal());
    } catch (_) {
      return date;
    }
  }

  String get departureLocation =>
      tripDetails?["departure_location"]?.toString() ?? "";

  String get arrivalLocation =>
      tripDetails?["arrival_location"]?.toString() ?? "";

  String get departureTime =>
      formatTime(tripDetails?["departure_time"]?.toString());

  String get arrivalTime =>
      formatTime(tripDetails?["expected_arrival_time"]?.toString());

  String get departureDate =>
      formatDate(tripDetails?["departure_time"]?.toString());

  num get sharedPrice => tripDetails?["shared_price"] ?? 0;

  num get privatePrice => tripDetails?["private_price"] ?? 0;

  int get remainingSeats {
    final value = tripDetails?["remaining_seats"];
    if (value == null) return 0;
    return int.tryParse(value.toString()) ?? 0;
  }

  String get tripType => tripDetails?["trip_type"]?.toString() ?? "";

  bool get isTrackingActive =>
      tripDetails?["tracking"]?["is_tracking_active"] ?? false;

  String get vehicleType =>
      tripDetails?["vehicle"]?["type"]?.toString() ?? "";

  String get vehicleModel =>
      tripDetails?["vehicle"]?["model"]?.toString() ?? "No model";

  String get vehicleImage {
    final image = tripDetails?["vehicle"]?["image"];
    if (image == null || image.toString().isEmpty) return "";

    return "http://10.0.2.2:8000/$image";
  }

  List get points => tripDetails?["points"] ?? [];

  String get routePolyline =>
      tripDetails?["route_polyline"]?.toString() ?? "";

  Set<Marker> get mapMarkers {
    final Set<Marker> result = {};

    for (var point in points) {
      final lat = point["latitude"];
      final lng = point["longitude"];

      if (lat == null || lng == null) continue;

      final type = point["type"]?.toString() ?? "";

      result.add(
        Marker(
          markerId: MarkerId(point["point_id"].toString()),
          position: LatLng(
            double.parse(lat.toString()),
            double.parse(lng.toString()),
          ),
          infoWindow: InfoWindow(
            title: type == "start" ? "Start" : "End",
            snippet: point["address"]?.toString() ?? "",
          ),
        ),
      );
    }

    return result;
  }

  List<LatLng> decodePolyline(String encoded) {
    List<LatLng> decodedPoints = [];

    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dLng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      decodedPoints.add(
        LatLng(lat / 1E5, lng / 1E5),
      );
    }

    return decodedPoints;
  }

  Set<Polyline> get mapPolylines {
    if (routePolyline.isNotEmpty) {
      final decodedRoutePoints = decodePolyline(routePolyline);

      if (decodedRoutePoints.isNotEmpty) {
        return {
          Polyline(
            polylineId: const PolylineId("trip_route"),
            width: 5,
            color: Colors.blueAccent,
            points: decodedRoutePoints,
          ),
        };
      }
    }

    final validPoints = points.where((point) {
      return point["latitude"] != null && point["longitude"] != null;
    }).toList();

    if (validPoints.length < 2) return {};

    return {
      Polyline(
        polylineId: const PolylineId("trip_route"),
        width: 5,
        color: Colors.blueAccent,
        points: validPoints.map((point) {
          return LatLng(
            double.parse(point["latitude"].toString()),
            double.parse(point["longitude"].toString()),
          );
        }).toList(),
      ),
    };
  }

  CameraPosition get initialCameraPosition {
    if (routePolyline.isNotEmpty) {
      final decodedRoutePoints = decodePolyline(routePolyline);

      if (decodedRoutePoints.isNotEmpty) {
        return CameraPosition(
          target: decodedRoutePoints.first,
          zoom: 8,
        );
      }
    }

    if (points.isNotEmpty &&
        points.first["latitude"] != null &&
        points.first["longitude"] != null) {
      return CameraPosition(
        target: LatLng(
          double.parse(points.first["latitude"].toString()),
          double.parse(points.first["longitude"].toString()),
        ),
        zoom: 8,
      );
    }

    return const CameraPosition(
      target: LatLng(33.5138, 36.3481),
      zoom: 8,
    );
  }
}