import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';

class TopMapCard extends StatelessWidget {
  const TopMapCard({
    super.key,
    required this.controller,
    required this.title,
    required this.subtitle,
    this.showBackButton = false,
    this.onBackPressed,
    this.showSummaryPill = true,
    this.heightFactor = 0.38,
  });

  final TripController controller;
  final String title;
  final String subtitle;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final bool showSummaryPill;
  final double heightFactor;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * heightFactor,
      margin: const EdgeInsets.fromLTRB(14, 14, 14, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.currentMapCenter,
                zoom: controller.initialZoom,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
              trafficEnabled: false,
              buildingsEnabled: false,
              indoorViewEnabled: false,
              tiltGesturesEnabled: true,
              rotateGesturesEnabled: true,
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              markers: controller.markers,
              polylines: controller.polylines,
              onTap: controller.onMapTapped,
              onMapCreated: controller.onMapCreated,
            ),
            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xCC081225),
                      Colors.transparent,
                      const Color(0xF2081225),
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                children: [
                  if (showBackButton)
                    _OverlayCircleButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: onBackPressed,
                    )
                  else
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6E88FF), Color(0xFFB889FF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.alt_route_rounded,
                        color: Colors.white,
                      ),
                    ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _OverlayCircleButton(
                    icon: Icons.my_location_rounded,
                    onTap: controller.initCurrentLocation,
                  ),
                ],
              ),
            ),
            if (showSummaryPill)
              Positioned(
                left: 16,
                right: 16,
                bottom: 18,
                child: _MapSummaryPill(controller: controller),
              ),
            if (controller.isGettingCurrentLocation)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}

class _OverlayCircleButton extends StatelessWidget {
  const _OverlayCircleButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xCC0E1D3E),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class _MapSummaryPill extends StatelessWidget {
  const _MapSummaryPill({required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    final bool isReady = controller.canContinueToDetails;
    final String text = !isReady
        ? 'map_pick_points_hint'.tr
        : '${controller.routeDistanceMiles.toStringAsFixed(1)} ${'miles_label'.tr} • ${controller.routeDurationMinutes} ${'mins_label'.tr}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xE6121E3C),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x3398AEFF)),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isReady
                  ? const Color(0x336E88FF)
                  : const Color(0x33FAAE7B),
            ),
            child: Icon(
              isReady ? Icons.route_rounded : Icons.touch_app_rounded,
              color: isReady ? const Color(0xFF8DA2FF) : const Color(0xFFFAAE7B),
              size: 18,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
