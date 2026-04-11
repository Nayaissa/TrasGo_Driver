import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/view/widget/home/section_title.dart';

class DateSection extends StatelessWidget {
  const DateSection({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dates = List.generate(4, (i) => now.add(Duration(days: i)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('select_departure_date'.tr),
        const SizedBox(height: 12),
        Row(
          children: [
            ...dates.map(
              (date) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _DateChip(
                    date: date,
                    isSelected:
                        controller.selectedDate.year == date.year &&
                        controller.selectedDate.month == date.month &&
                        controller.selectedDate.day == date.day,
                    onTap: () => controller.selectQuickDate(date),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () => controller.pickDate(context),
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: 52,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF121E3C),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.calendar_month, color: Colors.white70),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip({
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [Color(0xFF6C7BFF), Color(0xFF9D7BFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isSelected ? null : const Color(0xFF121E3C),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _monthName(date.month),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white70,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${date.day}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int month) {
    final months = [
      '',
      'jan'.tr,
      'feb'.tr,
      'mar'.tr,
      'apr'.tr,
      'may'.tr,
      'jun'.tr,
      'jul'.tr,
      'aug'.tr,
      'sep'.tr,
      'oct'.tr,
      'nov'.tr,
      'dec'.tr,
    ];
    return months[month];
  }
}
