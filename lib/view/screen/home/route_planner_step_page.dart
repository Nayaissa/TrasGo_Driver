
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/trip_create_controller.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/home/GlassCard.dart';
import 'package:transport_project/view/widget/home/seats_card.dart';
import 'package:transport_project/view/widget/home/section_title.dart';
import 'package:transport_project/view/widget/home/trip_type_section.dart';

class RoutePlannerStep extends StatelessWidget {
  const RoutePlannerStep({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('route-planner-step'),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlassCard(child: PlannerHeader()),
          const SizedBox(height: 14),
          GetBuilder<TripController>(
            id: 'trip_points',
            builder: (_) => GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'choose_point_type'.tr,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'choose_point_type_subtitle'.tr,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      SelectionModeChip(
                        icon: Icons.trip_origin_rounded,
                        label: 'pickup'.tr,
                        isSelected: controller.selectionMode == 'pickup',
                        onTap: () => controller.setSelectionMode('pickup'),
                      ),
                      SelectionModeChip(
                        icon: Icons.flag_rounded,
                        label: 'destination'.tr,
                        isSelected: controller.selectionMode == 'destination',
                        onTap: () => controller.setSelectionMode('destination'),
                      ),
                      SelectionModeChip(
                        icon: Icons.add_road_rounded,
                        label: 'add_stop'.tr,
                        isSelected: controller.selectionMode == 'stop',
                        onTap: () => controller.setSelectionMode('stop'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          GetBuilder<TripController>(
            id: 'trip_type',
            builder: (_) => TripTypeSection(controller: controller),
          ),
          const SizedBox(height: 14),
          GetBuilder<TripController>(
            id: 'seats_section',
            builder: (_) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionTitle('available_seats'.tr),
                const SizedBox(height: 10),
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: SeatsCard(controller: controller),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          GetBuilder<TripController>(
            id: 'trip_points',
            builder: (_) => Row(
              children: [
                Expanded(
                  child: SecondaryActionButton(
                    text: 'clear_stops'.tr,
                    borderColor: AppColor.thirdColor,
                    icon: Icons.layers_clear_outlined,
                    onTap: controller.clearStops,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SecondaryActionButton(
                    text: 'reset_points'.tr,
                    borderColor: const Color(0xFFFF7B7B),
                    icon: Icons.restart_alt_rounded,
                    onTap: controller.clearAllPoints,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          CustomAuthButton(
            text: 'continue_to_trip_details'.tr,
            onPressed: controller.goToTripDetails,
          ),
        ],
      ),
    );
  }
}

class PlannerHeader extends StatelessWidget {
  const PlannerHeader({super.key});


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [AppColor.thirdColor, AppColor.fourthColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.map_outlined, color: Colors.white),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'route_intro_title'.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'route_intro_subtitle'.tr,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectionModeChip extends StatelessWidget {
  const SelectionModeChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isSelected
                ? const LinearGradient(
                     colors: [AppColor.thirdColor, AppColor.fourthColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected ? null :AppColor.fifthColor,
            border: Border.all(
              color: isSelected ? Colors.transparent : const Color(0x2FFFFFFF),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected ? Colors.white :AppColor.thirdColor,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondaryActionButton extends StatelessWidget {
  const SecondaryActionButton({
    required this.text,
    required this.borderColor,
    required this.icon,
    required this.onTap,
  });

  final String text;
  final Color borderColor;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: borderColor),
        backgroundColor: AppColor.fifthColor,

        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      icon: Icon(icon, size: 18),
      label: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}