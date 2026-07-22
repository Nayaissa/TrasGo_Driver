import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/profile/driver_profile_controller.dart';
import 'package:transport_project/core/class/diohelper.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/core/constant/routes.dart';

class App {
  static void logout() {
    myServices.removeFromSharedPreferences('token');
    myServices.setString('step', '1');
    Get.offAllNamed(AppRoute.login);
  }
}
class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DriverProfileControllerImp>(
      builder: (controller) {
        if (controller.profileStatusRequest == StatusRequest.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.thirdColor),
          );
        }

        if (controller.profileStatusRequest == StatusRequest.serverfailure) {
          return _buildMessage(
            message: "حدث خطأ أثناء تحميل الملف الشخصي",
            icon: Icons.error_outline,
          );
        }

        if (controller.profileStatusRequest == StatusRequest.noData) {
          return _buildMessage(
            message: "لا توجد بيانات للملف الشخصي",
            icon: Icons.info_outline,
          );
        }

        return RefreshIndicator(
          color: AppColor.thirdColor,
          backgroundColor: AppColor.primaryColor,
          onRefresh: () async {
            await controller.refreshProfile();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 18,
              bottom: 105,
            ),
            child: Column(
              children: [
                _buildTopBar(controller),
                const SizedBox(height: 20),
                _buildHeaderSection(controller),
                const SizedBox(height: 22),
                _buildIdentityDetails(controller),
                const SizedBox(height: 16),
                _buildVehicleCard(controller),
                const SizedBox(height: 16),
                _buildPassengerReviews(controller),
                const SizedBox(height: 16),
                _buildAccountSettings(controller),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildMessage({
    required String message,
    required IconData icon,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white70, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(DriverProfileControllerImp controller) {
    return Row(
      children: [
        const SizedBox(width: 48),
        Expanded(
          child: Center(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return const LinearGradient(
                  colors: [AppColor.thirdColor, AppColor.fourthColor],
                ).createShader(bounds);
              },
              child: const Text(
                "TransGo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: IconButton(
            onPressed: () {
              controller.refreshProfile();
            },
            icon: const Icon(Icons.refresh, color: Colors.white, size: 22),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection(DriverProfileControllerImp controller) {
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
                  colors: [AppColor.thirdColor, AppColor.fourthColor],
                ),
              ),
              child: ClipOval(
                child: controller.photo.isNotEmpty
                    ? Image.network(
                        controller.photo,
                        width: 104,
                        height: 104,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _emptyProfileImage();
                        },
                      )
                    : _emptyProfileImage(),
              ),
            ),
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColor.thirdColor,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.primaryColor, width: 3),
              ),
              child: const Icon(Icons.check, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          controller.driverName.isEmpty ? "-" : controller.driverName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star, color: AppColor.fourthColor, size: 19),
            const SizedBox(width: 5),
            Text(
              controller.rating.toString(),
              style: const TextStyle(
                color: AppColor.fourthColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          controller.email.isEmpty ? "-" : controller.email,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
        ),
      ],
    );
  }

  static Widget _emptyProfileImage() {
    return Container(
      width: 104,
      height: 104,
      color: Colors.white.withOpacity(0.08),
      child: const Icon(Icons.person, color: Colors.white, size: 48),
    );
  }

  Widget _buildIdentityDetails(DriverProfileControllerImp controller) {
    return _buildContainerWrapper(
      title: "IDENTITY DETAILS",
      child: Column(
        children: [
          _buildInfoRow(
            Icons.person_outline,
            "Full Name",
            controller.driverName,
          ),
          const Divider(color: Colors.white10, height: 22),
          _buildInfoRow(
            Icons.phone_outlined,
            "Phone Number",
            controller.phoneNumber,
          ),
          const Divider(color: Colors.white10, height: 22),
          _buildInfoRow(Icons.email_outlined, "Email", controller.email),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(DriverProfileControllerImp controller) {
    final String carImage =
        controller.carPhotos.isNotEmpty ? controller.carPhotos.first : "";

    return _buildContainerWrapper(
      title: "VEHICLE INFO",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: carImage.isNotEmpty
                ? Image.network(
                    carImage,
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _emptyCarImage();
                    },
                  )
                : _emptyCarImage(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Text(
                  controller.carType.isEmpty ? "-" : controller.carType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: AppColor.fourthColor.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  "CAR",
                  style: TextStyle(
                    color: AppColor.fourthColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                color: Colors.grey,
                size: 15,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  controller.carPlate.isEmpty ? "-" : controller.carPlate,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (controller.carPhotos.length > 1) ...[
            const SizedBox(height: 16),
            SizedBox(
              height: 75,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.carPhotos.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(width: 10);
                },
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      controller.carPhotos[index],
                      width: 90,
                      height: 75,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 90,
                          height: 75,
                          color: Colors.white.withOpacity(0.08),
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white54,
                            size: 26,
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPassengerReviews(DriverProfileControllerImp controller) {
    return _buildContainerWrapper(
      title: "PASSENGER REVIEWS",
      child: controller.reviews.isEmpty
          ? Row(
              children: [
                Icon(
                  Icons.rate_review_outlined,
                  color: Colors.grey.shade500,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  "No reviews yet",
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            )
          : Column(
              children: List.generate(controller.reviews.length, (index) {
                final review = controller.reviews[index];

                if (review is! Map) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == controller.reviews.length - 1 ? 0 : 12,
                  ),
                  child: _buildReviewItem(
                    review["user_name"]?.toString() ?? "Passenger",
                    review["comment"]?.toString() ?? "",
                    int.tryParse(review["rating"]?.toString() ?? "0") ?? 0,
                  ),
                );
              }),
            ),
    );
  }

  Widget _buildReviewItem(String name, String review, int rating) {
    final int safeRating = rating.clamp(0, 5);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColor.fifthColor.withOpacity(0.55),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name.isEmpty ? "Passenger" : name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Row(
            children: List.generate(5, (index) {
              return Icon(
                index < safeRating ? Icons.star : Icons.star_border,
                color: AppColor.fourthColor,
                size: 13,
              );
            }),
          ),
          const SizedBox(height: 8),
          Text(
            review.isEmpty ? "-" : review,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(DriverProfileControllerImp controller) {
    return _buildContainerWrapper(
      title: "ACCOUNT SETTINGS",
      child: Column(
        children: [
          _buildSettingTile(Icons.security_outlined, "Account Security"),
          const Divider(color: Colors.white10),
          _buildSettingTile(Icons.notifications_none_outlined, "Notifications"),
          const Divider(color: Colors.white10),
          _buildSettingTile(Icons.privacy_tip_outlined, "Privacy"),
          const Divider(color: Colors.white10),
          _buildSettingTile(Icons.help_outline, "Help & Support"),
          const Divider(color: Colors.white10),
          _buildSettingTile(
            Icons.logout,
            "Logout",
            isLogout: true,
            onTap: () {
              controller.logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(
    IconData icon,
    String title, {
    bool isLogout = false,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      minLeadingWidth: 0,
      leading: Icon(
        icon,
        color: isLogout ? Colors.redAccent : AppColor.thirdColor,
        size: 22,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? Colors.redAccent : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: Colors.white24,
        size: 14,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColor.primaryColor,
          radius: 18,
          child: Icon(icon, color: Colors.grey, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
              ),
              const SizedBox(height: 3),
              Text(
                value.isEmpty ? "-" : value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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

  static Widget _emptyCarImage() {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.directions_car, color: Colors.white54, size: 52),
    );
  }

  Widget _buildContainerWrapper({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: child,
        ),
      ],
    );
  }
}