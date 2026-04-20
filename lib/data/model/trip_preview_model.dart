class TripPreviewModel {
  final bool? success;
  final String? message;
  final TripPreviewData? data;
  final int? statusCode;
  final String? timestamp;

  TripPreviewModel({
    this.success,
    this.message,
    this.data,
    this.statusCode,
    this.timestamp,
  });

  factory TripPreviewModel.fromJson(Map<String, dynamic> json) {
    return TripPreviewModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? TripPreviewData.fromJson(json['data']) : null,
      statusCode: json['status_code'],
      timestamp: json['timestamp'],
    );
  }
}

class TripPreviewData {
  final double? estimatedDistanceKm;
  final int? estimatedDurationMinutes;
  final String? routePolyline;
  final double? systemCalculatedPrice;
  final PriceRange? sharedPriceRange;
  final PriceRange? privatePriceRange;
  final GovernorateModel? startGovernorate;
  final GovernorateModel? endGovernorate;
  final List<OrderedPointModel> orderedPoints;

  TripPreviewData({
    this.estimatedDistanceKm,
    this.estimatedDurationMinutes,
    this.routePolyline,
    this.systemCalculatedPrice,
    this.sharedPriceRange,
    this.privatePriceRange,
    this.startGovernorate,
    this.endGovernorate,
    required this.orderedPoints,
  });

  factory TripPreviewData.fromJson(Map<String, dynamic> json) {
    return TripPreviewData(
      estimatedDistanceKm: (json['estimated_distance_km'] as num?)?.toDouble(),
      estimatedDurationMinutes: json['estimated_duration_minutes'],
      routePolyline: json['route_polyline'],
      systemCalculatedPrice:
          (json['system_calculated_price'] as num?)?.toDouble(),
      sharedPriceRange: json['shared_price_range'] != null
          ? PriceRange.fromJson(json['shared_price_range'])
          : null,
      privatePriceRange: json['private_price_range'] != null
          ? PriceRange.fromJson(json['private_price_range'])
          : null,
      startGovernorate: json['start_governorate'] != null
          ? GovernorateModel.fromJson(json['start_governorate'])
          : null,
      endGovernorate: json['end_governorate'] != null
          ? GovernorateModel.fromJson(json['end_governorate'])
          : null,
      orderedPoints: (json['ordered_points'] as List<dynamic>?)
              ?.map((e) => OrderedPointModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class PriceRange {
  final double? min;
  final double? max;

  PriceRange({
    this.min,
    this.max,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) {
    return PriceRange(
      min: (json['min'] as num?)?.toDouble(),
      max: (json['max'] as num?)?.toDouble(),
    );
  }
}

class GovernorateModel {
  final int? governorateId;
  final String? name;
  final bool? isActive;
  final String? createdAt;

  GovernorateModel({
    this.governorateId,
    this.name,
    this.isActive,
    this.createdAt,
  });

  factory GovernorateModel.fromJson(Map<String, dynamic> json) {
    return GovernorateModel(
      governorateId: json['governorate_id'],
      name: json['name'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
    );
  }
}

class OrderedPointModel {
  final String? pointType;
  final double? latitude;
  final double? longitude;
  final String? note;
  final int? sequenceOrder;
  final String? address;

  OrderedPointModel({
    this.pointType,
    this.latitude,
    this.longitude,
    this.note,
    this.sequenceOrder,
    this.address,
  });

  factory OrderedPointModel.fromJson(Map<String, dynamic> json) {
    return OrderedPointModel(
      pointType: json['point_type'],
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      note: json['note'],
      sequenceOrder: json['sequence_order'],
      address: json['address'],
    );
  }
}