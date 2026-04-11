import 'package:flutter/material.dart';
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
        const SectionTitle('TRIP TYPE'),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TripTypeCard(
                title: 'Shared',
                subtitle: 'Optimized for individual seat bookings',
                icon: Icons.people_alt_outlined,
                selected: controller.allowShared,
                onTap: controller.toggleShared,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TripTypeCard(
                title: 'Private',
                subtitle: 'Book the entire vehicle for the trip',
                icon: Icons.person_outline,
                selected: controller.allowPrivate,
                onTap: controller.togglePrivate,
              ),
            ),
          ],
        ),
      ],
    );
  }
}