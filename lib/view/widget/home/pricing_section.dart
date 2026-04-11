import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/view/widget/home/price_field.dart';
import 'package:transport_project/view/widget/home/section_title.dart';

class PricingSection extends StatelessWidget {
  const PricingSection({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SectionTitle('pricing_setup'.tr),
            const Spacer(),
            Text(
              '${'suggested_price'.tr} \$${controller.suggestedPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF77A8FF),
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (controller.allowShared) ...[
          PriceField(
            controller: controller.priceController,
            hint: 'seat_price'.tr,
            prefixText: '\$',
          ),
          const SizedBox(height: 8),
          Text(
            'price_range_note'.tr,
            style: TextStyle(
              color: Colors.red.shade300,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (controller.allowPrivate) ...[
          if (controller.allowShared) const SizedBox(height: 12),
          PriceField(
            controller: controller.privatePriceController,
            hint: 'private_trip_price_optional'.tr,
            prefixText: '\$',
          ),
        ],
      ],
    );
  }
}