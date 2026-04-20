import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/data/model/trip_draft.dart';
import 'package:transport_project/data/model/trip_preview_model.dart';
import 'package:transport_project/view/widget/home/trip_created_sheet.dart';

class TripController extends GetxController {
  final int vehicleCapacity = 10;
  bool hasActiveTrip = false;
  int currentStep = 0;

  final Completer<GoogleMapController> mapController = Completer();
  final Set<Marker> markers = <Marker>{};
  final Set<Polyline> polylines = <Polyline>{};

  static const LatLng initialMapCenter = LatLng(33.5138, 36.2765);

  LatLng currentMapCenter = initialMapCenter;
  double initialZoom = 17.0;
  bool isGettingCurrentLocation = false;

  LatLng? pickup;
  LatLng? destination;
  final List<LatLng> stops = [];
  final List<LatLng> backendRoutePoints = [];

  String selectionMode = 'pickup';

  double routeDistanceMiles = 0.0;
  int routeDurationMinutes = 0;
  double suggestedPrice = 45.0;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int availableSeats = 3;
  bool allowShared = true;
  bool allowPrivate = true;
  double sharedSeatPrice = 20.0;
  double? privateTripPrice;

  final notesController = TextEditingController();
  final priceController = TextEditingController(text: '20.00');
  final privatePriceController = TextEditingController();

  bool showTripDetails = false;

  StatusRequest? previewStatusRequest;
  TripPreviewModel? tripPreviewModel;

  StatusRequest? storeTripStatusRequest;
  Map<String, dynamic>? storeTripResponse;

  double systemCalculatedPrice = 0.0;
  double sharedMinPrice = 0.0;
  double sharedMaxPrice = 0.0;
  double privateMinPrice = 0.0;
  double privateMaxPrice = 0.0;

  String? startGovernorateName;
  String? endGovernorateName;

  @override
  void onInit() {
    super.onInit();
    _seedValidTime();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      initCurrentLocation();
    });
  }

  @override
  void onClose() {
    notesController.dispose();
    priceController.dispose();
    privatePriceController.dispose();
    super.onClose();
  }

  void _seedValidTime() {
    final now = DateTime.now();
    final roundedMinute = ((now.minute ~/ 5) + 1) * 5;
    final adjusted = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      roundedMinute >= 60 ? 0 : roundedMinute,
    );

    selectedDate = DateTime(adjusted.year, adjusted.month, adjusted.day);
    selectedTime = TimeOfDay(
      hour: roundedMinute >= 60 ? (now.hour + 1) % 24 : now.hour,
      minute: roundedMinute >= 60 ? 0 : roundedMinute,
    );
  }

  Future<void> onMapCreated(GoogleMapController googleController) async {
    if (!mapController.isCompleted) {
      mapController.complete(googleController);
    }
  }

  Future<void> initCurrentLocation() async {
    try {
      isGettingCurrentLocation = true;
      update(['map']);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        isGettingCurrentLocation = false;
        update(['map']);
        Get.snackbar(
          'تنبيه',
          'يرجى تشغيل خدمة الموقع GPS',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        isGettingCurrentLocation = false;
        update(['map']);
        Get.snackbar(
          'تنبيه',
          'تم رفض صلاحية الوصول إلى الموقع',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        isGettingCurrentLocation = false;
        update(['map']);
        Get.snackbar(
          'تنبيه',
          'صلاحية الموقع مرفوضة نهائيًا. فعّلها من إعدادات الهاتف.',
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
      );

      currentMapCenter = LatLng(position.latitude, position.longitude);
      initialZoom = 17.5;

      final googleController = await mapController.future;
      await googleController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: currentMapCenter,
            zoom: initialZoom,
            tilt: 0,
            bearing: 0,
          ),
        ),
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'تعذر جلب الموقع الحالي',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isGettingCurrentLocation = false;
      update(['map']);
    }
  }

  void setSelectionMode(String mode) {
    selectionMode = mode;
    update(['trip_points']);
  }

  bool get canContinueToDetails => pickup != null && destination != null;

  List<LatLng> get routePoints => <LatLng>[
        if (pickup != null) pickup!,
        ...stops,
        if (destination != null) destination!,
      ];

  List<LatLng> get displayedRoutePoints =>
      backendRoutePoints.length >= 2 ? backendRoutePoints : routePoints;

  Future<void> goToTripDetails() async {
    if (!canContinueToDetails) {
      Get.snackbar(
        'error_title'.tr,
        'trip_points_required'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    await previewTripRoute();

    if (previewStatusRequest == StatusRequest.success) {
      currentStep = 1;
      update(['trip_step', 'map', 'trip_points', 'pricing_section']);
    }
  }

  void backToRoutePlanner() {
    currentStep = 0;
    update(['trip_step', 'map', 'trip_points']);
  }

  void setBackendRoutePoints(List<LatLng> points) {
    backendRoutePoints
      ..clear()
      ..addAll(points);
    _buildMapObjects();
    update(['map']);
  }

  String formatPointLabel(LatLng? point, {String? emptyLabel}) {
    if (point == null) return emptyLabel ?? 'point_not_selected'.tr;
    return '${point.latitude.toStringAsFixed(4)}, ${point.longitude.toStringAsFixed(4)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String formatDepartureTime(DateTime dateTime) {
    return '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
        '${_twoDigits(dateTime.hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)}';
  }

  List<Map<String, dynamic>> buildPreviewPointsPayload() {
    final List<Map<String, dynamic>> points = [];

    if (pickup != null) {
      points.add({
        "point_type": "start",
        "latitude": pickup!.latitude,
        "longitude": pickup!.longitude,
        "note": "نقطة البداية",
      });
    }

    for (int i = 0; i < stops.length; i++) {
      points.add({
        "point_type": "stop",
        "latitude": stops[i].latitude,
        "longitude": stops[i].longitude,
        "note": "نقطة توقف ${i + 1}",
      });
    }

    if (destination != null) {
      points.add({
        "point_type": "end",
        "latitude": destination!.latitude,
        "longitude": destination!.longitude,
        "note": "نقطة النهاية",
      });
    }

    return points;
  }

  Map<String, dynamic> buildStoreTripPayload() {
    final sharedPrice = double.tryParse(priceController.text.trim());
    final privatePrice = double.tryParse(privatePriceController.text.trim());

    return {
      "departure_time": formatDepartureTime(departureDateTime),
      "total_seats": availableSeats,
      "allow_shared": allowShared,
      "allow_private": allowPrivate,
      if (allowShared) "shared_price": sharedPrice ?? 0.0,
      if (allowPrivate) "private_price": privatePrice ?? 0.0,
      "notes": notesController.text.trim(),
      "points": buildPreviewPointsPayload(),
    };
  }

  List<LatLng> decodePolyline(String encoded) {
    final List<LatLng> polylineCoordinates = [];
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

      final int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dLat;

      shift = 0;
      result = 0;

      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      final int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dLng;

      polylineCoordinates.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polylineCoordinates;
  }

  Future<void> previewTripRoute() async {
    if (pickup == null || destination == null) return;

    previewStatusRequest = StatusRequest.loading;
    update(['map', 'trip_points', 'pricing_section']);

    try {
      final value = await DioHelper.postsData(
        url: 'v1/driver/trips/preview',
        data: {
          "total_seats": availableSeats,
          "allow_shared": allowShared,
          "allow_private": allowPrivate,
          "points": buildPreviewPointsPayload(),
        },
      );

      if (value != null && value.statusCode == 200) {
        tripPreviewModel = TripPreviewModel.fromJson(value.data);
        final data = tripPreviewModel?.data;

        final polyline = data?.routePolyline;
        if (polyline != null && polyline.isNotEmpty) {
          backendRoutePoints
            ..clear()
            ..addAll(decodePolyline(polyline));
        } else {
          backendRoutePoints.clear();
        }

        final estimatedKm = data?.estimatedDistanceKm ?? 0.0;
        routeDistanceMiles = estimatedKm * 0.621371;
        routeDurationMinutes = data?.estimatedDurationMinutes ?? 0;

        systemCalculatedPrice = data?.systemCalculatedPrice ?? 0.0;
        suggestedPrice = systemCalculatedPrice > 0 ? systemCalculatedPrice : 45.0;

        sharedMinPrice = data?.sharedPriceRange?.min ?? 0.0;
        sharedMaxPrice = data?.sharedPriceRange?.max ?? 0.0;
        privateMinPrice = data?.privatePriceRange?.min ?? 0.0;
        privateMaxPrice = data?.privatePriceRange?.max ?? 0.0;

        startGovernorateName = data?.startGovernorate?.name;
        endGovernorateName = data?.endGovernorate?.name;

        if (allowShared && sharedMinPrice > 0) {
          priceController.text = sharedMinPrice.toStringAsFixed(2);
        }

        if (allowPrivate && privateMinPrice > 0) {
          privatePriceController.text = privateMinPrice.toStringAsFixed(2);
        }

        _buildMapObjects();
        previewStatusRequest = StatusRequest.success;
      } else {
        previewStatusRequest = StatusRequest.failure;
        Get.snackbar(
          'warning_title'.tr,
          tripPreviewModel?.message ?? 'تعذر معاينة الرحلة',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (error) {
      previewStatusRequest = StatusRequest.serverfailure;
      Get.snackbar(
        'error_title'.tr,
        'server_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
      );
    }

    update(['map', 'trip_points', 'pricing_section']);
  }

  void onMapTapped(LatLng point) {
    if (selectionMode == 'pickup') {
      pickup = point;
    } else if (selectionMode == 'destination') {
      destination = point;
    } else if (selectionMode == 'stop') {
      stops.add(point);
    }

    backendRoutePoints.clear();
    _buildMapObjects();
    _updateRouteMeta();

    update(['map', 'trip_points']);
    update(['pricing_section']);
    update(['trip_flow']);
  }

  void openTripDetails() {
    if (pickup != null && destination != null) {
      showTripDetails = true;
      update(['trip_flow']);
    }
  }

  void _buildMapObjects() {
    markers.clear();
    polylines.clear();

    if (pickup != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickup!,
          infoWindow: const InfoWindow(title: 'نقطة البداية'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        ),
      );
    }

    if (destination != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('destination'),
          position: destination!,
          infoWindow: const InfoWindow(title: 'نقطة النهاية'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    for (int i = 0; i < stops.length; i++) {
      markers.add(
        Marker(
          markerId: MarkerId('stop_$i'),
          position: stops[i],
          infoWindow: InfoWindow(title: 'نقطة توقف ${i + 1}'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueOrange,
          ),
        ),
      );
    }

    if (displayedRoutePoints.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('trip_route'),
          points: displayedRoutePoints,
          width: 6,
          color: const Color(0xFF6E88FF),
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
          jointType: JointType.round,
        ),
      );
    }
  }

  void _updateRouteMeta() {
    if (routePoints.length < 2) {
      routeDistanceMiles = 0.0;
      routeDurationMinutes = 0;
      suggestedPrice = 45.0;
      return;
    }

    double totalKm = 0.0;

    for (int i = 0; i < routePoints.length - 1; i++) {
      totalKm += _calculateDistanceKm(routePoints[i], routePoints[i + 1]);
    }

    routeDistanceMiles = totalKm * 0.621371;
    routeDurationMinutes = (totalKm / 40 * 60).round();
    suggestedPrice = (totalKm * 2.5).clamp(10.0, 200.0);
  }

  double _calculateDistanceKm(LatLng start, LatLng end) {
    const double earthRadius = 6371;

    final double dLat = _degToRad(end.latitude - start.latitude);
    final double dLng = _degToRad(end.longitude - start.longitude);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
            math.cos(_degToRad(start.latitude)) *
                math.cos(_degToRad(end.latitude)) *
                math.sin(dLng / 2) *
                math.sin(dLng / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degToRad(double deg) => deg * math.pi / 180.0;

  DateTime get departureDateTime => DateTime(
        selectedDate.year,
        selectedDate.month,
        selectedDate.day,
        selectedTime.hour,
        selectedTime.minute,
      );

  TripAvailability get availability {
    if (allowShared && allowPrivate) return TripAvailability.both;
    if (allowShared) return TripAvailability.sharedOnly;
    return TripAvailability.privateOnly;
  }

  void selectQuickDate(DateTime date) {
    selectedDate = DateTime(date.year, date.month, date.day);
    update(['date_section']);
  }

  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.isBefore(DateTime.now())
          ? DateTime.now()
          : selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF8B5CF6),
              surface: Color(0xFF0F172A),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate = DateTime(picked.year, picked.month, picked.day);
      update(['date_section']);
    }
  }

  Future<void> pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Color(0xFF0F172A),
              hourMinuteTextColor: Colors.white,
              dialHandColor: Color(0xFF8B5CF6),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedTime = picked;
      update(['time_section']);
    }
  }

  void incrementSeats() {
    if (availableSeats < vehicleCapacity) {
      availableSeats++;
      update(['seats_section']);
    }
  }

  void decrementSeats() {
    if (availableSeats > 1) {
      availableSeats--;
      update(['seats_section']);
    }
  }

  void toggleShared() {
    if (!allowShared && !allowPrivate) {
      allowShared = true;
    } else {
      allowShared = !allowShared;
      if (!allowShared && !allowPrivate) allowPrivate = true;
    }
    update(['trip_type', 'pricing_section']);
  }

  void togglePrivate() {
    if (!allowPrivate && !allowShared) {
      allowPrivate = true;
    } else {
      allowPrivate = !allowPrivate;
      if (!allowPrivate && !allowShared) allowShared = true;
    }
    update(['trip_type', 'pricing_section']);
  }

  void clearStops() {
    stops.clear();
    backendRoutePoints.clear();
    _buildMapObjects();
    _updateRouteMeta();

    systemCalculatedPrice = 0.0;
    sharedMinPrice = 0.0;
    sharedMaxPrice = 0.0;
    privateMinPrice = 0.0;
    privateMaxPrice = 0.0;

    update(['map', 'trip_points']);
    update(['pricing_section']);
  }

  void clearAllPoints() {
    pickup = null;
    destination = null;
    stops.clear();
    backendRoutePoints.clear();
    polylines.clear();
    markers.clear();
    routeDistanceMiles = 0.0;
    routeDurationMinutes = 0;
    suggestedPrice = 45.0;
    systemCalculatedPrice = 0.0;
    sharedMinPrice = 0.0;
    sharedMaxPrice = 0.0;
    privateMinPrice = 0.0;
    privateMaxPrice = 0.0;
    startGovernorateName = null;
    endGovernorateName = null;
    selectionMode = 'pickup';
    showTripDetails = false;
    currentStep = 0;
    previewStatusRequest = null;
    storeTripStatusRequest = null;
    priceController.text = '20.00';
    privatePriceController.clear();
    notesController.clear();

    update(['map', 'trip_points', 'pricing_section', 'trip_step', 'create_trip_button']);
    update(['trip_flow']);
  }

  String? validateTrip() {
    final now = DateTime.now();
    final price = double.tryParse(priceController.text.trim()) ?? 0.0;
    final privatePrice = privatePriceController.text.trim().isEmpty
        ? null
        : double.tryParse(privatePriceController.text.trim());

    if (pickup == null) {
      return 'يجب تحديد نقطة الانطلاق من الخريطة.';
    }

    if (destination == null) {
      return 'يجب تحديد نقطة الوصول من الخريطة.';
    }

    if (pickup == destination) {
      return 'يجب تحديد نقطة انطلاق ووصول مختلفتين.';
    }

    if (departureDateTime.isBefore(now)) {
      return 'لا يسمح بإنشاء رحلة بتاريخ أو وقت يسبق الوقت الحالي.';
    }

    if (hasActiveTrip) {
      return 'لا يسمح للسائق بإنشاء أكثر من رحلة نشطة في نفس الوقت.';
    }

    if (availableSeats > vehicleCapacity) {
      return 'عدد المقاعد يتجاوز سعة السيارة المسجلة في النظام.';
    }

    if (!allowShared && !allowPrivate) {
      return 'يجب تفعيل نوع رحلة واحد على الأقل.';
    }

    if (allowShared) {
      if (price <= 0) {
        return 'يجب إدخال سعر صالح للمقعد المشترك.';
      }

      if (sharedMinPrice > 0 &&
          sharedMaxPrice > 0 &&
          (price < sharedMinPrice || price > sharedMaxPrice)) {
        return 'سعر المقعد يجب أن يكون بين ${sharedMinPrice.toStringAsFixed(2)} و ${sharedMaxPrice.toStringAsFixed(2)}';
      }
    }

    if (allowPrivate) {
      if (privatePrice == null || privatePrice <= 0) {
        return 'يجب إدخال سعر صالح للرحلة الخاصة.';
      }

      if (privateMinPrice > 0 &&
          privateMaxPrice > 0 &&
          (privatePrice < privateMinPrice || privatePrice > privateMaxPrice)) {
        return 'سعر الرحلة الخاصة يجب أن يكون بين ${privateMinPrice.toStringAsFixed(2)} و ${privateMaxPrice.toStringAsFixed(2)}';
      }
    }

    return null;
  }

  Future<void> createTrip() async {
    final validationError = validateTrip();

    if (validationError != null) {
      Get.snackbar(
        'خطأ في التحقق',
        validationError,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    storeTripStatusRequest = StatusRequest.loading;
    update(['create_trip_button']);

    final requestBody = buildStoreTripPayload();

    try {
      final value = await DioHelper.postsData(
        url: 'v1/driver/trips',
        data: requestBody,
      );

      if (value == null) {
        storeTripStatusRequest = StatusRequest.failure;
        Get.snackbar(
          'خطأ',
          'لم يتم استلام رد من الخادم',
          snackPosition: SnackPosition.BOTTOM,
        );
        update(['create_trip_button']);
        return;
      }

      final Map<String, dynamic> responseMap =
          value.data is Map<String, dynamic>
              ? value.data as Map<String, dynamic>
              : <String, dynamic>{};

      storeTripResponse = responseMap;

      final bool isHttpOk = value.statusCode == 200 || value.statusCode == 201;
      final bool isSuccess =
          responseMap['success'] == null ? isHttpOk : responseMap['success'] == true;

      final String message =
          responseMap['message']?.toString() ?? 'تم إنشاء الرحلة بنجاح';

      if (isHttpOk && isSuccess) {
        hasActiveTrip = true;
        storeTripStatusRequest = StatusRequest.success;

        final draft = TripDraft(
          pickup: pickup!,
          destination: destination!,
          stops: stops,
          departureDateTime: departureDateTime,
          availableSeats: availableSeats,
          allowShared: allowShared,
          allowPrivate: allowPrivate,
          sharedSeatPrice: allowShared
              ? double.parse(priceController.text.trim())
              : 0.0,
          privateTripPrice: allowPrivate
              ? double.tryParse(privatePriceController.text.trim())
              : null,
          notes: notesController.text.trim(),
          suggestedPrice: suggestedPrice,
          status: TripStatus.pending,
        );

        Get.snackbar(
          'نجاح',
          message,
          snackPosition: SnackPosition.BOTTOM,
        //  backgroundColor: Colors.green.shade700,
          colorText: Colors.white,
        );

        Get.bottomSheet(
          TripCreatedSheet(draft: draft),
          backgroundColor: const Color(0xFF0F172A),
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
        );
      } else {
        storeTripStatusRequest = StatusRequest.failure;

        Get.snackbar(
          'تنبيه',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
        );
      }
    } catch (error) {
      storeTripStatusRequest = StatusRequest.serverfailure;

      Get.snackbar(
        'خطأ',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
    }

    update(['create_trip_button']);
  }

  void onPrivateTripBooked() {
    allowPrivate = false;
    allowShared = true;
    update(['trip_type', 'pricing_section']);
  }

  void onSharedSeatBooked({required int remainingSeats}) {
    availableSeats = remainingSeats;
    if (remainingSeats <= 0) {
      allowShared = false;
      allowPrivate = true;
    }
    update(['seats_section', 'trip_type']);
  }
}