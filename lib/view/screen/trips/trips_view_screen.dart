import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/trips/trips_view_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/view/widget/trips/custom_appar.dart';
import 'package:transport_project/view/widget/trips/title_section.dart';
import 'package:transport_project/view/widget/trips/trip_card.dart';

class TripsPage extends StatelessWidget {
  const TripsPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(TripsControllerImp());

    return SafeArea(
      child: GetBuilder<TripsControllerImp>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(),
                const SizedBox(height: 20),
                TitleSection(subTitle: "Manage Trips", title: "Manage Trips"),
                tabs(controller),
                const SizedBox(height: 10),
                Expanded(child: _tripsList(controller)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget tabs(TripsControllerImp controller) {
    if (controller.getTabStatusRequest == StatusRequest.loading &&
        controller.tabModel == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final items = controller.tabModel?.data?.items;

    if (items == null) return const SizedBox();

    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(items.length, (index) {
            bool isSelected = controller.selectedTab == index;

            return GestureDetector(
              onTap: () => controller.changeTab(index),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient:
                      isSelected
                          ? const LinearGradient(
                            colors: [AppColor.thirdColor, AppColor.fourthColor],
                          )
                          : null,
                  color: isSelected ? null : Colors.white10,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  items[index].name ?? '',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _tripsList(TripsControllerImp controller) {
    if (controller.getTabStatusRequest == StatusRequest.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.trips.isEmpty) {
      return const Center(
        child: Text("No Trips", style: TextStyle(color: Colors.white)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.trips.length,
      itemBuilder: (context, index) {
        return TripCard(data: controller.trips[index]);
      },
    );
  }
}
