import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/home/date_section.dart';
import 'package:transport_project/view/widget/home/notes_section.dart';
import 'package:transport_project/view/widget/home/pricing_section.dart';
import 'package:transport_project/view/widget/home/seats_card.dart';
import 'package:transport_project/view/widget/home/time_card.dart';
import 'package:transport_project/view/widget/home/top_map_card.dart';
import 'package:transport_project/view/widget/home/trip_type_section.dart';

class TripCreationPage extends StatelessWidget {
  TripCreationPage({super.key});

  final TripController controller = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GetBuilder<TripController>(
          id: 'map',
          builder: (_) => TopMapCard(controller: controller),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GetBuilder<TripController>(
                  id: 'trip_points',
                  builder:
                      (_) => Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () => controller.setSelectionMode(
                                          'pickup',
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          controller.selectionMode == 'pickup'
                                              ? const Color(0xFF7C90FF)
                                              : const Color(0xFF121E3C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text('pickup'.tr),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () => controller.setSelectionMode(
                                          'destination',
                                        ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          controller.selectionMode ==
                                                  'destination'
                                              ? const Color(0xFF7C90FF)
                                              : const Color(0xFF121E3C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text('destination'.tr),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed:
                                        () =>
                                            controller.setSelectionMode('stop'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          controller.selectionMode == 'stop'
                                              ? const Color(0xFF7C90FF)
                                              : const Color(0xFF121E3C),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text('add_stop'.tr),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: controller.clearStops,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFF7C90FF),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text('clear_stops'.tr),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: controller.clearAllPoints,
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Colors.redAccent,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: Text('reset_points'.tr),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<TripController>(
                        id: 'date_section',
                        builder: (_) => DateSection(controller: controller),
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: GetBuilder<TripController>(
                              id: 'time_section',
                              builder:
                                  (_) => TimeCard(
                                    title: 'time'.tr,
                                    value: controller.selectedTime.format(
                                      context,
                                    ),
                                    onTap: () => controller.pickTime(context),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GetBuilder<TripController>(
                              id: 'seats_section',
                              builder: (_) => SeatsCard(controller: controller),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      GetBuilder<TripController>(
                        id: 'trip_type',
                        builder: (_) => TripTypeSection(controller: controller),
                      ),
                      const SizedBox(height: 18),
                      GetBuilder<TripController>(
                        id: 'pricing_section',
                        builder: (_) => PricingSection(controller: controller),
                      ),
                      const SizedBox(height: 18),
                      NotesSection(controller: controller),
                      const SizedBox(height: 24),
                      CustomAuthButton(text: 'انشاء رحلة'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
