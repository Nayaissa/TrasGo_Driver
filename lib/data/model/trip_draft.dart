import 'package:google_maps_flutter/google_maps_flutter.dart';

enum TripAvailability { sharedOnly, privateOnly, both }
enum TripStatus { pending, active, completed, cancelled }

class TripDraft {
  final LatLng pickup;
  final LatLng destination;
  final List<LatLng> stops;
  final DateTime departureDateTime;
  final int availableSeats;
  final bool allowShared;
  final bool allowPrivate;
  final double sharedSeatPrice;
  final double? privateTripPrice;
  final String notes;
  final double suggestedPrice;
  final TripStatus status;

  TripDraft({
    required this.pickup,
    required this.destination,
    required this.stops,
    required this.departureDateTime,
    required this.availableSeats,
    required this.allowShared,
    required this.allowPrivate,
    required this.sharedSeatPrice,
    this.privateTripPrice,
    required this.notes,
    required this.suggestedPrice,
    required this.status,
  });
}