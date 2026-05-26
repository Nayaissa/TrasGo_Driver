import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/trips/trips_view_controller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/trips/imagePlaceholder.dart';

class TripCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const TripCard({super.key, required this.data});

  String _formatSyriaTime(String? value) {
    if (value == null || value.isEmpty) {
      return "";
    }

    try {
      final utcTime = DateTime.parse(value).toUtc();
      final syriaTime = utcTime.add(const Duration(hours: 3));

      return "${syriaTime.year}-${syriaTime.month.toString().padLeft(2, '0')}-${syriaTime.day.toString().padLeft(2, '0')} "
          "${syriaTime.hour.toString().padLeft(2, '0')}:${syriaTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return value;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = _formatSyriaTime(
      data["date"]?.toString(),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [
            AppColor.fifthColor,
            AppColor.secondaryColor,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _image(),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  ' الرحلة : ${data["title"]?.toString()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "\$${data["price"] ?? 0}",
                    style: const TextStyle(
                      color: AppColor.fourthColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "EST.EARNINGS",
                    style: TextStyle(
                      color: Colors.white38,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formattedDate,
                style: const TextStyle(
                  color: Colors.white60,
                ),
              ),
              const Text(
                "Departure",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _route(),
          const SizedBox(height: 18),
          _button(),
        ],
      ),
    );
  }

  Widget _image() {
    final image = data["image"]?.toString() ?? "";

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Stack(
        children: [
          image.isEmpty
              ? ImagePlaceHolder(
                  width: 0.0,
                  height: 150,
                )
              : Image.network(
                  image,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return ImagePlaceHolder(
                      width: 0.0,
                      height: 150,
                    );
                  },
                ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.6),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColor.thirdColor,
                    AppColor.fourthColor,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                data["type"]?.toString() ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _route() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            _dot(Colors.blueAccent),
            Container(
              width: 2,
              height: 30,
              color: Colors.white24,
            ),
            _dot(Colors.red),
          ],
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ORIGIN",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data["from"]?.toString() ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "DESTINATION",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data["to"]?.toString() ?? "",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
Widget _button() {
  final status = data["status"]?.toString();

  /// فقط الرحلات النشطة يظهر لها زر بدء الرحلة
  final bool canStartTrip =
      status == "active";

  return GetBuilder<TripsControllerImp>(
    builder: (controller) {
      final bool isLoading =
          controller.tripActionStatusRequest
                  ?.toString()
                  .contains("loading") ??
              false;

      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: CustomAuthButton(
                  text: "Trip Details",

                  onPressed: () {
                    final tripId = data["trip_id"];

                    if (tripId == null) {
                      Get.snackbar(
                        "Error",
                        "Trip id not found",
                        snackPosition: SnackPosition.BOTTOM,
                      );

                      return;
                    }

                    controller.goToDetailsPage(
                      int.parse(tripId.toString()),
                    );
                  },
                ),
              ),

              const SizedBox(width: 10),

              InkWell(
                borderRadius: BorderRadius.circular(25),

                onTap: () {
                  final tripId = data["trip_id"];

                  if (tripId == null) {
                    Get.snackbar(
                      "Error",
                      "Trip id not found",
                      snackPosition: SnackPosition.BOTTOM,
                    );

                    return;
                  }

                  controller.goToBookingsPage(data);
                },

                child: Container(
                  width: 50,
                  height: 50,

                  decoration: const BoxDecoration(
                    color: Colors.white10,
                    shape: BoxShape.circle,
                  ),

                  child: const Icon(
                    Icons.receipt_long,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          /// زر بدء الرحلة فقط
          if (canStartTrip) ...[
            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 48,

              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                    color: AppColor.fourthColor,
                    width: 1.5,
                  ),

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),

                  foregroundColor: Colors.white,
                ),

                icon: isLoading
                    ? const SizedBox(
                        width: 18,
                        height: 18,

                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.play_arrow,
                        color: AppColor.fourthColor,
                      ),

                label: const Text(
                  "بدء الرحلة",

                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                onPressed: isLoading
                    ? null
                    : () {
                        final tripId = data["trip_id"];

                        if (tripId == null) {
                          Get.snackbar(
                            "Error",
                            "Trip id not found",
                            snackPosition: SnackPosition.BOTTOM,
                          );

                          return;
                        }

                        controller.startTrip(
                          int.parse(tripId.toString()),
                        );
                      },
              ),
            ),
          ],
        ],
      );
    },
  );
}
}