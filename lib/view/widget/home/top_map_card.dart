import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';

class TopMapCard extends StatelessWidget {
  const TopMapCard({super.key, required this.controller});

  final TripController controller;

  @override
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.38,
      margin: const EdgeInsets.fromLTRB(10, 10, 10, 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 25,
            offset: Offset(0, 15),
          ),
        ],
      ),

      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: controller.currentMapCenter,
                zoom: controller.initialZoom,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: true,
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

            if (controller.isGettingCurrentLocation)
              const Center(child: CircularProgressIndicator()),

            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(.35),
                      Colors.transparent,
                      Colors.black.withOpacity(.55),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: IgnorePointer(
                child: Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFFAAE7B),
                      ),
                      alignment: Alignment.center,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'تفاصيل الرحلة',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),

                    const Spacer(),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.14),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.notifications_none,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              left: 16,
              bottom: 18,
              child: IgnorePointer(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1A38).withOpacity(.9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.navigation,
                        color: Color(0xFF77A8FF),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        controller.pickup == null &&
                                controller.destination == null
                            ? 'حدد نقطة البداية من الخريطة'
                            : controller.destination == null
                            ? 'حدد نقطة النهاية من الخريطة'
                            : '${controller.routeDistanceMiles.toStringAsFixed(1)} MILES  •  ${controller.routeDurationMinutes} MINS',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
