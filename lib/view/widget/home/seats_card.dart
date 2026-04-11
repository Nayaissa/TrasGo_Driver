import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/view/widget/home/circle_icon_button.dart';

class SeatsCard extends StatelessWidget {
  const SeatsCard({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'available_seats'.tr,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF121E3C),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              CircleIconButton(
                icon: Icons.remove,
                onTap: controller.decrementSeats,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    '${controller.availableSeats}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              CircleIconButton(
                icon: Icons.add,
                onTap: controller.incrementSeats,
              ),
            ],
          ),
        ),
      ],
    );
  }
}