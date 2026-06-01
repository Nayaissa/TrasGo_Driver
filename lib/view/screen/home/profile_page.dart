import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/driver_profile_controller.dart';
import 'package:transport_project/core/constant/AppColor.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DriverProfileController());

    return GetBuilder<DriverProfileController>(
      builder: (controller) {
        return Container(
          color: AppColor.primaryColor,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            child: Column(
              children: [
                _buildHeaderSection(controller),
                const SizedBox(height: 20),
                _buildQuickStatsRow(controller),
                const SizedBox(height: 24),
                _buildPerformanceMatrix(controller),
                const SizedBox(height: 16),
                _buildBalanceCard(controller),
                const SizedBox(height: 16),
                _buildIdentityDetails(controller),
                const SizedBox(height: 16),
                _buildVehicleCard(controller),
                const SizedBox(height: 16),
                _buildPassengerReviews(),
                const SizedBox(height: 16),
                _buildAccountSettings(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeaderSection(DriverProfileController controller) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF6E88FF),
                    Color(0xFFD08DFF),
                  ],
                ),
              ),
              child: const CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
            ),
            const CircleAvatar(
              radius: 14,
              backgroundColor: Color(0xFF6E88FF),
              child: Icon(Icons.check, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          controller.driverName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: Color(0xFFD08DFF), size: 18),
            const SizedBox(width: 4),
            Text(
              '${controller.rating}',
              style: const TextStyle(
                color: Color(0xFFD08DFF),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          controller.rank,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatsRow(DriverProfileController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatBadge(Icons.directions_car, "${controller.trips}\nTrips"),
        _buildStatBadge(Icons.group, "${controller.passengers}\nPassengers"),
        _buildStatBadge(Icons.calendar_today, "${controller.years}\nYears"),
      ],
    );
  }

  Widget _buildStatBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1731).withOpacity(.96),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6E88FF), size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceMatrix(DriverProfileController controller) {
    return _buildContainerWrapper(
      title: "PERFORMANCE MATRIX",
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        childAspectRatio: 2.2,
        children: [
          _buildMatrixItem(controller.completedTrips.toString(), "COMPLETED"),
          _buildMatrixItem(controller.cancelledTrips.toString(), "CANCELLED"),
          _buildMatrixItem("\$${controller.totalEarnings}", "TOTAL", isAmount: true),
          _buildMatrixItem(controller.rating.toString(), "AVG RATING", isRating: true),
        ],
      ),
    );
  }

  Widget _buildMatrixItem(
    String value,
    String label, {
    bool isAmount = false,
    bool isRating = false,
  }) {
    Color valColor = Colors.white;

    if (isAmount) valColor = const Color(0xFFD08DFF);
    if (isRating) valColor = const Color(0xFF6E88FF);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: valColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white54,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(DriverProfileController controller) {
    return _buildContainerWrapper(
      title: "BALANCE",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\$${controller.walletBalance.toStringAsFixed(2)}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "+\$${controller.todayEarnings} today",
            style: const TextStyle(
              color: Color(0xFFD08DFF),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF6E88FF),
                  Color(0xFFD08DFF),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: ElevatedButton(
              onPressed: () => controller.refreshWallet(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: const Text(
                'OPEN WALLET',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIdentityDetails(DriverProfileController controller) {
    return _buildContainerWrapper(
      title: "IDENTITY DETAILS",
      trailing: TextButton(
        onPressed: () {},
        child: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Color(0xFF6E88FF),
            fontSize: 12,
          ),
        ),
      ),
      child: Column(
        children: [
          _buildInfoRow(Icons.person_outline, "Full Name", controller.driverName),
          const Divider(color: Colors.white10, height: 20),
          _buildInfoRow(Icons.phone_outlined, "Phone Number", "+1 (555) 012-3456"),
          const Divider(color: Colors.white10, height: 20),
          _buildInfoRow(
            Icons.directions_car_outlined,
            "Vehicle Identity",
            "${controller.carModel} • ${controller.carPlate}",
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColor.primaryColor,
          radius: 18,
          child: Icon(icon, color: const Color(0xFF6E88FF), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white54, fontSize: 11)),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCard(DriverProfileController controller) {
    return _buildContainerWrapper(
      title: "",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://via.placeholder.com/400x200',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            controller.carModel,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            controller.carPlate,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerReviews() {
    return _buildContainerWrapper(
      title: "PASSENGER REVIEWS",
      child: Column(
        children: [
          _buildReviewItem(
            "Sarah J.",
            "Excellent driver, very punctual!",
            5,
          ),
          const SizedBox(height: 12),
          _buildReviewItem(
            "David K.",
            "Professional driver and smooth ride.",
            5,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String review, int rating) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.primaryColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 12, backgroundColor: Colors.white24),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  rating,
                  (index) => const Icon(
                    Icons.star,
                    color: Color(0xFFD08DFF),
                    size: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            review,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings() {
    return _buildContainerWrapper(
      title: "ACCOUNT SETTINGS",
      child: Column(
        children: [
          _buildSettingTile(Icons.security, "Account Security"),
          _buildSettingTile(Icons.notifications_none, "Notifications"),
          _buildSettingTile(Icons.privacy_tip_outlined, "Privacy"),
          _buildSettingTile(Icons.help_outline, "Help & Support"),
          _buildSettingTile(Icons.logout, "Logout", isLogout: true),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, {bool isLogout = false}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : const Color(0xFF6E88FF),
        size: 20,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : Colors.white,
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white24,
        size: 14,
      ),
      onTap: () {},
    );
  }

  Widget _buildContainerWrapper({
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                if (trailing != null) trailing,
              ],
            ),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF0C1731).withOpacity(.96),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(.04)),
          ),
          child: child,
        ),
      ],
    );
  }
}