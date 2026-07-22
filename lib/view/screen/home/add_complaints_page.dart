import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:transport_project/controller/complaints/add_complaint_controller.dart';
import 'package:transport_project/core/class/statusrequest.dart';
import 'package:transport_project/core/constant/AppColor.dart';
import 'package:transport_project/core/functions/vaildinput.dart';

class AddComplaintPage extends StatelessWidget {
  const AddComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AddComplaintControllerImp());

    return Scaffold(
      backgroundColor: AppColor.primaryColor,
      body: SafeArea(
        child: GetBuilder<AddComplaintControllerImp>(
          builder: (controller) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
              child: Form(
                key: controller.formState,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAppBar(),
                    const SizedBox(height: 24),

                    const Text(
                      "إضافة شكوى جديدة",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "أخبرنا بالمشكلة التي واجهتك وسيتم مراجعتها من قبل الفريق المختص.",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSectionTitle("نوع الشكوى"),
                            const SizedBox(height: 10),

                            _buildComplaintTypeDropdown(controller),

                            const SizedBox(height: 22),

                            _buildSectionTitle("تفاصيل المشكلة"),
                            const SizedBox(height: 10),

                            _buildDetailsField(controller),

                            const SizedBox(height: 22),

                            _buildInfoCard(),

                            const SizedBox(height: 30),

                            _buildSubmitButton(controller),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        InkWell(
          onTap: () {
            Get.back();
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColor.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ),
        const Spacer(),
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: AppColor.cardColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
          child: const Icon(
            Icons.support_agent_rounded,
            color: AppColor.thirdColor,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildComplaintTypeDropdown(AddComplaintControllerImp controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColor.fifthColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.complaintType,
          isExpanded: true,
          dropdownColor: AppColor.fifthColor,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColor.thirdColor,
          ),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
          ),
          items: controller.complaintTypes.map((item) {
            return DropdownMenuItem<String>(
              value: item["value"],
              child: Row(
                children: [
                  Container(
                    height: 34,
                    width: 34,
                    decoration: BoxDecoration(
                      color: AppColor.thirdColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.report_problem_outlined,
                      color: AppColor.thirdColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item["title"] ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.updateComplaintType(value);
            }
          },
        ),
      ),
    );
  }
Widget _buildDetailsField(AddComplaintControllerImp controller) {
  return TextFormField(
    controller: controller.detailsController,
    minLines: 6,
    maxLines: 8,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 15,
    ),
    cursorColor: AppColor.thirdColor,
    validator: (value) {
      return validInput(
        value ?? "",
        10,
        500,
        "text",
      );
    },
    decoration: InputDecoration(
      hintText: "اكتب تفاصيل المشكلة هنا...",
      hintStyle: TextStyle(
        color: Colors.white.withOpacity(0.38),
        fontSize: 14,
      ),
      filled: true,
      fillColor: AppColor.fifthColor,
      contentPadding: const EdgeInsets.all(18),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppColor.thirdColor,
          width: 1.2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 1,
        ),
      ),
    ),
  );
}

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColor.fourthColor.withOpacity(0.20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 38,
            width: 38,
            decoration: BoxDecoration(
              color: AppColor.fourthColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: AppColor.fourthColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "سيتم إرسال الشكوى إلى الإدارة، وستظهر حالتها في صفحة الشكاوى بعد الإرسال.",
              style: TextStyle(
                color: Colors.white.withOpacity(0.70),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(AddComplaintControllerImp controller) {
    final bool isLoading = controller.statusRequest == StatusRequest.loading;

    return InkWell(
      onTap: isLoading
          ? null
          : () {
              controller.submitComplaint();
            },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [
              AppColor.thirdColor,
              AppColor.fourthColor,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColor.thirdColor.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.4,
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "إرسال الشكوى",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}