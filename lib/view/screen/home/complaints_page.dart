import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/complaints/complaints_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/core/constant/routes.dart';
import 'package:transport_project/view/widget/trips/custom_appar.dart';
import 'package:transport_project/view/widget/trips/title_section.dart';

class ComplaintsOverviewScreen extends StatelessWidget {
  const ComplaintsOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF16223F);
    const primaryPurple = Color(0xFF9484F6);

    Get.put(ComplaintsControllerImp());

    return SafeArea(
      child: GetBuilder<ComplaintsControllerImp>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppbar(),

                TitleSection(subTitle: "الشكاوى", title: "Complaints"),

                const SizedBox(height: 12),

                _buildTopHeader(
                  primaryPurple,
                  onAddComplaint: () {
                    Get.offNamed(AppRoute.addcomplaint);
                  },
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: _buildComplaintsBody(
                    controller,
                    cardColor,
                    primaryPurple,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildComplaintsBody(
    ComplaintsControllerImp controller,
    Color cardColor,
    Color primaryPurple,
  ) {
    if (controller.complaintsStatusRequest == StatusRequest.loading ||
        controller.complaintsStatusRequest == null) {
      return Center(child: CircularProgressIndicator(color: primaryPurple));
    }

    if (controller.complaintsStatusRequest == StatusRequest.serverfailure) {
      return Center(
        child: ElevatedButton(
          onPressed: controller.refreshComplaints,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
          ),
          child: const Text("Retry"),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshComplaints,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        children: [
          _buildTotalCard(controller, cardColor, primaryPurple),

          const SizedBox(height: 16),

          _buildStatisticsCards(controller, cardColor, primaryPurple),

          const SizedBox(height: 24),

          _buildSearchBox(controller),

          const SizedBox(height: 16),

          _buildFilters(controller, primaryPurple),

          const SizedBox(height: 24),

          _buildSectionTitle(),

          const SizedBox(height: 16),

          if (controller.filteredComplaints.isEmpty)
            _buildEmptyComplaintsCard(cardColor)
          else
            ...List.generate(controller.filteredComplaints.length, (index) {
              final complaint = controller.filteredComplaints[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildComplaintCard(complaint, cardColor),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildTopHeader(
    Color primaryPurple, {
    required VoidCallback onAddComplaint,
  }) {
    return InkWell(
      onTap: onAddComplaint,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColor.thirdColor, AppColor.fourthColor],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white, size: 18),
            SizedBox(width: 6),
            Text(
              "New",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalCard(
    ComplaintsControllerImp controller,
    Color cardColor,
    Color primaryPurple,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryPurple.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: primaryPurple.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL\nCOMPLAINTS: ${controller.totalComplaints}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Driver complaints retrieved successfully',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(
    ComplaintsControllerImp controller,
    Color cardColor,
    Color primaryPurple,
  ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.verified_outlined, color: primaryPurple),
                const SizedBox(height: 12),
                Text(
                  'NEW COMPLAINTS',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${controller.newComplaints}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            children: [
              _buildMiniStatusCard(
                'RESOLVED',
                '${controller.resolvedComplaints}',
                Icons.check_circle_outline,
                const Color(0xFF4AC3E1),
              ),
              const SizedBox(height: 12),
              _buildMiniStatusCard(
                'TECHNICAL',
                '${controller.technicalComplaints}',
                Icons.build_outlined,
                const Color(0xFFBC6FF1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBox(ComplaintsControllerImp controller) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF121B32),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        style: const TextStyle(color: Colors.white),
        onChanged: controller.searchComplaints,
        decoration: InputDecoration(
          hintText: 'Search complaint code or description...',
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildFilters(
    ComplaintsControllerImp controller,
    Color primaryPurple,
  ) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            ['All', 'New', 'Technical', 'Resolved'].map((filterName) {
              final isSelected = controller.selectedFilter == filterName;

              return GestureDetector(
                onTap: () {
                  controller.changeFilter(filterName);
                },
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
                              colors: [
                                AppColor.thirdColor,
                                AppColor.fourthColor,
                              ],
                            )
                            : null,
                    color: isSelected ? null : Colors.white10,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    filterName,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Container(width: 12, height: 2, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          'RECENT COMPLAINTS',
          style: TextStyle(
            color: Colors.grey[400],
            letterSpacing: 2,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildComplaintCard(ComplaintModel complaint, Color cardColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  complaint.id,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.grey[500], fontSize: 11),
                ),
              ),
              Row(
                children: [
                  _buildTag(complaint.status, Colors.blueAccent),
                  const SizedBox(width: 6),
                  _buildTag(complaint.type, const Color(0xFFBC6FF1)),
                ],
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            complaint.ticketId,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              complaint.description,
              textDirection: TextDirection.rtl,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.grey[500], size: 16),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        complaint.date,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 8),

              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColor.thirdColor, AppColor.fourthColor],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: complaint.id,
                      middleText: complaint.description,
                      textConfirm: "OK",
                      confirmTextColor: Colors.white,
                      onConfirm: () {
                        Get.back();
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyComplaintsCard(Color cardColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: const Center(
        child: Text(
          "No complaints found",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMiniStatusCard(
    String title,
    String count,
    IconData icon,
    Color iconColor,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF16223F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: iconColor.withOpacity(0.1),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  count,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
