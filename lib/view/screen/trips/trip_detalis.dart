import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/trips/bookings_details_controller.dart';
import 'package:transport_project/controller/trips/trip_detalis_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/data/model/attendance_model%20.dart';
import 'package:transport_project/view/widget/trips/custom_appar.dart';
import 'package:transport_project/view/widget/trips/imagePlaceholder.dart';
import 'package:transport_project/view/widget/trips/title_section.dart';
import 'package:transport_project/view/widget/trips/trip_map_detalis.dart';

class DetailsTrip extends StatelessWidget {
  const DetailsTrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: GetBuilder<TripsDetailsImp>(
        init: TripsDetailsImp(),
        builder: (controller) {
          if (controller.statusRequest == StatusRequest.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          final int tripId = controller.tripId ?? 0;

          if (!Get.isRegistered<RideController>()) {
            Get.put(RideController(tripId: tripId));
          }

          return SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: CustomAppbar(),
                ),

                const SizedBox(height: 10),

                TripDetailsMapCard(
                  title: "ACTIVE ROUTE",
                  subtitle:
                      "${controller.departureLocation} → ${controller.arrivalLocation}",
                  initialCameraPosition: controller.initialCameraPosition,
                  markers: controller.mapMarkers,
                  polylines: controller.mapPolylines,
                  heightFactor: 0.34,
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      const SizedBox(height: 15),

                      const TitleSection(
                        subTitle: "Trip Details",
                        title: "",
                      ),

                      const SizedBox(height: 15),

                      _buildTabSwitcher(controller),

                      const SizedBox(height: 20),

                      controller.activeTab == 0
                          ? Column(
                              children: [
                                _journeyTimeline(controller),
                                _routeStrategy(controller),
                                _occupancy(controller),
                                _tracking(controller),
                                _vehicleSpecs(controller),
                              ],
                            )
                          : GetBuilder<RideController>(
                              builder: (attendanceController) {
                                return _attendanceSection(
                                  attendanceController,
                                );
                              },
                            ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTabSwitcher(TripsDetailsImp controller) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          _buildTabItem(
            title: "Trip Details",
            index: 0,
            controller: controller,
          ),
          _buildTabItem(
            title: "Attendance",
            index: 1,
            controller: controller,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required String title,
    required int index,
    required TripsDetailsImp controller,
  }) {
    final bool isSelected = controller.activeTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color(0xFF4285F4),
                      Color(0xFF9575CD),
                    ],
                  )
                : null,
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _journeyTimeline(TripsDetailsImp controller) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel("JOURNEY TIMELINE"),
          const SizedBox(height: 15),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TimeNode(time: controller.departureTime, label: "DEPARTURE"),
              Container(width: 40, height: 1, color: Colors.grey[800]),
              TimeNode(time: controller.arrivalTime, label: "ARRIVAL"),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            controller.departureDate,
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          const SectionLabel("PRICES"),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "\$${controller.sharedPrice}",
                style: const TextStyle(
                  color: AppColor.thirdColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "\$${controller.privatePrice} private",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _routeStrategy(TripsDetailsImp controller) {
    final points = controller.points;

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const TitleText("Route Strategy"),
          const SizedBox(height: 20),

          if (points.isEmpty)
            const Text(
              "No route points",
              style: TextStyle(color: Colors.grey),
            )
          else
            ...points.map((point) {
              final isStart = point["type"] == "start";

              return RoutePointItem(
                title: point["address"] ?? "",
                sub: point["note"] ?? "",
                isStart: isStart,
              );
            }),
        ],
      ),
    );
  }

  Widget _occupancy(TripsDetailsImp controller) {
    return GlassCard(
      child: Row(
        children: [
          SeatIndicator(seats: controller.remainingSeats),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${controller.remainingSeats} Seats Left",
                style: const TextStyle(color: Colors.white),
              ),
              Text(
                controller.tripType,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tracking(TripsDetailsImp controller) {
    return GlassCard(
      child: Row(
        children: [
          Icon(
            controller.isTrackingActive
                ? Icons.location_on
                : Icons.location_off,
            color:
                controller.isTrackingActive ? Colors.greenAccent : Colors.grey,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionLabel("TRACKING"),
              Text(
                controller.isTrackingActive
                    ? "Tracking is active"
                    : "Tracking is not active",
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vehicleSpecs(TripsDetailsImp controller) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionLabel("VEHICLE SPECS"),
          const SizedBox(height: 12),

          Row(
            children: [
              VehicleImage(image: controller.vehicleImage),
              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.vehicleType,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      controller.vehicleModel,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendanceSection(RideController controller) {
    if (controller.attendanceRequest == StatusRequest.loading) {
      return const GlassCard(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (controller.attendanceRequest == StatusRequest.serverfailure) {
      return const GlassCard(
        child: Text(
          "حدث خطأ في جلب بيانات الحضور",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    if (controller.attendanceRequest == StatusRequest.noData ||
        controller.passengers.isEmpty) {
      return const GlassCard(
        child: Text(
          "لا يوجد ركاب",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.getAttendance,
      child: Column(
        children: [
          GlassCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white12,
                      child: Icon(Icons.people, color: Colors.white),
                    ),
                    SizedBox(width: 15),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Passenger Attendance",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Total Passengers",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  "${controller.passengers.length}",
                  style: const TextStyle(
                    color: Color(0xFFB388FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ...controller.passengers.asMap().entries.map((entry) {
            final index = entry.key;
            final passenger = entry.value;

            return _attendanceCard(
              passenger,
              index,
              controller,
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _attendanceCard(
    AttendanceItem passenger,
    int index,
    RideController controller,
  ) {
    final bool? isPresent = passenger.attendanceStatusKey == null
        ? null
        : passenger.attendanceStatusKey == "present";

    return GlassCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.white10,
                backgroundImage: passenger.passengerImage != null
                    ? NetworkImage(passenger.passengerImage!)
                    : null,
                child: passenger.passengerImage == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      passenger.passengerName ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      passenger.passengerPhone ?? '',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              _attendanceStatusChip(
                passenger.bookingStatus ?? '',
                const Color(0xFF00ACC1),
              ),
            ],
          ),

          const Divider(color: Colors.white10, height: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn(
                "Booking Code",
                passenger.bookingCode ?? '',
                const Color(0xFF4285F4),
              ),
              Flexible(
                child: _infoColumn(
                  "Pickup Point",
                  passenger.pickupPoint ?? '',
                  Colors.white,
                  alignRight: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              const Text(
                "Attendance Status: ",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              Text(
                isPresent == null
                    ? "Not marked"
                    : isPresent
                        ? "Present"
                        : "Absent",
                style: TextStyle(
                  color: isPresent == null
                      ? Colors.orange
                      : isPresent
                          ? Colors.green
                          : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: _attendanceActionButton(
                  title: "Present",
                  color: isPresent == true
                      ? Colors.green
                      : AppColor.thirdColor,
                  icon: Icons.check_circle,
                  onTap: () => controller.setAttendance(index, true),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _attendanceActionButton(
                  title: "Absent",
                  color: isPresent == false
                      ? Colors.red
                      : AppColor.fourthColor,
                  icon: Icons.cancel,
                  onTap: () => controller.setAttendance(index, false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _attendanceActionButton({
    required String title,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _attendanceStatusChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
        ),
      ),
    );
  }

  Widget _infoColumn(
    String label,
    String value,
    Color valueColor, {
    bool alignRight = false,
  }) {
    return Column(
      crossAxisAlignment:
          alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: alignRight ? TextAlign.end : TextAlign.start,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(18),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: padding,
            decoration: BoxDecoration(
              color: AppColor.fifthColor.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColor.grey),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class SectionLabel extends StatelessWidget {
  final String text;

  const SectionLabel(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColor.fourthColor,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;

  const TitleText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class TimeNode extends StatelessWidget {
  final String time;
  final String label;

  const TimeNode({
    super.key,
    required this.time,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          time,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class RoutePointItem extends StatelessWidget {
  final String title;
  final String sub;
  final bool isStart;

  const RoutePointItem({
    super.key,
    required this.title,
    required this.sub,
    required this.isStart,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Icon(
              Icons.circle,
              size: 10,
              color: isStart ? Colors.blue : Colors.cyan,
            ),
            Container(
              width: 1.5,
              height: 45,
              color: Colors.grey[800],
            ),
          ],
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                sub,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),

        Text(
          isStart ? "START" : "END",
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class SeatIndicator extends StatelessWidget {
  final int seats;

  const SeatIndicator({
    super.key,
    required this.seats,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 55,
          height: 55,
          child: CircularProgressIndicator(
            value: seats == 0 ? 0 : 1,
            strokeWidth: 6,
            backgroundColor: Colors.grey[800],
            valueColor: const AlwaysStoppedAnimation<Color>(
              Colors.blueAccent,
            ),
          ),
        ),
        Text(
          "$seats",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class VehicleImage extends StatelessWidget {
  final String image;

  const VehicleImage({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty) {
      return ImagePlaceHolder(width: 65, height: 65);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        image,
        width: 65,
        height: 65,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return ImagePlaceHolder(width: 65, height: 65);
        },
      ),
    );
  }
}