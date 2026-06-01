import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_project/controller/trips/trips_view_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class ActiveTripTrackingPage extends StatefulWidget {
  const ActiveTripTrackingPage({super.key});

  @override
  State<ActiveTripTrackingPage> createState() => _ActiveTripTrackingPageState();
}

class _ActiveTripTrackingPageState extends State<ActiveTripTrackingPage> {
  GoogleMapController? mapController;
  LatLng? lastCarPosition;

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _moveCameraToCar(LatLng position) {
    if (lastCarPosition == position) return;

    lastCarPosition = position;

    mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripsControllerImp>(
      builder: (controller) {
        final activeTripData = controller.activeTripData;
        final trackingData = controller.trackingData;

        if (activeTripData == null && trackingData == null) {
          return const Scaffold(
            body: Center(child: Text("No active trip data")),
          );
        }

        final int tripId =
            trackingData?["trip_id"] ?? activeTripData?["trip_id"];

        final Map<String, dynamic> details = Map<String, dynamic>.from(
          activeTripData?["trip_details"] ?? {},
        );

        final Map<String, dynamic> trip = Map<String, dynamic>.from(
          trackingData?["trip"] ?? {},
        );

        final Map<String, dynamic> tracking = Map<String, dynamic>.from(
          trackingData?["tracking"] ?? details["tracking"] ?? {},
        );

        final from = trip["from"] ?? details["departure_location"] ?? "";
        final to = trip["to"] ?? details["arrival_location"] ?? "";

        final markers = _buildMarkers(
          tracking: tracking,
          carIcon: controller.carMarkerIcon,
          currentDriverPosition: controller.currentDriverPosition,
        );

        final polylines = _buildPolylines(
          trackingData: trackingData,
          details: details,
        );

        final initialPosition = _initialPosition(
          tracking: tracking,
          details: details,
          currentDriverPosition: controller.currentDriverPosition,
        );

        final carPosition = _getCarPosition(
          tracking: tracking,
          currentDriverPosition: controller.currentDriverPosition,
        );

        if (carPosition != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _moveCameraToCar(carPosition);
          });
        }

        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: initialPosition,
                    zoom: 16,
                    bearing: 0,
                    tilt: 0,
                  ),
                  onMapCreated: (GoogleMapController googleMapController) {
                    mapController = googleMapController;

                    if (carPosition != null) {
                      _moveCameraToCar(carPosition);
                    }
                  },
                  markers: markers,
                  polylines: polylines,

                  // لا نخفي ماركر موقعك الحقيقي
                  myLocationEnabled: true,
                  myLocationButtonEnabled: true,

                  zoomControlsEnabled: false,
                  rotateGesturesEnabled: false,
                  tiltGesturesEnabled: false,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: _topHeader(tripId),
                ),
                Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: _bottomCard(
                    controller: controller,
                    tripId: tripId,
                    from: from.toString(),
                    to: to.toString(),
                    tracking: tracking,
                    currentDriverPosition: controller.currentDriverPosition,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  LatLng? _getCarPosition({
    required Map<String, dynamic> tracking,
    required Position? currentDriverPosition,
  }) {
    final lastPosition = tracking["last_position"];

    if (currentDriverPosition != null) {
      return LatLng(
        currentDriverPosition.latitude,
        currentDriverPosition.longitude,
      );
    }

    if (lastPosition != null &&
        lastPosition["latitude"] != null &&
        lastPosition["longitude"] != null) {
      final lat = double.tryParse(lastPosition["latitude"].toString());
      final lng = double.tryParse(lastPosition["longitude"].toString());

      if (lat != null && lng != null) {
        return LatLng(lat, lng);
      }
    }

    return null;
  }

  Set<Marker> _buildMarkers({
    required Map<String, dynamic> tracking,
    required BitmapDescriptor? carIcon,
    required Position? currentDriverPosition,
  }) {
    final Set<Marker> markers = {};

    final lastPosition = tracking["last_position"];

    double? carLat;
    double? carLng;
    double carHeading = 0;

    if (currentDriverPosition != null) {
      carLat = currentDriverPosition.latitude;
      carLng = currentDriverPosition.longitude;
      carHeading =
          currentDriverPosition.heading < 0 ? 0 : currentDriverPosition.heading;
    } else if (lastPosition != null &&
        lastPosition["latitude"] != null &&
        lastPosition["longitude"] != null) {
      carLat = double.tryParse(lastPosition["latitude"].toString());
      carLng = double.tryParse(lastPosition["longitude"].toString());
      carHeading =
          double.tryParse(lastPosition["heading"]?.toString() ?? "0") ?? 0;
    }

    if (carLat != null && carLng != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("driver_car"),
          position: LatLng(carLat, carLng),
          icon: carIcon ??
              BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen,
              ),
          anchor: const Offset(0.5, 1.0),
          flat: false,
          rotation: 0,
          zIndex: 10,
          infoWindow: const InfoWindow(title: "موقع السائق"),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines({
    required Map<String, dynamic>? trackingData,
    required Map<String, dynamic> details,
  }) {
    final Set<Polyline> polylines = {};

    final routePolyline =
        trackingData?["trip"]?["route_polyline"] ?? details["route_polyline"];

    if (routePolyline != null && routePolyline.toString().isNotEmpty) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId("route"),
          points: _decodePolyline(routePolyline.toString()),
          width: 5,
          color: AppColor.fourthColor,
        ),
      );
    }

    return polylines;
  }

  LatLng _initialPosition({
    required Map<String, dynamic> tracking,
    required Map<String, dynamic> details,
    required Position? currentDriverPosition,
  }) {
    if (currentDriverPosition != null) {
      return LatLng(
        currentDriverPosition.latitude,
        currentDriverPosition.longitude,
      );
    }

    final lastPosition = tracking["last_position"];

    if (lastPosition != null &&
        lastPosition["latitude"] != null &&
        lastPosition["longitude"] != null) {
      return LatLng(
        double.parse(lastPosition["latitude"].toString()),
        double.parse(lastPosition["longitude"].toString()),
      );
    }

    final routePoints = tracking["route"]?["points"] as List?;
    final startResponsePoints = details["points"] as List?;
    final points = routePoints ?? startResponsePoints;

    if (points != null && points.isNotEmpty) {
      final first = points.first;

      return LatLng(
        double.parse(first["latitude"].toString()),
        double.parse(first["longitude"].toString()),
      );
    }

    return const LatLng(33.5138, 36.2765);
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> points = [];
    int index = 0;
    int len = encoded.length;
    int lat = 0;
    int lng = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlng = ((result & 1) != 0) ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      points.add(LatLng(lat / 100000.0, lng / 100000.0));
    }

    return points;
  }

  Widget _topHeader(int tripId) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Get.back(),
            borderRadius: BorderRadius.circular(20),
            child: const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white12,
              child: Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "الرحلة الحالية",
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
                Text(
                  "Trip #$tripId",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
            ),
            child: const Row(
              children: [
                Icon(Icons.gps_fixed, color: Colors.greenAccent, size: 16),
                SizedBox(width: 5),
                Text(
                  "Live",
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomCard({
    required TripsControllerImp controller,
    required int tripId,
    required String from,
    required String to,
    required Map<String, dynamic> tracking,
    required Position? currentDriverPosition,
  }) {
    final isLoading =
        controller.tripActionStatusRequest == StatusRequest.loading;

    final lastPosition = tracking["last_position"];

    final speed = currentDriverPosition != null
        ? (currentDriverPosition.speed <= 0
            ? "--"
            : (currentDriverPosition.speed * 3.6).toStringAsFixed(2))
        : lastPosition?["speed_kmh"]?.toString() ?? "--";

    final hasLiveLocation =
        currentDriverPosition != null || tracking["has_live_location"] == true;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColor.secondaryColor.withOpacity(0.97),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 45,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Column(
                children: [
                  _dot(Colors.blueAccent),
                  Container(width: 2, height: 32, color: Colors.white24),
                  _dot(Colors.redAccent),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "من",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Text(
                      from,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "إلى",
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    Text(
                      to,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _infoBox(
                  icon: Icons.speed,
                  title: "السرعة",
                  value: speed == "--" ? "--" : "$speed km/h",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _infoBox(
                  icon: Icons.location_on,
                  title: "الموقع",
                  value: hasLiveLocation ? "مباشر" : "غير متاح",
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26),
                ),
              ),
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.stop_circle_outlined),
              label: const Text(
                "إنهاء الرحلة",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              onPressed: isLoading
                  ? null
                  : () {
                      controller.endTrip(tripId, fromTracking: true);
                    },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoBox({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColor.fourthColor, size: 22),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
                Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 11,
      height: 11,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}