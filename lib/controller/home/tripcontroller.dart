import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_project/data/model/trip_draft.dart';
import 'package:transport_project/view/widget/home/trip_created_sheet.dart';

class TripController extends GetxController {
  final int vehicleCapacity = 4;
  bool hasActiveTrip = false;

  final Completer<GoogleMapController> mapController = Completer();
  final Set<Marker> markers = <Marker>{};
  final Set<Polyline> polylines = <Polyline>{};

  static const LatLng initialMapCenter = LatLng(33.5138, 36.2765); // Damascus

  LatLng currentMapCenter = initialMapCenter;
  double initialZoom = 17.0;
  bool isGettingCurrentLocation = false;

  LatLng? pickup;
  LatLng? destination;
  final List<LatLng> stops = [];

  String selectionMode = 'pickup'; // pickup | destination | stop

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
          'صلاحية الموقع مرفوضة نهائيًا. فعّليها من إعدادات الهاتف.',
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

  void onMapTapped(LatLng point) {
    if (selectionMode == 'pickup') {
      pickup = point;
    } else if (selectionMode == 'destination') {
      destination = point;
    } else if (selectionMode == 'stop') {
      stops.add(point);
    }

    _buildMapObjects();
    _updateRouteMeta();

    update(['map', 'trip_points']);
    update(['pricing_section']);
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

    final routePoints = <LatLng>[
      if (pickup != null) pickup!,
      ...stops,
      if (destination != null) destination!,
    ];

    if (routePoints.length >= 2) {
      polylines.add(
        Polyline(
          polylineId: const PolylineId('trip_route'),
          points: routePoints,
          width: 5,
          color: const Color(0xFF111827),
        ),
      );
    }
  }

  void _updateRouteMeta() {
    final routePoints = <LatLng>[
      if (pickup != null) pickup!,
      ...stops,
      if (destination != null) destination!,
    ];

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
    _buildMapObjects();
    _updateRouteMeta();
    update(['map', 'trip_points']);
    update(['pricing_section']);
  }

  void clearAllPoints() {
    pickup = null;
    destination = null;
    stops.clear();
    polylines.clear();
    markers.clear();
    routeDistanceMiles = 0.0;
    routeDurationMinutes = 0;
    suggestedPrice = 45.0;
    selectionMode = 'pickup';

    update(['map', 'trip_points', 'pricing_section']);
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
      final minAllowed = suggestedPrice * 0.5;
      final maxAllowed = suggestedPrice;
      if (price < minAllowed || price > maxAllowed) {
        return 'سعر المقعد يجب أن يكون بين 50% و100% من السعر المقترح.';
      }
    }

    if (allowPrivate && privatePrice != null && privatePrice <= 0) {
      return 'سعر الرحلة الخاصة يجب أن يكون أكبر من صفر.';
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

    final draft = TripDraft(
      pickup: pickup!,
      destination: destination!,
      stops: stops,
      departureDateTime: departureDateTime,
      availableSeats: availableSeats,
      allowShared: allowShared,
      allowPrivate: allowPrivate,
      sharedSeatPrice: double.parse(priceController.text.trim()),
      privateTripPrice: privatePriceController.text.trim().isEmpty
          ? null
          : double.tryParse(privatePriceController.text.trim()),
      notes: notesController.text.trim(),
      suggestedPrice: suggestedPrice,
      status: TripStatus.pending,
    );

    hasActiveTrip = true;

    Get.bottomSheet(
      TripCreatedSheet(draft: draft),
      backgroundColor: const Color(0xFF0F172A),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    );
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
