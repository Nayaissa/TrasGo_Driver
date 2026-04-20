// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:transport_project/controller/home/tripcontroller.dart';
// import 'package:transport_project/core/class/statusrequest.dart';
// import 'package:transport_project/view/screen/home/route_planner_step_page.dart';
// import 'package:transport_project/view/screen/home/trip_details_page.dart';
// import 'package:transport_project/view/widget/home/top_map_card.dart';

// class TripCreationPage extends StatelessWidget {
//   TripCreationPage({super.key});

//   final TripController controller = Get.put(TripController());

//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<TripController>(
//       id: 'trip_step',
//       builder: (_) {
//         final bool showDetails = controller.currentStep == 1;

//         return Column(
//           children: [
//             GetBuilder<TripController>(
//               id: 'map',
//               builder: (_) => Stack(
//                 children: [
//                   TopMapCard(
//                     controller: controller,
//                     title: showDetails
//                         ? 'trip_details_title'.tr
//                         : 'route_planner_title'.tr,
//                     subtitle: showDetails
//                         ? 'trip_details_subtitle'.tr
//                         : 'route_planner_subtitle'.tr,
//                     showBackButton: showDetails,
//                     showSummaryPill: showDetails,
//                     onBackPressed: controller.backToRoutePlanner,
//                     heightFactor: showDetails ? 0.46 : 0.52,
//                   ),
//                   if (showDetails &&
//                       controller.previewStatusRequest == StatusRequest.loading)
//                     Positioned(
//                       top: 16,
//                       left: 16,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 14,
//                           vertical: 10,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.black.withOpacity(.65),
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         child: const Row(
//                           children: [
//                             SizedBox(
//                               width: 18,
//                               height: 18,
//                               child: CircularProgressIndicator(strokeWidth: 2),
//                             ),
//                             SizedBox(width: 10),
//                             Text(
//                               '���� ������ ������...',
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 220),
//                 child: showDetails
//                     ? TripDetailsStep(controller: controller)
//                     : RoutePlannerStep(controller: controller),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/home/tripcontroller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/view/screen/home/route_planner_step_page.dart';
import 'package:transport_project/view/screen/home/trip_details_page.dart';
import 'package:transport_project/view/widget/home/top_map_card.dart';

class TripCreationPage extends StatelessWidget {
  TripCreationPage({super.key});

  final TripController controller = Get.put(TripController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TripController>(
      id: 'trip_step',
      builder: (_) {
        final bool showDetails = controller.currentStep == 1;

        return Column(
          children: [
            GetBuilder<TripController>(
              id: 'map',
              builder: (_) => Stack(
                children: [
                  TopMapCard(
                    controller: controller,
                    title: showDetails
                        ? 'trip_details_title'.tr
                        : 'route_planner_title'.tr,
                    subtitle: showDetails
                        ? 'trip_details_subtitle'.tr
                        : 'route_planner_subtitle'.tr,
                    showBackButton: showDetails,
                    showSummaryPill: showDetails,
                    onBackPressed: controller.backToRoutePlanner,
                    heightFactor: showDetails ? 0.46 : 0.52,
                  ),
                  if (showDetails &&
                      controller.previewStatusRequest == StatusRequest.loading)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.65),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: 10),
                            Text(
                              'جاري معاينة المسار...',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: showDetails
                    ? TripDetailsStep(controller: controller)
                    : RoutePlannerStep(controller: controller),
              ),
            ),
          ],
        );
      },
    );
  }
}