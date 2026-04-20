// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:transport_project/controller/home/tripcontroller.dart';
// import 'package:transport_project/core/class/statusrequest.dart';
// import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
// import 'package:transport_project/view/widget/home/GlassCard.dart';
// import 'package:transport_project/view/widget/home/date_section.dart';
// import 'package:transport_project/view/widget/home/notes_section.dart';
// import 'package:transport_project/view/widget/home/pricing_section.dart';
// import 'package:transport_project/view/widget/home/time_card.dart';

// class TripDetailsStep extends StatelessWidget {
//   const TripDetailsStep({super.key, required this.controller});

//   final TripController controller;

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       key: const ValueKey('trip-details-step'),
//       padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 18),
//           GetBuilder<TripController>(
//             id: 'pricing_section',
//             builder:
//                 (_) => GlassCard(
//                   padding: const EdgeInsets.all(16),
//                   child:
//                       controller.previewStatusRequest == StatusRequest.loading
//                           ? const Center(
//                             child: Padding(
//                               padding: EdgeInsets.all(20),
//                               child: CircularProgressIndicator(),
//                             ),
//                           )
//                           : Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'المسافة: ${controller.routeDistanceMiles.toStringAsFixed(2)} ميل',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'المدة: ${controller.routeDurationMinutes} دقيقة',
//                                 style: const TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               if (controller.systemCalculatedPrice > 0)
//                                 Text(
//                                   'السعر المحسوب: ${controller.systemCalculatedPrice.toStringAsFixed(2)}',
//                                   style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               if (controller.allowShared &&
//                                   controller.sharedMinPrice > 0 &&
//                                   controller.sharedMaxPrice > 0) ...[
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'سعر المقعد المشترك: من ${controller.sharedMinPrice.toStringAsFixed(2)} إلى ${controller.sharedMaxPrice.toStringAsFixed(2)}',
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                               if (controller.allowPrivate &&
//                                   controller.privateMinPrice > 0 &&
//                                   controller.privateMaxPrice > 0) ...[
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   'سعر الرحلة الخاصة: من ${controller.privateMinPrice.toStringAsFixed(2)} إلى ${controller.privateMaxPrice.toStringAsFixed(2)}',
//                                   style: const TextStyle(
//                                     color: Colors.white70,
//                                     fontSize: 14,
//                                   ),
//                                 ),
//                               ],
//                             ],
//                           ),
//                 ),
//           ),
//           const SizedBox(height: 18),
//           GetBuilder<TripController>(
//             id: 'date_section',
//             builder: (_) => DateSection(controller: controller),
//           ),
//           const SizedBox(height: 18),
//           GetBuilder<TripController>(
//             id: 'time_section',
//             builder:
//                 (_) => TimeCard(
//                   title: 'time'.tr,
//                   value: controller.selectedTime.format(context),
//                   onTap: () => controller.pickTime(context),
//                 ),
//           ),
//           const SizedBox(height: 18),
//           GetBuilder<TripController>(
//             id: 'pricing_section',
//             builder: (_) => PricingSection(controller: controller),
//           ),
//           const SizedBox(height: 18),
//           NotesSection(controller: controller),
//           const SizedBox(height: 24),
//           CustomAuthButton(
//             text: 'create_trip_now'.tr,
//             onPressed: controller.createTrip,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // class _GlassCard extends StatelessWidget {
// //   const _GlassCard({
// //     required this.child,
// //     this.padding = const EdgeInsets.all(18),
// //   });

// //   final Widget child;
// //   final EdgeInsets padding;

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       width: double.infinity,
// //       padding: padding,
// //       decoration: BoxDecoration(
// //         color: const Color(0xCC0F1832),
// //         borderRadius: BorderRadius.circular(24),
// //         border: Border.all(color: const Color(0x1FFFFFFF)),
// //       ),
// //       child: child,
// //     );
// //   }
// // }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';
import 'package:transport_project/view/widget/home/GlassCard.dart';
import 'package:transport_project/view/widget/home/date_section.dart';
import 'package:transport_project/view/widget/home/notes_section.dart';
import 'package:transport_project/view/widget/home/pricing_section.dart';
import 'package:transport_project/view/widget/home/time_card.dart';

class TripDetailsStep extends StatelessWidget {
  const TripDetailsStep({super.key, required this.controller});

  final TripController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const ValueKey('trip-details-step'),
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          GetBuilder<TripController>(
            id: 'pricing_section',
            builder:
                (_) => GlassCard(
                  padding: const EdgeInsets.all(16),
                  child:
                      controller.previewStatusRequest == StatusRequest.loading
                          ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CircularProgressIndicator(),
                            ),
                          )
                          : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المسافة: ${controller.routeDistanceMiles.toStringAsFixed(2)} ميل',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'المدة: ${controller.routeDurationMinutes} دقيقة',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (controller.systemCalculatedPrice > 0)
                                Text(
                                  'السعر المحسوب: ${controller.systemCalculatedPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              if (controller.allowShared &&
                                  controller.sharedMinPrice > 0 &&
                                  controller.sharedMaxPrice > 0) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'سعر المقعد المشترك: من ${controller.sharedMinPrice.toStringAsFixed(2)} إلى ${controller.sharedMaxPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                              if (controller.allowPrivate &&
                                  controller.privateMinPrice > 0 &&
                                  controller.privateMaxPrice > 0) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'سعر الرحلة الخاصة: من ${controller.privateMinPrice.toStringAsFixed(2)} إلى ${controller.privateMaxPrice.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ],
                          ),
                ),
          ),
          const SizedBox(height: 18),
          GetBuilder<TripController>(
            id: 'date_section',
            builder: (_) => DateSection(controller: controller),
          ),
          const SizedBox(height: 18),
          GetBuilder<TripController>(
            id: 'time_section',
            builder:
                (_) => TimeCard(
                  title: 'time'.tr,
                  value: controller.selectedTime.format(context),
                  onTap: () => controller.pickTime(context),
                ),
          ),
          const SizedBox(height: 18),
          GetBuilder<TripController>(
            id: 'pricing_section',
            builder: (_) => PricingSection(controller: controller),
          ),
          const SizedBox(height: 18),
          NotesSection(controller: controller),
          const SizedBox(height: 24),
          GetBuilder<TripController>(
            id: 'create_trip_button',
            builder:
                (_) => CustomAuthButton(
                  text:
                      controller.storeTripStatusRequest == StatusRequest.loading
                          ? 'جاري إنشاء الرحلة...'
                          : 'create_trip_now'.tr,
                  onPressed:
                      controller.storeTripStatusRequest == StatusRequest.loading
                          ? () {}
                          : controller.createTrip,
                ),
          ),
        ],
      ),
    );
  }
}
