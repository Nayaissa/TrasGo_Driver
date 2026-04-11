import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:transport_project/data/model/trip_draft.dart';

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
            child: ElevatedButton(
              onPressed: () => Get.back(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C90FF),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('إغلاق'),
            ),
          ),
        ],
      ),
    );
  }
}