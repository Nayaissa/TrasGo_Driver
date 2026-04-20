import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_project/data/model/trip_draft.dart';
import 'package:transport_project/view/widget/auth/custom_auth_button_widget.dart';

class TripCreatedSheet extends StatelessWidget {
  const TripCreatedSheet({super.key, required this.draft});

  final TripDraft draft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'تم إنشاء الرحلة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'حالة الرحلة: ${draft.status.name}  |  المقاعد: ${draft.availableSeats}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'الانطلاق: ${DateFormat('yyyy-MM-dd hh:mm a').format(draft.departureDateTime)}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 6),
          Text(
            'الخيارات: ${draft.allowShared ? 'مشتركة' : ''}${draft.allowShared && draft.allowPrivate ? ' + ' : ''}${draft.allowPrivate ? 'خاصة' : ''}',
            style: const TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: CustomAuthButton(
              text: 'اغلاق',
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
