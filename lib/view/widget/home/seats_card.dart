import 'package:flutter/material.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/home/circle_icon_button.dart';

class SeatsCard extends StatelessWidget {
  const SeatsCard({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColor.primaryColor,
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
