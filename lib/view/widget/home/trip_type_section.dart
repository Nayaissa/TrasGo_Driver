import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/view/widget/home/section_title.dart';
import 'package:transport_project/view/widget/home/trip_type_card.dart';

class TripTypeSection extends StatelessWidget {
  const TripTypeSection({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: SectionTitle('trip_type'.tr),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TripTypeCard(
                title: 'private_trip'.tr,
                subtitle: 'private_trip_desc'.tr,
                icon: Icons.person_outline,
                selected: controller.allowPrivate,
                onTap: controller.togglePrivate,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: TripTypeCard(
                title: 'shared_trip'.tr,
                subtitle: 'shared_trip_desc'.tr,
                icon: Icons.people_alt_outlined,
                selected: controller.allowShared,
                onTap: controller.toggleShared,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
