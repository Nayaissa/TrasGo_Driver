import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/trips/bookings_details_controller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/trips/custom_appar.dart';

class RideDetailsScreen extends StatelessWidget {
  const RideDetailsScreen({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RideController(tripId: 0));

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: GetBuilder<RideController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppbar(),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Ride Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      _buildStatusChip("Accepted", const Color(0xFF00ACC1)),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(child: _buildTripDetailsTab(controller)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripDetailsTab(RideController controller) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildSectionCard(
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white10,
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "naya issa",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "09388004144",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const Text(
                    "Profile >",
                    style: TextStyle(color: Color(0xFF4285F4), fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  _buildMiniChip(Icons.airline_seat_recline_normal, "1 SEAT"),
                  const SizedBox(width: 10),
                  _buildMiniChip(
                    Icons.check_circle,
                    "ACCEPTED",
                    color: const Color(0xFF00ACC1),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on, color: Color(0xFF4285F4)),
                      SizedBox(width: 5),
                      Text(
                        "Pickup Point",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "04:16 AM",
                    style: TextStyle(
                      color: AppColor.thirdColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.only(left: 30),
                child: Text(
                  "05 May 2026",
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),

              const SizedBox(height: 15),

              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white10,
                ),
                child: const Center(
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.blueAccent,
                    size: 40,
                  ),
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                "الانطلاق من الكراج الجنوبي",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text(
                "سوريا، دمشق، G87X+926",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),

        const SizedBox(height: 15),

        _buildSectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "PAYMENT BREAKDOWN",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
              const Divider(color: Colors.white10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Estimated Total",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Text(
                    "2000.21",
                    style: TextStyle(
                      color: Color(0xFFB388FF),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Payment Method", style: TextStyle(color: Colors.white)),
                  Row(
                    children: [
                      Icon(Icons.money, color: Colors.blueAccent, size: 18),
                      SizedBox(width: 5),
                      Text("Cash", style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        _buildGradientButton("Confirm Arrival"),

        Center(
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Cancel Booking",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required Widget child, EdgeInsets? margin}) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: child,
    );
  }

  Widget _buildStatusChip(String text, Color color, {bool small = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: small ? 8 : 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: small ? 10 : 12),
      ),
    );
  }

  Widget _buildMiniChip(
    IconData icon,
    String text, {
    Color color = Colors.white24,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: color == Colors.white24 ? Colors.white70 : color,
          ),
          const SizedBox(width: 5),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 82),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                maxLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF9575CD)],
        ),
      ),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            text,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
